library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FIRST is
  port
    (
      clk, reset : in  std_ulogic;        -- Register control
      load       : in  std_ulogic;        -- Load signal
      inp        : in  std_ulogic_vector(3 downto 0);  -- Start value
      count      : out std_ulogic_vector(3 downto 0);  -- Count value
      up         : out  std_ulogic;        -- Up signal
      min_count  : out std_ulogic;        -- Minumum count flag
      max_count  : out std_ulogic         -- Maximum count flag
      );
end FIRST;

-- The architecture below describes a 4-bit up counter. When the counter
-- reaches its maximum value, the signal max_count is activated.

architecture RTL of first is
  --  Declarative region
  signal next_count : u_unsigned(3 downto 0);
begin
  --  Statement region
  -- Combinational logic used for register input

up <= '1' when load = '1' else 
      '0' when(up ='1') and max_count = '1' else 
      '1' when (up = '0') and min_count = '1';
  next_count <= 
    unsigned(inp) when load = '1' else
    unsigned(count) + 1 when up = '1' else 
    unsigned(count) - 1 when up ='0';

  REGISTERS: process (clk) is
  begin
    -- Synchronous reset
    if rising_edge(clk) then
      count <= 
        (others => '0') when reset else 
        std_logic_vector(next_count);
    end if;
  end process;

  -- Concurrent signal assignment
  max_count <= 
    '1' when count = "1111" else 
    '0';
  min_count <=
    '1' when count = "0000" else
    '0';
end RTL;
