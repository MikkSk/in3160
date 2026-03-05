library IEEE;
use IEEE.std_logic_1164.all;

package seg7_pkg is
	function bin2ssd(
		di : std_ulogic_vector(3 downto 0)
	) return std_ulogic_vector;
end package seg7_pkg;

package body seg7_pkg is
	function bin2ssd(
		di : std_ulogic_vector(3 downto 0)
	) return std_ulogic_vector is
	begin 
		case di is 
			when "0000" => return "1111110"; --0
			when "0001" => return "0110000"; --1
			when "0010" => return "1101101"; --2
			when "0011" => return "1111001"; --3
			when "0100" => return "0110011"; --4
			when "0101" => return "1011011"; --5
			when "0110" => return "1011111"; --6
			when "0111" => return "1110000"; --7
			when "1000" => return "1111111"; --8
			when "1001" => return "1111011"; --9
			when "1010" => return "1110111"; --A
			when "1011" => return "0011111"; --B
			when "1100" => return "1001110"; --C
			when "1101" => return "0111101"; --D
			when "1110" => return "1001111"; --E
			when "1111" => return "1000111"; --F
			when others => return "0000000"; 
		end case;
	end function;
end package body seg7_pkg;


