library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity Register_Logic is
    
    port (
        DD_IN  : in  std_logic;
        DD_OUT : out std_logic;
        Clk    : in  std_logic

    );
end entity Register_Logic;
architecture rtl of Register_Logic is 
begin 
    process (clk)
    begin
        if (CLK'event AND CLK = '1') then  
            DD_OUT<=DD_IN;
        end if;
    end process;
end architecture rtl;