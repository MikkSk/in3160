library IEEE;
use IEEE.std_logic_1164.all;

entity output_sync is 
	port(
	mclk    : in std_ulogic;
	reset   : in std_ulogic;
	EN_in   : in std_ulogic;
	DIR_in  : in std_ulogic;
	EN_out  : out std_ulogic;
	DIR_out : out std_ulogic
);
end entity output_sync;

architecture rtl of output_sync is
	signal EN_reg : std_ulogic;
	signal DIR_reg : std_ulogic;
begin
	process(mclk, reset)
	begin
		if reset = '1' then
			EN_reg <= '0';
			DIR_reg <= '0';
		elsif rising_edge(mclk) then
			EN_reg <= EN_in;
			DIR_reg <= DIR_in;
		end if;
	end process;
	EN_out <= EN_reg;
	DIR_out <= DIR_reg;
end architecture;	
