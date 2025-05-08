-----Program Counter
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProgramCounter is
    Port (
        clk       : in STD_LOGIC;
        rst       : in STD_LOGIC;
        stall     : in STD_LOGIC;  -- Hazard detection
        branch    : in STD_LOGIC;  -- From EX stage
        branch_addr : in STD_LOGIC_VECTOR(7 downto 0); -- From ALU
        PC        : out STD_LOGIC_VECTOR(7 downto 0)
    );
end ProgramCounter;

architecture Behavioral of ProgramCounter is
    signal counter : UNSIGNED(7 downto 0);
begin
    process(clk, rst)
    begin
        if rst = '1' then
            counter <= (others => '0');
        elsif rising_edge(clk) then
            if stall = '0' then
                if branch = '1' then
                    counter <= unsigned(branch_addr);
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
    PC <= STD_LOGIC_VECTOR(counter);
end Behavioral;


