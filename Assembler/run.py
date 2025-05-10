#!/usr/bin/env python3
"""
Script to run the Assembler on the test program
"""

import os
import subprocess
import sys

# Run the assembler on the test program
try:
    print("Assembling asm_example.asm with Assembler.py...")
    result = subprocess.run(
        [sys.executable, "Assembler.py", "asm_example.asm"], 
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
    
    # Display the binary and readable output files
    binary_file = "asm_example.bin"
    readable_file = "asm_example_readable.txt"
    
    if os.path.exists(binary_file):
        print(f"\nBinary output ({binary_file}):")
        with open(binary_file, 'r') as f:
            print(f.read())
            
    if os.path.exists(readable_file):
        print(f"\nReadable output ({readable_file}):")
        with open(readable_file, 'r') as f:
            print(f.read())
    
    print("\nAssembly successful!")
    
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)