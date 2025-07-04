library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flipflop is

    port (
        clk     : in STD_LOGIC;
        rst     : in STD_LOGIC;
        D       : in STD_LOGIC;
        Q       : out STD_LOGIC:='0'
    );
end flipflop;

architecture Behavioral of flipflop is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            Q <='0';  
        elsif rising_edge(clk) then
            Q <= D;
        end if;
    end process;
end Behavioral;

-- Example instantiation for different bit widths:
-- 
-- For 1-bit (single bit):
-- ff_1bit : entity work.flipflop
--     generic map (WIDTH => 1)
--     port map (
--         clk => clock,
--         rst => reset,
--         D => data_in(0 downto 0),  -- or use D(0) => single_bit_signal
--         Q => data_out(0 downto 0)
--     );
--
-- For 8-bit:
-- ff_8bit : entity work.flipflop
--     generic map (WIDTH => 8)
--     port map (
--         clk => clock,
--         rst => reset,
--         D => byte_data_in,
--         Q => byte_data_out
--     );
--
