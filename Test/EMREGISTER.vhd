library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ExecuteMemory is
    Port (
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        enable          : in  STD_LOGIC;

        Mem_Read_In        : in STD_LOGIC;
        Interrupt_In       : in STD_LOGIC;
        ALU_Result_In      : in STD_LOGIC_VECTOR(31 downto 0);
        Sp_Load_In         : in STD_LOGIC_vector(11 downto 0);
        Swap_In            : in STD_LOGIC;
        Rsrc1_In           : in STD_LOGIC_VECTOR(2 downto 0);
        Rsrc2_In           : in STD_LOGIC_VECTOR(2 downto 0);
        Rd_In              : in STD_LOGIC_VECTOR(2 downto 0);
        Reg1_Data_In       : in STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data_In       : in STD_LOGIC_VECTOR(31 downto 0);
        Reg_Write_In       : in STD_LOGIC;
        IN_Port_In         : in STD_LOGIC;
        Pc_In              : in STD_LOGIC_VECTOR(31 downto 0);
        Set_Carry_In       : in STD_LOGIC;
        Sp_Inc_In          : in STD_LOGIC;
        Sp_Dec_In          : in STD_LOGIC;
        Sp_Enable_In       : in STD_LOGIC;
        Branch_In          : in STD_LOGIC;
        Update_Flag_In     : in STD_LOGIC;
        Mem_Write_In       : in STD_LOGIC;
        RTI_In             : in STD_LOGIC;
        Return_Signal_In   : in STD_LOGIC;
        DM_IN              : in STD_LOGIC;
        Imm_Offset_In      : in STD_LOGIC_VECTOR(15 downto 0);
        Out_Port_In        : in STD_LOGIC;
        call_In            : in STD_LOGIC;
        flush_In           : in STD_LOGIC; 
        
        -- Outputs
        RTI                : out STD_LOGIC;
        Mem_Read           : out STD_LOGIC;
        Return_Signal      : out STD_LOGIC;
        Mem_Write          : out STD_LOGIC;
        ALU_Result         : out STD_LOGIC_VECTOR(31 downto 0);
        Sp_Load            : out STD_LOGIC_VECTOR( 11 downto 0);
        Rsrc1              : out STD_LOGIC_VECTOR(2 downto 0);
        Rsrc2              : out STD_LOGIC_VECTOR(2 downto 0);
        Rd                 : out STD_LOGIC_VECTOR(2 downto 0);
        Pc                 : out STD_LOGIC_VECTOR(31 downto 0);
        Set_Carry          : out STD_LOGIC;
        Sp_Inc             : out STD_LOGIC;
        Sp_Dec             : out STD_LOGIC;
        Sp_Enable          : out STD_LOGIC;
        Branch             : out STD_LOGIC;
        Update_Flag        : out STD_LOGIC;
        Reg1_Data          : out STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data          : out STD_LOGIC_VECTOR(31 downto 0);
        Swap               : out STD_LOGIC;
        Reg_Write          : out STD_LOGIC;
        IN_Port            : out STD_LOGIC;
        call_out           : out STD_LOGIC;
        DM_Addr            : out STD_LOGIC;
        Index              : out STD_LOGIC_VECTOR(15 downto 0);
        Out_Port           : out STD_LOGIC;
        Interrupt_out      : out STD_LOGIC
    );
end ExecuteMemory;

architecture Behavioral of ExecuteMemory is
    -- Internal registers to store input values
    signal Mem_Read_Reg        : STD_LOGIC := '0';
    signal Interrupt_Reg       : STD_LOGIC := '0';
    signal ALU_Result_Reg      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Sp_Load_Reg         : STD_LOGIC_vector(11 downto 0) := (others => '0');
    signal Swap_Reg            : STD_LOGIC := '0';
    signal Rsrc1_Reg           : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Rsrc2_Reg           : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Rd_Reg              : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Reg1_Data_Reg       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Reg2_Data_Reg       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Reg_Write_Reg       : STD_LOGIC := '0';
    signal IN_Port_Reg         : STD_LOGIC := '0';
    signal Pc_Reg              : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Set_Carry_Reg       : STD_LOGIC := '0';
    signal Sp_Inc_Reg          : STD_LOGIC := '0';
    signal Sp_Dec_Reg          : STD_LOGIC := '0';
    signal Sp_Enable_Reg       : STD_LOGIC := '0';
    signal Branch_Reg          : STD_LOGIC := '0';
    signal Update_Flag_Reg     : STD_LOGIC := '0';
    signal Mem_Write_Reg       : STD_LOGIC := '0';
    signal RTI_Reg             : STD_LOGIC := '0';
    signal Return_Signal_Reg   : STD_LOGIC := '0';
    signal DM_Reg              : STD_LOGIC := '0';
    signal Imm_Offset_Reg      : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Out_Port_Reg        : STD_LOGIC := '0';
    signal call_Reg            : STD_LOGIC := '0';

begin
    -- Register inputs on rising edge
    process (clk, rst)
    begin
        if rst = '1' then
            call_Reg <= '0';
            Mem_Read_Reg      <= '0';
            Interrupt_Reg     <= '0';
            ALU_Result_Reg    <= (others => '0');
            Sp_Load_Reg       <= (others => '0');
            Swap_Reg          <= '0';
            Rsrc1_Reg         <= (others => '0');
            Rsrc2_Reg         <= (others => '0');
            Rd_Reg            <= (others => '0');
            Reg1_Data_Reg     <= (others => '0');
            Reg2_Data_Reg     <= (others => '0');
            Reg_Write_Reg     <= '0';
            IN_Port_Reg       <= '0';
            Pc_Reg            <= (others => '0');
            Set_Carry_Reg     <= '0';
            Sp_Inc_Reg        <= '0';
            Sp_Dec_Reg        <= '0';
            Sp_Enable_Reg     <= '0';
            Branch_Reg        <= '0';
            Update_Flag_Reg   <= '0';
            Mem_Write_Reg     <= '0';
            RTI_Reg           <= '0';
            Return_Signal_Reg <= '0';
            DM_Reg            <= '0';
            Imm_Offset_Reg    <= (others => '0');
            Out_Port_Reg      <= '0';
        elsif rising_edge(clk) then
            if enable = '1' then
                call_Reg <= call_In;
                Mem_Read_Reg      <= Mem_Read_In;
                Interrupt_Reg     <= Interrupt_In;
                ALU_Result_Reg    <= ALU_Result_In;
                Sp_Load_Reg       <= Sp_Load_In;
                Swap_Reg          <= Swap_In;
                Rsrc1_Reg         <= Rsrc1_In;
                Rsrc2_Reg         <= Rsrc2_In;
                Rd_Reg            <= Rd_In;
                Reg1_Data_Reg     <= Reg1_Data_In;
                Reg2_Data_Reg     <= Reg2_Data_In;
                Reg_Write_Reg     <= Reg_Write_In;
                IN_Port_Reg       <= IN_Port_In;
                Pc_Reg            <= Pc_In;
                Set_Carry_Reg     <= Set_Carry_In;
                Sp_Inc_Reg        <= Sp_Inc_In;
                Sp_Dec_Reg        <= Sp_Dec_In;
                Sp_Enable_Reg     <= Sp_Enable_In;
                Branch_Reg        <= Branch_In;
                Update_Flag_Reg   <= Update_Flag_In;
                Mem_Write_Reg     <= Mem_Write_In;
                RTI_Reg           <= RTI_In;
                Return_Signal_Reg <= Return_Signal_In;
                DM_Reg            <= DM_In;
                Imm_Offset_Reg    <= Imm_Offset_In;
                Out_Port_Reg      <= Out_Port_In;
            end if;
        end if;
    end process;

    -- Combinational outputs (continuous assignments)
RTI            <= '0' when flush_in = '1' else RTI_Reg;
Mem_Read       <= '0' when flush_in = '1' else Mem_Read_Reg;
Return_Signal  <= '0' when flush_in = '1' else Return_Signal_Reg;
Mem_Write      <= '0' when flush_in = '1' else Mem_Write_Reg;
ALU_Result     <= (others => '0') when flush_in = '1' else ALU_Result_Reg;
Sp_Load        <=  (others => '0')when flush_in = '1' else Sp_Load_Reg;
Rsrc1          <= (others => '0') when flush_in = '1' else Rsrc1_Reg;
Rsrc2          <= (others => '0') when flush_in = '1' else Rsrc2_Reg;
Rd             <= (others => '0') when flush_in = '1' else Rd_Reg;
Pc             <= (others => '0') when flush_in = '1' else Pc_Reg;
Set_Carry      <= '0' when flush_in = '1' else Set_Carry_Reg;
Sp_Inc         <= '0' when flush_in = '1' else Sp_Inc_Reg;
Sp_Dec         <= '0' when flush_in = '1' else Sp_Dec_Reg;
Sp_Enable      <= '0' when flush_in = '1' else Sp_Enable_Reg;
Branch         <= '0' when flush_in = '1' else Branch_Reg;
Update_Flag    <= '0' when flush_in = '1' else Update_Flag_Reg;
Reg1_Data      <= (others => '0') when flush_in = '1' else Reg1_Data_Reg;
Reg2_Data      <= (others => '0') when flush_in = '1' else Reg2_Data_Reg;
Swap           <= '0' when flush_in = '1' else Swap_Reg;
Reg_Write      <= '0' when flush_in = '1' else Reg_Write_Reg;
IN_Port        <= '0' when flush_in = '1' else IN_Port_Reg;
DM_Addr        <= '0' when flush_in = '1' else DM_Reg;
Index          <= (others => '0') when flush_in = '1' else Imm_Offset_Reg;
Out_Port       <= '0' when flush_in = '1' else Out_Port_Reg;
call_out       <= '0' when flush_in = '1' else call_Reg;
Interrupt_out  <= '0' when flush_in = '1' else Interrupt_Reg;

end Behavioral;