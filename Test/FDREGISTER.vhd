library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FetchDecode is
    Port (
        clk            : in  STD_LOGIC;
        rst            : in  STD_LOGIC;
        en             : in  STD_LOGIC;
        Pc_in          : in  STD_LOGIC_VECTOR(31 downto 0);
        Instruction_In : in  STD_LOGIC_VECTOR(31 downto 0);
        Interrupt_In   : in  STD_LOGIC;
        Pc             : out STD_LOGIC_VECTOR(31 downto 0);
        Rsrc1          : out STD_LOGIC_VECTOR(2 downto 0);
        Rsrc2          : out STD_LOGIC_VECTOR(2 downto 0);
        Interrupt      : out STD_LOGIC;
        Instruction    : out STD_LOGIC_VECTOR(31 downto 0)
    );
     
end FetchDecode;

architecture Behavioral of FetchDecode is
    -- Internal registers to store input values
    signal Pc_Reg          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Instruction_Reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Interrupt_Reg   : STD_LOGIC := '0';
     
begin
    -- Sequential process for register updates
    process (clk, rst)
    begin
        if rst = '1' then
            -- Reset all registers to default values
            Pc_Reg          <= (others => '0');
            Instruction_Reg <= (others => '0');
            Interrupt_Reg   <= '0';
        elsif rising_edge(clk) then
            -- On rising edge, update registers if enabled
            if en = '1' then
                Pc_Reg          <= Pc_in;
                Instruction_Reg <= Instruction_In;
                Interrupt_Reg   <= Interrupt_In;
            end if;
			elsif falling_edge(clk) then
				  Pc          <= Pc_in;
				 Rsrc1       <= instruction_in(26 downto 24);
				 Rsrc2       <= instruction_in(23 downto 21);
				 Instruction <= Instruction_In;
				 Interrupt   <= Interrupt_In;
     
        end if;
    end process;
    
    -- Continuous assignments for outputs
    -- Output values are directly driven by the register values
  
end Behavioral;