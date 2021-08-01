LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity DeMuxTest is 
end DeMuxTest;

architecture RTL of DeMuxTest is
component DeMux
    generic(    
            w:integer--width of word    
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
end component;
TYPE estado is (s0, s1,s2,s3,s4,s5,s6);
SIGNAL presente:estado:=s0;

signal Data_In :std_logic_vector(7 downto 0);
signal Address : std_logic_vector(1 downto 0);
signal Out_0,Out_1,Out_2,Out_3 :std_logic_vector(7 downto 0);
SIGNAL 	Clk : 	STD_LOGIC := '0';
begin
reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
end process reloj;
u1: DeMux 
generic map (
    w => 8
)
PORT MAP (
        Out_0    =>Out_0,
        Out_1    =>Out_1,
        Out_2    =>Out_2,
        Out_3    =>Out_3,
        Clk     =>clk,
        Address => Address,
        Data_In => Data_In
    );
STAt: process(Clk,presente)
BEGIN
    if clk'event and clk='1' then 
        case presente is
            when s0=>
                presente<=S1; 
                Data_In  <= (others =>'0');
                Address <= "00";
            when s1=>
                presente<=S2;
                Data_In  <= x"01";
                Address <= "00";
            when s2=>
                presente<=S3;
                Data_In  <= x"39";
                Address <= "01";
            when s3=>
                presente<=S4;
                Data_In  <= x"FF";
                Address <= "10";
            when s4=>
                presente<=S0;
                Data_In  <= x"EE";
                Address <= "11";            
            when others => null; 
        end case;         
    end if;
end process STAt;
end architecture RTL; 