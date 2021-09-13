library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity Mux is
    generic(    
            w:integer--width of word    
        );
    port(
        In_0 : in  std_logic_vector (w-1 downto 0);
        In_1 : in  std_logic_vector (w-1 downto 0);
        In_2 : in  std_logic_vector (w-1 downto 0);
        In_3 : in  std_logic_vector (w-1 downto 0);
        In_4 : in  std_logic_vector (w-1 downto 0);
        In_5 : in  std_logic_vector (w-1 downto 0);
        In_6 : in  std_logic_vector (w-1 downto 0);
        In_7 : in  std_logic_vector (w-1 downto 0);
        In_8 : in  std_logic_vector (w-1 downto 0);
        In_9 : in  std_logic_vector (w-1 downto 0);
        In_A : in  std_logic_vector (w-1 downto 0);
        Sel  : in  std_logic_vector (3 downto 0);
        DOut : out std_logic_vector (w-1 downto 0));  

end Mux ;
architecture RTL of Mux is 
begin
	with Sel select
		DOut <=  In_0 when "0000",
	        In_1 when "0001",
            In_2 when "0010",
		    In_3 when "0011",
            In_4 when "0100",
		    In_5 when "0101",
		    In_6 when "0110",
		    In_7 when "0111",
            In_8 when "1000",
            In_9 when "1001",
            In_A when others;
end architecture RTL;