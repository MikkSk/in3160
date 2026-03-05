library IEEE;
use IEEE.std_logic_1164.all;
use work.seg7_pkg.all;

entity bin2ssd_test is
	port(
		di : std_ulogic_vector(3 downto 0);
		abcdefg : out std_ulogic_vector(6 downto 0)
	);
end entity bin2ssd_test;

architecture rtl of bin2ssd_test is
begin
	abcdefg <= bin2ssd(di);
end architecture rtl;
