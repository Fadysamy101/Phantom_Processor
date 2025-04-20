-----Program Counter
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProgramCounter is
    Port (
        clk : in STD_LOGIC;          
        rst : in STD_LOGIC;         
        en : in STD_LOGIC;          
        PC : out STD_LOGIC_VECTOR (7 downto 0)  
    );
end ProgramCounter;

architecture Behavioral of ProgramCounter is

    signal counter : UNSIGNED (7 downto 0) := (others => '0');
--    signal rst_sync, en_sync : STD_LOGIC;
--    signal rst_ff, en_ff : STD_LOGIC;





begin

--    process (clk)
--    begin
--        if rising_edge(clk) then
--            rst_ff <= rst;
--            rst_sync <= rst_ff;
--        end if;
--    end process;


--    process (clk)
--    begin
--        if rising_edge(clk) then
--            en_ff <= en;
--            en_sync <= en_ff;
--        end if;
--    end process;


    process (clk, rst)  
    begin
	 
	 
		  if rst = '1' then
            counter <= (others => '0');				
				
        elsif rising_edge(clk) then
		     
            if en = '1' then
				
				counter <= counter + 1; 
				
				end if;  
								
        end if;
	 
	 
	 
	 
	 
--        if  rising_edge(clk) then  
--				if rst = '1' then
--					counter <= (others => '0');		
--            elsif en = '1' then  
--                counter <= counter + 1;
--            end if;
--        end if;
		  
		  
		  
    end process;


    PC <= STD_LOGIC_VECTOR(counter); 


end Behavioral;









