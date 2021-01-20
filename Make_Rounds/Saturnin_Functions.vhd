library IEEE; 
use IEEE.std_logic_1164.all; 

package Saturnin_Functions is
    procedure XOR_Key(signal state, key  :  in std_logic_vector(15 downto 0);
                    signal state_Out : out std_logic_vector(15 downto 0));
end Saturnin_Functions;

package body Saturnin_Functions is
procedure XOR_Key(signal state, key  :  in std_logic_vector(15 downto 0);
                    signal state_Out : out std_logic_vector(15 downto 0)) is
begin 
    state_Out <= state XOR key;
end procedure XOR_Key;

end Saturnin_Functions;