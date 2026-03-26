library IEEE;
use IEEE.std_logic_1164.all;

entity input_sync is 
	port(
	mclk    : in std_ulogic;
	SA	: in std_ulogic;
	SB	: in std_ulogic;
	SA_sync : out std_ulogic;
	SB_sync : out std_ulogic

);
end entity input_sync;

architecture rtl of input_sync is
	signal SA_ff1, SA_ff2 : std_ulogic;
	signal SB_ff1, SB_ff2 : std_ulogic;

begin
	process(mclk)
	begin
		if rising_edge(mclk) then
			SA_ff1 <= SA;
			SA_ff2 <= SA_ff1;
			SB_ff1 <= SB;
			SB_ff2 <= SB_ff1;
		end if;
	end process;
	SA_sync <= SA_ff2;
	SB_sync <= SB_ff2;
		
end architecture;	
