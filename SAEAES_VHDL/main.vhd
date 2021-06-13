LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use work.Saturnin_Functions.all;

entity Saturnin_Block_Encrypt is 
CONSTANT M0 is array (255 downto 0, 31 downto 0) of std_logic;
CONSTANT M1 is array (255 downto 0, 31 downto 0) of std_logic;
CONSTANT M2 is array (255 downto 0, 31 downto 0) of std_logic;
CONSTANT M3 is array (255 downto 0, 31 downto 0) of std_logic;

end Saturnin_Block_Encrypt;

architecture Main of Saturnin_Block_EncryptV2 is 
component
end Main;
