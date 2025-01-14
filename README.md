# 🛡️ Firewall Equivalence Checker

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

\> A tool for verifying semantic equivalence between different firewall configurations (in both iptables and eBPF) using SMT formulas.

## 🚀 Features

- Convert iptables rules to SMT formulas
- Convert eBPF rules to SMT formulas (Coming Soon)
- Check semantic equivalence between firewall configurations
- Generate concrete packet examples for behavioral differences

A key goal is to enable the use of LLMs to automatically translate iptables to eBPF and then check the equivalence of the two.

## 🏗️ Components

### 1. iptablesToSMT
Converts iptables rules into SMT formulas through:
- Parsing iptables save files into internal representations
- Generating equivalent C code simulations
- Using KLEE symbolic execution for SMT formula generation

### 2. eBPFtoSMT (🚧 Under Development)
Transforms eBPF rules to SMT formulas by:
- Compiling eBPF rules to LLVM IR
- Applying KLEE symbolic execution for formula generation

### 3. checkConsistency (🚧 Under Development)
Verifies firewall configuration equivalence:
- Compares SMT formula sets
- Identifies behavioral differences
- Provides concrete packet examples for discrepancies

## 📦 Installation

\```bash
# Clone the repository
git clone https://github.com/yourusername/firewall-equivalence-checker.git

# Navigate to the project directory
cd firewall-equivalence-checker

# Get the KLEE Docker container
docker pull klee/klee
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📚 Documentation

Detailed documentation coming soon\!

## 🙏 Acknowledgments

- Inspired by William Hallahan's FireMason tool.
- KLEE Symbolic Execution Engine
- Z3 SMT Solver
- The iptables and eBPF communities

---

<p align="center">Made with ❤️ for the network security community</p>