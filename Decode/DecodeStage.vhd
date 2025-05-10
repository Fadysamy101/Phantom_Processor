library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decode_Stage is
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
end Decode_Stage;


architecture Behavioral of Decode_Stage is
    -- Component declarations
    component Controller is
        Port (
            opcode         : in  STD_LOGIC_VECTOR(4 downto 0);
				
            RegWrite       : out STD_LOGIC;
            ALUSrc1        : out STD_LOGIC;
            ALUSrc2        : out STD_LOGIC;
				
            MemRead        : out STD_LOGIC;
            MemWrite       : out STD_LOGIC;
            MemToReg       : out STD_LOGIC;
				
            Sp_Inc         : out STD_LOGIC;
            Sp_Dec         : out STD_LOGIC;
            Sp_Enable      : out STD_LOGIC;
				
            Branch         : out STD_LOGIC;
            Jump           : out STD_LOGIC;
            Call           : out STD_LOGIC;
            ReturnSig      : out STD_LOGIC;
				
            Set_Carry      : out STD_LOGIC;
            Update_Flag    : out STD_LOGIC;
				
            Swap           : out STD_LOGIC;
				
            OutPort        : out STD_LOGIC;
            InPort         : out STD_LOGIC;
				
            Halt           : out STD_LOGIC;
				
            J_SC           : out STD_LOGIC_VECTOR(1 downto 0);
				
            IntAck         : out STD_LOGIC;
            FlagsSave      : out STD_LOGIC;
            FlagsRestore   : out STD_LOGIC
        );
    end component;
    
    component Reg is
        generic(
            address_bits : integer := 3;
            word_width   : integer := 32
        );
        port(
            clk              : in  std_logic;
            rst              : in  std_logic;
            we1              : in  std_logic;
            address_sel_sw   : in  std_logic;
            we2_swap         : in  std_logic;
				
            write_address_1  : in  std_logic_vector(address_bits-1 downto 0);
            write_address_2  : in  std_logic_vector(address_bits-1 downto 0);
				
            read_address_1   : in  std_logic_vector(address_bits-1 downto 0);
            read_address2_1  : in  std_logic_vector(address_bits-1 downto 0);
            read_address2_2  : in  std_logic_vector(address_bits-1 downto 0);
				
            data_in_1        : in  std_logic_vector(word_width-1 downto 0);
            data_in_2        : in  std_logic_vector(word_width-1 downto 0);
				
            data_out1        : out std_logic_vector(word_width-1 downto 0);
            data_out2        : out std_logic_vector(word_width-1 downto 0)
        );
    end component;
    
    component Hazard_Detection_Unit is
        port(
            FD_RS1                : in  std_logic_vector(2 downto 0);
            FD_RS2                : in  std_logic_vector(2 downto 0);
            D_Ex_rd               : in  std_logic_vector(2 downto 0);
            D_EX_Mem_Read         : in  std_logic;
            D_EX_Mem_Write        : in  std_logic;
            Data_interface_needed : in  std_logic;
            Branch_Taken          : in  std_logic;
				
            Stall                 : out std_logic_vector(1 downto 0);
            Flush                 : out std_logic_vector(1 downto 0)
        );
    end component;
    
    -- Internal signals
    signal opcode_sig         : STD_LOGIC_VECTOR(4 downto 0);
    signal reg_rs1_addr       : STD_LOGIC_VECTOR(2 downto 0);
    signal reg_rs2_addr       : STD_LOGIC_VECTOR(2 downto 0);
    signal reg_rd_addr        : STD_LOGIC_VECTOR(2 downto 0);
    signal control_reg_write  : STD_LOGIC;
    signal control_swap       : STD_LOGIC;
    signal modified_reg_write : STD_LOGIC;
    signal internal_immediate : STD_LOGIC_VECTOR(15 downto 0);
    signal internal_offset    : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Control signals from controller (before hazard modification)
    signal ctrl_reg_write     : STD_LOGIC;
    signal ctrl_alu_src1      : STD_LOGIC;
    signal ctrl_alu_src2      : STD_LOGIC;
    signal ctrl_mem_read      : STD_LOGIC;
    signal ctrl_mem_write     : STD_LOGIC;
    signal ctrl_mem_to_reg    : STD_LOGIC;
    signal ctrl_sp_inc        : STD_LOGIC;
    signal ctrl_sp_dec        : STD_LOGIC;
    signal ctrl_sp_enable     : STD_LOGIC;
    signal ctrl_branch        : STD_LOGIC;
    signal ctrl_jump          : STD_LOGIC;
    signal ctrl_call          : STD_LOGIC;
    signal ctrl_return_sig    : STD_LOGIC;
    signal ctrl_set_carry     : STD_LOGIC;
    signal ctrl_update_flag   : STD_LOGIC;
    signal ctrl_swap          : STD_LOGIC;
    signal ctrl_out_port      : STD_LOGIC;
    signal ctrl_in_port       : STD_LOGIC;
    signal ctrl_halt          : STD_LOGIC;
    signal ctrl_j_sc          : STD_LOGIC_VECTOR(1 downto 0);
    signal ctrl_int_ack       : STD_LOGIC;
    signal ctrl_flags_save    : STD_LOGIC;
    signal ctrl_flags_restore : STD_LOGIC;
    signal internal_flush     : STD_LOGIC_VECTOR(1 downto 0);
    
begin
    -- Extract fields from instruction
    opcode_sig <= instruction(31 downto 27);
    
    -- Extract register addresses based on instruction format
    -- This is a simplified approach; you may need to decode different formats
    reg_rd_addr  <= instruction(20 downto 18);
    reg_rs1_addr <= instruction(26 downto 24);
    reg_rs2_addr <= instruction(23 downto 21);
    
    -- Extract immediate and offset fields
    internal_immediate <= instruction(15 downto 0);
    internal_offset 	  <= instruction(15 downto 0);
    
    -- Pass to outputs
    immediate <= internal_immediate;
    offset 	  <= internal_offset;
    rs1_addr  <= reg_rs1_addr;
    rs2_addr  <= reg_rs2_addr;
    rd_addr   <= reg_rd_addr;
    
    -- Instantiate Controller
    controller_inst: Controller port map (
        opcode 		=> opcode_sig,
        RegWrite 		=> ctrl_reg_write,
        ALUSrc1 		=> ctrl_alu_src1,
        ALUSrc2 		=> ctrl_alu_src2,
        MemRead 		=> ctrl_mem_read,
        MemWrite 		=> ctrl_mem_write,
        MemToReg 		=> ctrl_mem_to_reg,
        Sp_Inc 		=> ctrl_sp_inc,
        Sp_Dec 		=> ctrl_sp_dec,
        Sp_Enable 	=> ctrl_sp_enable,
        Branch 		=> ctrl_branch,
        Jump 			=> ctrl_jump,
        Call 			=> ctrl_call,
        ReturnSig 	=> ctrl_return_sig,
        Set_Carry 	=> ctrl_set_carry,
        Update_Flag 	=> ctrl_update_flag,
        Swap 			=> ctrl_swap,
        OutPort 		=> ctrl_out_port,
        InPort 		=> ctrl_in_port,
        Halt 			=> ctrl_halt,
        J_SC 			=> ctrl_j_sc,
        IntAck 		=> ctrl_int_ack,
        FlagsSave 	=> ctrl_flags_save,
        FlagsRestore => ctrl_flags_restore
    );
    
    -- Instantiate Register File
    register_file_inst: Reg
        generic map (
            address_bits => 3,
            word_width => 32
        )
        port map (
            clk 					=> clk,
            rst 					=> rst,
            we1 					=> wb_reg_write,
            address_sel_sw 	=> ctrl_swap,
            we2_swap 			=> swap_enable,
            write_address_1 	=> wb_reg_addr,
            write_address_2 	=> swap_reg_addr,
            read_address_1 	=> reg_rs1_addr,
            read_address2_1 	=> reg_rd_addr, -----------------
            read_address2_2 	=> reg_rs2_addr, ------------------
            data_in_1 			=> write_data,
            data_in_2 			=> swap_data,
            data_out1 			=> read_data1,
            data_out2 			=> read_data2
        );
    
    -- Instantiate Hazard Detection Unit
    hazard_unit_inst: Hazard_Detection_Unit port map 
	 (
        FD_RS1 					=> reg_rs1_addr,
        FD_RS2 					=> reg_rs2_addr,
        D_Ex_rd 					=> ex_dest_reg,
        D_EX_Mem_Read 			=> ex_mem_read,
        D_EX_Mem_Write 			=> ex_mem_write,
        Data_interface_needed => data_hazard_needed,
        Branch_Taken 			=> branch_taken,
        Stall 						=> stall,
        Flush 						=> internal_flush
    );
    
    flush <= internal_flush;
    
    -- Control signal modification based on hazard detection
    process(internal_flush, ctrl_reg_write, ctrl_alu_src1, ctrl_alu_src2, 
            ctrl_mem_read, ctrl_mem_write, ctrl_mem_to_reg,
            ctrl_sp_inc, ctrl_sp_dec, ctrl_sp_enable, 
            ctrl_branch, ctrl_jump, ctrl_call, ctrl_return_sig,
            ctrl_set_carry, ctrl_update_flag, ctrl_swap,
            ctrl_out_port, ctrl_in_port, ctrl_halt,
            ctrl_j_sc, ctrl_int_ack, ctrl_flags_save, ctrl_flags_restore)
    begin
        -- Default: pass through control signals
        reg_write 	 <= ctrl_reg_write;
        alu_src1 		 <= ctrl_alu_src1;
        alu_src2 		 <= ctrl_alu_src2;
        mem_read 		 <= ctrl_mem_read;
        mem_write 	 <= ctrl_mem_write;
        mem_to_reg 	 <= ctrl_mem_to_reg;
        sp_inc 		 <= ctrl_sp_inc;
        sp_dec 		 <= ctrl_sp_dec;
        sp_enable 	 <= ctrl_sp_enable;
        branch 		 <= ctrl_branch;
        jump 			 <= ctrl_jump;
        call  			 <= ctrl_call;
        return_sig 	 <= ctrl_return_sig;
        set_carry 	 <= ctrl_set_carry;
        update_flag   <= ctrl_update_flag;
        swap 			 <= ctrl_swap;
        out_port 		 <= ctrl_out_port;
        in_port 		 <= ctrl_in_port;
        halt 			 <= ctrl_halt;
        j_sc 		 	 <= ctrl_j_sc;
        int_ack 		 <= ctrl_int_ack;
        flags_save    <= ctrl_flags_save;
        flags_restore <= ctrl_flags_restore;
        
        -- If flush[1] is set, nullify the control signals
        if internal_flush(1) = '1' then
            reg_write 		<= '0';
            alu_src1 		<= '0';
            alu_src2 		<= '0';
            mem_read 		<= '0';
            mem_write 		<= '0';
            mem_to_reg 		<= '0';
            sp_inc 			<= '0';
            sp_dec 			<= '0';
            sp_enable 		<= '0';
            branch 			<= '0';
            jump 				<= '0';
            call 				<= '0';
            return_sig 		<= '0';
            set_carry 		<= '0';
            update_flag 	<= '0';
            swap 				<= '0';
            out_port 		<= '0';
            in_port 			<= '0';
            halt 				<= '0';
            j_sc 				<= "00";
            int_ack 			<= '0';
            flags_save 		<= '0';
            flags_restore 	<= '0';
        end if;
    end process;
    
end Behavioral;