--Decode Execute 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decode_Execute is
    Port (        
		  clk          : in STD_logic;
		  rst          : in STD_logic;
		  Opcode       : in STD_LOGIC_VECTOR (2 downto 0);
		  src1_data 	: in STD_LOGIC_VECTOR (7 downto 0);
		  src2_data 	: in STD_LOGIC_VECTOR (7 downto 0);
		  dst_address  : in STD_LOGIC_VECTOR (2 downto 0);
		  RegWrite 		: in STD_LOGIC;
		  
		  
		  Opcode_out      : out STD_LOGIC_VECTOR (2 downto 0);
		  src1_data_out 	: out STD_LOGIC_VECTOR (7 downto 0);
		  src2_data_out 	: out STD_LOGIC_VECTOR (7 downto 0);
		  dst_address_out : out STD_LOGIC_VECTOR (2 downto 0);
		  RegWrite_out 	: out STD_LOGIC
  
		  
    );
end Decode_Execute;






architecture Behavioral of Decode_Execute is



begin



    process(clk, rst)
    begin
        if rst = '1' then
            Opcode_out      <= (others => '0');
            dst_address_out <= (others => '0');
            RegWrite_out    <= '0';
            src1_data_out  <= (others => '0');
				src2_data_out  <= (others => '0');
				
				
        elsif rising_edge(clk) then
		     
            Opcode_out      <= Opcode;
            dst_address_out <= dst_address;
            RegWrite_out    <= RegWrite;
				src1_data_out   <= src1_data;
				src2_data_out   <= src2_data;  
				
				
        end if;
    end process;



    
    


end Behavioral;
