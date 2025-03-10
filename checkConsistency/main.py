#!/usr/bin/env python3
import os
import sys
import subprocess
import tempfile
import argparse
from pathlib import Path

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
    
    // Prepare an Ethernet header
    struct ethhdr *eth = (struct ethhdr *)packet_data;
    eth->h_proto = __constant_htons(ETH_P_IP);
    
    // Prepare an IP header after the Ethernet header
    struct iphdr *ip = (struct iphdr *)(eth + 1);
    ip->version = 4;
    ip->ihl = 5; // 20 bytes
    ip->saddr = src_ip;
    
    // Set up the xdp_md context
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
        temp_dir_obj = tempfile.TemporaryDirectory()
        temp_dir = temp_dir_obj.name
    else:
        os.makedirs(output_dir, exist_ok=True)
        temp_dir = output_dir
    
    temp_dir_path = Path(temp_dir)
    
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
        
        # Compile with clang and generate LLVM bitcode
        bitcode_file = temp_dir_path / "test_harness.bc"
        compile_cmd = f"docker run --rm -v {temp_dir}:/code {docker_image} clang -emit-llvm -c -g -O0 -Wno-everything -I/code -I/klee/include /code/test_harness.c -o /code/test_harness.bc"
        
        print("Compiling code...")
        print(f"Working directory: {temp_dir}")
        proc = subprocess.run(compile_cmd, shell=True, capture_output=True, text=True)
        
        if proc.returncode != 0:
            print("Compilation failed:")
            print(proc.stderr)
            return False
        
        # Run KLEE on the bitcode
        klee_cmd = f"docker run --rm -v {temp_dir}:/code --ulimit='stack=-1:-1' {docker_image} klee --optimize --max-time={timeout} /code/test_harness.bc"
        
        print("Running KLEE to check equivalence...")
        klee_result = subprocess.run(klee_cmd, shell=True, capture_output=True, text=True)
        
        # Print KLEE output
        print(klee_result.stdout)
        if klee_result.stderr:
            print("STDERR:", klee_result.stderr)
        
        # Check for KLEE warnings that indicate differences
        klee_output_dir = next((temp_dir_path / d for d in os.listdir(temp_dir) if d.startswith("klee-out")), None)
        
        if klee_output_dir and klee_output_dir.exists():
            warnings_file = klee_output_dir / "warnings.txt"
            if warnings_file.exists():
                with open(warnings_file, 'r') as f:
                    warnings = f.readlines()
                
                differences = [w for w in warnings if "DIFFERENCE" in w]
                if differences:
                    print("Firewalls are NOT equivalent!")
                    for diff in differences:
                        print(diff.strip())
                    return False
            
            # Also check for any failed assertions
            error_file = klee_output_dir / "test-suite.log"
            if error_file.exists():
                with open(error_file, 'r') as f:
                    content = f.read()
                    if "FAILED" in content:
                        print("Firewalls are NOT equivalent! (Failed assertion)")
                        return False
        
        print("Firewalls are equivalent! No differences found.")
        return True
    finally:
        if cleanup_needed:
            temp_dir_obj.cleanup()

def main():
    parser = argparse.ArgumentParser(description='Check equivalence of two eBPF firewall programs using KLEE')
    parser.add_argument('firewall_a', help='First eBPF firewall file')
    parser.add_argument('firewall_b', help='Second eBPF firewall file')
    parser.add_argument('--timeout', type=int, default=300, help='KLEE timeout in seconds')
    parser.add_argument('--output-dir', help='Directory to store files for inspection (defaults to auto-cleaned temp dir)')
    args = parser.parse_args()
    
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
