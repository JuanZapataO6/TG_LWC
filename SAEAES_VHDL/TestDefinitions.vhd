library IEEE; 
use IEEE.std_logic_1164.all; 
use work.Definitions.all; -- Para poder utilizar el paquete 

entity TestDefinitions is     
    port (
        Vector_In : in std_logic_vector(31 downto 0); 
        vector_ekey : out std_logic_vector(31 downto 0)
    ); 
end TestDefinitions;  
architecture rtl of TestDefinitions is 

begin 
p1: process(Vector_In)  
    variable eKey : std_logic_vector(31 downto 0);
    begin 
    RotSub(Vector_In,eKey);  
    vector_ekey<= eKey;
end process p1; 
end rtl;