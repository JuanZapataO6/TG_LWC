LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity MuxTest is 
end MuxTest;

architecture RTL of MuxTest is
component Mux
    generic(    
            w:integer--width of word    
        );
    port(
        In_0    : in  std_logic_vector (w-1 downto 0);
        In_1    : in  std_logic_vector (w-1 downto 0);
        In_2    : in  std_logic_vector (w-1 downto 0);
        In_3    : in  std_logic_vector (w-1 downto 0);
        Address : in  std_logic_vector (1 downto 0);
        Data_Out    : out std_logic_vector (w-1 downto 0)
    );
end component;
TYPE estado is (s0, s1,s2,s3,s4,s5,s6);
SIGNAL presente:estado:=s0;

signal In_0,In_1,In_2,In_3 :std_logic_vector(7 downto 0);
signal Address : std_logic_vector(1 downto 0);
signal Out_0 :std_logic_vector(7 downto 0);
SIGNAL 	Clk : 	STD_LOGIC := '0';
begin
reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
end process reloj;
u1: Mux 
generic map (
    w=> 8
)
PORT MAP (
        In_0    =>In_0,
        In_1    =>In_1,
        In_2    =>In_2,
        In_3    =>In_3,
        Address => Address,
        Data_Out => Out_0
    );
STAt: process(Clk,presente)
BEGIN
    if clk'event and clk='1' then 
        case presente is
            when s0=>
                presente<=S1; 
                In_0  <= (others =>'0');
                Address <= "00";
            when s1=>
                presente<=S2;
                In_1  <= x"01";
                Address <= "00";
            when s2=>
                presente<=S3;
                In_2  <= x"39";
                Address <= "01";
            when s3=>
                presente<=S4;
                In_3  <= x"FF";
                Address <= "10";
            when s4=>
                presente<=S0;
                In_3  <= x"EE";
                Address <= "11";            
            when others => null; 
        end case;         
    end if;
end process STAt;
end architecture RTL; 