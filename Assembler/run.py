#!/usr/bin/env python3
"""
Script to run the Assembler on the test program with .mem output format
"""

import os
import subprocess
import sys

# Get the current directory
current_dir = os.path.dirname(os.path.abspath(__file__))

# Define the path to the assembler script
assembler_path = os.path.join(current_dir, "Assembler.py")

# Define the path to the input file
input_file = os.path.join(current_dir, "asm_example.asm")

# Check if the assembler file exists
if not os.path.exists(assembler_path):
    print(f"Error: Assembler script not found at {assembler_path}")
    sys.exit(1)

# Check if the input file exists
if not os.path.exists(input_file):
    print(f"Error: Input file not found at {input_file}")
    print("Please create an asm_example.asm file in the same directory.")
    sys.exit(1)

# Run the assembler on the test program
try:
    print(f"Assembling {input_file} with Assembler.py...")
    result = subprocess.run(
        [sys.executable, assembler_path, input_file, "--mem"], 
        capture_output=True, 
        text=True
    )
    
    # Print output
    if result.stdout:
        print(result.stdout)
        
    # Check for errors
    if result.returncode != 0:
        print("Error during assembly:")
        print(result.stderr)
        sys.exit(1)
    
    # Display the .mem output file
    mem_file = os.path.join(current_dir, "asm_example.mem")
    
    if os.path.exists(mem_file):
        print(f"\n.mem output file contents ({mem_file}):")
        with open(mem_file, 'r') as f:
            content = f.read()
            print(content)
            
            # Count the number of instructions
            section_count = content.count('@')
            instruction_count = len(content.strip().split('\n')) - section_count
            
            print(f"\nStatistics:")
            print(f"- Memory sections: {section_count}")
            print(f"- Instructions: {instruction_count}")
    else:
        print(f"Warning: Expected output file {mem_file} not found")
    
    print("\nAssembly process complete!")
    
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)