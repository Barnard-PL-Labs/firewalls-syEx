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
uint8_t *packet_base = packet_data;

// Simplified model of packet processing for XDP programs
int process_packet(int (*firewall_func)(struct xdp_md *, uint32_t, uint32_t), uint32_t src_ip, uint32_t dst_ip) {
    // We'll pass the src_ip directly to the firewall function instead of creating a packet
    struct xdp_md ctx;
    memset(&ctx, 0, sizeof(ctx));
    
    return firewall_func(&ctx, src_ip, dst_ip);
}



int main() {
    uint32_t src_ip;
    uint32_t dst_ip;
    // Make the source IP symbolic
    klee_make_symbolic(&src_ip, sizeof(src_ip), "src_ip");
    klee_make_symbolic(&dst_ip, sizeof(dst_ip), "dst_ip");
    
    // Process the packet through both firewalls
    int result_a = process_packet(xdp_firewall_a, src_ip, dst_ip);
    int result_b = process_packet(xdp_firewall_b, src_ip, dst_ip);
    
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