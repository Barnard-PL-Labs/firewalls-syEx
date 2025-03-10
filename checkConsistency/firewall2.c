#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <bpf/bpf_helpers.h>

SEC("xdp")
int xdp_firewall(struct xdp_md *ctx) {
    // Get pointers to the start and end of the packet data
    void *data = (void *)(unsigned long)ctx->data;
    void *data_end = (void *)(unsigned long)ctx->data_end;

    // Parse Ethernet header
    struct ethhdr *eth = data;
    if (data + sizeof(*eth) > data_end)
        return XDP_PASS;

    // Process only IPv4 packets
    if (eth->h_proto == __constant_htons(ETH_P_IP)) {
        struct iphdr *iph = data + sizeof(*eth);
        if ((void *)iph + sizeof(*iph) > data_end)
            return XDP_PASS;

        // Example filter: drop packets from source IP 192.168.1.100
        // __constant_htonl converts the IP constant to network byte order.
        if (iph->saddr == __constant_htonl(0xC0A80164)) {
            return XDP_DROP;
        }
    }
    // Allow all other packets to pass
    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
