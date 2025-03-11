library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_7seg is
    Port ( bin_in : in  STD_LOGIC_VECTOR(3 downto 0);
           seg_out : out STD_LOGIC_VECTOR(6 downto 0));
end decoder_7seg;

architecture Behavioral of decoder_7seg is
begin
    process(bin_in)
    begin
        case bin_in is
            when "0000" => seg_out <= NOT "0111111"; -- 0
            when "0001" => seg_out <= NOT "0000110"; -- 1
            when "0010" => seg_out <= NOT "1011011"; -- 2
            when "0011" => seg_out <= NOT "1001111"; -- 3
            when "0100" => seg_out <= NOT "1100110"; -- 4
            when "0101" => seg_out <= NOT "1101101"; -- 5
            when "0110" => seg_out <= NOT "1111101"; -- 6
            when "0111" => seg_out <= NOT "0000111"; -- 7
            when "1000" => seg_out <= NOT "1111111"; -- 8
            when "1001" => seg_out <= NOT "1101111"; -- 9
            when "1010" => seg_out <= NOT "1110111"; -- A
            when "1011" => seg_out <= NOT "1111100"; -- B
            when "1100" => seg_out <= NOT "0111001"; -- C
            when "1101" => seg_out <= NOT "1011110"; -- D
            when "1110" => seg_out <= NOT "1111001"; -- E
            when "1111" => seg_out <= NOT "1110001"; -- F
            when others => seg_out <= NOT "0000000"; -- Apagado
        end case;
    end process;
end Behavioral;
