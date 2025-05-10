#!/usr/bin/env python3
"""
Enhanced Assembler for Team1 Instruction Set Architecture with .mem Output Support

This assembler translates assembly language into machine code according to the
instruction format provided in Team1_Phase1_Report.pdf.

Features:
- .ORG directive (set origin address)
- Hexadecimal constants and addresses
- Data statements
- Labels and robust error handling
- Direct output to .mem format
- Full 32-bit binary output

Instruction Format:
31:27    26:24    23:21    20:18    17:16    15:0
opcode   Rsrc1    Rsrc2    Rdst     -        Immediate/offset

"""

import re
import sys
import os

class Assembler:
    def __init__(self):
        # Define opcodes from the instruction set
        self.opcodes = {
            'NOP': '00000',
            'HLT': '00001',
            'SETC': '00010',
            'NOT': '00011',
            'INC': '00100',
            'OUT': '00101',
            'IN': '00110',
            'MOV': '00111',
            'SWAP': '01000',
            'ADD': '01001',
            'SUB': '01010',
            'AND': '01011',
            'IADD': '01100',
            'PUSH': '01101',
            'POP': '01110',
            'LDM': '01111',
            'LDD': '10000',
            'STD': '10001',
            'JZ': '10010',
            'JN': '10011',
            'JC': '10100',
            'JMP': '10101',
            'CALL': '10110',
            'RET': '10111',
            'INT': '11000',
            'RTI': '11001'
        }
        
        # Assembler directives
        self.directives = ['.ORG', '.DATA', '.CODE']
        
        # Initialize labels dictionary
        self.labels = {}
        
        # Current program counter used for label resolution
        self.pc = 0
        self.origin = 0  # Default origin
        
        # Initialize binary output
        self.memory_map = {}  # Maps address to instruction
        
        # For 2-pass assembler
        self.instructions = []
        
        # For data directives
        self.data_values = {}

    def parse_hex_value(self, value_str):
        """Parse a hexadecimal value with optional 0x prefix."""
        value_str = value_str.strip()
        
        try:
            # If it looks like a hex value with optional 0x prefix
            if value_str.startswith('0x') or value_str.startswith('0X'):
                return int(value_str, 16)
            elif all(c in '0123456789ABCDEFabcdef' for c in value_str):
                return int(value_str, 16)
            else:
                # Try as decimal if not hex format
                return int(value_str)
        except ValueError:
            raise ValueError(f"Invalid numeric value: {value_str}")

    def register_to_binary(self, reg):
        """Convert register name (R0-R7) to 3-bit binary."""
        if not reg.upper().startswith('R') or not reg[1:].isdigit():
            raise ValueError(f"Invalid register name: {reg}")
        
        reg_num = int(reg[1:])
        if reg_num < 0 or reg_num > 7:
            raise ValueError(f"Register number out of range (0-7): {reg}")
        
        return format(reg_num, '03b')

    def immediate_to_binary(self, imm, bits=16):
        """Convert immediate value to binary with specified bit width."""
        # Parse the immediate value (hex or decimal)
        try:
            value = self.parse_hex_value(imm)
            
            # Check if value fits in the specified bits
            max_value = (1 << bits) - 1
            
            if value > max_value:
                raise ValueError(f"Immediate value out of range for {bits} bits: {imm}")
            
            # For 16-bit values, handle as unsigned
            return format(value & ((1 << bits) - 1), f'0{bits}b')
            
        except ValueError as e:
            raise ValueError(f"Error parsing immediate value '{imm}': {e}")

    def parse_operands(self, operands_str):
        """Parse operands string into list of operands."""
        if not operands_str:
            return []
        
        # Handle special case for LDD and STD with offset(register) format
        if '(' in operands_str and ')' in operands_str:
            parts = re.split(r',\s*', operands_str)
            for i, part in enumerate(parts):
                if '(' in part and ')' in part:
                    offset_match = re.match(r'([^(]+)\(([^)]+)\)', part)
                    if offset_match:
                        offset, reg = offset_match.groups()
                        parts[i] = reg
                        parts.append(offset.strip())
            return [p.strip() for p in parts]
        else:
            return [p.strip() for p in re.split(r',\s*', operands_str)]

    def handle_directive(self, directive, operand, line_num):
        """Handle assembler directives."""
        if directive == '.ORG':
            try:
                self.origin = self.parse_hex_value(operand)
                self.pc = self.origin
                return True
            except ValueError:
                raise ValueError(f"Invalid origin address: {operand}")
        elif directive == '.DATA':
            # Data section - currently just a marker
            return True
        elif directive == '.CODE':
            # Code section - currently just a marker
            return True
        return False

    def first_pass(self, code):
        """First pass: collect labels and build instruction list."""
        lines = code.strip().split('\n')
        
        for line_num, line in enumerate(lines, 1):
            # Strip comments and whitespace
            if ';' in line:
                line = line[:line.index(';')]
            line = line.strip()
            
            # Skip empty lines
            if not line:
                continue
            
            # Check for labels
            if ':' in line:
                label, rest = line.split(':', 1)
                label = label.strip()
                self.labels[label] = self.pc
                line = rest.strip()
                if not line:  # If only a label on this line
                    continue
            
            # Split instruction into opcode and operands
            parts = re.split(r'\s+', line, maxsplit=1)
            opcode = parts[0].upper()
            operands_str = parts[1] if len(parts) > 1 else ""
            
            # Handle directives
            if opcode in self.directives:
                if self.handle_directive(opcode, operands_str, line_num):
                    continue  # Directive handled, skip to next line
            
            # Check if this is a data value (a standalone hexadecimal or decimal number)
            if not operands_str and opcode not in self.opcodes and opcode not in self.directives:
                try:
                    value = self.parse_hex_value(opcode)
                    # Store as a special "DATA" instruction
                    self.instructions.append((line_num, "DATA", opcode, self.pc))
                    self.pc += 1
                    continue
                except ValueError:
                    pass  # Not a valid number, continue processing as normal instruction
            
            # Store the instruction for second pass
            self.instructions.append((line_num, opcode, operands_str, self.pc))
            
            # Increment PC for the next instruction
            if opcode in self.opcodes:
                self.pc += 1

    def second_pass(self):
        """Second pass: generate binary code for each instruction."""
        for line_num, opcode, operands_str, address in self.instructions:
            try:
                binary = None
                
                # Handle data values
                if opcode == "DATA":
                    value = self.parse_hex_value(operands_str)
                    if value > 0xFFFFFFFF:
                        raise ValueError(f"Data value exceeds 32 bits: {operands_str}")
                    binary = format(value, '032b')
                    self.memory_map[address] = binary
                    continue
                
                # Get the opcode binary
                if opcode not in self.opcodes:
                    raise ValueError(f"Unknown opcode: {opcode}")
                
                opcode_bin = self.opcodes[opcode]
                operands = self.parse_operands(operands_str)
                
                # Initialize register fields and immediate field
                rsrc1_bin = '000'  # Default is R0
                rsrc2_bin = '000'  # Default is R0
                rdst_bin = '000'   # Default is R0
                immediate_bin = '0000000000000000'  # 16 bits of zeros
                
                # Format the binary instruction based on the instruction type
                if opcode in ['NOP', 'HLT', 'SETC', 'RET', 'RTI']:
                    # No operands
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                elif opcode in ['NOT', 'INC', 'IN', 'POP']:
                    # Format: opcode Rdst
                    rdst_bin = self.register_to_binary(operands[0])
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                elif opcode in ['OUT', 'PUSH']:
                    # Format: opcode Rsrc1
                    rsrc1_bin = self.register_to_binary(operands[0])
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                elif opcode in ['MOV', 'SWAP']:
                    # Format: opcode Rdst, Rsrc1
                    rsrc1_bin = self.register_to_binary(operands[1])
                    rdst_bin = self.register_to_binary(operands[0])
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                elif opcode in ['ADD', 'SUB', 'AND']:
                    # Format: opcode Rdst, Rsrc1, Rsrc2
                    rsrc1_bin = self.register_to_binary(operands[1])
                    rsrc2_bin = self.register_to_binary(operands[2])
                    rdst_bin = self.register_to_binary(operands[0])
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                elif opcode == 'IADD':
                    # Format: opcode Rdst, Rsrc1, Imm
                    rsrc1_bin = self.register_to_binary(operands[1])
                    rdst_bin = self.register_to_binary(operands[0])
                    immediate_bin = self.immediate_to_binary(operands[2])
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                elif opcode == 'LDM':
                    # Format: opcode Rdst, Imm
                    rdst_bin = self.register_to_binary(operands[0])
                    immediate_bin = self.immediate_to_binary(operands[1])
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                elif opcode == 'LDD':
                    # Format: opcode Rdst, offset(Rsrc1)
                    # operands = [Rdst, Rsrc1, offset]
                    rsrc1_bin = self.register_to_binary(operands[1])
                    rdst_bin = self.register_to_binary(operands[0])
                    immediate_bin = self.immediate_to_binary(operands[2])
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                elif opcode == 'STD':
                    # Format: opcode Rsrc1, offset(Rsrc2)
                    # operands = [Rsrc1, Rsrc2, offset]
                    rsrc1_bin = self.register_to_binary(operands[0])
                    rsrc2_bin = self.register_to_binary(operands[1])
                    immediate_bin = self.immediate_to_binary(operands[2])
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                elif opcode in ['JZ', 'JN', 'JC', 'JMP', 'CALL']:
                    # Format: opcode Imm
                    # Check if it's a label or immediate value
                    if operands[0] in self.labels:
                        immediate_value = self.labels[operands[0]]
                        immediate_bin = self.immediate_to_binary(str(immediate_value))
                    else:
                        immediate_bin = self.immediate_to_binary(operands[0])
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                elif opcode == 'INT':
                    # Format: opcode index
                    immediate_bin = self.immediate_to_binary(operands[0])
                    binary = f"{opcode_bin}{rsrc1_bin}{rsrc2_bin}{rdst_bin}00{immediate_bin}"
                
                else:
                    raise ValueError(f"Unsupported opcode: {opcode}")
                
                # Add binary code to memory map
                self.memory_map[address] = binary
                
            except Exception as e:
                print(f"Error at line {line_num}: {e}")
                print(f"  Instruction: {opcode} {operands_str}")
                raise

    def write_output(self, output_file, format_type='bin'):
        """Write assembled output to file in specified format."""
        if format_type == 'mem':
            # Write in .mem format with @XXXXX section headers
            self.write_mem_output(output_file)
        else:
            # Write in original format
            self.write_bin_output(output_file)
            
    def write_bin_output(self, output_file):
        """Write binary output in original format."""
        binary_output = self.generate_output()
        
        with open(output_file, 'w') as f:
            for address, binary in binary_output:
                # Convert binary to hex for more compact representation
                hex_value = format(int(binary, 2), '08X')
                f.write(f"{address:08X}: {hex_value}\n")
        
        # Also write a more readable output file with annotations
        readable_output = f"{os.path.splitext(output_file)[0]}_readable.txt"
        with open(readable_output, 'w') as f:
            f.write(f"# Assembly of {output_file}\n")
            f.write(f"# Generated by Enhanced Assembler Modified\n\n")
            f.write("# Address  | Hex Code   | Binary (32-bits)\n")
            f.write("# --------------------------------------------\n")
            
            # Write the memory map with complete binary representation
            for address, binary in binary_output:
                hex_value = format(int(binary, 2), '08X')
                
                # Format each line with address, hex, and full binary
                f.write(f"0x{address:06X} | {hex_value} | {binary}\n")
            
            # Add label information
            if self.labels:
                f.write("\n# Labels:\n")
                for label, address in sorted(self.labels.items()):
                    f.write(f"# {label}: address 0x{address:06X}\n")
                    
            # Add instruction format reference
            f.write("\n# Instruction Format Reference:\n")
            f.write("# 31:27    26:24    23:21    20:18    17:16    15:0\n")
            f.write("# opcode   Rsrc1    Rsrc2    Rdst     -        Immediate/offset\n")
    
    def write_mem_output(self, output_file):
        """Write output in .mem format with @XXXXX section headers."""
        binary_output = self.generate_output()
        
        # Group instructions by section (first 5 hex digits of address)
        sections = {}
        for address, binary in binary_output:
            # Use the first 5 hex digits as section
            section = format(address, '05X')
            if section not in sections:
                sections[section] = []
            sections[section].append((address, binary))
        
        # Write sections to file
        with open(output_file, 'w') as f:
            for section in sorted(sections.keys()):
                # Write section header
                f.write(f"@{section}\n")
                
                # Write binary instructions for this section
                for _, binary in sorted(sections[section]):
                    f.write(f"{binary}\n")
        
        print(f"\nWrote .mem output to {output_file}")
        print(f"Created {len(sections)} memory sections with {len(binary_output)} instructions")

    def generate_output(self):
        """Generate binary output in correct memory address order."""
        # Sort memory addresses
        sorted_addresses = sorted(self.memory_map.keys())
        
        # Create a list to hold the final binary output
        binary_output = []
        
        if not sorted_addresses:
            return binary_output
            
        # Add instructions in memory address order
        for address in sorted_addresses:
            binary = self.memory_map[address]
            binary_output.append((address, binary))
        
        return binary_output

    def assemble(self, code):
        """Assemble the code and return binary output."""
        self.first_pass(code)
        self.second_pass()
        return self.generate_output()

def main():
    if len(sys.argv) < 2:
        print("Usage: python ModifiedAssembler.py input_file.asm [output_file] [-m/--mem]")
        print("  input_file.asm: Assembly source file to assemble")
        print("  output_file: Optional output file (default: input_file_base.bin or .mem)")
        print("  -m/--mem: Output in .mem format with @XXXXX headers (default: bin format)")
        return

    input_file = sys.argv[1]
    
    # Check if input file exists
    if not os.path.exists(input_file):
        print(f"Error: Input file '{input_file}' not found")
        return
    
    # Check for -m/--mem flag
    output_format = 'bin'
    if '-m' in sys.argv or '--mem' in sys.argv:
        output_format = 'mem'
        # Remove the flag from args
        if '-m' in sys.argv:
            sys.argv.remove('-m')
        if '--mem' in sys.argv:
            sys.argv.remove('--mem')
    
    # Default output file name based on input filename and format
    if len(sys.argv) > 2:
        output_file = sys.argv[2]
    else:
        base_name = os.path.splitext(input_file)[0]
        extension = '.mem' if output_format == 'mem' else '.bin'
        output_file = f"{base_name}{extension}"

    try:
        # Read assembly code from input file
        with open(input_file, 'r') as f:
            code = f.read()
        
        print(f"Assembling file: {input_file}")
        
        # Create assembler and process the code
        assembler = Assembler()
        binary_output = assembler.assemble(code)
        
        # Write output in requested format
        assembler.write_output(output_file, output_format)
        
        print(f"\nAssembly successful!")
        print(f"Output written to: {output_file}")
        
        if output_format != 'mem':
            print(f"Readable output written to: {os.path.splitext(output_file)[0]}_readable.txt")
        
        print(f"\nSummary:")
        print(f"- Instructions: {len(binary_output)}")
        print(f"- Labels defined: {len(assembler.labels)}")
        print(f"- Memory locations used: {len(binary_output)}")
        
    except Exception as e:
        print(f"Error during assembly: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    main()