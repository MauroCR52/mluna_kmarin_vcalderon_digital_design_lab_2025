library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_sumador is
    Port ( SW : in  STD_LOGIC_VECTOR (8 downto 0); -- 9 switches para A, B y Cin
           HEX0 : out STD_LOGIC_VECTOR (6 downto 0); -- Display principal (Suma)
           HEX1 : out STD_LOGIC_VECTOR (6 downto 0)); -- Display para Carry Out
end top_sumador;

architecture Structural of top_sumador is
    signal Sum : STD_LOGIC_VECTOR(3 downto 0);
    signal Cout : STD_LOGIC;

    component sumador_4bits
        Port ( A     : in  STD_LOGIC_VECTOR (3 downto 0);
               B     : in  STD_LOGIC_VECTOR (3 downto 0);
               Cin   : in  STD_LOGIC;
               Sum   : out STD_LOGIC_VECTOR (3 downto 0);
               Cout  : out STD_LOGIC);
    end component;

    component decoder_7seg
        Port ( bin_in : in  STD_LOGIC_VECTOR(3 downto 0);
               seg_out : out STD_LOGIC_VECTOR(6 downto 0));
    end component;

begin
    -- Conectar switches a los operandos
    U1: sumador_4bits port map (
        A => SW(3 downto 0),
        B => SW(7 downto 4),
        Cin => SW(8),
        Sum => Sum,
        Cout => Cout
    );

    -- Decodificar la salida de la suma en HEX0
    U2: decoder_7seg port map (
        bin_in => Sum,
        seg_out => HEX0
    );

    -- Mostrar Carry Out en HEX1 (muestra '1' si hay carry, apagado si no)
    HEX1 <= NOT "0000110" when Cout = '1' else NOT "0000000"; -- 1 o apagado

end Structural;
