	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

	entity PipelineProcessor is
		 Port (
			  clk        : in STD_LOGIC;
			  rst        : in STD_LOGIC;
		 
			  -- I/O ports
			  in_port    : in STD_LOGIC_VECTOR(31 downto 0);
			  out_port   : out STD_LOGIC_VECTOR(31 downto 0)
		 );
	end PipelineProcessor;

	architecture Structural of PipelineProcessor is
		
		 
		-- Component declarations:
		
		-- PC_new
		-- Instruction Memory
		
		-- Fetch/DEC register
		
		-- Decode Stage (Controller, Hazard_Detection_Unit, RegsiterFile)
		
		-- DEC/EX register
		
		-- Forwarding Unit
		-- ALU
		-- CCR
		
		-- EX/MEM register
		
		-- Memory
		-- Stack
		
		-- MEM/WB register
		
		-- Writeback
		
		
		-- Fetch
		-- PC_New
		component PC_New is
		Port 
		(
			clk                   : in STD_LOGIC;
			rst                   : in STD_LOGIC;
			stall                 : in STD_LOGIC;  -- Hazard detection
			branch                : in STD_LOGIC;  -- From EX stage
			in_from_CCR           : in STD_LOGIC_VECTOR(3 downto 0);
			in_J_SC               : in STD_LOGIC_VECTOR(1 downto 0);
			Call                  : in STD_LOGIC;
			branch_addr           : in STD_LOGIC_VECTOR(31 downto 0); -- From ALU
			RTI                   : in std_logic;
			Return_flag           : in std_logic;
			Interrupt             : in std_logic;
			PC_loaded_from_memory : in STD_LOGIC_VECTOR(31 downto 0);
		  
			PC                    : out STD_LOGIC_VECTOR(31 downto 0)
		);
		end component;
		
		
		-- Instruction Memory
		component InstructionMemory is
		Port 
		(        
			PC 		  : in STD_LOGIC_VECTOR (11 downto 0); 
			data_bus : out STD_LOGIC_VECTOR ( 31 downto 0)
		  
		);
		end component;
		
		
		-- Fetch/Dec register
		 component FetchDecode is
			  Port 
			  (
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
		 
		 
		-- Decode
		-- Decode stage
		component Decode_Stage is
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
		 
		 
		 -- DEC/EX register
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
		 
		 
		 -- Forwarding Unit
		component Forwarding_Unit is
     port(
    -- Input registers from Decode/Execute stage
    D_EX_rs1      : in std_logic_vector(2 downto 0);
    D_EX_rs2      : in std_logic_vector(2 downto 0);
    
    -- Destination registers from Execute/Memory and Memory/Writeback stages
    EX_M_rd       : in std_logic_vector(2 downto 0);
    M_WB_rd       : in std_logic_vector(2 downto 0);
    
    -- Register write enable signals
    EX_M_RegWrite : in std_logic;
    M_WB_RegWrite : in std_logic;
    
    -- Input data signals (as shown in the diagram)
    M_WB_Rd_data  : in std_logic_vector(31 downto 0);
    EX_M_Rd_data  : in std_logic_vector(31 downto 0);
    Rarc1_data    : in std_logic_vector(31 downto 0);
    Rarc2_Data    : in std_logic_vector(31 downto 0);
   
    Immediate     : in std_logic_vector(15 downto 0);
    
    -- Immediate selection control
    IMM_Sel       : in std_logic;  -- Signal to select immediate value
    
    -- Output control signals (as shown in the diagram)

    -- Output operands (as shown in the diagram)
    Operand1      : out std_logic_vector(31 downto 0);
    Operand2      : out std_logic_vector(31 downto 0)
    );
    end component Forwarding_Unit;
		 
		 -- ALU
		 component ALU is
		 Port 
		 (
			  -- Inputs
			  operand1 : in  STD_LOGIC_VECTOR(31 downto 0);  -- First operand
			  operand2 : in  STD_LOGIC_VECTOR(31 downto 0);  -- Second operand
			  ALU_OP   : in  STD_LOGIC_VECTOR(4 downto 0);   -- Operation select
			  offset   : in  STD_LOGIC_VECTOR(15 downto 0);  -- Offset for address calculation
			  Imm      : in  STD_LOGIC_VECTOR(15 downto 0);  -- Immediate value
			  
			  -- Outputs
			  ALU_OUT  : out STD_LOGIC_VECTOR(31 downto 0);  -- ALU result
			  CCR      : out STD_LOGIC_VECTOR(3 downto 0)    -- Condition Code Register (Z, N, C flags)
			  -- zero flag = CCR(0)
			  -- negative flag = CCR(1)
			  -- carry flag = CCR(2)
		 );
		end component;
		
		
		-- CCR
		component CCR is
		port 
		(
			  clk              : in std_logic;
			  reset            : in std_logic;
			  update_flag      : in std_logic;
			  Carry_in         : in std_logic;
			  Return_flags     : in std_logic_vector(3 downto 0);
			  RTI_Restore_flags: in std_logic;
			  CCR_out          : out std_logic_vector(3 downto 0);
			  CCR_in           : in std_logic_vector(3 downto 0)
		);
		end component;
		
				 
		 -- EX/MEM register
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
		 
		 
		 -- Memory
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
		 
		 
		 -- Stack
		 component stack_pointer is
		 Port ( 
			  -- Control signals
			  clk         : in STD_LOGIC;
			  rst         : in STD_LOGIC;
			  SP_enable   : in STD_LOGIC;
			  SP_INC      : in STD_LOGIC;  -- Pop operation
			  SP_DEC      : in STD_LOGIC;  -- Push operation
			  SP_mem      : in STD_LOGIC_VECTOR(15 downto 0);  -- SP from memory stage
			  
			  -- Output
			  SP_out      : out STD_LOGIC_VECTOR(15 downto 0)
		 );
		end component;
		
				 
		 -- MEM/WB register
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

         --Hazard Detection Unit
         component Hazard_Detection_Unit is
			  Port (
					FD_RS1 : in std_logic_vector(2 downto 0);
                    FD_RS2 : in std_logic_vector(2 downto 0);
                    D_Ex_rd : in std_logic_vector(2 downto 0);
                    D_EX_Mem_Read: in std_logic;
                    D_EX_Mem_Write: in std_logic;
                    Data_interface_needed: in std_logic;
                    Branch_Taken: in std_logic;
                    -- Outputs
                    Stall: out std_logic_vector(1 downto 0);
                    Flush: out std_logic_vector(1 downto 0)
			  );
		 end component;

		 --Fetch stage
         signal instruction_from_instruction_memory : STD_LOGIC_VECTOR(31 downto 0);
		 -- Pipeline register signals
		 -- IF/ID signals
		 signal if_pc_out          : STD_LOGIC_VECTOR(31 downto 0);
		 signal if_instr_out       : STD_LOGIC_VECTOR(31 downto 0);
		 signal if_interrupt_out   : STD_LOGIC;
         --Controller
        signal Controller_J_SC_In           : STD_LOGIC_VECTOR(1 downto 0); 
		signal Controller_Swap_In           : STD_LOGIC;
        signal Controller_Set_Carry_In      : STD_LOGIC;
        signal Controller_Sp_Inc_In         : STD_LOGIC;
        signal Controller_Sp_Dec_In         : STD_LOGIC;
        signal Controller_Sp_Enable_In      : STD_LOGIC;
        signal Controller_RTI_In            : STD_LOGIC;
        signal Controller_Return_Signal_In  : STD_LOGIC;
        signal Controller_Call_In           : STD_LOGIC;
        signal Controller_ALU_Srcl_In       : STD_LOGIC;
        signal Controller_Branch_In         : STD_LOGIC;
        signal Controller_Mem_Read_In       : STD_LOGIC;
        signal Controller_Reg_Write_In      : STD_LOGIC;
        signal Controller_Update_Flag_In    : STD_LOGIC;
        signal Controller_IN_Port_In        : STD_LOGIC;
        signal Controller_Mem_Write_In      : STD_LOGIC;
        signal Controller_DM_In            : STD_LOGIC;


        ------------------------ Decode stage signals ---------------------------
		-- Signals from IF/ID pipeline register (prefixed with F/D)
		signal F_D_instruction       : STD_LOGIC_VECTOR(31 downto 0);
		signal F_D_PC_plus1          : STD_LOGIC_VECTOR(31 downto 0);
				  
		-- Signals from Write Back stage
		signal write_data_sig        : STD_LOGIC_VECTOR(31 downto 0);
		signal wb_reg_addr_sig       : STD_LOGIC_VECTOR(2 downto 0);
		signal wb_reg_write_sig      : STD_LOGIC;
				  
		-- Signals for swap operation
		signal swap_data_sig         : STD_LOGIC_VECTOR(31 downto 0);
		signal swap_reg_addr_sig     : STD_LOGIC_VECTOR(2 downto 0);
		signal swap_enable_sig       : STD_LOGIC;
				  
		-- Hazard Detection input signals
		signal ex_mem_read_sig       : STD_LOGIC;
		signal ex_mem_write_sig      : STD_LOGIC;
		signal ex_dest_reg_sig       : STD_LOGIC_VECTOR(2 downto 0);
		signal data_hazard_needed_sig: STD_LOGIC;
		signal branch_taken_sig      : STD_LOGIC;
				  
		-- Output signals to ID/EX pipeline register (prefixed with D/E)
		signal D_E_read_data1        : STD_LOGIC_VECTOR(31 downto 0);
		signal D_E_read_data2        : STD_LOGIC_VECTOR(31 downto 0);
		signal D_E_immediate         : STD_LOGIC_VECTOR(15 downto 0);
		signal D_E_offset            : STD_LOGIC_VECTOR(15 downto 0);
		signal D_E_rs1_addr          : STD_LOGIC_VECTOR(2 downto 0);
		signal D_E_rs2_addr          : STD_LOGIC_VECTOR(2 downto 0);
		signal D_E_rd_addr           : STD_LOGIC_VECTOR(2 downto 0);
				  
		-- Control signals to ID/EX pipeline register (prefixed with D/E)
		signal D_E_reg_write         : STD_LOGIC;
		signal D_E_alu_src1          : STD_LOGIC;
		signal D_E_alu_src2          : STD_LOGIC;
		signal D_E_mem_read          : STD_LOGIC;
		signal D_E_mem_write         : STD_LOGIC;
		signal D_E_mem_to_reg        : STD_LOGIC;
		signal D_E_sp_inc            : STD_LOGIC;
		signal D_E_sp_dec            : STD_LOGIC;
		signal D_E_sp_enable         : STD_LOGIC;
		signal D_E_branch            : STD_LOGIC;
		signal D_E_jump              : STD_LOGIC;
		signal D_E_call              : STD_LOGIC;
		signal D_E_return_sig        : STD_LOGIC;
		signal D_E_set_carry         : STD_LOGIC;
		signal D_E_update_flag       : STD_LOGIC;
		signal D_E_swap              : STD_LOGIC;
		signal D_E_out_port          : STD_LOGIC;
		signal D_E_in_port           : STD_LOGIC;
		signal D_E_halt              : STD_LOGIC;
		signal D_E_j_sc              : STD_LOGIC_VECTOR(1 downto 0);
		signal D_E_int_ack           : STD_LOGIC;
		signal D_E_flags_save        : STD_LOGIC;
		signal D_E_flags_restore     : STD_LOGIC;
				  
		-- Hazard detection output signals
		signal stall_sig             : STD_LOGIC_VECTOR(1 downto 0);
		signal flush_sig             : STD_LOGIC_VECTOR(1 downto 0);
        ------------------ End of Decode stage signals -------------------

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
         signal id_interrupt_out     : STD_LOGIC;
		 signal id_branch_out      : STD_LOGIC;
		 signal id_mem_read_out    : STD_LOGIC;
		 signal id_reg_write_out   : STD_LOGIC;
		 signal id_update_flag_out : STD_LOGIC;
		 signal id_in_port_out     : STD_LOGIC;
		 signal id_mem_write_out   : STD_LOGIC;
		 signal id_j_sc_out        : STD_LOGIC_VECTOR(1 downto 0);
		 signal id_alu_slc_out     : STD_LOGIC_VECTOR(4 downto 0);
		 signal id_dm_out          : STD_LOGIC;
		--  signal  in_port_signal    :std_logic;  
		--  signal  out_port_signal   :std_logic;
     
		 
		 -- EX/MEM signals
		 signal ex_mem_rti_out         : STD_LOGIC;
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
		 ---CCR signals
         signal ccr_from_CCR_out            : std_logic_vector(3 downto 0);
         signal CCR_from_Alu      : std_logic_vector(3 downto 0);
         --Forwarding signals
        signal D_EX_rs1        : STD_LOGIC_VECTOR(2 downto 0);
        signal D_EX_rs2        : STD_LOGIC_VECTOR(2 downto 0);
        signal EX_M_rd         : STD_LOGIC_VECTOR(2 downto 0);
        signal M_WB_rd         : STD_LOGIC_VECTOR(2 downto 0);
        signal EX_M_RegWrite   : STD_LOGIC;
        signal M_WB_RegWrite   : STD_LOGIC;
        signal M_WB_Rd_data    : STD_LOGIC_VECTOR(31 downto 0);
        signal EX_M_Rd_data    : STD_LOGIC_VECTOR(31 downto 0);
        signal Rarc1_data      : STD_LOGIC_VECTOR(31 downto 0);
        signal Rarc2_Data      : STD_LOGIC_VECTOR(31 downto 0);
        signal Immediate       : STD_LOGIC_VECTOR(15 downto 0);
        signal IMM_Sel         : STD_LOGIC;
        signal Operand1        : STD_LOGIC_VECTOR(31 downto 0);
        signal Operand2        : STD_LOGIC_VECTOR(31 downto 0);
        
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
		 
		
		--  signal halt               : STD_LOGIC;
		--  signal jz                 : STD_LOGIC;
		--  signal jn                 : STD_LOGIC;
		--  signal jc                 : STD_LOGIC;
		--  signal int_ack            : STD_LOGIC;
		--  signal flags_save         : STD_LOGIC;
		--  signal flags_restore      : STD_LOGIC;
		 
		 -- Hazard detection signals
		 signal stall              : STD_LOGIC_VECTOR(1 downto 0);
		 signal flush              : STD_LOGIC_VECTOR(1 downto 0);
		 
		 -- Forwarding signals
		 signal forward_rs1        : STD_LOGIC_VECTOR(1 downto 0);
		 signal forward_rs2        : STD_LOGIC_VECTOR(1 downto 0);
		 
		 -- ALU signals
		 signal alu_result         : STD_LOGIC_VECTOR(31 downto 0);
		--  signal alu_zero           : STD_LOGIC;
		--  signal alu_neg            : STD_LOGIC;
		--  signal alu_carry          : STD_LOGIC;
		 signal in_J_SC           : STD_LOGIC_VECTOR(1 downto 0); 
		 -- Register file signals
		 signal reg_data_out1      : STD_LOGIC_VECTOR(31 downto 0);
		 signal reg_data_out2      : STD_LOGIC_VECTOR(31 downto 0);
		 signal rs1_addr_FD       : STD_LOGIC_VECTOR(2 downto 0);
         signal rs2_addr_FD       : STD_LOGIC_VECTOR(2 downto 0);
		 -- Program counter signals
		 signal pc_in              : STD_LOGIC_VECTOR(31 downto 0);
		 signal pc_out             : STD_LOGIC_VECTOR(31 downto 0);
		 signal pc_enable          : STD_LOGIC;
		 signal  PC_loaded_from_memory : STD_LOGIC_VECTOR(31 downto 0);
		 -- Stack pointer signals
		 signal sp_out             : STD_LOGIC_VECTOR(31 downto 0);
		 
		 -- Flag register signals
		 signal zero_flag          : STD_LOGIC;
		 signal neg_flag           : STD_LOGIC;
		 signal carry_flag         : STD_LOGIC;
         --PC_new signals
       signal branch_addr_se : STD_LOGIC_VECTOR(31 downto 0);
       signal en2 : STD_LOGIC;

	begin
		 --Pipeline registers
		 -- Instruction Fetch/Decode Stage
         branch_addr_se <= (15 downto 0 => id_imm_offset_out(15)) & id_imm_offset_out;

         ProgramCounter:PC_New 
        Port map 
        (
        clk=>clk,
        rst=>rst,
        call=>id_call_out,                  
        stall=>stall(0),                 
        branch=>id_branch_out,              
        in_from_CCR=>ccr_from_CCR_out,          
        in_J_SC=>in_J_SC,              
        branch_addr => branch_addr_se,
      
        RTI=>ex_mem_rti_out,                 
        Return_flag=>id_return_sig_out ,          
        Interrupt=>id_interrupt_out,
        PC_loaded_from_memory=> PC_loaded_from_memory,
        PC=>pc_out                   
        );
        InstructionMemory_inst: InstructionMemory
         port map(
            PC => pc_out(11 downto 0),
            data_bus => instruction_from_instruction_memory
        );

      
		 FD_Stage: FetchDecode
		 port map(
			  clk            => clk,
			  rst            => rst,
			  en             => pc_enable,
			  Pc_in          => pc_out,
			  Instruction_In => instruction_from_instruction_memory,
			  Interrupt_In   => '0',  -- TODO: Connect interrupt signal
			  Pc             => if_pc_out,
			  Rsrc1          => rs1_addr_FD,  -- Connected directly to register file
			  Rsrc2          => rs2_addr_FD,  -- Connected directly to register file
			  Interrupt      => if_interrupt_out,
			  Instruction    => if_instr_out
		 );
        
        ----- connecting F/D pipeline register to Decode stage -----
        F_D_instruction <= if_instr_out;
        F_D_PC_plus1 <= if_pc_out;

        -- TODO: connect with writeback stage
        

         Decode_Stage_inst: Decode_Stage
		 port map 
		 (
			  -- Clock and reset
			  clk                => clk,
			  rst                => rst,
			  
			  -- Input from IF/ID pipeline register (with F/D prefix)
			  instruction        => F_D_instruction,
			  PC_plus1           => F_D_PC_plus1,
			  
			  -- Input from Write Back stage
			  write_data         => write_data_sig,
			  wb_reg_addr        => wb_reg_addr_sig,
			  wb_reg_write       => wb_reg_write_sig,
			  
			  -- Input for swap operation
			  swap_data          => swap_data_sig,
			  swap_reg_addr      => swap_reg_addr_sig,
			  swap_enable        => swap_enable_sig,
			  
			  -- Hazard Detection inputs
			  ex_mem_read        => ex_mem_read_sig,
			  ex_mem_write       => ex_mem_write_sig,
			  ex_dest_reg        => ex_dest_reg_sig,
			  data_hazard_needed => data_hazard_needed_sig,
			  branch_taken       => branch_taken_sig,
			  
			  -- Outputs to ID/EX pipeline register (with D/E prefix)
			  read_data1         => D_E_read_data1,
			  read_data2         => D_E_read_data2,
			  immediate          => D_E_immediate,
			  offset             => D_E_offset,
			  rs1_addr           => D_E_rs1_addr,
			  rs2_addr           => D_E_rs2_addr,
			  rd_addr            => D_E_rd_addr,
			  
			  -- Control signals to ID/EX pipeline register (with D/E prefix)
			  reg_write          => D_E_reg_write,
			  alu_src1           => D_E_alu_src1,
			  alu_src2           => D_E_alu_src2,
			  mem_read           => D_E_mem_read,
			  mem_write          => D_E_mem_write,
			  mem_to_reg         => D_E_mem_to_reg,
			  sp_inc             => D_E_sp_inc,
			  sp_dec             => D_E_sp_dec,
			  sp_enable          => D_E_sp_enable,
			  branch             => D_E_branch,
			  jump               => D_E_jump,
			  call               => D_E_call,
			  return_sig         => D_E_return_sig,
			  set_carry          => D_E_set_carry,
			  update_flag        => D_E_update_flag,
			  swap               => D_E_swap,
			  out_port           => D_E_out_port,
			  in_port            => D_E_in_port,
			  halt               => D_E_halt,
			  j_sc               => D_E_j_sc,
			  int_ack            => D_E_int_ack,
			  flags_save         => D_E_flags_save,
			  flags_restore      => D_E_flags_restore,
			  
			  -- To hazard detection unit
			  stall              => stall_sig,
			  flush              => flush_sig
		 );

         ----- connecting Decode stage to D/E pipeline register -----
         -- D_E_rs1_addr
         -- D_E_rs2_addr
         -- D_E_rd_addr
         -- D_E_immediate
         -- D_E_read_data1
         -- D_E_read_data2

		 -- Decode/Execute Stage
         en2 <= not stall(1);
		 DE_Stage: DecodeExecute
		 port map(
			  clk             => clk,
			  rst             => rst,
			  enable          => en2,

			  -- Inputs from Fetch/Decode
			  Pc_In           => if_pc_out,
			  Read_Addr1_In   => D_E_rs1_addr,
			  Read_Addr2_In   => D_E_rs2_addr,
			  Interrupt_In    => if_interrupt_out,
			  Rd_Addr_In      => D_E_rd_addr,
			  Imm_Offset_In   => D_E_immediate,
			  Rsrc1_Data_In   => D_E_read_data1,
			  Rsrc2_Data_In   => D_E_read_data2,

			  -- Control signals in
			  Swap_In         => Controller_Swap_In,
			  Set_Carry_In    => Controller_Set_Carry_In,
			  Sp_Inc_In       => Controller_Sp_Inc_In,
			  Sp_Dec_In       => Controller_SP_DEC_IN,
			  Sp_Enable_In    => Controller_Sp_Enable_In,
			  RTI_In          => Controller_RTI_In,  -- TODO: Connect RTI
			  Return_Signal_In=> Controller_Return_Signal_In,
			  Call_In         => Controller_Return_Signal_In,
			  ALU_Srcl_In     => Controller_ALU_Srcl_In,
			  Branch_In       => Controller_Branch_In,
			  Mem_Read_In     => Controller_Mem_Read_In,
			  Reg_Write_In    => Controller_Reg_Write_In,
			  Update_Flag_In  => Controller_Update_Flag_In,
              IN_Port_In      => Controller_IN_Port_In,
			  Mem_Write_In    => Controller_Mem_Write_In,
			  J_SC_In         => Controller_J_SC_In,  -- Combined jump signals
			  Opcode_In       => if_instr_out(31 downto 27),
			  DM_In           => Controller_DM_In    ,  -- TODO: Connect DM

			  -- Outputs to Execute/Memory
			  Mem_Read        => id_mem_read_out,
			  Interrupt       => id_interrupt_out,
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
			  RTI             => id_rti_out,
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

        --Execute Stage
        -- Forwarding Unit
            Forwarding_Unit_inst: Forwarding_Unit
             port map(
                D_EX_rs1 => D_EX_rs1,
                D_EX_rs2 => D_EX_rs2,
                EX_M_rd => EX_M_rd,
                M_WB_rd => M_WB_rd,
                EX_M_RegWrite => EX_M_RegWrite,
                M_WB_RegWrite => M_WB_RegWrite,
                M_WB_Rd_data => M_WB_Rd_data,
                EX_M_Rd_data => EX_M_Rd_data,
                Rarc1_data => Rarc1_data,
                Rarc2_Data => Rarc2_Data,
          
                Immediate => Immediate,
                IMM_Sel => IMM_Sel,
                Operand1 => Operand1,
                Operand2 => Operand2
            );


            -- ALU
            ALU_inst:ALU
             port map(
                operand1 => operand1,
                operand2 => operand2,
                ALU_OP => id_alu_slc_out,
                offset =>Operand2(15 downto 0) ,
                Imm => Operand2(15 downto 0), 
                ALU_OUT => alu_result,
                CCR => CCR_from_Alu
            );
        CCR_inst: CCR
         port map(
            clk => clk,
            reset => rst,
            update_flag => id_update_flag_out,
            Carry_in => id_set_carry_out,
            Return_flags =>PC_loaded_from_memory(3 downto 0),
            RTI_Restore_flags =>ex_mem_rti_out,
            CCR_out => CCR_from_CCR_out,
            CCR_in => CCR_from_Alu
        );
		 -- Forwarding Unit
		

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
			  RTI_In          => id_mem_write_out,  -- TODO: Connect RTI
			  Return_Signal_In=> id_return_sig_out,
			  DM_IN           => id_dm_out,
			  Imm_Offset_In   => id_imm_offset_out,
			  -- Outputs to Memory/Writeback
			  RTI             => ex_mem_rti_out,
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
			  Read_Data_In     => write_data_sig,
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
        HD_Stage: Hazard_Detection_Unit
        port map(
            FD_RS1 => rs1_addr_FD,
            FD_RS2 => rs2_addr_FD,
            D_Ex_rd => id_rd_out,
            D_EX_Mem_Read => ex_mem_read_sig,
            D_EX_Mem_Write => ex_mem_write_sig,
            Data_interface_needed => data_hazard_needed_sig,
            Branch_Taken => branch_taken_sig,
            Stall => stall_sig,
            Flush => flush_sig
        );
        -- Next PC Logic
    

	end Structural;