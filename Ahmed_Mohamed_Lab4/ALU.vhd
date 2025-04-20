library ieee;
use ieee.std_logic_1164.all;

entity ALU is
    generic (
        WIDTH : integer := 8
    );
    port (
        S   : in std_logic_vector(2 downto 0); 
        In1, In2 : in std_logic_vector(WIDTH-1 downto 0);
        Cin : in std_logic;
        F   : out std_logic_vector(WIDTH-1 downto 0);
        Cout : out std_logic
    );
end entity ALU;

architecture ALU_arch of ALU is

 


    component ALU_B is
        generic (WIDTH : integer := 8);
        port (
            S   : in std_logic_vector(1 downto 0);
            In1, In2 : in std_logic_vector(WIDTH-1 downto 0);
            Cin : in std_logic;
            F   : out std_logic_vector(WIDTH-1 downto 0);
            Cout : out std_logic
        );
    end component;




--  signal F_A, F_B, F_C, F_D : std_logic_vector(WIDTH-1 downto 0);
	 signal F_B : std_logic_vector(WIDTH-1 downto 0);

--  signal Cout_A, Cout_B, Cout_C, Cout_D : std_logic;
	 signal Cout_B : std_logic;

begin

 
--    aluA: ALU_A
--	 
--        generic map(WIDTH => WIDTH)
--		  
--        port map(S => S(1 downto 0), In1 => In1, In2 => In2, Cin => Cin, F => F_A, Cout => Cout_A);
		  

    aluB: ALU_B
	 
        generic map(WIDTH => WIDTH)
		  
        port map(S => S(1 downto 0), In1 => In1, In2 => In2, Cin => Cin, F => F_B, Cout => Cout_B);
		  
		  

--    aluC: ALU_C
--	 
--        generic map(WIDTH => WIDTH)
--		  
--        port map(S => S(1 downto 0), In1 => In1, In2 => In2, Cin => Cin, F => F_C, Cout => Cout_C);
--		  
--		  
--
--    aluD: ALU_D
--	 
--        generic map(WIDTH => WIDTH)
--		  
--        port map(S => S(1 downto 0), In1 => In1, In2 => In2, Cin => Cin, F => F_D, Cout => Cout_D);
		  
		  


    F <= F_B when S(2) = '1' else
         (others => '0');

    Cout <= Cout_B when S(2) = '1' else
            '0';


end architecture ALU_arch;
