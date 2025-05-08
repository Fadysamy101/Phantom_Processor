library ieee;
use ieee.std_logic_1164.all;


entity ALU_B is

	generic (
		WIDTH : integer := 8
	);

	port (
		S : in std_logic_vector(1 downto 0);
		In1, In2 : in std_logic_vector(WIDTH-1 downto 0);
		Cin : in std_logic;
		F : out std_logic_vector(WIDTH-1 downto 0);
		Cout : out std_logic
	);

end entity ALU_B;


architecture ALU_arch of ALU_B is

	begin
	
	
	
	
	
	

	----bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
	F <= (In1 xor In2) when S = "00"
	else not(In1 and In2) when S = "01"
	else (In1 or In2) when S = "10"
	else not(In1);
	
	Cout <= '0';




	-- your component and signal declarations here

	-- Your structural/behavioural code here

end architecture ALU_arch;