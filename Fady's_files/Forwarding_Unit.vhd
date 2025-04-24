library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Forwarding_Unit is
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
end entity Forwarding_Unit;

architecture Behavioral of Forwarding_Unit is
begin
  process(D_EX_rs1, D_EX_rs2, EX_M_rd, M_WB_rd)
  begin
    -- Default: no forwarding
    Forward_array_Rs1 <= "00";
    Forward_array_Rs2 <= "00";

    -- Forwarding logic for rs1
    if (D_EX_rs1 = EX_M_rd and EX_M_rd /= "000") then
      Forward_array_Rs1 <= "10"; -- Forward from EX/MEM
    elsif (D_EX_rs1 = M_WB_rd and M_WB_rd /= "000") then
      Forward_array_Rs1 <= "01"; -- Forward from MEM/WB
    end if;

    -- Forwarding logic for rs2
    if (D_EX_rs2 = EX_M_rd and EX_M_rd /= "000") then
      Forward_array_Rs2 <= "10"; -- Forward from EX/MEM
    elsif (D_EX_rs2 = M_WB_rd and M_WB_rd /= "000") then
      Forward_array_Rs2 <= "01"; -- Forward from MEM/WB
    end if;
  end process;
end architecture Behavioral;
