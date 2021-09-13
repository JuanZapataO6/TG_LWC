library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity XOR_key is 
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (15 downto 0);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Addr_Rd_K   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Rd_En_K     : out std_logic;
        Data_Out_B  : in std_logic_vector (15 downto 0);
        Data_Out_K  : in std_logic_vector (15 downto 0);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end XOR_key;
architecture Main of XOR_key is 
signal i : std_logic_vector(3 downto 0);
type estado is (s0, s1,s2,s2_0,s2_1,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
signal presente:estado:=s0;
begin
STat: process (Clk)
variable Addr_Aux :std_logic_vector (4 DOWNTO 0):="00000";
variable Establish :std_logic_vector (5 downto 0):="000000";
begin
if (CLK'event AND CLK = '0') then 
    if En_In = '1' then  
            case presente is 
                when s0 =>-- STAR 
                    presente  <= s1;
                    Addr_Rd_B <= x"0";
                    Addr_Rd_K <= x"0";
                    Addr_Wr_B <= x"1";
                    Addr_Aux  := "00000";
                    En_Out <= '0';
                    Rd_En_B   <= '1';
                    Rd_En_K   <= '1';
                    Wr_En_B   <= '1';
                when s1 => 
                    presente <= s2;
                    Addr_Rd_B <= Addr_Aux(3 downto 0);--0
                    Addr_Rd_K <= x"0";--Addr_Aux(3 downto 0);
                    Rd_En_B   <= '0';
                    Rd_En_K   <= '0';
                    Wr_En_B   <= '1';
                when s2 =>
                    presente <= s3;
                    Addr_Aux   := Addr_Aux+1;--1
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_K  <= Addr_Aux(3 downto 0);                  
                    Rd_En_B    <= '0';
                    Rd_En_K    <= '0';
                    Wr_En_B    <= '1';
                when s3 =>
                    presente <= s4;
                    Addr_Aux   := Addr_Aux+1;--2
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_K  <= Addr_Aux(3 downto 0); 
                    Rd_En_B    <= '0';
                    Rd_En_K    <= '0';
                    Wr_En_B    <= '1';
                when s4 =>
                    presente <= s5;
                    Addr_Aux   := Addr_Aux+1;--3
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_K  <= Addr_Aux(3 downto 0);
                    Rd_En_B    <= '0';
                    Rd_En_K    <= '0';
                    Wr_En_B    <= '1';
                when s5 =>
                    presente <= s6;
                    Addr_Wr_B  <= Addr_Aux(3 downto 0)-3;
                    Data_RIn_B <= Data_Out_B XOR Data_Out_K;
                    Rd_En_B    <= '1';
                    Rd_En_K    <= '1';
                    Wr_En_B    <= '0';
                when s6 =>
                    Addr_Aux   := Addr_Aux+1;--4--15
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_K  <= Addr_Aux(3 downto 0);  
                    Addr_Wr_B  <= Addr_Aux(3 downto 0)-3;
                    Data_RIn_B <= Data_Out_B XOR Data_Out_K;
                    Rd_En_B    <= '0';
                    Rd_En_K    <= '0';
                    Wr_En_B    <= '0';
                    if Addr_Aux >= "01111" then--16
                        presente <= s7;
                    else
                        presente <= s6;
                    end if;
                when s7 =>
                    presente <= s8;
                    Addr_Wr_B  <= Addr_Aux(3 downto 0)-2;
                    Data_RIn_B <= Data_Out_B XOR Data_Out_K;
                    Rd_En_B    <= '1';
                    Rd_En_K    <= '1';
                    Wr_En_B    <= '0';
                when s8 =>
                    presente <= s9;
                    Addr_Wr_B  <= Addr_Aux(3 downto 0)-1;--1--5--9
                    Data_RIn_B <= Data_Out_B XOR Data_Out_K;
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_K  <= Addr_Aux(3 downto 0);                 
                    Rd_En_B    <= '1';
                    Rd_En_K    <= '1';
                    Wr_En_B    <= '0';
                when s9 =>
                    presente <= s10;
                    Data_RIn_B <= Data_Out_K;--x"111" & Addr_Aux(3 downto 0);--
                    Addr_Wr_B  <= Addr_Aux(3 downto 0);--1--5--9
                    Data_RIn_B <= Data_Out_B XOR Data_Out_K;
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_K  <= Addr_Aux(3 downto 0);                 
                    Rd_En_B    <= '1';
                    Rd_En_K    <= '1';
                    Wr_En_B    <= '0';
                when s10 =>
                    presente <= s11;
                    Addr_Wr_B  <= Addr_Aux(3 downto 0);--1--5--9
                    En_Out <= '1';
                    Addr_Aux   := "00000";
                    Addr_Rd_B  <= "0000";
                    Addr_Rd_K  <= "0000";
                    Rd_En_B    <= '1';
                    Rd_En_K    <= '1';
                    Wr_En_B    <= '1';
                when s11 =>
                    presente <= s0;
                    En_Out <= '0';
                    Addr_Aux   := "00000";
                    Addr_Rd_B  <= "0000";
                    Addr_Rd_K  <= "0000";
                    Addr_Wr_B  <= "0000";
                    Rd_En_B    <= '1';
                    Rd_En_K    <= '1';
                    Wr_En_B    <= '1';
                when others => null;
            end case;
        end if;
    end if;
end process STat;
end Main;