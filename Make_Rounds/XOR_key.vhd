library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity XOR_key is 
    port (
        state   : inout std_logic_vector (0 to 15);
        i       : out std_logic_vector(3 downto 0);
        key     : inout std_logic_vector (0 to 15)
    );
end XOR_key;
architecture Main of XOR_key is 
signal i : std_logic_vector(3 downto 0);
type estado is (s0, s1,s2,s3);
signal presente:estado:=s0;
begin
    process --(Clk)
    begin
    --if (CLK'event AND CLK = '1') then 
    --  case presente 
    --      when s0 =>
    --                presente <=s1;
    for j in 0 to 15 loop
        i<=j;
        state <= state xor key;
    end loop;

end Main;