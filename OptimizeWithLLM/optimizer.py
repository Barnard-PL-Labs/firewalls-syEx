import google.generativeai as genai
from OptimizeWithLLM.config.config import GeminiConfig

class GeminiOptimizer:
    def __init__(self, api_key):
        GeminiConfig.set_api_key(api_key)  # Set the API key in config
        genai.configure(api_key=GeminiConfig.API_KEY)
        self.model = genai.GenerativeModel(GeminiConfig.MODEL_NAME)

    def optimize_ebpf_rules(self, ebpf_rules):
        prompt = f"""You are tasked with optimizing a set of eBPF firewall rules to enhance performance and efficiency, while ensuring they maintain the same functional behavior.

### Instructions:
1. **Input:** A list of eBPF firewall rules.
   ```ebpf
   {ebpf_rules}
   ```

2. **Objective:**
   - Improve the rules for better performance in an eBPF environment.
   - Reduce redundancy and complexity where possible.
   - Ensure the optimized rules are functionally equivalent to the original set.

3. **Considerations:**
   - Maintain the original intent and security posture of the rules.
   - Optimize for eBPF execution environment, considering rule order and efficiency in eBPF processing.
   - Ensure logical equivalence to the original rules.

4. **Output:** Provide only the optimized eBPF rules in the same format, without explanations.

Optimized eBPF rules:
```ebpf
"""

        prompt_with_rules = f"""{prompt}\n{ebpf_rules}"""

        response_stream = self.model.generate_content(prompt_with_rules, stream=True)
        optimized_rules_text = ""
        print("Gemini API Output (Streaming):")
        for chunk in response_stream:
            print(chunk.text or "", end="")
            optimized_rules_text += chunk.text if chunk.text else ""
        print()
        return optimized_rules_text


# Placeholder for symbolic execution verification (in symbolic_exec/)
def verify_equivalence(original_rules, optimized_rules):
    # Implementation will be added later
    pass

# Placeholder for performance metrics (in metrics/)
def measure_performance(iptables_rules):
    # Implementation will be added later
    pass
