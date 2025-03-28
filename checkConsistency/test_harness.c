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
    ctx.data = 0;
    ctx.data_end = sizeof(struct ethhdr) + sizeof(struct iphdr);
    
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