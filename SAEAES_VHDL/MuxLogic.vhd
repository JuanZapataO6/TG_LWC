library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity MuxLogic is
    port(
        In_0   : in  std_logic;
        In_1   : in  std_logic;
        In_2   : in  std_logic;
        In_3   : in  std_logic;
        Address    : in  std_logic_vector (1 downto 0);
        Data_Out        : out std_logic
    );
end MuxLogic;
architecture RTL of MuxLogic is 
begin
	with Address select
		Data_Out <= In_0    when "00",
	                In_1    when "01",
                    In_2    when "10",
		            In_3    when "11",
                    In_3    when others;
end architecture RTL;
