--Fetch_Decode 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Fetch_Decode is
    Port (        
--      PC 		      : in STD_LOGIC_VECTOR (7 downto 0);

		  clk          : in STD_logic;
		  rst          : in STD_logic;
		  en 				: in STD_LOGIC;
		  instruction  : in STD_LOGIC_VECTOR (15 downto 0);		  
		  Opcode       : out STD_LOGIC_VECTOR (2 downto 0);
		  src1_address : out STD_LOGIC_VECTOR (2 downto 0);
		  src2_address : out STD_LOGIC_VECTOR (2 downto 0);
		  dst_address  : out STD_LOGIC_VECTOR (2 downto 0)
		  
		   
		  
    );
end Fetch_Decode;



architecture Behavioral of Fetch_Decode is

	

	signal instruction_reg : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');


 

begin


	process(clk, rst)
	begin

		  if rst = '1' then
            instruction_reg <= (others => '0');				
				
        elsif rising_edge(clk) then
		     
            if en = '1' then
				
				instruction_reg <= instruction; 
				
				end if;  
								
        end if;
	

	end process;
	
	
	
    Opcode       <= instruction_reg(15 downto 13) when en = '1' else "000"; 
    src1_address <= instruction_reg(12 downto 10) when en = '1' else "000";
    src2_address <= instruction_reg(9 downto 7)   when en = '1' else "000";
    dst_address  <= instruction_reg(6 downto 4)   when en = '1' else "000";
    
    


end Behavioral;