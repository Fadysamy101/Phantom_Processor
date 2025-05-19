-- Writeback
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Writeback is
    Port (        
		  clk          : in STD_logic;
		  rst          : in STD_logic;
		  Opcode       : in STD_LOGIC_VECTOR (2 downto 0);
		  alu_result   : in std_logic_vector(7 downto 0);
        Cout 			: in std_logic;
		  dst1_address  : in STD_LOGIC_VECTOR (2 downto 0);
          dst2_address  : in STD_LOGIC_VECTOR (2 downto  0);
		  RegWrite 		: in STD_LOGIC;
		  
		  
		  Opcode_out      : out STD_LOGIC_VECTOR (2 downto 0);
		  dst1_address_out : out STD_LOGIC_VECTOR (2 downto 0);
		  dst2_address_out : out STD_LOGIC_VECTOR (2 downto 0);
		  RegWrite_out 	: out STD_LOGIC;
		  alu_result_out  : out std_logic_vector(7 downto 0);
        Cout_out 			: out std_logic
  
		  
    );
end Writeback;






architecture Behavioral of Writeback is



begin



    process(clk, rst)
    begin
        if rst = '1' then
            Opcode_out      <= (others => '0');
            dst1_address_out <= (others => '0');
            dst2_address_out <= (others => '0');
            RegWrite_out    <= '0';
            alu_result_out  <= (others => '0');
            Cout_out        <= '0';

				
				
        elsif rising_edge(clk) then
		     
            Opcode_out      <= Opcode;
            dst1_address_out <= dst1_address;
            dst2_address_out <= dst2_address;
            RegWrite_out    <= RegWrite;
			alu_result_out  <= alu_result;
            Cout_out        <= Cout;
            
				
				
        end if;
    end process;



    
    


end Behavioral;

