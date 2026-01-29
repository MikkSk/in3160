library IEEE;
use IEEE.std_logic_1164.all;

entity decoder is
	port(
		sw : in std_ulogic_vector(1 downto 0);
		ld : out std_ulogic_vector(3 downto 0)
		
);
end entity decoder;


