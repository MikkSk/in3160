library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


architecture seg7ctrl_arch of seg7ctrl is
	--Using a 19-bit counter, needed for 200Hz toggle from 100MHz
	signal counter 	      : unsigned(18 downto 0) := (others => '0');
	signal digit_sel      : std_ulogic;
	signal selected_digit : std_ulogic_vector(3 downto 0);
	signal seg_out	      : std_ulogic_vector(6 downto 0);
begin
	process(mclk, reset)
	begin
		if reset = '1' then
			counter <= (others => '0');
		elsif rising_edge(mclk) then
			counter <= counter + 1;
		end if;
	end process;
	--Choosing dig
	digit_sel <= counter(18);
	--output to board
	c <= digit_sel;
	--multiplex d0,d1
	selected_digit <= d0 when digit_sel = '0' else d1;


	process(selected_digit)
	begin
		case selected_digit is
			when "0000" => seg_out <= "0000000";
			when "0001" => seg_out <= "0011110";
			when "0010" => seg_out <= "0111100";
			when "0011" => seg_out <= "1001111";
			when "0100" => seg_out <= "0001110";
			when "0101" => seg_out <= "0111101";
			when "0110" => seg_out <= "0011101";
			when "0111" => seg_out <= "0010101";
			when "1000" => seg_out <= "0111011";
			when "1001" => seg_out <= "0111110";
			when "1010" => seg_out <= "1110111";
			when "1011" => seg_out <= "0000101";
			when "1100" => seg_out <= "1111011";
			when "1101" => seg_out <= "0011100";
			when "1110" => seg_out <= "0001101";
			when "1111" => seg_out <= "1111111";
			when others => seg_out <= "0000000";
		end case;
	end process;

end architecture seg7ctrl_arch;
