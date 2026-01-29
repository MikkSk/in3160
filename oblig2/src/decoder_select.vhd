library IEEE;
use IEEE.std_logic_1164.all;

architecture select_arch of decoder is	
begin
	with sw select ld <= 
	"1110" when "00",
	"1101" when "01",
	"1011" when "10",
	"1111" when "11", -- my change
	"0000" when others;
end architecture select_arch;
