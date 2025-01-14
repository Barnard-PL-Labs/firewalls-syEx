import json
import shutil
import subprocess
import tempfile
import os
import iptc
import time

def restore_iptables_script(iptables_script):
    """Restore iptables rules into the kernel using iptables-restore."""
    with tempfile.NamedTemporaryFile(delete=False) as temp_file:
        temp_file.write(iptables_script.encode('utf-8'))
        temp_file.flush()
        try:
            subprocess.check_call(f"iptables-restore < {temp_file.name}", shell=True)
        finally:
            os.unlink(temp_file.name)

def read_iptables_rules():
    """Read and parse live iptables rules using python-iptables."""
    table = iptc.Table(iptc.Table.FILTER)
    table.refresh()

    rules = []
    for chain in table.chains:
        for rule in chain.rules:
            rule_data = {
                "proto": rule.protocol.lower() if rule.protocol else "any",
                "src_ip": rule.src.split('/')[0] if rule.src else "any",
                "dst_ip": rule.dst.split('/')[0] if rule.dst else "any",
                "src_port": None,
                "dst_port": None,
                "action": rule.target.name.upper()
            }

            for match in rule.matches:
                if match.name in ["tcp", "udp"]:
                    rule_data["src_port"] = match.sport if hasattr(match, "sport") else None
                    rule_data["dst_port"] = match.dport if hasattr(match, "dport") else None

            rules.append(rule_data)
    return rules

def generate_c_code(rules, output_filename):
    """Generate a C program to simulate iptables logic and integrate with KLEE."""
    c_code_header = r'''#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef USE_KLEE
#include "klee/klee.h"
#endif

#define ACTION_DROP   0
#define ACTION_ACCEPT 1

typedef struct {
    int proto;  // Protocol: -1 = any, 6 = TCP, 17 = UDP, 1 = ICMP
    uint32_t src_ip;
    uint32_t dst_ip;
    uint16_t src_port;
    uint16_t dst_port;
    int action; // 0 = DROP, 1 = ACCEPT
} ipt_rule_t;

#define MAX_RULES 128
'''

    # Generate rules initialization
    rules_init = []
    for i, rule in enumerate(rules):
        proto_map = {"tcp": 6, "udp": 17, "icmp": 1, "any": -1}
        proto = proto_map.get(rule["proto"], -1)
        
        # Convert IP addresses
        src_ip = "0" if rule["src_ip"] == "any" else rule["src_ip"]
        dst_ip = "0" if rule["dst_ip"] == "any" else rule["dst_ip"]
        if src_ip != "0":
            src_ip = sum(int(x) << (24-i*8) for i, x in enumerate(src_ip.split('.')))
        if dst_ip != "0":
            dst_ip = sum(int(x) << (24-i*8) for i, x in enumerate(dst_ip.split('.')))
        
        # Convert ports
        src_port = 0 if not rule["src_port"] else int(rule["src_port"].split(':')[0])
        dst_port = 0 if not rule["dst_port"] else int(rule["dst_port"].split(':')[0])
        action = 1 if rule["action"] == "ACCEPT" else 0

        rules_init.append(f"    rules[{i}] = (ipt_rule_t){{ {proto}, {src_ip}, {dst_ip}, {src_port}, {dst_port}, {action} }};")

    c_code_main = f'''
ipt_rule_t rules[MAX_RULES];
int rules_count = 0;

void init_rules() {{
    // Initialize rules
{chr(10).join(rules_init)}
    rules_count = {len(rules)};
}}

int check_packet(uint32_t src_ip, uint32_t dst_ip, uint16_t src_port, uint16_t dst_port, int proto) {{
    for (int i = 0; i < rules_count; i++) {{
        ipt_rule_t r = rules[i];
        if (r.proto != -1 && r.proto != proto) continue;
        if (r.src_ip != 0 && r.src_ip != src_ip) continue;
        if (r.dst_ip != 0 && r.dst_ip != dst_ip) continue;
        if (r.src_port != 0 && r.src_port != src_port) continue;
        if (r.dst_port != 0 && r.dst_port != dst_port) continue;
        return r.action;
    }}
    return ACTION_DROP; // Default policy
}}

#ifndef CONCRETE_TEST
int main() {{
    uint32_t src_ip, dst_ip;
    uint16_t src_port, dst_port;
    int proto;

#ifdef USE_KLEE
    klee_make_symbolic(&src_ip, sizeof(src_ip), "src_ip");
    klee_make_symbolic(&dst_ip, sizeof(dst_ip), "dst_ip");
    klee_make_symbolic(&src_port, sizeof(src_port), "src_port");
    klee_make_symbolic(&dst_port, sizeof(dst_port), "dst_port");
    klee_make_symbolic(&proto, sizeof(proto), "proto");
    klee_assume(proto == 6 || proto == 17 || proto == 1);
#else
    // Default test values when not using KLEE
    src_ip = 3232235876;  // 192.168.1.100
    dst_ip = 0;
    src_port = 1024;
    dst_port = 80;
    proto = 6;  // TCP
#endif

    init_rules();
    int result = check_packet(src_ip, dst_ip, src_port, dst_port, proto);
    
#ifdef USE_KLEE
    if (result == ACTION_ACCEPT) {{
        klee_warning("ACCEPT");
        klee_assert(result == ACTION_ACCEPT);
    }} else {{
        klee_warning("DROP");
        klee_assert(result == ACTION_DROP);
    }}
#endif
    return result;
}}
#endif
'''

    # Write the full C code to file
    with open(output_filename, "w") as f:
        f.write(c_code_header)
        f.write(c_code_main)

def parse_smt2_files(klee_output_dir):
    """Parse and return the SMT2 formulas generated by KLEE."""
    smt_formulas = []
    
    # Find all .smt2 files in the KLEE output directory
    for file in os.listdir(klee_output_dir):
        if file.endswith('.smt2'):
            test_num = file.split('test')[1].split('.')[0]  # Extract test number
            ktest_file = os.path.join(klee_output_dir, f"test{test_num}.ktest")
            
            # Read the SMT formula
            with open(os.path.join(klee_output_dir, file), 'r') as f:
                content = f.read()
            
            try:
                # Use ktest-tool to get concrete values
                ktest_output = subprocess.check_output(['ktest-tool', ktest_file], 
                                                     stderr=subprocess.PIPE).decode('utf-8')
                
                # Parse ktest-tool output to get concrete values
                concrete_values = {}
                current_name = None
                
                for line in ktest_output.splitlines():
                    if 'name:' in line:
                        current_name = line.split('name: \'')[1].split('\'')[0]
                    elif current_name and 'int :' in line:
                        value = int(line.split('int : ')[1])
                        concrete_values[current_name] = value
                        current_name = None
                

                # Compile and run the C program with concrete values
                test_result = run_concrete_test(concrete_values)
                path_type = "ACCEPT" if test_result == 1 else "DROP"
                smt_formulas.append((path_type, content))
                
            except (subprocess.CalledProcessError, IOError) as e:
                print(f"Warning: Could not process {ktest_file}: {str(e)}")
                continue
    
    return smt_formulas

def run_concrete_test(values):
    """Run the C program with concrete values and return the result."""
    logs_dir = "logs"
    os.makedirs(logs_dir, exist_ok=True)
    
    # Create a unique filename using timestamp
    test_file = os.path.join(logs_dir, f"concrete_test_{int(time.time())}.c")
    
    with open(test_file, 'w') as f:
        f.write('''
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

// Function prototypes
void init_rules(void);
int check_packet(uint32_t src_ip, uint32_t dst_ip, uint16_t src_port, uint16_t dst_port, int proto);

// Include the implementation
#define CONCRETE_TEST
#include "../test_rules.c"

int main() {
    uint32_t src_ip = %d;
    uint32_t dst_ip = %d;
    uint16_t src_port = %d;
    uint16_t dst_port = %d;
    int proto = %d;
    
    // Initialize rules
    init_rules();
    int result = check_packet(src_ip, dst_ip, src_port, dst_port, proto);
    printf("%%d\\n", result);  // Ensure clean output format
    return 0;
}
''' % (values['src_ip'], values['dst_ip'], 
       values['src_port'], values['dst_port'], values['proto']))

    try:
        executable = test_file + '.exe'
        subprocess.check_call(['gcc', test_file, '-o', executable])
        output = subprocess.check_output([executable]).decode('utf-8').strip()
        if not output:
            raise ValueError("No output from concrete test")
        return int(output)
    except (ValueError, subprocess.CalledProcessError) as e:
        print(f"Error running concrete test: {str(e)}")
        return None
    finally:
        if os.path.exists(executable):
            os.unlink(executable)

def run_klee(c_filename):
    """Compile the generated C file to LLVM bitcode and run KLEE."""
    bc_filename = c_filename.replace(".c", ".bc")
    try:
        # Remove existing klee-out-0 directory if it exists
        if os.path.exists("klee-out-0"):
            shutil.rmtree("klee-out-0")
            
        subprocess.check_call(["clang", "-DUSE_KLEE", "-I/usr/local/include/klee", "-emit-llvm", "-c", c_filename, "-o", bc_filename])
        result = subprocess.check_output(["klee", "--write-smt2s", bc_filename], 
                                      stderr=subprocess.STDOUT).decode("utf-8")
       
        klee_output_dir = "klee-out-0"
        # Parse SMT formulas
        smt_formulas = parse_smt2_files(klee_output_dir)
        return result, smt_formulas
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"KLEE failed: {e.output.decode('utf-8')}")

def main():
    """Local test function"""
    # Skip actual iptables manipulation and use test data
    rules = [
        {
            "proto": "udp",
            "src_ip": "192.168.1.0",
            "dst_ip": "10.0.0.1",
            "src_port": "53",
            "dst_port": "53",
            "action": "ACCEPT"
        },
        {
            "proto": "tcp",
            "src_ip": "192.168.1.100",
            "dst_ip": "any",
            "src_port": "1024:65535",
            "dst_port": "80",
            "action": "ACCEPT"
        },
        
        {
            "proto": "any",
            "src_ip": "any",
            "dst_ip": "any",
            "src_port": None,
            "dst_port": None,
            "action": "DROP"
        }
    ]
    
    try:
        # Skip restore_iptables_script call
        
        # Generate C code
        output_file = "test_rules.c"
        generate_c_code(rules, output_file)
        
        # Run KLEE and get SMT formulas
        klee_output, smt_formulas = run_klee(output_file)
        
        # Print SMT formulas for each path
        print("\nSMT Formulas:")
        for i, formula in enumerate(smt_formulas):
            print(f"\nPath {i + 1}:")
            print(f"Path Type: {formula[0]}")
            print(formula[1])
            
    except Exception as e:
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    main()
