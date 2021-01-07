library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;
entity MDS is 
    port (
        state : inout std_logic_vector (0 to 255 
    );
end MDS;


architecture Main of MDS is 
--
    signal x0: std_logic_vector (15 downto 0);
    signal x1: std_logic_vector (15 downto 0);
    signal x2: std_logic_vector (15 downto 0);
    signal x3: std_logic_vector (15 downto 0);
    signal x4: std_logic_vector (15 downto 0);
    signal x5: std_logic_vector (15 downto 0);
    signal x6: std_logic_vector (15 downto 0);
    signal x7: std_logic_vector (15 downto 0);
    --
    signal x8: std_logic_vector (15 downto 0);
    signal x9: std_logic_vector (15 downto 0);
    signal xa: std_logic_vector (15 downto 0);
    signal xb: std_logic_vector (15 downto 0);
    signal xc: std_logic_vector (15 downto 0);
    signal xd: std_logic_vector (15 downto 0);
    signal xe: std_logic_vector (15 downto 0);
    signal xf: std_logic_vector (15 downto 0);
    type estado is (s0, s1,s2,s3);
    signal presente:estado:=s0;
    begin
    process (x0,x1,x2,x3,x4,x5,x6,x7,
                x8,x9,xa,xb,xc,xd,xe,xf
                    CLK,presente)
    begin
    if (CLK'event AND CLK = '1') then 
        case presente is
            when s0 =>
                presente <= s1;
                x0 <= state(15 downto 0);
                x1 <= state(31 downto 16);
                x2 <= state(49 downto 32);
                x3 <= state(63 downto 48);
                x4 <= state(79 downto 64);
                x5 <= state(95 downto 80);
                x6 <= state(111 downto 96);
                x7 <= state(127 downto 112);
                --
                x8 <= state(143 downto 128);
                x9 <= state(159 downto 144);
                xa <= state(176 downto 160);
                xb <= state(191 downto 176);
                xc <= state(207 downto 192);
                xd <= state(223 downto 208);
                xe <= state(239 downto 224);
                xf <= state(255 downto 240);
            when s1 =>
                presente <=s2;
                x8<= (x8 xor xc);
                x9<= (x9 xor xd);
                xa<= (xa xor xe);
                xb<= (xb xor xf);
                x0<= (x0 xor x4);
                x1<= (x1 xor x5);
                x2<= (x2 xor x6);
                x3<= (x3 xor x7);
            when s2 => -- existe un desplazamiento 
                presente <= s3


    end if;   


end architecture;
