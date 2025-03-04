import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'iptablesToSMT')))
from OptimizeWithLLM.optimizer import GeminiOptimizer
from OptimizeWithLLM.symbolic_exec.symbolic_exec import verify_equivalence_ebpf
from OptimizeWithLLM.metrics.metrics import measure_performance_ebpf
# from OptimizeWithLLM.symbolic_exec.symbolic_exec import verify_equivalence # No longer used
# from OptimizeWithLLM.metrics.metrics import measure_performance # No longer used
# from iptablesToSMT import index as iptables_to_smt # No longer used
import argparse

def load_ebpf_rules(file_path):
    with open(file_path, 'r') as f:
        return f.read()

def save_optimized_ebpf_rules(optimized_rules, file_path="optimized_ebpf_rules.c"):
    with open(file_path, 'w') as f:
        f.write(optimized_rules)
    return file_path

def main():
    parser = argparse.ArgumentParser(description="eBPF Rule Optimizer using Gemini API")
    parser.add_argument("api_key", help="Your Gemini API key")
    parser.add_argument("input_file", help="Path to the input eBPF rules file")
    parser.add_argument("output_file", nargs='?', default="optimized_ebpf_rules.c", help="Path to save the optimized eBPF rules (default: optimized_ebpf_rules.txt)")
    args = parser.parse_args()
    api_key = args.api_key
    input_file = args.input_file
    output_file = args.output_file

    # Load eBPF rules from input file
    original_ebpf_rules = load_ebpf_rules(input_file)

    # Initialize Gemini optimizer with API key
    optimizer = GeminiOptimizer(api_key)

    # Optimize eBPF rules using Gemini API
    print("Optimizing eBPF rules using Gemini API...")
    optimized_ebpf_rules_text = optimizer.optimize_ebpf_rules(original_ebpf_rules)

    print("\nOptimized eBPF Rules (from Gemini):")
    print(optimized_ebpf_rules_text)

    # Save optimized eBPF rules to a file
    optimized_ebpf_file = save_optimized_ebpf_rules(optimized_ebpf_rules_text)
    print(f"\nOptimized eBPF rules saved to: {optimized_ebpf_file}")

    # Performance measurement (placeholder)
    print("\nMeasuring performance (placeholder)...")
    # Placeholder for performance measurement
    optimized_rules_measured, metrics = measure_performance_ebpf(original_ebpf_rules, optimizer.optimize_ebpf_rules) # Call eBPF version
    print("Performance metrics:", metrics) # Placeholder output

    # Symbolic execution equivalence verification (placeholder)
    print("\nVerifying equivalence using symbolic execution (placeholder)...")
    # Placeholder for symbolic execution verification
    is_equivalent = verify_equivalence_ebpf(original_ebpf_rules, optimized_ebpf_rules_text) # Call eBPF version
    if is_equivalent: # Placeholder output
        print("Optimized rules are semantically equivalent to original rules (placeholder).")
    else:
        print("Optimized rules are NOT semantically equivalent to original rules (placeholder).")

if __name__ == "__main__":
    main()
