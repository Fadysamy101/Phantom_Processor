-- Controller
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
    Port (        
		  Opcode   : in STD_LOGIC_VECTOR (2 downto 0);
		  ALU_sel  : out STD_LOGIC_VECTOR (2 downto 0);
		  RegWrite : out STD_LOGIC
    );
end Controller;




architecture Behavioral of Controller is



begin

	ALU_sel  <= Opcode when Opcode = "100" or Opcode = "101" or Opcode = "110" or Opcode = "111" else "000";
	RegWrite <= '1' when Opcode = "100" or Opcode = "101" or Opcode = "110" or Opcode = "111" else '0';




end Behavioral;