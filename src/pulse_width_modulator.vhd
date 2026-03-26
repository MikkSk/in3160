library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pulse_width_modulator is
    port(
        mclk       : in std_ulogic;
        reset      : in std_ulogic;
        duty_cycle : in std_ulogic_vector(7 downto 0);
        EN         : out std_ulogic;
        DIR        : out std_ulogic
    );
end entity pulse_width_modulator;

architecture rtl of pulse_width_modulator is

    constant width : integer := 20;
    signal counter : unsigned(width - 1 downto 0) := (others => '0');

    type state_type is (forward_idle, forward_pwm, reverse_idle, reverse_pwm, wait_low_1, wait_low_2);
    signal state : state_type := forward_idle;

    signal duty_abs : unsigned(7 downto 0);

    alias counter_msb : unsigned(7 downto 0) is counter(width - 1 downto width - 8);	
    signal next_dir : std_ulogic;

begin

    duty_abs <= unsigned(abs(signed(duty_cycle)));

    --counter
    process(mclk)
    begin 
	    if rising_edge(mclk) then
		    counter <= counter + 1;
	    end if;
    end process;


    process(mclk, reset)
    begin
        if reset = '1' then
            state <= forward_idle;
            EN    <= '0';
            DIR   <= '1';

        elsif rising_edge(mclk) then
            case state is

                when forward_idle =>
                    EN  <= '0';
                    DIR <= '1';

                    if signed(duty_cycle) > 0 then
                        state <= forward_pwm;
                    elsif signed(duty_cycle) < 0 then
                        next_dir <= '0';
			state <= wait_low_1;
                    end if;

                when forward_pwm =>
                    DIR <= '1';

                    if counter_msb < duty_abs then
                        EN <= '1';
                    else
                        EN <= '0';
                    end if;

                    if signed(duty_cycle) < 0 then
                        next_dir <= '0';
			state <= wait_low_1;
		    elsif signed(duty_cycle) = 0 then
			state <= forward_idle;
                    end if;

                when reverse_idle =>
                    EN  <= '0';
                    DIR <= '0';

                    if signed(duty_cycle) < 0 then
                        state <= reverse_pwm;
                    elsif signed(duty_cycle) > 0 then
			next_dir <= '1';
			state <= wait_low_1;
                    end if;

                when reverse_pwm =>
                    DIR <= '0';

                    if counter_msb < duty_abs then
                        EN <= '1';
                    else
                        EN <= '0';
                    end if;

                    if signed(duty_cycle) > 0 then
			next_dir <= '1';
			state <= wait_low_1;
		    elsif signed(duty_cycle) = 0 then
			state <= reverse_idle;
                    end if;
		

		--safety redudancy
		when wait_low_1 =>
			EN <= '0';
			state <= wait_low_2;

		when wait_low_2 =>
			EN <= '0';
			DIR <= next_dir;
			if next_dir = '1' then
				state <= forward_idle;
			else
				state <= reverse_idle;
			end if;

            end case;
        end if;
    end process;

end architecture;
