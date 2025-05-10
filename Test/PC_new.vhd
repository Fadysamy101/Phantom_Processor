    library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
entity PC_new is 
 port
 ( 
    PC_old           : in STD_LOGIC_VECTOR(31 downto 0);
    branch           : in STD_LOGIC;  -- From EX stage
    in_from_CCR      : in STD_LOGIC_VECTOR(3 downto 0);
    in_J_SC          : in STD_LOGIC_VECTOR(1 downto 0);
    Call             : in STD_LOGIC;
    branch_addr      : in STD_LOGIC_VECTOR(31 downto 0); -- From ALU
    RTI              : in std_logic;
    Return_flag      : in std_logic;
    Interrupt        : in std_logic;
    PC_new           : out STD_LOGIC_VECTOR(31 downto 0);
    PC_loaded_from_memory   : in STD_LOGIC_VECTOR(31 downto 0)


 );   
end entity;
architecture behavioral of PC_new is
    signal flag_decision : STD_LOGIC;
    signal branch_decision : STD_LOGIC;
   
    signal PC_new_temp : STD_LOGIC_VECTOR(31 downto 0); 
    signal Return_Decision : STD_LOGIC;

begin
    --procees to handle the branch and jump conditions
    process(in_from_CCR, in_J_SC, Call, branch)
begin
    case in_J_SC is 
        when "00" => 
            if in_from_CCR(0) = '1' then
                branch_decision <= '1' and branch;
            else
                branch_decision <= '0';
            end if;
        when "01" => 
            if in_from_CCR(1) = '1' then
                branch_decision <= '1' and branch;
            else
                branch_decision <= '0';
            end if;   
        when "10" => 
            if in_from_CCR(2) = '1' then
                branch_decision <= '1' and branch;
            else
                branch_decision <= '0';
            end if;      
        when "11" =>
            branch_decision <= '1' and branch;
        when others =>   
            branch_decision <= '0';
    end case;
    end process;

    --process to handle the branch and jump conditions
    process(branch_decision, Call, branch_addr, PC_old)
    begin
       if Call = '1' then
        PC_new_temp <= branch_addr(31 downto 0); -- Jump to subroutine
    elsif branch_decision = '1' then
        PC_new_temp <= branch_addr(31 downto 0); -- Conditional branch
    else
        PC_new_temp <= std_logic_vector(unsigned(PC_old) + 1); -- Normal PC increment
    end if;
        report "PC_new" & std_logic'image(PC_new_temp(0)) &  std_logic'image(PC_new_temp(1)) severity note;

    end process;
   --process to handle Return address or Pc_New
    process(PC_new_temp, Return_flag, RTI, Interrupt, PC_loaded_from_memory)
    begin
    Return_Decision<= RTI or Return_flag or  Interrupt; 
    if Return_Decision = '1' then
        PC_new <= PC_loaded_from_memory;
    else
        PC_new <= PC_new_temp;
    end if; 
      report "Pc_Out" & std_logic'image(PC_new_Temp(0)) &  std_logic'image(PC_new_temp(1)) severity note;    
    end process; 


end architecture;
