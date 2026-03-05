library IEEE;
use IEEE.std_logic_1164.all;

entity self_test_system is
	port (
		clk     : in std_ulogic;
		reset   : in std_ulogic;
		abcdefg : out std_ulogic_vector(6 downto 0);
		c	: out std_ulogic
);
end entity self_test_system;

architecture rtl of self_test_system is
	signal d0 : std_ulogic_vector(3 downto 0);
	signal d1 : std_ulogic_vector(3 downto 0);
begin

	u_self_test : entity work.self_test
		port map (
				mclk => clk,
				reset => reset,
				d0 => d0,
				d1 => d1
			);
	u_seg7ctrl : entity work.seg7ctrl
		port map(
				mclk => clk,
				reset => reset,
				d0 => d0,
				d1 => d1,
				abcdefg => abcdefg,
				c => c
			);
end architecture rtl;
