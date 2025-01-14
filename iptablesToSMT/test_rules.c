#include <stdio.h>
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
    // Initialize rules
    rules[0] = (ipt_rule_t){ 17, 3232235776, 167772161, 53, 53, 1 };
    rules[1] = (ipt_rule_t){ 6, 3232235876, 0, 1024, 80, 1 };
    rules[2] = (ipt_rule_t){ -1, 0, 0, 0, 0, 0 };
    rules_count = 3;
}

int check_packet(uint32_t src_ip, uint32_t dst_ip, uint16_t src_port, uint16_t dst_port, int proto) {
    for (int i = 0; i < rules_count; i++) {
        ipt_rule_t r = rules[i];
        if (r.proto != -1 && r.proto != proto) continue;
        if (r.src_ip != 0 && r.src_ip != src_ip) continue;
        if (r.dst_ip != 0 && r.dst_ip != dst_ip) continue;
        if (r.src_port != 0 && r.src_port != src_port) continue;
        if (r.dst_port != 0 && r.dst_port != dst_port) continue;
        return r.action;
    }
    return ACTION_DROP; // Default policy
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
