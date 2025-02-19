import google.generativeai as genai
from OptimizeWithLLM.config.config import GeminiConfig

class GeminiOptimizer:
    def __init__(self, api_key):
        GeminiConfig.set_api_key(api_key)  # Set the API key in config
        genai.configure(api_key=GeminiConfig.API_KEY)
        self.model = genai.GenerativeModel(GeminiConfig.MODEL_NAME)

    def optimize_iptables_rules(self, iptables_rules):
        prompt = f"""You are tasked with optimizing a set of iptables firewall rules to enhance performance while maintaining the same functional behavior. The goal is to improve the processing efficiency by considering aspects like rule order, redundant rules, and rule grouping.

### Instructions:
1. **Input:** A list of iptables firewall rules in the following format:
   ```iptables
   {iptables_rules}
   ```
   
2. **Objective:** 
   - Reorder the rules if necessary to minimize the number of checks.
   - Remove any redundant rules without changing the firewall behavior.
   - Ensure that the optimized set of rules is logically equivalent to the original set.
   
3. **Considerations:**
   - The original rules must be preserved in terms of their logical functionality.
   - The optimization should result in fewer rule checks, better resource utilization, and faster packet processing.
   - Maintain any conditional logic and prioritization inherent in the original rules.

4. **Output:** Provide only the optimized iptables rules in the same format, without any explanation.

Optimized iptables rules:
```iptables
"""

        prompt_with_rules = prompt.format(iptables_rules=iptables_rules)

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
