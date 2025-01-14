def generate_c_code(tables, output_file):
    """Generate C code from the parsed iptables rules"""
    
    # Protocol number mapping
    proto_map = {
        "tcp": 6,
        "udp": 17,
        "icmp": 1,
        "any": -1
    }
    
    # Start with the header template
    c_code = """#include <stdio.h>
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

ipt_rule_t rules[MAX_RULES];
int rules_count = 0;

void init_rules() {
    // Initialize rules array
"""
    
    rule_idx = 0
    
    # Process filter table rules
    if 'filter' in tables:
        filter_table = tables['filter']
        for chain_name, chain in filter_table.chains.items():
            for rule in chain.rules:
                # Skip logging rules and other special chains
                if rule.action in ['LOG', 'LOGGING', 'LOGGING_FORWARD']:
                    continue
                    
                c_code += f"    rules[{rule_idx}].proto = {proto_map.get(rule.proto.lower(), -1)};\n"
                
                # Convert IP addresses to uint32_t
                if rule.src_ip != "any":
                    c_code += f"    rules[{rule_idx}].src_ip = {ip_to_int(rule.src_ip)};\n"
                else:
                    c_code += f"    rules[{rule_idx}].src_ip = 0;\n"
                    
                if rule.dst_ip != "any":
                    c_code += f"    rules[{rule_idx}].dst_ip = {ip_to_int(rule.dst_ip)};\n"
                else:
                    c_code += f"    rules[{rule_idx}].dst_ip = 0;\n"
                
                # Handle ports from matches
                src_port = "0"
                dst_port = "0"
                if "tcp" in rule.matches or "udp" in rule.matches:
                    match_data = rule.matches.get("tcp", rule.matches.get("udp", {}))
                    if "sport" in match_data:
                        src_port = match_data["sport"]
                    if "dport" in match_data:
                        dst_port = match_data["dport"]
                
                c_code += f"    rules[{rule_idx}].src_port = {src_port};\n"
                c_code += f"    rules[{rule_idx}].dst_port = {dst_port};\n"
                
                # Convert action to integer
                action = 1 if rule.action == "ACCEPT" else 0
                c_code += f"    rules[{rule_idx}].action = {action};\n\n"
                
                rule_idx += 1
    
    c_code += f"    rules_count = {rule_idx};\n"
    c_code += "}\n\n"
    
    # Add the packet checking function
    c_code += """int check_packet(uint32_t src_ip, uint32_t dst_ip, uint16_t src_port, uint16_t dst_port, int proto) {
    for (int i = 0; i < rules_count; i++) {
        bool match = true;
        
        // Check protocol
        if (rules[i].proto != -1 && rules[i].proto != proto) {
            match = false;
        }
        
        // Check source IP
        if (rules[i].src_ip != 0 && rules[i].src_ip != src_ip) {
            match = false;
        }
        
        // Check destination IP
        if (rules[i].dst_ip != 0 && rules[i].dst_ip != dst_ip) {
            match = false;
        }
        
        // Check source port
        if (rules[i].src_port != 0 && rules[i].src_port != src_port) {
            match = false;
        }
        
        // Check destination port
        if (rules[i].dst_port != 0 && rules[i].dst_port != dst_port) {
            match = false;
        }
        
        if (match) {
            return rules[i].action;
        }
    }
    
    return ACTION_DROP;  // Default policy
}

#ifndef CONCRETE_TEST
int main() {
    uint32_t src_ip, dst_ip;
    uint16_t src_port, dst_port;
    int proto;
    
#ifdef USE_KLEE
    klee_make_symbolic(&src_ip, sizeof(src_ip), "src_ip");
    klee_make_symbolic(&dst_ip, sizeof(dst_ip), "dst_ip");
    klee_make_symbolic(&src_port, sizeof(src_port), "src_port");
    klee_make_symbolic(&dst_port, sizeof(dst_port), "dst_port");
    klee_make_symbolic(&proto, sizeof(proto), "proto");
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
    if (result == ACTION_ACCEPT) {
        klee_warning("ACCEPT");
        klee_assert(result == ACTION_ACCEPT);
    } else {
        klee_warning("DROP");
        klee_assert(result == ACTION_DROP);
    }
#endif
    return result;
}
#endif
"""
    
    # Write the generated code to file
    with open(output_file, 'w') as f:
        f.write(c_code)

def ip_to_int(ip_str):
    """Convert an IP address string to an integer"""
    try:
        parts = ip_str.split('.')
        if len(parts) != 4:
            return 0
        return sum(int(part) << (24 - 8 * i) for i, part in enumerate(parts))
    except:
        return 0