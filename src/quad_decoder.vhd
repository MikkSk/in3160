library IEEE;
use IEEE.std_logic_1164.all;

entity quad_decoder is
	port(
	mclk    : in std_ulogic;
	reset   : in std_ulogic;
	SA      : in std_ulogic;
	SB      : in std_ulogic;
	pos_dec : out std_ulogic;
	pos_inc : out std_ulogic
);
end entity quad_decoder;

architecture rtl of quad_decoder is
	type state_type is (s_reset, s_init, s_0, s_1, s_2, s_3);
	signal state : state_type := s_reset;
	signal next_state : state_type := s_reset;
	signal err : std_ulogic;
	signal AB : std_ulogic_vector(1 downto 0);

begin 
	AB <= SA & SB;
	--register
	process(mclk, reset)
	begin
		if reset = '1' then
			state <= s_reset;
		elsif rising_edge(mclk) then
			state <= next_state;
		end if;
	end process;
	--fsm logic
	process(state, AB)
	begin
		--default
		next_state <= state;
		case state is
			when s_reset => 
				next_state <= s_init;
			
			when s_init =>
				case AB is
					when "00" => next_state <= s_0;
					when "01" => next_state <= s_1;
					when "11" => next_state <= s_2;
					when "10" => next_state <= s_3;
					when others => next_state <= s_reset;
				end case;
			
			when s_0 =>
				case AB is
					when "00" => next_state <= s_0;
					when "01" => next_state <= s_1;
					when "11" => next_state <= s_reset;
					when "10" => next_state <= s_3;
					when others => next_state <= s_reset;
				end case;
			when s_1 =>
				case AB is 
					when "00" => next_state <= s_0;
					when "01" => next_state <= s_1;
					when "11" => next_state <= s_2;
					when "10" => next_state <= s_reset;
					when others => next_state <= s_reset;
				end case;
			when s_2 =>
				case AB is
					when "00" => next_state <= s_reset;
					when "01" => next_state <= s_1;
					when "11" => next_state <= s_2;
					when "10" => next_state <= s_3;
					when others => next_state <= s_reset;
				end case;
			when s_3 =>
				case AB is
					when "00" => next_state <= s_0;
					when "01" => next_state <= s_reset;
					when "11" => next_state <= s_2;
					when "10" => next_state <= s_3;
					when others => next_state <= s_reset;
				end case;
		end case;
	end process;

	process(mclk, reset)
	begin
	if reset = '1' then
		pos_inc <= '0';
		pos_dec <= '0';
		err <= '0';
	elsif rising_edge(mclk) then
		pos_inc <= '0';
		pos_dec <= '0';
		err <= '0';

	case state is
		when s_0 =>
			if AB = "01" then
				pos_inc <= '1';
			elsif AB = "10" then
				pos_dec <= '1';
			elsif AB = "11" then
				err <= '1';
			end if;

		when s_1 =>
			if AB = "11" then
				pos_inc <= '1';
			elsif AB = "00" then
				pos_dec <= '1';
			elsif AB = "10" then
				err <= '1';
			end if;

		when s_2 =>
			if AB = "10" then
				pos_inc <= '1';
			elsif AB = "01" then
				pos_dec <= '1';
			elsif AB = "00" then
				err <= '1';
			end if;

		when s_3 => 
			if AB = "00" then
				pos_inc <= '1';
			elsif AB = "11" then
				pos_dec <= '1';
			elsif AB = "01" then
				err <= '1';
			end if;

		when others =>
			null;
	end case;
	end if;
	end process;
end architecture rtl;
