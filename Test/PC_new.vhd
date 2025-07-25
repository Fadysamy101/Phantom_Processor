library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC_New is
    Port (
        clk                   : in STD_LOGIC;
        rst                   : in STD_LOGIC;
        PC_initial            : in STD_LOGIC_VECTOR(31 downto 0); -- Initial PC value
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
        PC                    : out STD_LOGIC_VECTOR(31 downto 0);
        branch_detected       : out STD_LOGIC
    );
end PC_New;

architecture Behavioral of PC_New is
    signal counter           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal next_PC           : STD_LOGIC_VECTOR(31 downto 0);
    signal branch_decision   : STD_LOGIC;
    signal Return_Decision   : STD_LOGIC;
begin

    -- Process to handle the branch and jump conditions based on flags
    -- Modified to consider stall condition
    flag_check: process(in_from_CCR, in_J_SC, branch, stall)
    begin
        branch_decision <= '0'; -- Default value
        branch_detected <= '0'; -- Default value
       
        -- Only process branch decisions if not stalled
        if stall = '0' and branch = '1' then
            case in_J_SC is
                when "00" =>
                    if in_from_CCR(0) = '1' then
                        branch_decision <= '1';
                        branch_detected <= '1';
                    end if;
                when "01" =>
                    if in_from_CCR(1) = '1' then
                        branch_decision <= '1';
                        branch_detected <= '1';
                    end if;  
                when "10" =>
                    if in_from_CCR(2) = '1' then
                        branch_decision <= '1';
                        branch_detected <= '1';
                    end if;      
                when "11" =>
                    branch_decision <= '1';
                    branch_detected <= '1';
                when others =>  
                    branch_decision <= '0';
                    branch_detected <= '0';
            end case;
        end if;
    end process flag_check;
   
    -- Calculate Return Decision (separate process)
    Return_Decision <= RTI or Return_flag or Interrupt;
   
    -- Process to calculate next PC value (combinational logic)
    -- Modified to consider stall condition
    next_pc_calc: process(counter, branch_decision, Call, branch_addr, Return_Decision, PC_loaded_from_memory, stall)
    begin
        -- Default: keep current PC if stalled
        next_PC <= counter;
        
        -- Only calculate new PC if not stalled
        if stall = '0' then
            -- Priority handling for PC update:
            -- 1. Return/Interrupt (highest)
            -- 2. Call
            -- 3. Branch
            -- 4. Normal increment (lowest)
           
            if Return_Decision = '1' then
                next_PC <= PC_loaded_from_memory;
            elsif Call = '1' then
                next_PC <= branch_addr;
            elsif branch_decision = '1' then
                next_PC <= branch_addr;
            else
                next_PC <= std_logic_vector(unsigned(counter) + 1);
            end if;
        end if;
    end process next_pc_calc;
   
    -- Sequential process to update counter on clock edge
    -- Simplified since stall logic is now in next_pc_calc
    pc_update: process(clk, rst)
    begin
        if rst = '1' then
            counter <=PC_initial;
        elsif rising_edge(clk) then
            counter <= next_PC;
        end if;
    end process pc_update;
   
    -- Output current PC value
    PC <= counter;
   
end Behavioral;