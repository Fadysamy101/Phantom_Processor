library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PipelineProcessor is
    Port (
        clk        : in STD_LOGIC;
        rst        : in STD_LOGIC;
        en         : in STD_LOGIC;
    
        -- I/O ports
        in_port    : in STD_LOGIC_VECTOR(31 downto 0);
        out_port   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end PipelineProcessor;

architecture Structural of PipelineProcessor is
    -- Component declarations
    --Pipeline stages + Decode stage+Memory
    component FetchDecode is
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
    end component; 
    component DecodeExecute is
        Port (
            clk             : in  STD_LOGIC;
            rst             : in  STD_LOGIC;
            enable          : in  STD_LOGIC;
            -- Inputs from Fetch/Decode
            Pc_In           : in STD_LOGIC_VECTOR(31 downto 0);
            Read_Addr1_In   : in STD_LOGIC_VECTOR(2 downto 0);
            Read_Addr2_In   : in STD_LOGIC_VECTOR(2 downto 0);
            Interrupt_In    : in STD_LOGIC;
            Rd_Addr_In      : in STD_LOGIC_VECTOR(2 downto 0);
            Imm_Offset_In   : in STD_LOGIC_VECTOR(15 downto 0);
            Rsrc1_Data_In   : in STD_LOGIC_VECTOR(31 downto 0);
            Rsrc2_Data_In   : in STD_LOGIC_VECTOR(31 downto 0);
            -- Control signals in
            Swap_In         : in STD_LOGIC;
            Set_Carry_In    : in STD_LOGIC;
            Sp_Inc_In       : in STD_LOGIC;
            Sp_Dec_In       : in STD_LOGIC;
            Sp_Enable_In    : in STD_LOGIC;
            RTI_In          : in STD_LOGIC;
            Return_Signal_In: in STD_LOGIC;
            Call_In         : in STD_LOGIC;
            ALU_Srcl_In     : in STD_LOGIC;
            Branch_In       : in STD_LOGIC;
            Mem_Read_In     : in STD_LOGIC;
            Reg_Write_In    : in STD_LOGIC;
            Update_Flag_In  : in STD_LOGIC;
            IN_Port_In      : in STD_LOGIC;
            Mem_Write_In    : in STD_LOGIC;
            J_SC_In         : in STD_LOGIC_VECTOR(1 downto 0);
            Opcode_In       : in STD_LOGIC_VECTOR(4 downto 0);
            DM_In           : in STD_LOGIC;
            -- Outputs to Execute/Memory
            Mem_Read        : out STD_LOGIC;
            Interrupt       : out STD_LOGIC;
            Reg1_Data       : out STD_LOGIC_VECTOR(31 downto 0);
            Reg2_Data       : out STD_LOGIC_VECTOR(31 downto 0);
            Swap            : out STD_LOGIC;
            Rsrc1           : out STD_LOGIC_VECTOR(2 downto 0);
            Rd              : out STD_LOGIC_VECTOR(2 downto 0);
            Reg_Write       : out STD_LOGIC;
            IN_Port         : out STD_LOGIC;
            Pc              : out STD_LOGIC_VECTOR(31 downto 0);
            Set_Carry       : out STD_LOGIC;
            Sp_Inc          : out STD_LOGIC;
            Sp_Dec          : out STD_LOGIC;
            Sp_Enable       : out STD_LOGIC;
            RTI             : out STD_LOGIC;
            Return_Signal   : out STD_LOGIC;
            Call            : out STD_LOGIC;
            ALU_Srcl        : out STD_LOGIC;
            Branch          : out STD_LOGIC;
            Update_Flag     : out STD_LOGIC;
            Mem_Write       : out STD_LOGIC;
            J_SC            : out STD_LOGIC_VECTOR(1 downto 0);
            ALU_SLC         : out STD_LOGIC_VECTOR(4 downto 0);
            DM              : out STD_LOGIC;
            Imm_Offset      : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component ExecuteMemory is
        Port (
            clk             : in  STD_LOGIC;
            rst             : in  STD_LOGIC;
            enable          : in  STD_LOGIC;
            -- Inputs from Decode/Execute
            Mem_Read_In     : in STD_LOGIC;
            Interrupt_In    : in STD_LOGIC;
            ALU_Result_In   : in STD_LOGIC_VECTOR(31 downto 0);
            Sp_Load_In      : in STD_LOGIC;
            Swap_In         : in STD_LOGIC;
            Rsrc1_In        : in STD_LOGIC_VECTOR(2 downto 0);
            Rd_In           : in STD_LOGIC_VECTOR(2 downto 0);
            Reg1_Data_In    : in STD_LOGIC_VECTOR(31 downto 0);
            Reg2_Data_In    : in STD_LOGIC_VECTOR(31 downto 0);
            Reg_Write_In    : in STD_LOGIC;
            IN_Port_In      : in STD_LOGIC;
            Pc_In           : in STD_LOGIC_VECTOR(31 downto 0);
            Set_Carry_In    : in STD_LOGIC;
            Sp_Inc_In       : in STD_LOGIC;
            Sp_Dec_In       : in STD_LOGIC;
            Sp_Enable_In    : in STD_LOGIC;
            Branch_In       : in STD_LOGIC;
            Update_Flag_In  : in STD_LOGIC;
            Mem_Write_In    : in STD_LOGIC;
            RTI_In          : in STD_LOGIC;
            Return_Signal_In: in STD_LOGIC;
            DM_IN           : in STD_LOGIC;
            Imm_Offset_In   : in STD_LOGIC_VECTOR(15 downto 0);
            -- Outputs to Memory/Writeback
            RTI             : out STD_LOGIC;
            Mem_Read        : out STD_LOGIC;
            Return_Signal   : out STD_LOGIC;
            Mem_Write       : out STD_LOGIC;
            ALU_Result      : out STD_LOGIC_VECTOR(31 downto 0);
            Sp_Load         : out STD_LOGIC;
            Rsrc1           : out STD_LOGIC_VECTOR(2 downto 0);
            Rd              : out STD_LOGIC_VECTOR(2 downto 0);
            Pc              : out STD_LOGIC_VECTOR(31 downto 0);
            Set_Carry       : out STD_LOGIC;
            Sp_Inc          : out STD_LOGIC;
            Sp_Dec          : out STD_LOGIC;
            Sp_Enable       : out STD_LOGIC;
            Branch          : out STD_LOGIC;
            Update_Flag     : out STD_LOGIC;
            Reg1_Data       : out STD_LOGIC_VECTOR(31 downto 0);
            Reg2_Data       : out STD_LOGIC_VECTOR(31 downto 0);
            Swap            : out STD_LOGIC;
            Reg_Write       : out STD_LOGIC;
            IN_Port         : out STD_LOGIC;
            DM_Addr         : out STD_LOGIC;
            Index           : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component MemoryWrite is
        Port (
            clk          : in  STD_LOGIC;
            rst          : in  STD_LOGIC;
            enable       : in  STD_LOGIC;
            -- Inputs from Execute/Memory
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
            -- Outputs to Writeback
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
    end component;

    component Forwarding_Unit is
        port(
            -- Source registers from Decode/Execute
            D_EX_rs1      : in std_logic_vector(2 downto 0);
            D_EX_rs2      : in std_logic_vector(2 downto 0);
            -- Destination registers from Execute/Memory and Memory/Writeback
            EX_M_rd       : in std_logic_vector(2 downto 0);
            M_WB_rd       : in std_logic_vector(2 downto 0);
            -- Outputs
            Forward_array_Rs1 : out std_logic_vector(1 downto 0);
            Forward_array_Rs2 : out std_logic_vector(1 downto 0)
        );
    end component;
    component PC_new is
        Port (
            clk              : in  STD_LOGIC;
            rst              : in  STD_LOGIC;
            en               : in  STD_LOGIC;
            -- Inputs
            in_from_CCR      : in  STD_LOGIC_VECTOR(3 downto 0);
            in_J_SC          : in  STD_LOGIC_VECTOR(1 downto 0);
            Call             : in  STD_LOGIC;
            branch_addr      : in  STD_LOGIC_VECTOR(31 downto 0); -- From ALU
            RTI              : in  std_logic;
            Return_flag      : in  std_logic;
            Interrupt        : in  std_logic;
            -- Outputs
            PC_new           : out STD_LOGIC_VECTOR(31 downto 0);
            PC_loaded_from_memory   : in STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
  
    component Memory IS
        GENERIC (
            Address_bits : INTEGER := 12;
            Data_width   : INTEGER := 32
        );
        PORT (
            clk      : IN STD_LOGIC;
            reset    : IN STD_LOGIC;
            writeEn  : IN STD_LOGIC;
            address  : IN STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
            readEn   : IN STD_LOGIC;
            data_in  : IN STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0)
        );
    END component;
    Component Decode_Stage is
    Port (
        -- Clock and reset
        clk               : in  STD_LOGIC;
        rst               : in  STD_LOGIC;
        
        -- Input from IF/ID pipeline register
        instruction       : in  STD_LOGIC_VECTOR(31 downto 0);
        PC_plus1          : in  STD_LOGIC_VECTOR(31 downto 0);
        
        -- Input from Write Back stage
        write_data        : in  STD_LOGIC_VECTOR(31 downto 0);
        wb_reg_addr       : in  STD_LOGIC_VECTOR(2 downto 0);
        wb_reg_write      : in  STD_LOGIC;
        
        -- Input for swap operation
        swap_data         : in  STD_LOGIC_VECTOR(31 downto 0);
        swap_reg_addr     : in  STD_LOGIC_VECTOR(2 downto 0);
        swap_enable       : in  STD_LOGIC;
        
        -- Hazard Detection inputs
        ex_mem_read       : in  STD_LOGIC;
        ex_mem_write      : in  STD_LOGIC;
        ex_dest_reg       : in  STD_LOGIC_VECTOR(2 downto 0);
        data_hazard_needed: in  STD_LOGIC;
        branch_taken      : in  STD_LOGIC;
        
        -- Outputs to ID/EX pipeline register
        read_data1        : out STD_LOGIC_VECTOR(31 downto 0);
        read_data2        : out STD_LOGIC_VECTOR(31 downto 0);
        immediate         : out STD_LOGIC_VECTOR(15 downto 0);
        offset            : out STD_LOGIC_VECTOR(15 downto 0);
        rs1_addr          : out STD_LOGIC_VECTOR(2 downto 0);
        rs2_addr          : out STD_LOGIC_VECTOR(2 downto 0);
        rd_addr           : out STD_LOGIC_VECTOR(2 downto 0);
        
        -- Control signals to ID/EX pipeline register
        reg_write         : out STD_LOGIC;
        alu_src1          : out STD_LOGIC;
        alu_src2          : out STD_LOGIC;
        mem_read          : out STD_LOGIC;
        mem_write         : out STD_LOGIC;
        mem_to_reg        : out STD_LOGIC;
        sp_inc            : out STD_LOGIC;
        sp_dec            : out STD_LOGIC;
        sp_enable         : out STD_LOGIC;
        branch            : out STD_LOGIC;
        jump              : out STD_LOGIC;
        call              : out STD_LOGIC;
        return_sig        : out STD_LOGIC;
        set_carry         : out STD_LOGIC;
        update_flag       : out STD_LOGIC;
        swap              : out STD_LOGIC;
        out_port          : out STD_LOGIC;
        in_port           : out STD_LOGIC;
        halt              : out STD_LOGIC;
        j_sc              : out STD_LOGIC_VECTOR(1 downto 0);
        int_ack           : out STD_LOGIC;
        flags_save        : out STD_LOGIC;
        flags_restore     : out STD_LOGIC;
        
        -- To hazard detection unit
        stall             : out STD_LOGIC_VECTOR(1 downto 0);
        flush             : out STD_LOGIC_VECTOR(1 downto 0)
    );
    end component;
    
    -- Pipeline register signals
    -- IF/ID signals
    signal if_pc_out          : STD_LOGIC_VECTOR(31 downto 0);
    signal if_instr_out       : STD_LOGIC_VECTOR(31 downto 0);
    signal if_interrupt_out   : STD_LOGIC;
    
    -- ID/EX signals
    signal id_pc_out          : STD_LOGIC_VECTOR(31 downto 0);
    signal id_rsrc1_out       : STD_LOGIC_VECTOR(2 downto 0);
    signal id_rsrc2_out       : STD_LOGIC_VECTOR(2 downto 0);
    signal id_rd_out          : STD_LOGIC_VECTOR(2 downto 0);
    signal id_imm_offset_out  : STD_LOGIC_VECTOR(15 downto 0);
    signal id_rsrc1_data_out  : STD_LOGIC_VECTOR(31 downto 0);
    signal id_rsrc2_data_out  : STD_LOGIC_VECTOR(31 downto 0);
    signal id_swap_out        : STD_LOGIC;
    signal id_set_carry_out   : STD_LOGIC;
    signal id_sp_inc_out      : STD_LOGIC;
    signal id_sp_dec_out      : STD_LOGIC;
    signal id_sp_enable_out   : STD_LOGIC;
    signal id_rti_out         : STD_LOGIC;
    signal id_return_sig_out  : STD_LOGIC;
    signal id_call_out        : STD_LOGIC;
    signal id_alu_srcl_out    : STD_LOGIC;
    signal id_branch_out      : STD_LOGIC;
    signal id_mem_read_out    : STD_LOGIC;
    signal id_reg_write_out   : STD_LOGIC;
    signal id_update_flag_out : STD_LOGIC;
    signal id_in_port_out     : STD_LOGIC;
    signal id_mem_write_out   : STD_LOGIC;
    signal id_j_sc_out        : STD_LOGIC_VECTOR(1 downto 0);
    signal id_alu_slc_out     : STD_LOGIC_VECTOR(4 downto 0);
    signal id_dm_out          : STD_LOGIC;
    signal  in_port_signal    :std_logic;  
    signal  out_port_signal   :std_logic;
    
    -- EX/MEM signals
    signal ex_rti_out         : STD_LOGIC;
    signal ex_mem_read_out    : STD_LOGIC;
    signal ex_return_sig_out  : STD_LOGIC;
    signal ex_mem_write_out   : STD_LOGIC;
    signal ex_alu_result_out  : STD_LOGIC_VECTOR(31 downto 0);
    signal ex_sp_load_out     : STD_LOGIC;
    signal ex_rsrc1_out       : STD_LOGIC_VECTOR(2 downto 0);
    signal ex_rd_out          : STD_LOGIC_VECTOR(2 downto 0);
    signal ex_pc_out          : STD_LOGIC_VECTOR(31 downto 0);
    signal ex_set_carry_out   : STD_LOGIC;
    signal ex_sp_inc_out      : STD_LOGIC;
    signal ex_sp_dec_out      : STD_LOGIC;
    signal ex_sp_enable_out   : STD_LOGIC;
    signal ex_branch_out      : STD_LOGIC;
    signal ex_update_flag_out : STD_LOGIC;
    signal ex_reg1_data_out   : STD_LOGIC_VECTOR(31 downto 0);
    signal ex_reg2_data_out   : STD_LOGIC_VECTOR(31 downto 0);
    signal ex_swap_out        : STD_LOGIC;
    signal ex_reg_write_out   : STD_LOGIC;
    signal ex_in_port_out     : STD_LOGIC;
    signal ex_dm_addr_out     : STD_LOGIC;
    signal ex_index_out       : STD_LOGIC_VECTOR(15 downto 0);
    signal alu_a              : std_logic_vector(31 downto 0);
    signal alu_b              : std_logic_vector(31 downto 0);
    
    -- MEM/WB signals
    signal mw_read_data_out   : STD_LOGIC_VECTOR(31 downto 0);
    signal mw_alu_result_out  : STD_LOGIC_VECTOR(31 downto 0);
    signal mw_reg1_addr_out   : STD_LOGIC_VECTOR(2 downto 0);
    signal mw_reg2_addr_out   : STD_LOGIC_VECTOR(2 downto 0);
    signal mw_mem_read_out    : STD_LOGIC;
    signal mw_reg1_data_out   : STD_LOGIC_VECTOR(31 downto 0);
    signal mw_swap_out        : STD_LOGIC;
    signal mw_in_port_out     : STD_LOGIC;
    signal mw_reg2_write_out  : STD_LOGIC;
    
    -- Control signals
    signal reg_write          : STD_LOGIC;
    signal alu_src1           : STD_LOGIC;
    signal alu_src2           : STD_LOGIC;
    signal alu_op             : STD_LOGIC_VECTOR(3 downto 0);
    signal mem_read           : STD_LOGIC;
    signal mem_write          : STD_LOGIC;
    signal mem_to_reg         : STD_LOGIC;
    signal sp_inc             : STD_LOGIC;
    signal sp_dec             : STD_LOGIC;
    signal sp_enable          : STD_LOGIC;
    signal branch             : STD_LOGIC;
    signal jump               : STD_LOGIC;
    signal call               : STD_LOGIC;
    signal return_sig         : STD_LOGIC;
    signal set_carry          : STD_LOGIC;
    signal update_flag        : STD_LOGIC;
    signal swap               : STD_LOGIC;
   
    signal halt               : STD_LOGIC;
    signal jz                 : STD_LOGIC;
    signal jn                 : STD_LOGIC;
    signal jc                 : STD_LOGIC;
    signal int_ack            : STD_LOGIC;
    signal flags_save         : STD_LOGIC;
    signal flags_restore      : STD_LOGIC;
    
    -- Hazard detection signals
    signal stall              : STD_LOGIC_VECTOR(1 downto 0);
    signal flush              : STD_LOGIC_VECTOR(1 downto 0);
    
    -- Forwarding signals
    signal forward_rs1        : STD_LOGIC_VECTOR(1 downto 0);
    signal forward_rs2        : STD_LOGIC_VECTOR(1 downto 0);
    
    -- ALU signals
    signal alu_result         : STD_LOGIC_VECTOR(31 downto 0);
    signal alu_zero           : STD_LOGIC;
    signal alu_neg            : STD_LOGIC;
    signal alu_carry          : STD_LOGIC;
    
    -- Register file signals
    signal reg_data_out1      : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_data_out2      : STD_LOGIC_VECTOR(31 downto 0);
    
    -- Program counter signals
    signal pc_in              : STD_LOGIC_VECTOR(31 downto 0);
    signal pc_out             : STD_LOGIC_VECTOR(31 downto 0);
    signal pc_enable          : STD_LOGIC;
    
    -- Stack pointer signals
    signal sp_out             : STD_LOGIC_VECTOR(31 downto 0);
    
    -- Flag register signals
    signal zero_flag          : STD_LOGIC;
    signal neg_flag           : STD_LOGIC;
    signal carry_flag         : STD_LOGIC;

begin
    --Pipeline registers
    -- Instruction Fetch/Decode Stage
    FD_Stage: FetchDecode
    port map(
        clk            => clk,
        rst            => rst,
        en             => pc_enable,
        Pc_in          => pc_out,
        Instruction_In => instr_data,
        Interrupt_In   => '0',  -- TODO: Connect interrupt signal
        Pc             => if_pc_out,
        Rsrc1          => open,  -- Connected directly to register file
        Rsrc2          => open,  -- Connected directly to register file
        Interrupt      => if_interrupt_out,
        Instruction    => if_instr_out
    );

    -- Decode/Execute Stage
    DE_Stage: DecodeExecute
    port map(
        clk             => clk,
        rst             => rst,
        enable          => not stall(1),
        -- Inputs from Fetch/Decode
        Pc_In           => if_pc_out,
        Read_Addr1_In   => if_instr_out(26 downto 24),
        Read_Addr2_In   => if_instr_out(23 downto 21),
        Interrupt_In    => if_interrupt_out,
        Rd_Addr_In      => if_instr_out(20 downto 18),
        Imm_Offset_In   => if_instr_out(15 downto 0),
        Rsrc1_Data_In   => reg_data_out1,
        Rsrc2_Data_In   => reg_data_out2,
        -- Control signals in
        Swap_In         => swap,
        Set_Carry_In    => set_carry,
        Sp_Inc_In       => sp_inc,
        Sp_Dec_In       => sp_dec,
        Sp_Enable_In    => sp_enable,
        RTI_In          => '0',  -- TODO: Connect RTI
        Return_Signal_In=> return_sig,
        Call_In         => call,
        ALU_Srcl_In     => alu_src1,
        Branch_In       => branch,
        Mem_Read_In     => mem_read,
        Reg_Write_In    => reg_write,
        Update_Flag_In  => update_flag,
        IN_Port_In      => in_port_signal,
        Mem_Write_In    => mem_write,
        J_SC_In         => jz & jn,  -- Combined jump signals
        Opcode_In       => if_instr_out(31 downto 27),
        DM_In           => '0',  -- TODO: Connect DM
        -- Outputs to Execute/Memory
        Mem_Read        => id_mem_read_out,
        Interrupt       => open,
        Reg1_Data       => id_rsrc1_data_out,
        Reg2_Data       => id_rsrc2_data_out,
        Swap            => id_swap_out,
        Rsrc1           => id_rsrc1_out,
        Rd              => id_rd_out,
        Reg_Write       => id_reg_write_out,
        IN_Port         => id_in_port_out,
        Pc              => id_pc_out,
        Set_Carry       => id_set_carry_out,
        Sp_Inc          => id_sp_inc_out,
        Sp_Dec          => id_sp_dec_out,
        Sp_Enable       => id_sp_enable_out,
        RTI             => open,
        Return_Signal   => id_return_sig_out,
        Call            => id_call_out,
        ALU_Srcl        => id_alu_srcl_out,
        Branch          => id_branch_out,
        Update_Flag     => id_update_flag_out,
        Mem_Write       => id_mem_write_out,
        J_SC            => id_j_sc_out,
        ALU_SLC         => id_alu_slc_out,
        DM              => id_dm_out,
        Imm_Offset      => id_imm_offset_out
    );

    -- Forwarding Unit
    Forward_Unit: Forwarding_Unit
    port map(
        D_EX_rs1         => id_rsrc1_out,
        D_EX_rs2         => id_rsrc2_out,
        EX_M_rd          => ex_rd_out,
        M_WB_rd          => mw_reg1_addr_out,
        Forward_array_Rs1 => forward_rs1,
        Forward_array_Rs2 => forward_rs2
    );

    -- ALU input multiplexers with forwarding
    process(forward_rs1, id_rsrc1_data_out, ex_alu_result_out, mw_alu_result_out)
    begin
        case forward_rs1 is
            when "00" =>    -- No forwarding
                alu_a <= id_rsrc1_data_out;
            when "01" =>    -- Forward from WB stage
                alu_a <= mw_alu_result_out;
            when "10" =>    -- Forward from MEM stage
                alu_a <= ex_alu_result_out;
            when others =>
                alu_a <= (others => '0');
        end case;
    end process;

    process(forward_rs2, id_rsrc2_data_out, ex_alu_result_out, mw_alu_result_out, id_alu_srcl_out, id_imm_offset_out)
    begin
        if id_alu_srcl_out = '1' then
            alu_b <= std_logic_vector(resize(signed(id_imm_offset_out), 32));
        else
            case forward_rs2 is
                when "00" =>    -- No forwarding
                    alu_b <= id_rsrc2_data_out;
                when "01" =>    -- Forward from WB stage
                    alu_b <= mw_alu_result_out;
                when "10" =>    -- Forward from MEM stage
                    alu_b <= ex_alu_result_out;
                when others =>
                    alu_b <= (others => '0');
            end case;
        end if;
    end process;    
    -- Execute/Memory Stage
    EM_Stage: ExecuteMemory
    port map(
        clk             => clk,
        rst             => rst,
        enable          => '1',
        -- Inputs from Decode/Execute
        Mem_Read_In     => id_mem_read_out,
        Interrupt_In    => '0',  -- TODO: Connect interrupt
        ALU_Result_In   => alu_result,
        Sp_Load_In      => '0',  -- TODO: Connect SP load
        Swap_In         => id_swap_out,
        Rsrc1_In        => id_rsrc1_out,
        Rd_In           => id_rd_out,
        Reg1_Data_In    => id_rsrc1_data_out,
        Reg2_Data_In    => id_rsrc2_data_out,
        Reg_Write_In    => id_reg_write_out,
        IN_Port_In      => id_in_port_out,
        Pc_In           => id_pc_out,
        Set_Carry_In    => id_set_carry_out,
        Sp_Inc_In       => id_sp_inc_out,
        Sp_Dec_In       => id_sp_dec_out,
        Sp_Enable_In    => id_sp_enable_out,
        Branch_In       => id_branch_out,
        Update_Flag_In  => id_update_flag_out,
        Mem_Write_In    => id_mem_write_out,
        RTI_In          => '0',  -- TODO: Connect RTI
        Return_Signal_In=> id_return_sig_out,
        DM_IN           => id_dm_out,
        Imm_Offset_In   => id_imm_offset_out,
        -- Outputs to Memory/Writeback
        RTI             => ex_rti_out,
        Mem_Read        => ex_mem_read_out,
        Return_Signal   => ex_return_sig_out,
        Mem_Write       => ex_mem_write_out,
        ALU_Result      => ex_alu_result_out,
        Sp_Load         => ex_sp_load_out,
        Rsrc1           => ex_rsrc1_out,
        Rd              => ex_rd_out,
        Pc              => ex_pc_out,
        Set_Carry       => ex_set_carry_out,
        Sp_Inc          => ex_sp_inc_out,
        Sp_Dec          => ex_sp_dec_out,
        Sp_Enable       => ex_sp_enable_out,
        Branch          => ex_branch_out,
        Update_Flag     => ex_update_flag_out,
        Reg1_Data       => ex_reg1_data_out,
        Reg2_Data       => ex_reg2_data_out,
        Swap            => ex_swap_out,
        Reg_Write       => ex_reg_write_out,
        IN_Port         => ex_in_port_out,
        DM_Addr         => ex_dm_addr_out,
        Index           => ex_index_out
    );
    -- Memory/Writeback Stage
    MW_Stage: MemoryWrite
    port map(
        clk          => clk,
        rst          => rst,
        enable       => '1',
        -- Inputs from Execute/Memory
        Read_Data_In     => data_in,
        ALU_Result_In    => ex_alu_result_out,
        Mem_Read_In      => ex_mem_read_out,
        Rsrc1_In         => ex_rsrc1_out,
        Rd_In            => ex_rd_out,
        Reg1_Data_In     => ex_reg1_data_out,
        Reg2_Data_In     => ex_reg2_data_out,
        Swap_In          => ex_swap_out,
        Reg_Write_In     => ex_reg_write_out,
        IN_Port_In       => ex_in_port_out,
        -- Outputs to Writeback
        Read_Data     => mw_read_data_out,
        ALU_Result    => mw_alu_result_out,
        Reg1_Addr     => mw_reg1_addr_out,
        Reg2_Addr     => mw_reg2_addr_out,
        Mem_Read      => mw_mem_read_out,
        Reg1_Data     => mw_reg1_data_out,
        Swap          => mw_swap_out,
        IN_Port       => mw_in_port_out,
        Reg2_Write    => mw_reg2_write_out
    );

    -- Hazard Detection Unit
    -- Next PC Logic
  

end Structural;