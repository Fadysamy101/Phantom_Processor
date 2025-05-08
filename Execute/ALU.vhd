library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
  port(
    -- Inputs
    operand1       : in std_logic_vector(31 downto 0);
    operand2       : in std_logic_vector(31 downto 0);
    opcode   : in std_logic_vector(2 downto 0);
    -- Outputs
    ALU_result  : out std_logic_vector(31 downto 0);
    carry    : out std_logic;
    Overflow: out std_logic
  );
end entity ALU;