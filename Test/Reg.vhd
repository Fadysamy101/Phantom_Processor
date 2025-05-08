library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is
    generic(
        ADDR_WIDTH : integer := 3;
        DATA_WIDTH : integer := 8
    );
    port(
        clk       : in std_logic;
        rst       : in std_logic;
        -- Write port
        we        : in std_logic;
        waddr     : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        wdata     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        -- Read ports
        raddr1    : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        raddr2    : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        rdata1    : out std_logic_vector(DATA_WIDTH-1 downto 0);
        rdata2    : out std_logic_vector(DATA_WIDTH-1 downto 0);
        -- Forwarding bypass
        fw_addr   : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        fw_data   : in std_logic_vector(DATA_WIDTH-1 downto 0);
        fw_en     : in std_logic
    );
end Reg;

architecture behavioral of Reg is
    type reg_array is array(0 to 2**ADDR_WIDTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal REGISTERS : reg_array;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            REGISTERS <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if we = '1' then
                REGISTERS(to_integer(unsigned(waddr))) <= wdata;
            end if;
        end if;
    end process;

    -- Read with forwarding bypass
    rdata1 <= fw_data when (fw_en = '1' and raddr1 = fw_addr) else 
              REGISTERS(to_integer(unsigned(raddr1)));
              
    rdata2 <= fw_data when (fw_en = '1' and raddr2 = fw_addr) else 
              REGISTERS(to_integer(unsigned(raddr2)));
end behavioral;
