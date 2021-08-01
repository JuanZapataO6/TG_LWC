LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 

entity DeMux is
    generic(    
        w:integer --width of word
    );
    port( 
        Out_0   : Out std_logic_vector (w-1 downto 0);
        Out_1   : Out std_logic_vector (w-1 downto 0);
        Out_2   : Out std_logic_vector (w-1 downto 0);
        Out_3   : Out std_logic_vector (w-1 downto 0);
        clk     : in  std_logic;
        Address : in  std_logic_vector (1 downto 0);
        Data_In : in  std_logic_vector (w-1 downto 0)
    );
end DeMux;
architecture RTL of DeMux is 
begin
process (Address,clk)
begin
    if clk 'event and clk = '1' then 
        case Address is
            when "00" => Out_0 <=Data_In; 
            when "01" => Out_1 <=Data_In;
            when "10" => Out_2 <=Data_In; 
            when "11" => Out_3 <=Data_In;
        when others => null;
        end case;
    end if;
end process;
end architecture RTL;
