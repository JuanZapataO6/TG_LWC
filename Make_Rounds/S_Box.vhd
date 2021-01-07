library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;
--
entity S_Box is
    port(
        --Verificar entradas tipo arreglo 
        state_0 : inout std_logic_vector(15 downto 0);
        state_1 : inout std_logic_vector(15 downto 0);
        state_2 : inout std_logic_vector(15 downto 0);
        state_3 : inout std_logic_vector(15 downto 0);
        state_4 : inout std_logic_vector(15 downto 0);
        state_5 : inout std_logic_vector(15 downto 0);
        state_6 : inout std_logic_vector(15 downto 0);
        state_7 : inout std_logic_vector(15 downto 0);
        state_8 : inout std_logic_vector(15 downto 0);
        state_9 : inout std_logic_vector(15 downto 0);
        state_10: inout std_logic_vector(15 downto 0);
        state_11: inout std_logic_vector(15 downto 0);
        state_12: inout std_logic_vector(15 downto 0);
        state_13: inout std_logic_vector(15 downto 0);
        state_14: inout std_logic_vector(15 downto 0);
        state_15: inout std_logic_vector(15 downto 0);
        load    : in std_logic;
        clk     : in std_logic
    );
end S_Box;
architecture Main of S_Box is 
    signal a0   : std_logic_vector(15 downto 0);
    signal a1   : std_logic_vector(15 downto 0);
    signal b0   : std_logic_vector(15 downto 0);
    signal b1   : std_logic_vector(15 downto 0);
    signal c0   : std_logic_vector(15 downto 0);
    signal c1   : std_logic_vector(15 downto 0);
    signal d0   : std_logic_vector(15 downto 0);
    signal d1   : std_logic_vector(15 downto 0);
    type estado is (s0,s1,s2,s3,s4,s5,s6,s7,s8);
    signal presente:estado:=s0;
    
    begin
    ASM: process (a0,b0,c0,d0,
            a1,b1,c1,d1,
            clk,presente)
    begin
        if (CLK'event AND CLK = '1') then
            case presente is 
                when s0=>
                    presente <= s1;
                    if load = '1' then-------n=--0--8
                        a0 <= state_0;-- [n] n+0=0--8 
                        b0 <= state_1;-- [n] n+1=1--9
                        c0 <= state_2;-- [n] n+2=2--10
                        d0 <= state_3;-- [n] n+3=3--11
                        a1 <= state_4;-- [n] n+4=4--12
                        b1 <= state_5;-- [n] n+5=5--13
                        c1 <= state_6;-- [n] n+6=6--14
                        d1 <= state_7;-- [n] n+7=7--15
                    else 
                        presente <= s8;
                    end if;
                when s1=>
                    presente <= s2;
                    a0 <= a0 xor (b0 AND c0);
                    a1 <= a1 xor (b1 AND c1);
                when s2=>
                    presente <= s3;
                    b0 <= b0 xor (a0 or d0);
                    b1 <= b1 xor (a1 or d1);
                when s3=>
                    presente <= s4;
                    d0 <= d0 xor (b0 or c0);
                    d1 <= d1 xor (b1 or c1);
                when s4=>
                    presente <= s5;
                    c0 <= c0 xor (b0 and d0);
                    c1 <= c1 xor (b1 and d1);
                when s5=>
                    presente <= s6;
                    b0 <= b0 xor (a0 or c0);
                    b1 <= b1 xor (a1 or c1);
                when s6=>
                    presente <= s7;
                    a0 <= a0 xor (b0 or d0);
                    a1 <= a1 xor (b1 or d1);
                when s7=>
                    presente <=s0;
                    state_0  <=b0;
                    state_1  <=c0;
                    state_2  <=d0;
                    state_3  <=a0;                    
                    state_4  <=d1;
                    state_5  <=b1;
                    state_6  <=a1;
                    state_7  <=c1;
                    
                when others => null;
            end case;
        end if;
    end process ASM;
end Main;