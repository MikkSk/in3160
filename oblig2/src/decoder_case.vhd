library IEEE;
use IEEE.std_logic_1164.all;

architecture case_arch of decoder is
begin
	process(sw) is 
	begin
		LD <="0000"; -- default state
		case (sw) is
			when "00" =>ld <="1110";
			when "01" =>ld <="1101";
			when "10" =>ld <="1011";
			when "11" =>ld <="0111";
			when others => null;
		end case;
	end process;
end architecture case_arch;


