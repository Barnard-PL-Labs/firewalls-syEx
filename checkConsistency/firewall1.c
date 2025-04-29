#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <bpf/bpf_helpers.h>


// Function to create a mock packet with given source IP
static void create_mock_packet(unsigned char *packet, uint32_t src_ip, uint32_t dst_ip) {
    struct ethhdr *eth = (struct ethhdr *)packet;
    struct iphdr *ip = (struct iphdr *)(packet + sizeof(struct ethhdr));
    
    // Setup Ethernet header
    eth->h_proto = htons(ETH_P_IP);
    
    // Setup IP header (minimal fields needed)
    ip->version = 4;
    ip->ihl = 5; // 5 * 4 = 20 bytes header
    ip->saddr = src_ip;
    ip->daddr = dst_ip;
}

SEC("xdp")
int xdp_firewall(struct xdp_md *ctx, uint32_t src_ip, uint32_t dst_ip) {
    // Ignore the real ctx parameter since we're using KLEE
    
    // Create mock packet data for KLEE testing
    unsigned char mock_packet[64] = {0};
    create_mock_packet(mock_packet, src_ip, dst_ip);
    
    // Extract IP header from our mock packet
    struct iphdr *ip = (struct iphdr *)(mock_packet + sizeof(struct ethhdr));
    
    // Check if packet is IPv4
    if (ip->daddr != 0xC0A80164) {
        return XDP_DROP;
    }
    if (ip->saddr == 0xC0A80165) {
        return XDP_DROP;
    }
    
    // Allow all other packets to pass
    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
