#!/usr/bin/env python3
"""
Script to run the 32-bit Assembler on the test program with memory format
that matches the memory_init1.mem example
"""

import os
import sys
from Assembler import Assembler

def main():
    print("32-bit Assembly to Memory Formatter")
    print("===========================")
    
    # Get the current directory
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Find assembly files in the current directory
    asm_files = [f for f in os.listdir(current_dir) if f.endswith('.asm')]
    
    if not asm_files:
        print("Error: No assembly (.asm) files found in the current directory.")
        print("Please create an assembly file with a .asm extension.")
        return 1
    
    # Use the first assembly file found or let user choose if multiple
    input_file = None
    if len(asm_files) == 1:
        input_file = asm_files[0]
        print(f"Found assembly file: {input_file}")
    else:
        print("Multiple assembly files found:")
        for i, file in enumerate(asm_files, 1):
            print(f"  {i}. {file}")
        
        try:
            choice = int(input("Enter the number of the file to process: "))
            if 1 <= choice <= len(asm_files):
                input_file = asm_files[choice-1]
            else:
                print("Invalid choice.")
                return 1
        except ValueError:
            print("Invalid input.")
            return 1
    
    # Full path to the input file
    input_path = os.path.join(current_dir, input_file)
    
    # Define output file path (replace extension with .mem)
    output_file = os.path.splitext(input_file)[0] + '.mem'
    output_path = os.path.join(current_dir, output_file)
    
    # Read assembly code
    try:
        with open(input_path, 'r') as f:
            asm_code = f.read()
        
        print(f"Processing assembly file: {input_file}")
        
        # Create assembler and process the code
        assembler = Assembler()
        binary_output = assembler.assemble(asm_code)
        
        # Write output in .mem format
        assembler.write_output(output_path, 'mem')
        
        print(f"\nMemory formatting complete!")
        print(f"Output written to: {output_file}")
        
        # Display part of the output file for verification
        print("\nMemory file preview:")
        print("===================")
        with open(output_path, 'r') as f:
            lines = f.readlines()
            # Show first 20 lines or all if fewer
            for i, line in enumerate(lines[:20]):
                print(line.strip())
            if len(lines) > 20:
                print("...")
        
        return 0
        
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
        return 1

if __name__ == "__main__":
    sys.exit(main())