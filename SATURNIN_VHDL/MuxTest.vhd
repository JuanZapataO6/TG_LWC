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
end component;
TYPE estado is (s0, s1,s2,s3,s4,s5,s6);
SIGNAL presente:estado:=s0;

signal In_0,In_1,In_2,In_3,In_4 :std_logic_vector(7 downto 0);
signal In_5,In_6,In_7,In_8,In_9,In_A :std_logic_vector(7 downto 0);
signal Address : std_logic_vector(3 downto 0);
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
        In_0=>In_0,
        In_1=>In_1,
        In_2=>In_2,
        In_3=>In_3,
        In_4=>In_4,
        In_5=>In_5,
        In_6=>In_6,
        In_7=>In_7,
        In_8=>In_8,
        In_9=>In_9,
        In_A=>In_A,
        Sel => Address,
        Data_Out => Out_0
    );
STAt: process(Clk,presente)
BEGIN
    if clk'event and clk='1' then 
        case presente is
            when s0=>
                presente<=S1; 
                In_0  <= (others =>'0');
                In_1  <= x"01";
                In_2  <= x"02";
                In_3  <= X"03";
                In_4  <= x"04";
                In_5  <= x"05";
                In_6  <= x"06";
                In_7  <= x"07";
                In_8  <= X"08";
                In_9  <= x"09";
                In_A  <= x"0A";
                Address <= "0000";
            when s1=>
                presente<=S2;
                In_1  <= x"01";
                Address <= "0001";
            when s2=>
                presente<=S3;
                In_2  <= x"39";
                Address <= "0010";
            when s3=>
                presente<=S4;
                In_3  <= x"FF";
                Address <= "0011";
            when s4=>
                presente<=S0;
                In_3  <= x"EE";
                Address <= "0100";            
            when others => null; 
        end case;         
    end if;
end process STAt;
end architecture RTL; 