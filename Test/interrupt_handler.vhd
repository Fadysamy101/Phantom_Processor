library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity interrupt_handler is
    port
    (
      INTR_IN_HW : in std_logic;  -- Interrupt input, single bit
      opcode   : in std_logic_vector(4 downto 0);
      INTR_FROM_MEM_STAGE : in std_logic;  -- Interrupt from memory stage
      stall_PC: out std_logic
    );
 end interrupt_handler;   
 architecture Behavioral of interrupt_handler is
  BEGIN
  process(INTR_IN_HW, opcode)
  begin
  if(intr_from_mem_stage = '1') then
    stall_PC <= '0';  
  elsif (INTR_IN_HW = '1' or opcode ="11000") then
    stall_PC <= '1';
  else
    stall_PC <= '0';
  end if;  
  end process;  
 end Behavioral;    