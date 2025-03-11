library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sumador_1bit is
    Port ( A     : in  STD_LOGIC;
           B     : in  STD_LOGIC;
           Cin   : in  STD_LOGIC;
           Sum   : out STD_LOGIC;
           Cout  : out STD_LOGIC);
end sumador_1bit;

architecture Behavioral of sumador_1bit is
begin
    Sum  <= A XOR B XOR Cin;
    Cout <= (A AND B) OR (Cin AND (A XOR B));
end Behavioral;
