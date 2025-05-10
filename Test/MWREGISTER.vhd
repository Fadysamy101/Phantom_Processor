library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MemoryWrite is

    Port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        enable       : in  STD_LOGIC;

        Read_Data_In     : in STD_LOGIC_VECTOR(31 downto 0);
        ALU_Result_In    : in STD_LOGIC_VECTOR(31 downto 0);
        Mem_Read_In      : in STD_LOGIC;
        Rsrc1_In         : in STD_LOGIC_VECTOR(2 downto 0);
		  Rd_In            : in STD_LOGIC_VECTOR(2 downto 0);
        Reg1_Data_In     : in STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data_In     : in STD_LOGIC_VECTOR(31 downto 0);
        Swap_In          : in STD_LOGIC;
        Reg_Write_In     : in STD_LOGIC;
        IN_Port_In       : in STD_LOGIC;

        Read_Data     : out STD_LOGIC_VECTOR(31 downto 0);
        ALU_Result    : out STD_LOGIC_VECTOR(31 downto 0);
		  Reg1_Addr     : out STD_LOGIC_VECTOR(2 downto 0);
        Reg2_Addr     : out STD_LOGIC_VECTOR(2 downto 0);
        Mem_Read      : out STD_LOGIC;
        Reg1_Data     : out STD_LOGIC_VECTOR(31 downto 0);
        Swap          : out STD_LOGIC;
        IN_Port       : out STD_LOGIC;
		  Reg2_Write    : out STD_LOGIC
    );
	 
end MemoryWrite;

architecture Behavioral of MemoryWrite is

    signal Read_Data_Reg     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ALU_Result_Reg    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Mem_Read_Reg      : STD_LOGIC := '0';
    signal Rsrc1_Reg         : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
	 signal Rd_Reg            : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Reg1_Data_Reg     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Reg2_Data_Reg     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Swap_Reg          : STD_LOGIC := '0';
    signal Reg_Write_Reg     : STD_LOGIC := '0';
    signal IN_Port_Reg       : STD_LOGIC := '0';
	 
begin

    process (clk, rst)
	 
    begin
	 
        if rst = '1' then
		  
            Read_Data_Reg   <= (others => '0');
            ALU_Result_Reg  <= (others => '0');
            Mem_Read_Reg    <= '0';
            Rsrc1_Reg       <= (others => '0');
				Rd_Reg          <= (others => '0');
            Reg1_Data_Reg   <= (others => '0');
            Reg2_Data_Reg   <= (others => '0');
            Swap_Reg        <= '0';
            Reg_Write_Reg   <= '0';
            IN_Port_Reg     <= '0';

            Read_Data   <= (others => '0');
            ALU_Result  <= (others => '0');
				Reg1_Addr   <= (others => '0');
            Reg2_Addr   <= (others => '0');
            Mem_Read    <= '0';
            Reg1_Data   <= (others => '0');
            Swap        <= '0';
            IN_Port     <= '0';
				Reg2_Write  <= '0';

        elsif rising_edge(clk) then
		  
            if enable = '1' then
				
                Read_Data_Reg   <= Read_Data_In;
                ALU_Result_Reg  <= ALU_Result_In;
                Mem_Read_Reg    <= Mem_Read_In;
                Rsrc1_Reg       <= Rsrc1_In;
					 Rd_Reg          <= Rd_In;
                Reg1_Data_Reg   <= Reg1_Data_In;
                Reg2_Data_Reg   <= Reg2_Data_In;
                Swap_Reg        <= Swap_In;
                Reg_Write_Reg   <= Reg_Write_In;
                IN_Port_Reg     <= IN_Port_In;
					 
            end if;

        elsif falling_edge(clk) then
		  
            Read_Data   <= Read_Data_Reg;
            ALU_Result  <= ALU_Result_Reg;
				Reg1_Addr   <= Rd_Reg;
            Reg2_Addr   <= Rsrc1_Reg;
            Mem_Read    <= Mem_Read_Reg;
            Reg1_Data   <= Reg1_Data_Reg;
            Swap        <= Swap_Reg;
            IN_Port     <= IN_Port_Reg;
				Reg2_Write  <= Swap_Reg;
				
        end if;
		  
    end process;
	 
end Behavioral;
