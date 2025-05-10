-- Writeback
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Writeback_ports is
    Port (       
	
		  ----------------------------------inputs-------------------------------	
		  clk        		   : in STD_logic;
		  --rst        		: in STD_logic;
		  In_port  				: in STD_LOGIC_VECTOR (31 downto 0);
		  Memory_data  		: in STD_LOGIC_VECTOR (31 downto 0);
		  Alu_result  			: in STD_LOGIC_VECTOR (31 downto 0);
		  Memory_read_flag   : in STD_logic;
		  
		  

		  read_data1  			: in STD_LOGIC_VECTOR (31 downto 0);
		  read_data2  			: in STD_LOGIC_VECTOR (31 downto 0);
		  swap_flag        	: in STD_logic;--reg_Write2 flag
		  
		  reg_write1_flag    : in STD_logic;
		  
		  read_address1  : in STD_LOGIC_VECTOR (2 downto 0);
		  read_address2  : in STD_LOGIC_VECTOR (2 downto 0);
		  dst_address_in : in STD_LOGIC_VECTOR (2 downto 0);
		  
		  in_port_flag   : in STD_logic;
		  out_port_flag  : in STD_logic;
		  
		  
		  ----------------------------------outputs-------------------------------
		  Output_port  		: out STD_LOGIC_VECTOR (31 downto 0);---d
		  
		  Write_data1  		: out STD_LOGIC_VECTOR (31 downto 0);---d
		  Write_data2  		: out STD_LOGIC_VECTOR (31 downto 0);---d
		  
		  Write_address1  : out STD_LOGIC_VECTOR (2 downto 0);
		  Write_address2  : out STD_LOGIC_VECTOR (2 downto 0);
		  --dst_address     : out STD_LOGIC_VECTOR (2 downto 0);
		  
		  we1   		 : out STD_logic;
		  we2_swap   : out STD_logic
		  
		  
		  

		  
-- outputs
--Output_port-, Write_data1-, Write_data1-, Write_address1-, Write_address2-, we1-, we2_swap-, dst_address-
-- inputs
--clk-, rst, In_port-, Memory_data(32)-, Alu_result(32)-, Memory_read_flag-
--read_data1-, swap_flag-, read_data2-, read_address1-, read_address2-
--in_port_flag-, dst_address-.
		  
    );
end Writeback_ports;






architecture Behavioral of Writeback_ports is


--signal WR_Data_GreenMux: std_logic_vector(31 downto 0);


begin



    process(clk)
    begin
        if rising_edge(clk) then

		  -----------output_port-------------
			if out_port_flag = '1' then
			
				Output_port <= read_data1;
			
			else
			
				Output_port <= (others => '0');
				
			end if;
		  -----------------------------------d
		  
		  -----------------data handling------------------------------------------------
		  
		  ----write_data1---handling----
		  
		  if 	Memory_read_flag = '1' then
		  
		  ----Memory_data
		  
				if swap_flag = '1' then
				---read_data1
				
						if in_port_flag = '1' then
						---In_port
						Write_data1 <= In_port;
						
						else
						---read_data1
						Write_data1 <= read_data1;
						
						end if 
				
				
				
				else
				---Memory_data
						if in_port_flag = '1' then
						---In_port
						Write_data1 <= In_port;
						
						else
						---Memory_data
						Write_data1 <= Memory_data;
						
						end if 				

				end if
		  
		  
		  
		  else
		  ----alu_result 

		  
				if swap_flag = '1' then
				---read_data1
				
						if in_port_flag = '1' then
						---In_port
						Write_data1 <= In_port;
						
						else
						---read_data1
						Write_data1 <= read_data1;
						
						end if 
				
				
				
				else
				---alu_result
						if in_port_flag = '1' then
						---In_port
						Write_data1 <= In_port;
						
						else
						---alu_result
						Write_data1 <= alu_result;
						
						end if 				

				end if		  
		  

		  end if;
		  
		  
		  ----write_data2---handling----
		  if swap_flag = '1' then
		  
		  Write_data2 <= read_data2;
		  
		  end if;
		  ------------------------------d
		  
		  
		  -------------------------------------------------------------------------------d
		  
		  
		  
		  
		  -----------------adresses handling------------------------------------------------
		  
		  
		  
		  --------handling write address 1----------------------------
		  if in_port_flag = '1' then
		  
		  Write_address1 <= dst_address_in;

		  else
		  
		  Write_address1 <= read_address1;
		  
		  end if;
		  
		  ------------------------------------------------------------d
		  
		  
		  
		  --------handling write address 2----------------------------
		  
		  
		  if swap_flag = '1' then
		  
		  Write_address2 <= dst_address_in;
		  
		  end if;
		  
		  ------------------------------------------------------------d		  
		  
		  
		  
		  -------------------------------------------------------------------------------d	
	
		  
		  -----------------flags handling------------------------------------------------
		  we1 <= reg_write1_flag;
		  
		  we2_swap <= swap_flag;  
		  -------------------------------------------------------------------------------d
		  
				
				
        end if;
    end process;



    
    


end Behavioral;

