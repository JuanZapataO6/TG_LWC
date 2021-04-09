library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity MuxLogic is
    
    port( 
        In_DataForce    : in  std_logic;
        In_XorKey       : in  std_logic;
        In_XorKeyRotated: in  std_logic;
        In_SBox         : in  std_logic;
        In_MDS          : in  std_logic;
        In_SRSheet      : in  std_logic;
        In_SRSlice      : in  std_logic;
        In_SRSheetInv   : in  std_logic;
        In_SRSliceInv   : in  std_logic;
        Addr_Control    : in  std_logic_vector (3 downto 0);        
        Data_Out        : out std_logic
    );

end MuxLogic;
architecture RTL of MuxLogic is 
begin
	with Addr_Control select
		Data_Out <= In_DataForce     when "0000", 
	                In_XorKey        when "0001",
		            In_SBox          when "0010", 
		            In_MDS           when "0011", 
                    In_XorKeyRotated when "0100",		            
		            In_SRSheet       when "0101", 
		            In_SRSlice       when "0110", 
		            In_SRSheetInv    when "0111",
                    In_SRSheetInv    when  others ;
end architecture RTL;
