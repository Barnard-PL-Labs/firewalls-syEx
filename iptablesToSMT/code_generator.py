def generate_c_code(tables, output_file):
    """Generate C code from the parsed iptables rules"""
    
    # Protocol number mapping
    proto_map = {
        "tcp": 6,
        "udp": 17,
        "icmp": 1,
        "icmpv6": 58,
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
    int proto;          // Protocol: -1 = any, 6 = TCP, 17 = UDP, 1 = ICMP
    uint32_t src_ip;
    uint32_t src_mask;  // Added subnet mask
    uint32_t dst_ip;
    uint32_t dst_mask;  // Added subnet mask
    uint16_t src_port;
    uint16_t src_port_high;  // For port ranges
    uint16_t dst_port;
    uint16_t dst_port_high;  // For port ranges
    bool has_state;
    uint8_t state_mask;  // Bitmap for states: NEW=1, ESTABLISHED=2, RELATED=4, INVALID=8
    int action;         // 0 = DROP, 1 = ACCEPT
} ipt_rule_t;

#define MAX_RULES 128
#define STATE_NEW        1
#define STATE_ESTABLISHED 2
#define STATE_RELATED    4
#define STATE_INVALID    8

ipt_rule_t rules[MAX_RULES];
int rules_count = 0;

uint32_t apply_mask(uint32_t ip, uint32_t mask) {
    return ip & mask;
}

void init_rules() {
    // Initialize rules array
"""
    
    rule_idx = 0
    
    # Process filter table rules in sequence
    if 'filter' in tables:
        filter_table = tables['filter']
        
        # Process chains in the correct order
        chain_sequence = [
            'ufw-before-input',
            'ufw-user-input',
            'ufw-after-input',
            'INPUT'  # Default chain
        ]
        
        for chain_name in chain_sequence:
            if chain_name in filter_table.chains:
                chain = filter_table.chains[chain_name]
                for rule in chain.rules:
                    # Skip only logging rules and jumps to UFW logging/tracking chains
                    if (rule.action in ['LOG', 'LOGGING', 'LOGGING_FORWARD'] or 
                        any(x in rule.action for x in [
                            'ufw-logging', 
                            'ufw-track',
                            'ufw-before-logging',
                            'ufw-after-logging',
                            'ufw-skip-to-policy'
                        ])):
                        continue
                        
                    c_code += f"    rules[{rule_idx}].proto = {proto_map.get(rule.proto.lower(), -1)};\n"
                    
                    # Convert IP addresses and masks to uint32_t
                    if rule.src_ip != "any":
                        c_code += f"    rules[{rule_idx}].src_ip = {ip_to_int(rule.src_ip)};\n"
                        if rule.src_mask:
                            c_code += f"    rules[{rule_idx}].src_mask = {cidr_to_mask(rule.src_mask)};\n"
                        else:
                            c_code += f"    rules[{rule_idx}].src_mask = 0xFFFFFFFF;\n"
                    else:
                        c_code += f"    rules[{rule_idx}].src_ip = 0;\n"
                        c_code += f"    rules[{rule_idx}].src_mask = 0;\n"
                        
                    if rule.dst_ip != "any":
                        c_code += f"    rules[{rule_idx}].dst_ip = {ip_to_int(rule.dst_ip)};\n"
                        if rule.dst_mask:
                            c_code += f"    rules[{rule_idx}].dst_mask = {cidr_to_mask(rule.dst_mask)};\n"
                        else:
                            c_code += f"    rules[{rule_idx}].dst_mask = 0xFFFFFFFF;\n"
                    else:
                        c_code += f"    rules[{rule_idx}].dst_ip = 0;\n"
                        c_code += f"    rules[{rule_idx}].dst_mask = 0;\n"
                    
                    # Handle ports from matches with ranges
                    src_port = "0"
                    src_port_high = "0"
                    dst_port = "0"
                    dst_port_high = "0"
                    
                    for match_type in ["tcp", "udp", "multiport"]:
                        if match_type in rule.matches:
                            match_data = rule.matches[match_type]
                            if "sport" in match_data:
                                if isinstance(match_data["sport"], list):
                                    src_port, src_port_high = match_data["sport"]
                                else:
                                    src_port = match_data["sport"]
                                    src_port_high = src_port
                            if "dport" in match_data:
                                if isinstance(match_data["dport"], list):
                                    dst_port, dst_port_high = match_data["dport"]
                                else:
                                    dst_port = match_data["dport"]
                                    dst_port_high = dst_port
                    
                    c_code += f"    rules[{rule_idx}].src_port = {src_port};\n"
                    c_code += f"    rules[{rule_idx}].src_port_high = {src_port_high};\n"
                    c_code += f"    rules[{rule_idx}].dst_port = {dst_port};\n"
                    c_code += f"    rules[{rule_idx}].dst_port_high = {dst_port_high};\n"
                    
                    # Handle state matches
                    state_mask = 0
                    has_state = False
                    if "state" in rule.matches:
                        has_state = True
                        states = rule.matches["state"].get("state", [])
                        for state in states:
                            if state.upper() == "NEW":
                                state_mask |= 1
                            elif state.upper() == "ESTABLISHED":
                                state_mask |= 2
                            elif state.upper() == "RELATED":
                                state_mask |= 4
                            elif state.upper() == "INVALID":
                                state_mask |= 8
                    
                    c_code += f"    rules[{rule_idx}].has_state = {'true' if has_state else 'false'};\n"
                    c_code += f"    rules[{rule_idx}].state_mask = {state_mask};\n"
                    
                    # Convert action to integer
                    action = 1 if rule.action == "ACCEPT" else 0
                    c_code += f"    rules[{rule_idx}].action = {action};\n\n"
                    
                    rule_idx += 1
        
        # Add default DROP policy rule at the end
        c_code += f"    rules[{rule_idx}].proto = -1;\n"
        c_code += f"    rules[{rule_idx}].src_ip = 0;\n"
        c_code += f"    rules[{rule_idx}].src_mask = 0;\n"
        c_code += f"    rules[{rule_idx}].dst_ip = 0;\n"
        c_code += f"    rules[{rule_idx}].dst_mask = 0;\n"
        c_code += f"    rules[{rule_idx}].src_port = 0;\n"
        c_code += f"    rules[{rule_idx}].src_port_high = 0;\n"
        c_code += f"    rules[{rule_idx}].dst_port = 0;\n"
        c_code += f"    rules[{rule_idx}].dst_port_high = 0;\n"
        c_code += f"    rules[{rule_idx}].has_state = false;\n"
        c_code += f"    rules[{rule_idx}].state_mask = 0;\n"
        c_code += f"    rules[{rule_idx}].action = 0;\n\n"
        rule_idx += 1
    
    c_code += f"    rules_count = {rule_idx};\n"
    c_code += "}\n\n"
    
    # Add enhanced packet checking function
    c_code += """int check_packet(uint32_t src_ip, uint32_t dst_ip, uint16_t src_port, uint16_t dst_port, int proto) {
    for (int i = 0; i < rules_count; i++) {
        bool match = true;
        
        // Check protocol
        if (rules[i].proto != -1 && rules[i].proto != proto) {
            match = false;
        }
        
        // Check source IP with mask
        if (rules[i].src_mask != 0 && 
            apply_mask(src_ip, rules[i].src_mask) != apply_mask(rules[i].src_ip, rules[i].src_mask)) {
            match = false;
        }
        
        // Check destination IP with mask
        if (rules[i].dst_mask != 0 && 
            apply_mask(dst_ip, rules[i].dst_mask) != apply_mask(rules[i].dst_ip, rules[i].dst_mask)) {
            match = false;
        }
        
        // Check source port range
        if (rules[i].src_port != 0 && 
            (src_port < rules[i].src_port || src_port > rules[i].src_port_high)) {
            match = false;
        }
        
        // Check destination port range
        if (rules[i].dst_port != 0 && 
            (dst_port < rules[i].dst_port || dst_port > rules[i].dst_port_high)) {
            match = false;
        }

        // Add state checking
        if (rules[i].has_state) {
            uint8_t current_state;
#ifdef USE_KLEE
            klee_make_symbolic(&current_state, sizeof(current_state), "connection_state");
            // Constrain state to valid values (1, 2, 4, or 8)
            klee_assume(current_state == STATE_NEW || 
                       current_state == STATE_ESTABLISHED || 
                       current_state == STATE_RELATED || 
                       current_state == STATE_INVALID);
#else
            current_state = STATE_NEW;  // Default to NEW state for non-KLEE testing
#endif
            if ((rules[i].state_mask & current_state) == 0) {
                match = false;
            }
        }
        
        if (match) {
            return rules[i].action;
        }
    }
    
    return ACTION_DROP;  // Default policy
}
"""

    # Add the main function (unchanged)
    c_code += """
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

def cidr_to_mask(cidr_str):
    """Convert CIDR notation to netmask"""
    try:
        bits = int(cidr_str)
        return (0xFFFFFFFF << (32 - bits)) & 0xFFFFFFFF
    except:
        return 0xFFFFFFFF