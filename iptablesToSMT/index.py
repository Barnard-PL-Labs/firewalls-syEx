from iptables_parser import parse_iptables_save_file
from code_generator import generate_c_code
from klee_runner import run_klee
import pprint

def runner(input_file, output_file):
    try:
        # Parse rules from iptables-save file
        tables = parse_iptables_save_file(input_file)
        
        # Print each table's contents using the __str__ methods
        for table_name, table in tables.items():
            print(f"\n=== Table: {table_name} ===")
            print(str(table))  # Explicitly convert to string
        
        # Generate C code
        generate_c_code(tables, output_file)
        
        # Run KLEE and get SMT formulas
        klee_output, smt_formulas = run_klee(output_file)
        
        # Group formulas by path type and extract assertions
        drop_assertions = []
        accept_assertions = []
        header = ""
        for formula in smt_formulas:
            path_type, smt = formula
            # Extract the assertion part (between assert and check-sat)
            lines = smt.split('\n')
            if not header:
                # Keep the header from the first formula
                header_end = next(i for i, line in enumerate(lines) if 'assert' in line)
                header = '\n'.join(lines[:header_end])
            
            # Extract just the assertion
            assert_start = next(i for i, line in enumerate(lines) if 'assert' in line)
            assert_end = next(i for i, line in enumerate(lines) if 'check-sat' in line)
            assertion = lines[assert_start:assert_end][0].replace('(assert ', '').rstrip(')')
            
            if path_type == "DROP":
                drop_assertions.append(assertion)
            elif path_type == "ACCEPT":
                accept_assertions.append(assertion)
        
        # Combine assertions
        def combine_assertions(assertions):
            if not assertions:
                return "false"
            combined = f"(or {' '.join(assertions)})"
            return f"{header}\n(assert {combined})\n(check-sat)\n(exit)"
        
        # Create combined formulas
        combined_drop = combine_assertions(drop_assertions)
        combined_accept = combine_assertions(accept_assertions)
        
        # Write formulas to SMT files
        base_name = output_file.rsplit('.', 1)[0]  # Remove .c extension if present
        
        with open(f"{base_name}_drop.smt2", 'w') as f:
            f.write(combined_drop)
            
        with open(f"{base_name}_accept.smt2", 'w') as f:
            f.write(combined_accept)
        
        print(f"\nSMT formulas written to:")
        print(f"- {base_name}_drop.smt2")
        print(f"- {base_name}_accept.smt2")
            
    except Exception as e:
        print(f"Error: {str(e)}")
        import traceback
        traceback.print_exc()  # This will help debug the actual error

