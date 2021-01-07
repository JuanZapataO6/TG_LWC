library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity XOR_key is 
    port (
        state   : inout std_logic_vector (0 to 15);
        key     : inout std_logic_vector (0 to 15)
    );
end XOR_key;
architecture Main of XOR_key is 
    

end Main;