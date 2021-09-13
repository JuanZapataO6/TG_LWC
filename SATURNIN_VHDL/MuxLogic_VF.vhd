library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity MuxLogic_VF is
    port( 
        In_0 : in  std_logic;
        In_1 : in  std_logic;
        In_2 : in  std_logic;
        In_3 : in  std_logic;
        --In_4 : in  std_logic;
        --In_5 : in  std_logic;
        --In_6 : in  std_logic;
        --In_7 : in  std_logic;
        --In_8 : in  std_logic;
        --In_9 : in  std_logic;
        --In_A : in  std_logic;
        Sel  : in  std_logic_vector (1 downto 0);        
        DOut : out std_logic);
end MuxLogic_VF;
architecture RTL of MuxLogic_VF is 
begin
	with Sel select
	    Dout <=	In_0 when "00",
	            In_1 when "01",
		        In_2 when "10",
                In_2 when "11",
		        In_3 when others; --"0011",
	        --In_4 when "0100",
		    --In_5 when "0101",
		    --In_6 when "0110",
		    --In_7 when "0111",
            --In_8 when "1000",
            --In_9 when "1001",
            --In_A when others;
end architecture RTL;
