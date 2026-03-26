library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.seg7_pkg.all;

entity seg7ctrl is
	port(.png
	 	mclk    : in std_ulogic; --100 MHz
		reset   : in std_ulogic;
		d0      : in std_ulogic_vector(3 downto 0);
		d1      : in std_ulogic_vector(3 downto 0);
		abcdefg : out std_ulogic_vector(6 downto 0);
		c	: out std_ulogic
	);
end entity seg7ctrl;

architecture rtl of seg7ctrl is
	--Using a 19-bit counter, needed for 200Hz toggle from 100MHz
	signal counter : unsigned(18 downto 0) := (others => '0');
	signal digit_sel : std_ulogic;
	signal selected_digit : std_ulogic_vector(3 downto 0);
begin
	process(mclk, reset)
	begin
		if reset = '1' then
			counter <=(others => '0');
		elsif rising_edge(mclk) then
			counter <=counter + 1;
		end if;
	end process;
	--Using MSB for half of the duty cycle
	digit_sel <= counter(18);
	--output to board
	c <= digit_sel;
	--multiplex d0,d1
	selected_digit <= d0 when digit_sel = '0' else d1;
	abcdefg <= bin2ssd(selected_digit);
end architecture rtl;
