library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sumador_4bits is
    Port ( A     : in  STD_LOGIC_VECTOR (3 downto 0);
           B     : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin   : in  STD_LOGIC;
           Sum   : out STD_LOGIC_VECTOR (3 downto 0);
           Cout  : out STD_LOGIC);
end sumador_4bits;

architecture Structural of sumador_4bits is
    
    signal C : STD_LOGIC_VECTOR (3 downto 1);

    
    component sumador_1bit
        Port ( A     : in  STD_LOGIC;
               B     : in  STD_LOGIC;
               Cin   : in  STD_LOGIC;
               Sum   : out STD_LOGIC;
               Cout  : out STD_LOGIC);
    end component;

begin
    
    FA0: sumador_1bit port map(A => A(0), B => B(0), Cin => Cin,   Sum => Sum(0), Cout => C(1));
    FA1: sumador_1bit port map(A => A(1), B => B(1), Cin => C(1),  Sum => Sum(1), Cout => C(2));
    FA2: sumador_1bit port map(A => A(2), B => B(2), Cin => C(2),  Sum => Sum(2), Cout => C(3));
    FA3: sumador_1bit port map(A => A(3), B => B(3), Cin => C(3),  Sum => Sum(3), Cout => Cout);

end Structural;
