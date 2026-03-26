library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;

entity self_test is
    port(
        mclk       : in  std_ulogic;
        reset      : in  std_ulogic;
        duty_cycle : out std_ulogic_vector(7 downto 0)
    );
end entity;

architecture rtl of self_test is

    -- parameters
    constant ROM_depth : integer := 20;
    constant sec_limit : unsigned(31 downto 0) := to_unsigned(300000000-1, 32);

    -- ROM func
    type memory_array is array(0 to ROM_depth-1) of std_ulogic_vector(7 downto 0);

    impure function initialize_ROM(file_name : string) return memory_array is
        file init_file : text open read_mode is file_name;
        variable current_line : line;
        variable temp_logic   : std_logic_vector(7 downto 0);
        variable result       : memory_array;
    begin
        for i in result'range loop
            readline(init_file, current_line);
            read(current_line, temp_logic);
            result(i) := std_ulogic_vector(temp_logic);
        end loop;
        return result;
    end function;

    -- signals
    signal rom_data    : memory_array := initialize_ROM("duty_values.txt");
    signal sec_counter : unsigned(31 downto 0) := (others => '0');
    signal tick_3s     : std_ulogic := '0';
    signal index       : unsigned(4 downto 0) := (others => '0');

begin

    -- timer
    process(mclk, reset)
    begin
        if reset = '1' then
            sec_counter <= (others => '0');
            tick_3s <= '0';
        elsif rising_edge(mclk) then
            if sec_counter = sec_limit then
                sec_counter <= (others => '0');
                tick_3s <= '1';
            else
                sec_counter <= sec_counter + 1;
                tick_3s <= '0';
            end if;
        end if;
    end process;

    -- index
    process(mclk, reset)
    begin
        if reset = '1' then
            index <= (others => '0');
        elsif rising_edge(mclk) then
            if tick_3s = '1' then
                if index = ROM_depth-1 then
                  -- index <= (others => '0');
                else
                    index <= index + 1;
                end if;
            end if;
        end if;
    end process;

    -- output
    duty_cycle <= rom_data(to_integer(index));

end architecture;
