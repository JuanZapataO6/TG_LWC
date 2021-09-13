library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity Register_A is
    generic(
        w:integer--width of word
    );
    port (
        DD_IN  : in  std_logic_vector (w-1 downto 0);
        DD_OUT : out std_logic_vector (w-1 downto 0);
        Clk    : in  std_logic

    );
end entity Register_A;
architecture rtl of Register_A is 
begin 
    process (clk)
    begin
        if (CLK'event AND CLK = '1') then  
            DD_OUT<=DD_IN;
        end if;
    end process;
end architecture rtl;