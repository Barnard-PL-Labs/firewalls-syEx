import subprocess
import tempfile
import os
import iptc
from typing import Dict, List, Optional, Union

class IPTablesRule:
    def __init__(self):
        self.table = "filter"
        self.chain = ""
        self.proto = "any"
        self.src_ip = "any"
        self.dst_ip = "any"
        self.src_port = None
        self.dst_port = None
        self.in_interface = None
        self.out_interface = None
        self.state = []
        self.action = "DROP"
        self.target_options = {}
        self.matches = {}

    def __str__(self):
        parts = [f"-A {self.chain}"]
        if self.proto != "any":
            parts.append(f"-p {self.proto}")
        if self.src_ip != "any":
            parts.append(f"-s {self.src_ip}")
        if self.dst_ip != "any":
            parts.append(f"-d {self.dst_ip}")
        if self.in_interface:
            parts.append(f"-i {self.in_interface}")
        if self.out_interface:
            parts.append(f"-o {self.out_interface}")
        
        # Add matches
        for match_name, match_data in self.matches.items():
            parts.append(f"-m {match_name}")
            for k, v in match_data.items():
                if isinstance(v, list):
                    parts.append(f"--{k} {','.join(v)}")
                else:
                    parts.append(f"--{k} {v}")
        
        # Add action and target options
        parts.append(f"-j {self.action}")
        for k, v in self.target_options.items():
            parts.append(f"--{k} {v}")
            
        return " ".join(parts)

class IPTablesChain:
    def __init__(self, name: str, policy: str = "ACCEPT"):
        self.name = name
        self.policy = policy
        self.rules: List[IPTablesRule] = []

    def __str__(self):
        result = [f":{self.name} {self.policy}"]
        for rule in self.rules:
            result.append(str(rule))
        return "\n".join(result)

class IPTablesTable:
    def __init__(self, name: str):
        self.name = name
        self.chains: Dict[str, IPTablesChain] = {}

    def __str__(self):
        result = [f"*{self.name}"]
        for chain in self.chains.values():
            result.append(str(chain))
        result.append("COMMIT")
        return "\n".join(result)

def parse_target_options(parts: List[str], start_idx: int) -> tuple[Dict[str, str], int]:
    """Parse target-specific options like --to-ports for DNAT/SNAT"""
    options = {}
    i = start_idx
    
    while i < len(parts):
        if parts[i].startswith('--'):
            if i + 1 < len(parts) and not parts[i + 1].startswith('-'):
                options[parts[i][2:]] = parts[i + 1]
                i += 2
            else:
                options[parts[i][2:]] = ''
                i += 1
        else:
            break
    
    return options, i

def parse_match_options(match_name: str, parts: List[str], start_idx: int) -> tuple[Dict[str, Union[str, List[str]]], int]:
    """Parse match-specific options like state matches"""
    options = {}
    i = start_idx
    
    while i < len(parts):
        if parts[i].startswith('--'):
            if match_name == "state" and parts[i] == "--state":
                options["state"] = parts[i + 1].split(',')
                i += 2
            elif match_name in ["tcp", "udp"]:
                if parts[i] in ["--sport", "--dport"]:
                    options[parts[i][2:]] = parts[i + 1]
                    i += 2
                else:
                    i += 1
            else:
                if i + 1 < len(parts) and not parts[i + 1].startswith('-'):
                    options[parts[i][2:]] = parts[i + 1]
                    i += 2
                else:
                    options[parts[i][2:]] = ''
                    i += 1
        else:
            break
    
    return options, i

def parse_iptables_save_file(filename: str) -> Dict[str, IPTablesTable]:
    """Parse iptables rules from an iptables-save format file."""
    try:
        with open(filename, 'r') as f:
            content = f.read()
            
        tables: Dict[str, IPTablesTable] = {}
        current_table = None
        
        for line in content.splitlines():
            line = line.strip()
            if not line or line.startswith('#'):
                continue
                
            if line.startswith('*'):
                table_name = line[1:].strip()
                current_table = IPTablesTable(table_name)
                tables[table_name] = current_table
                continue
                
            if line.startswith(':'):
                # Chain definition
                parts = line[1:].split()
                chain_name = parts[0]
                policy = parts[1] if len(parts) > 1 else "ACCEPT"
                if current_table:
                    current_table.chains[chain_name] = IPTablesChain(chain_name, policy)
                continue
                
            if line.startswith('COMMIT'):
                current_table = None
                continue
                
            if line.startswith('-A') and current_table:
                rule = IPTablesRule()
                rule.table = current_table.name
                parts = line.split()
                i = 1  # Skip -A
                
                # Get chain name
                rule.chain = parts[i]
                i += 1
                
                while i < len(parts):
                    part = parts[i]
                    
                    if part == '-p':
                        rule.proto = parts[i + 1]
                        i += 2
                    elif part == '-s':
                        rule.src_ip = parts[i + 1].split('/')[0]
                        i += 2
                    elif part == '-d':
                        rule.dst_ip = parts[i + 1].split('/')[0]
                        i += 2
                    elif part == '-i':
                        rule.in_interface = parts[i + 1]
                        i += 2
                    elif part == '-o':
                        rule.out_interface = parts[i + 1]
                        i += 2
                    elif part == '-m':
                        match_name = parts[i + 1]
                        i += 2
                        match_options, i = parse_match_options(match_name, parts, i)
                        rule.matches[match_name] = match_options
                    elif part == '-j':
                        rule.action = parts[i + 1]
                        i += 2
                        if rule.action in ['DNAT', 'SNAT', 'MASQUERADE']:
                            options, i = parse_target_options(parts, i)
                            rule.target_options = options
                    else:
                        i += 1
                
                if rule.chain in current_table.chains:
                    current_table.chains[rule.chain].rules.append(rule)
        
        return tables
        
    except FileNotFoundError:
        raise RuntimeError(f"Could not find iptables rules file: {filename}")
    except Exception as e:
        raise RuntimeError(f"Error parsing iptables rules file: {str(e)}")

def read_live_iptables() -> Dict[str, IPTablesTable]:
    """Read and parse live iptables rules using python-iptables."""
    tables = {}
    
    for table_name in ['filter', 'nat', 'mangle', 'raw']:
        try:
            table = iptc.Table(table_name)
            table.refresh()
            
            ipt_table = IPTablesTable(table_name)
            tables[table_name] = ipt_table
            
            for chain in table.chains:
                ipt_chain = IPTablesChain(chain.name, chain.policy if hasattr(chain, 'policy') else 'ACCEPT')
                ipt_table.chains[chain.name] = ipt_chain
                
                for rule in chain.rules:
                    ipt_rule = IPTablesRule()
                    ipt_rule.table = table_name
                    ipt_rule.chain = chain.name
                    ipt_rule.proto = rule.protocol.lower() if rule.protocol else "any"
                    ipt_rule.src_ip = rule.src.split('/')[0] if rule.src else "any"
                    ipt_rule.dst_ip = rule.dst.split('/')[0] if rule.dst else "any"
                    ipt_rule.in_interface = rule.in_interface if rule.in_interface else None
                    ipt_rule.out_interface = rule.out_interface if rule.out_interface else None
                    ipt_rule.action = rule.target.name if rule.target else "DROP"
                    
                    # Handle matches
                    for match in rule.matches:
                        match_data = {}
                        if match.name in ["tcp", "udp"]:
                            if hasattr(match, "sport"):
                                match_data["sport"] = match.sport
                            if hasattr(match, "dport"):
                                match_data["dport"] = match.dport
                        elif match.name == "state":
                            if hasattr(match, "state"):
                                match_data["state"] = match.state.split(',')
                        
                        ipt_rule.matches[match.name] = match_data
                    
                    # Handle target options
                    if rule.target and hasattr(rule.target, "to_ports"):
                        ipt_rule.target_options["to-ports"] = rule.target.to_ports
                    
                    ipt_chain.rules.append(ipt_rule)
                    
        except Exception as e:
            print(f"Warning: Could not read {table_name} table: {str(e)}")
            continue
    
    return tables