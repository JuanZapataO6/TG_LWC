library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity DeMux is
    generic(    
            w:integer--width of word    
        );
    port( 
        Out_DataForce    : Out std_logic_vector (w-1 downto 0);
        Out_XorKey       : Out std_logic_vector (w-1 downto 0);
        Out_XorKeyRotated: Out std_logic_vector (w-1 downto 0);
        Out_SBox         : Out std_logic_vector (w-1 downto 0);
        Out_MDS          : Out std_logic_vector (w-1 downto 0);
        Out_SRSheet      : Out std_logic_vector (w-1 downto 0);
        Out_SRSlice      : Out std_logic_vector (w-1 downto 0);
        Out_SRSheetInv   : Out std_logic_vector (w-1 downto 0);
        Out_SRSliceInv   : Out std_logic_vector (w-1 downto 0);
        clk              : in  std_logic;
        Addr_Control     : in  std_logic_vector (3 downto 0);        
        Data_In          : in  std_logic_vector (w-1 downto 0)
    );

end DeMux;
architecture RTL of DeMux is 
begin
process (Addr_Control,clk)
begin
    if clk 'event and clk = '1' then 
        case Addr_Control is
            when "0000" => Out_DataForce <=Data_In; 
            when "0001" => Out_XorKey <=Data_In;
            when "0010" => Out_SBox <=Data_In; 
            when "0011" => Out_MDS <=Data_In; 
            when "0100" => Out_SRSlice <=Data_In; 
            when "0101" => Out_SRSheet <=Data_In; 
            when "0110" => Out_XorKeyRotated <=Data_In; 
            when "0111" => Out_SRSheetInv <=Data_In;
            when "1000" => Out_SRSliceInv <=Data_In;
            when others => Out_XorKey <=Data_In;
        end case;
    end if;
end process;
end architecture RTL;
