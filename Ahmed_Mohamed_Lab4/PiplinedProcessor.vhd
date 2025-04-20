-- PiplinedProcessor
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PiplinedProcessor is
    Port (
        clk : in STD_LOGIC;          
        rst : in STD_LOGIC;         
        en : in STD_LOGIC 
    );
end PiplinedProcessor;



architecture Behavioral of PiplinedProcessor is


    component ProgramCounter
        Port (
            clk    : in STD_LOGIC;
            rst    : in STD_LOGIC;
            en : in STD_LOGIC;
            PC : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
	 
	 
	 component InstructionMemory
        Port (
            PC     : in STD_LOGIC_VECTOR(7 downto 0);
            data_bus : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
	 
	 
	 component Fetch_Decode
        Port (
            clk           : in STD_LOGIC;
            rst           : in STD_LOGIC;
				en 				: in STD_LOGIC;
            instruction   : in STD_LOGIC_VECTOR(15 downto 0);
            opcode        : out STD_LOGIC_VECTOR(2 downto 0);
            src1_address     : out STD_LOGIC_VECTOR(2 downto 0);
            src2_address     : out STD_LOGIC_VECTOR(2 downto 0);
            dst_address      : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;
	 
	 
	 
	 
	 component Reg
        Port (
            clk       : in STD_LOGIC;
            rst       : in STD_LOGIC;
            we  : in STD_LOGIC;
            read_address1 : in STD_LOGIC_VECTOR(2 downto 0);
            read_address2 : in STD_LOGIC_VECTOR(2 downto 0);
            write_address  : in STD_LOGIC_VECTOR(2 downto 0);
				data_in  : in STD_LOGIC_VECTOR(7 downto 0);
            data_out1 : out STD_LOGIC_VECTOR(7 downto 0);
            data_out2 : out STD_LOGIC_VECTOR(7 downto 0)
            
        );
    end component;
	 
	
	 
	 
	 
    component Decode_Execute
        Port (
            clk           : in STD_LOGIC;
            rst           : in STD_LOGIC;
            opcode        : in STD_LOGIC_VECTOR(2 downto 0);
            src1_data     : in STD_LOGIC_VECTOR(7 downto 0);
            src2_data     : in STD_LOGIC_VECTOR(7 downto 0);
            dst_address      : in STD_LOGIC_VECTOR(2 downto 0);
            RegWrite      : in STD_LOGIC;
				
				
            Opcode_out    : out STD_LOGIC_VECTOR(2 downto 0);
            src1_data_out : out STD_LOGIC_VECTOR(7 downto 0);
            src2_data_out : out STD_LOGIC_VECTOR(7 downto 0);
            dst_address_out  : out STD_LOGIC_VECTOR(2 downto 0);
            RegWrite_out  : out STD_LOGIC
        );
    end component;
	 
	 
	 component Controller
    Port (
        opcode       : in STD_LOGIC_VECTOR(2 downto 0);
        regWrite     : out STD_LOGIC
    );
	 end component;

	 
	 
	 
	 
	 component ALU
        Port (
            S     : in STD_LOGIC_VECTOR(2 downto 0);		  
            In1, In2 : in STD_LOGIC_VECTOR(7 downto 0);
				Cin 		  : in std_logic;
            F     : out STD_LOGIC_VECTOR(7 downto 0);
            Cout       : out STD_LOGIC
        );
    end component;
	 
--	     generic (
--        WIDTH : integer := 8
--    );





    component Writeback
        Port (
			  clk          : in STD_logic;
			  rst          : in STD_logic;
			  Opcode       : in STD_LOGIC_VECTOR (2 downto 0);
			  alu_result   : in std_logic_vector(7 downto 0);
			  Cout 			: in std_logic;
			  dst_address  : in STD_LOGIC_VECTOR (2 downto 0);
			  RegWrite 		: in STD_LOGIC;
			  
			  
			  Opcode_out      : out STD_LOGIC_VECTOR (2 downto 0);
			  dst_address_out : out STD_LOGIC_VECTOR (2 downto 0);
			  RegWrite_out 	: out STD_LOGIC;
			  alu_result_out  : out std_logic_vector(7 downto 0);
			  Cout_out 			: out std_logic
        );
    end component;
	 
	 
	 
	 		
	 
------------Signals



    -- Signal Declarations
    signal pc_out          : STD_LOGIC_VECTOR(7 downto 0);
    signal instruction     : STD_LOGIC_VECTOR(15 downto 0);
	 
	 
	 
	 -- Fetch/Decode signals
    signal fd_opcode       : STD_LOGIC_VECTOR(2 downto 0);
    signal fd_src1_addr    : STD_LOGIC_VECTOR(2 downto 0);
    signal fd_src2_addr    : STD_LOGIC_VECTOR(2 downto 0);
    signal fd_dst_addr     : STD_LOGIC_VECTOR(2 downto 0);
	 
	 
	 
	 
	 -- RegisterFile signals
    signal rf_src1_data    : STD_LOGIC_VECTOR(7 downto 0);
    signal rf_src2_data    : STD_LOGIC_VECTOR(7 downto 0);
	 
	 
	 
	 
	 
	 
	 -- Decode/Execute signals
    signal de_opcode       : STD_LOGIC_VECTOR(2 downto 0);
    signal de_src1_data    : STD_LOGIC_VECTOR(7 downto 0);
    signal de_src2_data    : STD_LOGIC_VECTOR(7 downto 0);
    signal de_dst_addr     : STD_LOGIC_VECTOR(2 downto 0);
	 signal de_regWrite     : STD_LOGIC;
	 
	 -- ALU signals
	 signal alu_result      : STD_LOGIC_VECTOR(7 downto 0);
    signal alu_cout        : STD_LOGIC;
	 
	 
	 -- Writeback signals
    signal wb_opcode       : STD_LOGIC_VECTOR(2 downto 0);
    signal wb_dst_addr     : STD_LOGIC_VECTOR(2 downto 0);
    signal wb_regWrite     : STD_LOGIC;
    signal wb_alu_result   : STD_LOGIC_VECTOR(7 downto 0);
    signal wb_cout         : STD_LOGIC;
	 
	 
	 
	 
	 ----controller
	 signal control_regWrite : STD_LOGIC;

	 
	 
	 


begin


    PC_Inst : ProgramCounter
        port map (
            clk => clk,
            rst => rst,
            en  => en,
            PC  => pc_out
        );
		  

		  

    IM_Inst : InstructionMemory
        port map (
            PC     => pc_out,
            data_bus => instruction
        );
		  

		  
		  
		  
	 FD_Inst : Fetch_Decode
        port map (
            clk         => clk,
            rst         => rst,
            en          => en,
            instruction => instruction,
            Opcode      => fd_opcode,
            src1_address   => fd_src1_addr,
            src2_address   => fd_src2_addr,
            dst_address    => fd_dst_addr
        );	
		
	  
	    
    RF_Inst : Reg
        port map (
            clk       => clk,
            rst       => rst,
            we  		 => wb_regWrite,
            read_address1 => fd_src1_addr,
            read_address2 => fd_src2_addr,
            write_address => wb_dst_addr,
            data_in   => wb_alu_result,
            data_out1 => rf_src1_data,
            data_out2 => rf_src2_data
        );	
		  
		  
		  
		  
	 CTRL_Inst : Controller
		 port map (
			  opcode   => fd_opcode, 
			  regWrite => control_regWrite
	 );
	  
		  
		  

   
    DE_Inst : Decode_Execute
        port map (
            clk           => clk,
            rst           => rst,
            opcode        => fd_opcode,
            src1_data     => rf_src1_data,
            src2_data     => rf_src2_data,
            dst_address      => fd_dst_addr,
            RegWrite      => control_regWrite,
            Opcode_out    => de_opcode,
            src1_data_out => de_src1_data,
            src2_data_out => de_src2_data,
            dst_address_out  => de_dst_addr, 
				RegWrite_out  => de_regWrite
        );


		  
		  
		  
	 ALU_Inst : ALU
        port map (
				S => de_opcode,
            In1   => de_src1_data,
            In2   => de_src2_data,            
            Cin    => '0',
            F => alu_result,
            Cout   => alu_cout
        );
		  
	  
	    
    WB_Inst : Writeback
        port map (
            clk             => clk,
            rst             => rst,
            Opcode          => de_opcode,
            alu_result      => alu_result,
            Cout            => alu_Cout,
            dst_address     => de_dst_addr,
            RegWrite        => de_regWrite, 

            Opcode_out      => wb_opcode,
            dst_address_out => wb_dst_addr,
            RegWrite_out    => wb_regWrite,
            alu_result_out  => wb_alu_result,
            Cout_out        => wb_Cout
        );	  
		  



end Behavioral;