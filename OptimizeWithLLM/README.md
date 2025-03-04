# OptimizeWithLLM: Gemini-Powered eBPF Optimizer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

\>  Optimize eBPF rules using Gemini API for enhanced performance.

## ✨ Features

- Gemini API Integration for eBPF rule optimization.
- Performance and redundancy optimization of eBPF rulesets.
- Output of optimized rules in eBPF format.

## 🛠️ Components

- **`main.py`**: Main script for running optimization.
- **`optimizer.py`**: Gemini API interaction logic.
- **`config/config.py`**: Configuration for Gemini API.
- **`metrics/metrics.py`**: Performance metrics placeholders.
- **`symbolic_exec/symbolic_exec.py`**: Symbolic execution placeholders.

## 📦 Installation

```bash
cd firewalls-syEx
wsl python3 -m pip install -r requirements.txt
```

## 🚀 Usage

1. Install requirements.
2. Get Gemini API Key.
3. Prepare eBPF rules file.
4. Run:

   ```bash
   python3 OptimizeWithLLM/main.py YOUR_API_KEY ebpf_rules_file [output_file]
   ```

## 📝 License

MIT License

## 🙏 Acknowledgements

- Google Gemini API
- Open-source community

---

Made with ❤️ for network security.
