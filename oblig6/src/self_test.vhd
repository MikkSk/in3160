library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity self_test is
	port (
		mclk  : in std_ulogic;
		reset : in std_ulogic;
		d0    : out std_ulogic_vector(3 downto 0);
		d1    : out std_ulogic_vector(3 downto 0)
	);
end entity;

architecture rtl of self_test is
	signal sec_counter : unsigned(26 downto 0) := (others => '0');
	signal second_tick : std_ulogic :='0';
	signal index 	   : unsigned(3 downto 0) := (others => '0');
	constant sec_limit : unsigned(26 downto 0) := to_unsigned(100000000,27);	
	type rom_t is array (0 to 15) of std_ulogic_vector(7 downto 0);

	constant secret_rom : rom_t :=
	(
	x"12",
	x"34",
	x"40",
	x"00",
	x"56",
	x"73",
	x"00",
	x"86",
	x"90",
	x"00",
	x"AB",
	x"30",
	x"00",
	x"C6",
	x"65",
	x"00"
	);

begin
	process (mclk, reset)
	begin
		if reset = '1' then
			sec_counter <= (others => '0');
			second_tick <= '0';

		elsif rising_edge(mclk) then
			if sec_counter = sec_limit then
				sec_counter <= (others => '0');
				second_tick <= '1';
			else
				sec_counter <= sec_counter + 1;
				second_tick <= '0';
			end if;
		end if;
	end process;

	process(mclk, reset)
	begin
		if reset = '1' then
			index <= (others => '0');
		
		elsif rising_edge(mclk) then

			if second_tick = '1' then
				index <= index + 1;
			end if;
		end if;
	end process;

	d1 <= secret_rom(to_integer(index))(7 downto 4);
	d0 <= secret_rom(to_integer(index))(3 downto 0);
end architecture;
