library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL; 
library work;
use work.Ope_Aritmeticas.all; --Para poder utilizar el paquete

entity sum is 
    port(v1,v2: in std_logic_vector (1 downto 0);
        v_result : out std_logic_vector(1 downto 0));
end sum;
architecture beh of sum is
begin
    p1: process(v1, v2)
    variable suma: std_logic_vector(1 downto 0);
    begin 
        vector_add (v1,v2,suma);
        v_result <= suma;
    end process p1;
end beh;