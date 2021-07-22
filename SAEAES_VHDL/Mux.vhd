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
        In_01   : in  std_logic_vector (w-1 downto 0);
        In_02   : in  std_logic_vector (w-1 downto 0);
        In_03   : in  std_logic_vector (w-1 downto 0);
        In_04   : in  std_logic_vector (w-1 downto 0);
        In_05   : in  std_logic_vector (w-1 downto 0);
        In_06   : in  std_logic_vector (w-1 downto 0);
        In_07   : in  std_logic_vector (w-1 downto 0);
        In_08   : in  std_logic_vector (w-1 downto 0);
        In_09   : in  std_logic_vector (w-1 downto 0);
        In_0A   : in  std_logic_vector (w-1 downto 0);
        Addr_Control    : in  std_logic_vector (3 downto 0);        
        Data_Out        : out std_logic_vector (w-1 downto 0)
    );

end Mux;
architecture RTL of Mux is 
begin
	with Addr_Control select
		Data_Out <= In_01     when "0000", 
	                In_02        when "0001",
		            In_04    when "0010", 
		            In_05    when "0011", 
		            In_06    when "0100", 
		            In_07In  when "0101", 
		            In_08when "0110", 
		            In_09    when "0111",
                    In_0A    when "1000",
                    In_SRSheetInv    when "1001",
                    In_SRSheetInv    when  others ;
end architecture RTL;
