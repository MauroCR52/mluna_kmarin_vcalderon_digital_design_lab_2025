library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sumador_4bits_tb is
end sumador_4bits_tb;

architecture Behavioral of sumador_4bits_tb is
    signal A_tb   : STD_LOGIC_VECTOR (3 downto 0);
    signal B_tb   : STD_LOGIC_VECTOR (3 downto 0);
    signal Cin_tb : STD_LOGIC;
    signal Sum_tb : STD_LOGIC_VECTOR (3 downto 0);
    signal Cout_tb: STD_LOGIC;

    component sumador_4bits
        Port ( A     : in  STD_LOGIC_VECTOR (3 downto 0);
               B     : in  STD_LOGIC_VECTOR (3 downto 0);
               Cin   : in  STD_LOGIC;
               Sum   : out STD_LOGIC_VECTOR (3 downto 0);
               Cout  : out STD_LOGIC);
    end component;

begin
    UUT: sumador_4bits port map(A => A_tb, B => B_tb, Cin => Cin_tb, Sum => Sum_tb, Cout => Cout_tb);

    process
    begin
        -- Prueba 1:  0001 (1) + 0010 (2) + 0
        A_tb   <= "0001";  
        B_tb   <= "0010";  
        Cin_tb <= '0';     
        wait for 10 ns;

        -- Prueba 2:  0110 (6) + 0011 (3) + 0
        A_tb   <= "0110";  
        B_tb   <= "0011";  
        Cin_tb <= '0';     
        wait for 10 ns;

        -- Prueba 3:  1111 (15) + 0001 (1) + 0 
        A_tb   <= "1111";  
        B_tb   <= "0001";  
        Cin_tb <= '0';     
        wait for 10 ns;

        -- Prueba 4:  1010 (10) + 0101 (5) + 1
        A_tb   <= "1010";  
        B_tb   <= "0101";  
        Cin_tb <= '1';     
        wait for 10 ns;

        wait;
    end process;
end Behavioral;
