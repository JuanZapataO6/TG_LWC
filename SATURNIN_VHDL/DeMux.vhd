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
        Out_0 : Out std_logic_vector (w-1 downto 0);
        Out_1 : Out std_logic_vector (w-1 downto 0);
        Out_2 : Out std_logic_vector (w-1 downto 0);
        Out_3 : Out std_logic_vector (w-1 downto 0);
        Out_4 : Out std_logic_vector (w-1 downto 0);
        Out_5 : Out std_logic_vector (w-1 downto 0);
        Out_6 : Out std_logic_vector (w-1 downto 0);
        Out_7 : Out std_logic_vector (w-1 downto 0);
        Out_8 : Out std_logic_vector (w-1 downto 0);
        Out_9 : Out std_logic_vector (w-1 downto 0);
        Out_A : Out std_logic_vector (w-1 downto 0);
        DIn   : in  std_logic_vector (w-1 downto 0);
        Sel   : in  std_logic_vector (3 downto 0));
end DeMux;
architecture RTL of DeMux is 
begin
process (Sel,DIn)
begin
    case Sel is
        when "0000" => 
            Out_0 <= DIn;
            Out_1 <= (others=>'1');
            Out_2 <= (others=>'1');
            Out_3 <= (others=>'1');
            Out_4 <= (others=>'1');
            Out_5 <= (others=>'1');
            Out_6 <= (others=>'1');
            Out_7 <= (others=>'1');
            Out_8 <= (others=>'1');
            Out_9 <= (others=>'1');
            Out_A <= (others=>'1');
        when "0001" => 
            Out_0 <= (others=>'1');
            Out_1 <= DIn;
            Out_2 <= (others=>'1');
            Out_3 <= (others=>'1');
            Out_4 <= (others=>'1');
            Out_5 <= (others=>'1');
            Out_6 <= (others=>'1');
            Out_7 <= (others=>'1');
            Out_8 <= (others=>'1');
            Out_9 <= (others=>'1');
            Out_A <= (others=>'1');
        when "0010" => 
            Out_0 <= (others=>'1');
            Out_1 <= (others=>'1');
            Out_2 <= DIn;
            Out_3 <= (others=>'1');
            Out_4 <= (others=>'1');
            Out_5 <= (others=>'1');
            Out_6 <= (others=>'1');
            Out_7 <= (others=>'1');
            Out_8 <= (others=>'1');
            Out_9 <= (others=>'1');
            Out_A <= (others=>'1');
        when "0011" => 
            Out_0 <= (others=>'1');
            Out_1 <= (others=>'1');
            Out_2 <= (others=>'1');
            Out_3 <= DIn;
            Out_4 <= (others=>'1');
            Out_5 <= (others=>'1');
            Out_6 <= (others=>'1');
            Out_7 <= (others=>'1');
            Out_8 <= (others=>'1');
            Out_9 <= (others=>'1');
            Out_A <= (others=>'1');
        when "0100" => 
            Out_0 <= (others=>'1');
            Out_1 <= (others=>'1');
            Out_2 <= (others=>'1');
            Out_3 <= (others=>'1');
            Out_4 <= DIn;
            Out_5 <= (others=>'1');
            Out_6 <= (others=>'1');
            Out_7 <= (others=>'1');
            Out_8 <= (others=>'1');
            Out_9 <= (others=>'1');
            Out_A <= (others=>'1');
        when "0101" => 
            Out_0 <= (others=>'1');
            Out_1 <= (others=>'1');
            Out_2 <= (others=>'1');
            Out_3 <= (others=>'1');
            Out_4 <= (others=>'1');
            Out_5 <= DIn;
            Out_6 <= (others=>'1');
            Out_7 <= (others=>'1');
            Out_8 <= (others=>'1');
            Out_9 <= (others=>'1');
            Out_A <= (others=>'1');
        when "0110" => 
            Out_0 <= (others=>'1');
            Out_1 <= (others=>'1');
            Out_2 <= (others=>'1');
            Out_3 <= (others=>'1');
            Out_4 <= (others=>'1');
            Out_5 <= (others=>'1');
            Out_6 <= (others=>'1');
            Out_7 <= DIn;
            Out_8 <= (others=>'1');
            Out_9 <= (others=>'1');
            Out_A <= (others=>'1');
        when "0111" => 
            Out_0 <= (others=>'1');
            Out_1 <= (others=>'1');
            Out_2 <= (others=>'1');
            Out_3 <= (others=>'1');
            Out_4 <= (others=>'1');
            Out_5 <= (others=>'1');
            Out_6 <= (others=>'1');
            Out_7 <= DIn;
            Out_8 <= (others=>'1');
            Out_9 <= (others=>'1');
            Out_A <= (others=>'1');
        when "1000" => 
            Out_0 <= (others=>'1');
            Out_1 <= (others=>'1');
            Out_2 <= (others=>'1');
            Out_3 <= (others=>'1');
            Out_4 <= (others=>'1');
            Out_5 <= (others=>'1');
            Out_6 <= (others=>'1');
            Out_7 <= (others=>'1');
            Out_8 <= DIn;
            Out_9 <= (others=>'1');
            Out_A <= (others=>'1');
        when "1001" =>
            Out_0 <= (others=>'1');
            Out_1 <= (others=>'1');
            Out_2 <= (others=>'1');
            Out_3 <= (others=>'1');
            Out_4 <= (others=>'1');
            Out_5 <= (others=>'1');
            Out_6 <= (others=>'1');
            Out_7 <= (others=>'1');
            Out_8 <= (others=>'1');
            Out_9 <= DIn;
            Out_A <= (others=>'1');
        when others => 
            Out_0 <= (others=>'1');
            Out_1 <= (others=>'1');
            Out_2 <= (others=>'1');
            Out_3 <= (others=>'1');
            Out_4 <= (others=>'1');
            Out_5 <= (others=>'1');
            Out_6 <= (others=>'1');
            Out_7 <= (others=>'1');
            Out_8 <= (others=>'1');
            Out_9 <= (others=>'1');
            Out_A <= DIn;
    end case;
end process;
end architecture RTL;
