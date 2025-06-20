LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY UnifiedMemory IS
    GENERIC (
        Address_bits : INTEGER := 12;  -- 12 bits = 4096 memory locations
        Data_width   : INTEGER := 32   -- 32-bit data width
    );
    PORT (
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;
        -- Data memory control signals
        Mem_Read        : IN STD_LOGIC;
        Mem_Write       : IN STD_LOGIC;
        PC_From_Counter : IN STD_LOGIC_VECTOR(11 DOWNTO 0);

        -- Address inputs for data memory
        DM_address      : IN STD_LOGIC;  -- Selector for address source
        ALU_result      : IN STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
        SP_Load         : IN STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
        SP_INC          : IN STD_LOGIC;
        Call            : IN STD_LOGIC;

        -- Data inputs
        Rsrc1           : IN STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
        PC_Flag_1       : IN STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);

        -- Data memory output
        Read_data       : OUT STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
        Struct_hazard_detected: out STD_LOGIC
    );
END ENTITY;
ARCHITECTURE Behavioral OF UnifiedMemory IS
    TYPE memory_array IS ARRAY (0 TO 2**Address_bits - 1) OF STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
    SIGNAL memory : memory_array := (OTHERS => (OTHERS => '0'));

    SIGNAL WriteAddress : STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
    SIGNAL ReadAddress  : STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
    SIGNAL Write_data   : STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
    SIGNAL instr_read_data : STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
    signal data_bus : STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
  

BEGIN
     
    -- Address generation logic
       --Write address selection based on DM_address
      process(DM_address,ALU_Result, SP_Load)
      begin
       if DM_address = '1' then
            WriteAddress <= SP_Load;
        else
            WriteAddress <= ALU_result;
        end if; 
      end process; 
      --Read address selection based on SP_INC
      process(SP_INC,ALU_Result, SP_Load)
      begin
       if SP_INC = '1' then
            ReadAddress <= SP_Load;
        else
            ReadAddress <= ALU_result;
        end if; 
      end process; 
      
      -- Data selection logic using call
    process(Call, Rsrc1, PC_Flag_1)
    begin
        if Call = '1' then
            Write_data <= Rsrc1; 
        else
            Write_data <= PC_Flag_1;  
        end if;
    end process;


    -- Memory access for data (read/write)
    process(clk, reset)
    begin
        if reset = '1' then
            data_bus <= (others => '0');
            Struct_hazard_detected <= '0';
        else
            Struct_hazard_detected <= '0';

            if Mem_Write = '1' and rising_edge(clk) then
                memory(to_integer(unsigned(WriteAddress))) <= Write_data;
                Struct_hazard_detected <= '1';
            elsif Mem_Read = '1' and falling_edge(clk) then
                data_bus <= memory(to_integer(unsigned(ReadAddress)));
                Struct_hazard_detected <= '1';
            else
                -- If no data access, pass instruction value
                data_bus <= data_bus;
            end if;
        end if;
    end process;
    instr_read_data <= memory(to_integer(unsigned(PC_From_Counter)));
    
        -- Combinational instruction fetch
        Read_data <= data_bus when Mem_Read = '1' else
                     instr_read_data when Mem_Write = '0';

END ARCHITECTURE;
