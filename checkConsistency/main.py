#!/usr/bin/env python3
import os
import sys
import subprocess
import tempfile
import argparse
from pathlib import Path
import datetime
import shutil

# Mock version of bpf_helpers.h
BPF_HELPERS_H = """
#ifndef __BPF_HELPERS_H
#define __BPF_HELPERS_H

#include <linux/types.h>

/* Mock BPF helper functions */
#define BPF_FUNC_map_lookup_elem 1
#define BPF_FUNC_map_update_elem 2
#define BPF_FUNC_map_delete_elem 3
#define BPF_FUNC_trace_printk 6

typedef void *(*bpf_map_lookup_elem_t)(void *map, const void *key);
typedef int (*bpf_map_update_elem_t)(void *map, const void *key, const void *value, __u64 flags);
typedef int (*bpf_map_delete_elem_t)(void *map, const void *key);
typedef int (*bpf_trace_printk_t)(const char *fmt, __u32 fmt_size, ...);

static void *(*bpf_map_lookup_elem)(void *map, const void *key) = (void *) BPF_FUNC_map_lookup_elem;
static int (*bpf_map_update_elem)(void *map, const void *key, const void *value, __u64 flags) = (void *) BPF_FUNC_map_update_elem;
static int (*bpf_map_delete_elem)(void *map, const void *key) = (void *) BPF_FUNC_map_delete_elem;
static int (*bpf_trace_printk)(const char *fmt, __u32 fmt_size, ...) = (void *) BPF_FUNC_trace_printk;

/* BPF_FUNC support macros */
#ifndef __uint
#define __uint(name, val) int (*name) = (void *)(val)
#endif

#ifndef __type
#define __type(name, val) typeof(val) *name = (typeof(val) *)(0)
#endif

#ifndef __array
#define __array(name, val) typeof(val) *name[] = { (typeof(val) *)(0) }
#endif

/* Section definitions */
#ifndef SEC
#define SEC(NAME) __attribute__((section(NAME), used))
#endif

#endif
"""

# More accurate test harness that properly handles eBPF memory access
C_TEMPLATE = """
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <klee/klee.h>

// Standard eBPF definitions needed by both programs
#include <linux/bpf.h>
#include <linux/in.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <bpf/bpf_helpers.h>

// Define XDP return values
#define XDP_ABORTED 0
#define XDP_DROP 1
#define XDP_PASS 2
#define XDP_TX 3
#define XDP_REDIRECT 4

// Include the first firewall program with renamed symbols
#define _license _license_a
#define xdp_firewall xdp_firewall_a
#include "firewall_a.h"
#undef xdp_firewall
#undef _license

// Include the second firewall program with renamed symbols
#define _license _license_b
#define xdp_firewall xdp_firewall_b
#include "firewall_b.h"
#undef xdp_firewall
#undef _license

// Special wrapper for eBPF programs that handles memory access more accurately
#define PACKET_SIZE 128
uint8_t packet_data[PACKET_SIZE];

// Simplified model of packet processing for XDP programs
int process_packet(int (*firewall_func)(struct xdp_md *), uint32_t src_ip) {
    memset(packet_data, 0, PACKET_SIZE);
    
    // Prepare an Ethernet header - ensure we have enough space
    if (sizeof(struct ethhdr) > PACKET_SIZE) {
        return XDP_ABORTED; // Safety check
    }
    
    struct ethhdr *eth = (struct ethhdr *)packet_data;
    eth->h_proto = __constant_htons(ETH_P_IP);
    
    // Prepare an IP header after the Ethernet header - with proper boundary checks
    if (sizeof(struct ethhdr) + sizeof(struct iphdr) > PACKET_SIZE) {
        return XDP_ABORTED; // Safety check
    }
    
    struct iphdr *ip = (struct iphdr *)(packet_data + sizeof(struct ethhdr));
    ip->version = 4;
    ip->ihl = 5; // 20 bytes
    ip->saddr = src_ip;
    
    // Set up the xdp_md context with precise boundaries
    struct xdp_md ctx;
    memset(&ctx, 0, sizeof(ctx));
    ctx.data = (uint32_t)(uintptr_t)packet_data;
    ctx.data_end = (uint32_t)(uintptr_t)(packet_data + sizeof(struct ethhdr) + sizeof(struct iphdr));
    
    // Call the firewall function
    return firewall_func(&ctx);
}

int main() {
    uint32_t src_ip;
    
    // Make the source IP symbolic
    klee_make_symbolic(&src_ip, sizeof(src_ip), "src_ip");
    
    // Process the packet through both firewalls
    int result_a = process_packet(xdp_firewall_a, src_ip);
    int result_b = process_packet(xdp_firewall_b, src_ip);
    
    // Check for equivalence
    if (result_a != result_b) {
        // klee_warning only takes a single string argument, so we use multiple calls
        klee_warning("DIFFERENCE DETECTED");
        
        // We can't format the IP address in the warning, but KLEE will show it in the test case
        if (result_a == XDP_DROP && result_b == XDP_PASS) {
            klee_warning("Firewall A drops packet but Firewall B passes it");
        } else {
            klee_warning("Firewall B drops packet but Firewall A passes it");
        }
        
        klee_assert(0);
    }
    
    return 0;
}
"""

def check_equivalence(file_a, file_b, timeout=300, output_dir=None, docker_image="klee/klee:3.0"):
    """Check if two eBPF firewall programs are equivalent using KLEE."""
    # Determine if we need a temporary directory or use the specified output directory
    cleanup_needed = output_dir is None
    if cleanup_needed:
        # Create a timestamped directory in the current working directory
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        temp_dir = os.path.join(os.getcwd(), f"klee_comparison_{timestamp}")
        os.makedirs(temp_dir, exist_ok=True)
        print(f"Created directory: {temp_dir}")
    else:
        os.makedirs(output_dir, exist_ok=True)
        temp_dir = output_dir
    
    # Convert to absolute path and ensure correct format for Docker
    temp_dir_path = Path(temp_dir).resolve()
    temp_dir_abs = str(temp_dir_path)
    
    # For WSL environments, we may need special handling
    # Check if we're in WSL
    is_wsl = False
    try:
        with open('/proc/version', 'r') as f:
            if 'microsoft' in f.read().lower():
                is_wsl = True
    except:
        pass
    
    if is_wsl:
        print("WSL environment detected, adjusting path for Docker...")
        # In WSL, we need to convert the path to a format Docker can understand
        # This typically means using the Linux path as-is
        temp_dir_docker = temp_dir_abs
        
        # For debugging
        print(f"WSL path: {temp_dir_abs}")
    elif sys.platform == "win32" and temp_dir_abs.startswith("\\\\wsl"):
        # Handle special WSL path format if running on Windows
        print("WSL path detected from Windows, adjusting for Docker...")
        # You might need to adjust this conversion based on your specific setup
        temp_dir_docker = temp_dir_abs.replace("\\", "/")
    else:
        # Use the absolute path for Docker mount
        temp_dir_docker = temp_dir_abs
    
    print(f"Using Docker mount path: {temp_dir_docker}")
    
    try:
        # Create mock bpf_helpers.h file
        bpf_dir = temp_dir_path / "bpf"
        bpf_dir.mkdir(exist_ok=True)
        with open(bpf_dir / "bpf_helpers.h", 'w') as f:
            f.write(BPF_HELPERS_H)
        
        # Copy the eBPF files to the temp directory
        for src_file, dest_name in [(file_a, "firewall_a.h"), (file_b, "firewall_b.h")]:
            with open(src_file, 'r') as f_src, open(temp_dir_path / dest_name, 'w') as f_dest:
                f_dest.write(f_src.read())
        
        # Create the test harness
        with open(temp_dir_path / "test_harness.c", 'w') as f:
            f.write(C_TEMPLATE)
        
        # Set permissions to allow Docker to write to the directory
        try:
            # Make the directory and contents writable by all
            for root, dirs, files in os.walk(temp_dir):
                # Set 777 permissions on the directories
                for d in dirs:
                    dir_path = os.path.join(root, d)
                    os.chmod(dir_path, 0o777)
                # Set 666 permissions on files
                for f in files:
                    file_path = os.path.join(root, f)
                    os.chmod(file_path, 0o666)
            # Set permission on the main directory too
            os.chmod(temp_dir, 0o777)
            print(f"Set write permissions on {temp_dir}")
        except Exception as e:
            print(f"Warning: Could not set permissions: {e}")
            
        # Verify files exist before running Docker
        test_harness_path = temp_dir_path / "test_harness.c"
        if not test_harness_path.exists():
            print(f"Error: test_harness.c not found at {test_harness_path}")
            return False
            
        # Check if Docker is running
        docker_check = subprocess.run("docker ps", shell=True, capture_output=True, text=True)
        if docker_check.returncode != 0:
            print("Error: Docker does not appear to be running or accessible. Error message:")
            print(docker_check.stderr)
            
            if is_wsl:
                print("\nRunning in WSL environment. Common issues include:")
                print("1. Docker Desktop not running on Windows host")
                print("2. WSL integration not enabled in Docker Desktop settings")
                print("3. Missing permissions for Docker socket")
                print("\nPossible solutions:")
                print("- Start Docker Desktop on Windows")
                print("- Enable WSL integration in Docker Desktop settings")
                print("- Run this script with sudo")
                print("- Add your user to the docker group: sudo usermod -aG docker $USER")
            
            return False
        
        # Compile with clang and generate LLVM bitcode
        bitcode_file = temp_dir_path / "test_harness.bc"
        
        # Docker command with proper volume mount
        # For WSL environments, we need to ensure Docker mounts work correctly
        if is_wsl:
            # List contents of temp directory to verify files are there
            print("Contents of temp directory:")
            for file in os.listdir(temp_dir):
                print(f" - {file}")
                
            # Check if test_harness.c exists
            if not (temp_dir_path / "test_harness.c").exists():
                print(f"ERROR: test_harness.c not found in {temp_dir}")
                
            compile_cmd = f"docker run --rm -v {temp_dir_docker}:/code:rw {docker_image} ls -la /code"
            print(f"Checking Docker mount with: {compile_cmd}")
            check_result = subprocess.run(compile_cmd, shell=True, capture_output=True, text=True)
            print("Docker ls result:")
            print(check_result.stdout)
            
            # Now run the actual compile command
            compile_cmd = f"docker run --rm -v {temp_dir_docker}:/code:rw {docker_image} clang -emit-llvm -c -g -O0 -Wno-everything -I/code -I/klee/include /code/test_harness.c -o /code/test_harness.bc"
        else:
            compile_cmd = f"docker run --rm -v {temp_dir_docker}:/code {docker_image} clang -emit-llvm -c -g -O0 -Wno-everything -I/code -I/klee/include /code/test_harness.c -o /code/test_harness.bc"
        
        print("Compiling code...")
        print(f"Working directory: {temp_dir}")
        print(f"Running command: {compile_cmd}")
        proc = subprocess.run(compile_cmd, shell=True, capture_output=True, text=True)
        
        if proc.returncode != 0:
            print("Compilation failed:")
            print(proc.stderr)
            return False
        
        # Run KLEE on the bitcode
        if is_wsl:
            klee_cmd = f"docker run --rm -v {temp_dir_docker}:/code:rw --ulimit='stack=-1:-1' {docker_image} klee --optimize --max-time={timeout} /code/test_harness.bc"
        else:
            klee_cmd = f"docker run --rm -v {temp_dir_docker}:/code --ulimit='stack=-1:-1' {docker_image} klee --optimize --max-time={timeout} /code/test_harness.bc"
        
        print("Running KLEE to check equivalence...")
        klee_result = subprocess.run(klee_cmd, shell=True, capture_output=True, text=True)
        
        # Print KLEE output
        print(klee_result.stdout)
        if klee_result.stderr:
            print("STDERR:", klee_result.stderr)
        
        # Parse KLEE results to check for problems
        memory_error = "memory error" in klee_result.stderr
        
        # Check output for completed/partial paths
        completed_paths = 0
        partially_completed = 0
        
        if "completed paths = " in klee_result.stdout:
            completed_str = klee_result.stdout.split("completed paths = ")[1].split("\n")[0].strip()
            try:
                completed_paths = int(completed_str)
            except:
                pass
                
        if "partially completed paths = " in klee_result.stdout:
            partial_str = klee_result.stdout.split("partially completed paths = ")[1].split("\n")[0].strip()
            try:
                partially_completed = int(partial_str)
            except:
                pass
        
        # Log any issues found
        if memory_error:
            print("\nWARNING: Memory errors were detected during analysis!")
            print("This may affect the accuracy of the equivalence check.")
            print("Consider fixing the memory access issues in the firewall code.")
        
        if completed_paths == 0 and partially_completed > 0:
            print("\nWARNING: KLEE did not complete any execution paths!")
            print("Results may be inconclusive. Check the firewall code for errors.")
            print("The equivalence check CANNOT be determined conclusively.")
            print("Fix the memory access issues before relying on the results.")
            return False
            
        # Check for differences warning
        differences_detected = False
        if "DIFFERENCE DETECTED" in klee_result.stdout or "DIFFERENCE DETECTED" in klee_result.stderr:
            differences_detected = True
            print("\nFirewalls are NOT equivalent! Differences detected:")
            if "Firewall A drops packet but Firewall B passes it" in klee_result.stdout or "Firewall A drops packet but Firewall B passes it" in klee_result.stderr:
                print("- Firewall A (first) drops some packets that Firewall B (second) would allow")
            if "Firewall B drops packet but Firewall A passes it" in klee_result.stdout or "Firewall B drops packet but Firewall A passes it" in klee_result.stderr:
                print("- Firewall B (second) drops some packets that Firewall A (first) would allow")
            return False
            
        # Only consider the firewalls equivalent if we didn't encounter serious issues
        if not memory_error and completed_paths > 0:
            print("Firewalls are equivalent! No differences found.")
            return True
        else:
            print("Results inconclusive due to analysis errors.")
            return False
    finally:
        if cleanup_needed:
            # Only clean up if requested - in WSL, it's often better to keep files for debugging
            print(f"Temporary files kept in: {temp_dir}")
            print("You can remove this directory manually if no longer needed.")
            # Uncomment the following lines to remove the directory automatically
            # import shutil
            # shutil.rmtree(temp_dir)

def main():
    parser = argparse.ArgumentParser(description='Check equivalence of two eBPF firewall programs using KLEE')
    parser.add_argument('firewall_a', help='First eBPF firewall file')
    parser.add_argument('firewall_b', help='Second eBPF firewall file')
    parser.add_argument('--timeout', type=int, default=300, help='KLEE timeout in seconds')
    parser.add_argument('--output-dir', help='Directory to store files for inspection (defaults to auto-cleaned temp dir)')
    args = parser.parse_args()
    
    # Check Docker permissions before proceeding
    docker_check = subprocess.run("docker version", shell=True, capture_output=True, text=True)
    if docker_check.returncode != 0 and "permission denied" in docker_check.stderr:
        print("Error: Permission denied when trying to access Docker.")
        print("This script requires Docker access. You can either:")
        print("1. Run this script with sudo: sudo python3 main.py ...")
        print("2. Add your user to the docker group: sudo usermod -aG docker $USER (requires logout/login)")
        print("\nTrying again with sudo...")
        
        # Try to run the same command with sudo to see if it works
        sudo_cmd = f"sudo {' '.join(sys.argv)}"
        print(f"Running: {sudo_cmd}")
        return subprocess.call(sudo_cmd, shell=True)
    
    if not os.path.exists(args.firewall_a):
        print(f"Error: {args.firewall_a} does not exist")
        return 1
    
    if not os.path.exists(args.firewall_b):
        print(f"Error: {args.firewall_b} does not exist")
        return 1
    
    print(f"Checking equivalence of {args.firewall_a} and {args.firewall_b}")
    
    if check_equivalence(args.firewall_a, args.firewall_b, args.timeout, output_dir=args.output_dir):
        return 0
    else:
        return 1

if __name__ == "__main__":
    sys.exit(main())
