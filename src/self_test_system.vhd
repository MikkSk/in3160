library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.seg7_pkg.all;

entity self_test_system is
	port(
		mclk 	: in std_ulogic;
		reset 	: in std_ulogic;
		--quad dec
		SA 	: in std_ulogic;
		SB      : in std_ulogic;
		--PWM
		EN_out  : out std_ulogic;
		DIR_out : out std_ulogic;
		--7seg
		abcdefg : out std_ulogic_vector(6 downto 0);
		c	: out std_ulogic
	);
end entity self_test_system;

architecture self_test_system;
	
	--signals PWM
	signal duty_cycle : std_ulogic_vector(7 downto 0);
	signal pwm_EN	  : std_ulogic;
	signal pwm_DIR	  : std_ulogic;
	--signals output sync
	signal EN_sync    : std_ulogic;
	signal DIR_sync   : std_ulogic;
	--signal input sync
	signal SA_sync	  : std_ulogic;
	signal SB_sync	  : std_ulogic;
	--signal quad dec
	signal pos_inc	  : std_ulogic;
	signal pos_dec	  : std_ulogic;
	--signal vel reader
	signal vel_signed : signed(7 downto 0);
	--signal 7seg display
	signal d0, d1 	  : std_ulogic_vector(3 downto 0);
begin
	--self test(pwm duty cycle)
	self_test_inst: entity work.self_test
	port map(
		mclk => mclk,
		reset => reset,
		duty_cycle => duty_cycle
	);
	--pwm(enable/direction for motor)
	pwm_inst : entity work.pulse_width_modulator
	port map(
		mclk => mclk,
		reset => reset,
		duty_cycle => duty_cycle
		EN => pwm_EN
		DIR => pwm_DIR
	);
	--output sync
	output_sync_inst : entity work.output_sync
	port map(
		mclk => mclk,
		reset => reset,
		EN_in => pwm_EN,
		DIR_in => pwm_DIR
		EN_out => EN_out,
		DIR_out => DIR_out
	);
	-- input sync
	input_sync_inst : entity work.input_sync
	port map(
		mclk => mclk,
		SA => SA,
		SB => SB,
		SA_sync => SA_sync,
		SB_sync => SB_sync
	);
	--quad decoder(pos_inc/pos_dec)
	quad_decoder_inst : entity work.quad_decoder
	port map(
		mclk => mclk,
		reset => reset,
		SA => SA_sync,
		SB => SB_sync,
		pos_inc => pos_inc,
		pos_dec => pos_dec
	);
	--vel reader(counts pulses -> signes velocity)
	velocity_reader_inst : entity work.velocity_reader
	port map(
		mclk => mclk,
		reset => reset,
		pos_inc => pos_inc,
		pos_dec => pos_dec,
		vel => vel_signed
	);
	--velocity to use for 7seg display
	d0 <= std_logic_vector(unsigned(abs(vel_signed))(3 downto 0));
	d1 <= std_logic_vector(unsigned(abs(vel_signed))(7 downto 0));
	--7seg display
	seg_7display_inst : entity work.seg7ctrl
	port map(
		mclk => mclk,
		reset => reset,
		d0 => d0,
		d1 => d1,
		abcdefg => abcdefg,
		c => c
	);
end architecture rtl;

