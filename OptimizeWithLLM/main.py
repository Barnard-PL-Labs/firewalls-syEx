import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'iptablesToSMT')))
from OptimizeWithLLM.optimizer import GeminiOptimizer
from OptimizeWithLLM.symbolic_exec.symbolic_exec import verify_equivalence
from OptimizeWithLLM.metrics.metrics import measure_performance
from iptablesToSMT import index as iptables_to_smt
import argparse

def load_iptables_rules(file_path):
    with open(file_path, 'r') as f:
        return f.read()

def save_optimized_rules(optimized_rules, file_path="optimized_iptables_rules.txt"):
    with open(file_path, 'w') as f:
        f.write(optimized_rules)
    return file_path

def main():
    parser = argparse.ArgumentParser(description="IPTables Rule Optimizer using Gemini API")
    parser.add_argument("api_key", help="Your Gemini API key")
    parser.add_argument("input_file", help="Path to the input iptables rules file")
    parser.add_argument("output_file", nargs='?', default="optimized_iptables_rules.txt", help="Path to save the optimized iptables rules (default: optimized_iptables_rules.txt)")
    args = parser.parse_args()
    api_key = args.api_key
    input_file = args.input_file
    output_file = args.output_file

    # Load iptables rules from input file
    original_iptables_rules = load_iptables_rules(input_file)

    # Initialize Gemini optimizer with API key
    optimizer = GeminiOptimizer(api_key)

    # Optimize iptables rules using Gemini API
    print("Optimizing iptables rules using Gemini API...")
    optimized_rules_text = optimizer.optimize_iptables_rules(original_iptables_rules)

    print("\nOptimized IPTables Rules (from Gemini):")
    print(optimized_rules_text)

    # Save optimized rules to a file
    optimized_rules_file = save_optimized_rules(optimized_rules_text)
    print(f"\nOptimized rules saved to: {optimized_rules_file}")

    # Performance measurement (placeholder)
    print("\nMeasuring performance (placeholder)...")
    optimized_rules_measured, metrics = measure_performance(original_iptables_rules, optimizer.optimize_iptables_rules)
    print("Performance metrics:", metrics)

    # Generate SMT for original rules
    print("\nGenerating SMT formulas for original rules...")
    original_smt_base_path = "output/original_rules"
    original_c_path = f"{original_smt_base_path}.c"
    #Don't know why, klee doesn't work in my environment, so I comment this line
    #iptables_to_smt.runner(input_file, original_c_path)
    original_smt_drop_path = f"{original_smt_base_path}_drop.smt2"
    original_smt_accept_path = f"{original_smt_base_path}_accept.smt2"

    # Generate SMT for optimized rules (saving optimized rules to a temp file first)
    print("\nGenerating SMT formulas for optimized rules...")
    temp_optimized_rules_file = "temp_optimized_rules.txt"
    save_optimized_rules(optimized_rules_text, temp_optimized_rules_file)
    optimized_smt_base_path = "output/optimized_rules"
    optimized_c_path = f"{optimized_smt_base_path}.c"
    #Don't know why, klee doesn't work in my environment, so I comment this line as well
    #iptables_to_smt.runner(temp_optimized_rules_file, optimized_c_path)
    optimized_smt_drop_path = f"{optimized_smt_base_path}_drop.smt2"
    optimized_smt_accept_path = f"{optimized_smt_base_path}_accept.smt2"

    # Symbolic execution equivalence verification (placeholder)
    print("\nVerifying equivalence using symbolic execution (placeholder)...")
    is_equivalent = verify_equivalence(original_smt_drop_path, optimized_smt_drop_path)
    if is_equivalent:
        print("Optimized rules are semantically equivalent to original rules (placeholder).")
    else:
        print("Optimized rules are NOT semantically equivalent to original rules (placeholder).")

if __name__ == "__main__":
    main()
