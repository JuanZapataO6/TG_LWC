library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
USE ieee.numeric_std.ALL;
use work.all;

entity Data_Force is
    port( 
        clk         :in  std_logic;
        En_In       :in  std_logic;
        --Ports for Data Generate
        Rd_En_K   :out std_logic;
        Rd_En_B   :out std_logic;
        Rd_En_N   :out std_logic;
        Addr_Rd_K :out std_logic_vector(4 downto 0);
        Addr_Rd_B :out std_logic_vector(3 downto 0);
        Addr_Rd_N :out std_logic_vector(3 downto 0);
        Data_Out_K :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_B :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_N :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        --Ports for MemBnk Write
        Data_rIn_xK :out std_logic_vector (15 DOWNTO 0);
        Data_rIn_xB :out std_logic_vector (15 DOWNTO 0);
        Addr_Wr_xB  :out std_logic_vector (3 DOWNTO 0);
        Addr_Wr_xK  :out std_logic_vector (3 DOWNTO 0);
        Wr_En_xK    :out std_logic;
        Wr_En_xB    :out std_logic;
        --Ports Of fininish 
        En_Out  :out std_logic
    );
end Data_Force;
architecture RTL of Data_Force is 
TYPE estado is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10);
SIGNAL presente:estado:=s0;
begin
STat: process(clk,presente)
variable Addr_Aux        :std_logic_vector (4 DOWNTO 0):="00000";
variable Addr_Rd_K_Aux :std_logic_vector (4 downto 0):="00000";
variable Establish :std_logic_vector (4 downto 0):="00000";
variable Data_rIn_xK_Aux  :std_logic_vector (15 DOWNTO 0):= x"7777";
variable Data_rIn_xB_Aux  :std_logic_vector (15 DOWNTO 0):= x"7777";
        
begin 
if clk 'event and clk = '1' then 
    if En_In ='1' then  
        case presente is
                when s0 =>
                    if Addr_Aux <= "10000" then
                        presente <= s1;
                        En_Out <='0';
                        Rd_En_K <='0';
                        Wr_En_xK <='1';
                        Wr_En_xB <='1';
                        Data_rIn_xB <= x"2929";
                        Addr_Rd_K <= Addr_Rd_K_Aux;
                        if Addr_Aux > x"7" then--0/0--2/1--4/2--6/3--8/4--A/5--C/6--E/7
                            Rd_En_B <= '0';------10/8--12/9--14/A--6/B--8/C--A/D--C/E--E/F
                            Addr_Rd_B <= Addr_Rd_K_Aux(3 downto 0);
                        else 
                            Rd_En_N <= '0';
                            Addr_Rd_N <= Addr_Rd_K_Aux(3 downto 0);
                        end if;
                    else
                        presente <= s8;
                    end if;
                when s1 =>
                    presente    <= s2;                    
                    Addr_Rd_K_Aux  := Addr_Rd_K_Aux+1;--1/0--3/1--5/2--7/3--9/4--B/5--D/6--F/7
                    if Addr_Aux > x"7" then------11/8--13/9--15/A--17/B--8/C--A/D--C/E--E/F
                        Rd_En_B <= '0';
                        Addr_Rd_B <= Addr_Rd_K_Aux(3 downto 0);
                    else 
                        Rd_En_N <= '0';
                        Addr_Rd_N <= Addr_Rd_K_Aux(3 downto 0);
                    end if;
                    Wr_En_xK  <= '1';
                    Wr_En_xB  <= '1';
                    Addr_Rd_K <= Addr_Rd_K_Aux;
                when s2 =>
                    presente    <= s3;
                    Rd_En_K   <= '1';
                    Rd_En_B   <= '1';
                    Rd_En_N   <= '1';
                when s3 =>
                    presente    <= s4;
                when s4 =>
                    presente    <= s5;
                    if Addr_Aux > x"7" then--1/0--3/1--5/2--7/3--9/4
                        Data_rIn_xB_Aux  :=Data_rIn_xB_Aux(15 downto 8) & Data_Out_B;--1
                        --Data_rIn_xB_Aux  := Data_rIn_xB_Aux(15 downto 8) & x"7" & Addr_Rd_K_Aux(3 downto 0);
                    else 
                        Data_rIn_xB_Aux  :=Data_rIn_xB_Aux(15 downto 8) & Data_Out_N;--1
                    end if;
                    Wr_En_xK  <= '1';
                    Wr_En_xB  <= '1';
                    Rd_En_K   <= '1';
                    Rd_En_B   <= '1';
                    Rd_En_N   <= '1'; 
                    Data_rIn_xK_Aux  := Data_rIn_xK_Aux(15 downto 8) & Data_Out_K;--0
                when s5 =>
                    presente    <= s6;
                    if Addr_Aux > x"7" then--1--3--5
                        Data_rIn_xB_Aux := Data_Out_B & Data_rIn_xB_Aux(7 downto 0);
                        --Data_rIn_xB_Aux := x"F"& Addr_Rd_K_Aux(3 downto 0) & Data_rIn_xB_Aux(7 downto 0);
                    else 
                        Data_rIn_xB_Aux := Data_Out_N & Data_rIn_xB_Aux(7 downto 0); --10
                    end if;
                    Data_rIn_xK_Aux := Data_Out_K & Data_rIn_xK_Aux(7 downto 0);  
                    Data_rIn_xK <= Data_rIn_xK_Aux;  
                    Data_rIn_xB <= Data_rIn_xB_Aux;--x"DDDD";--
                    Addr_Wr_xB <=Addr_Aux(Addr_Aux'length-2 downto 0);--x"1"; -- 
                    Addr_Wr_xK <= Addr_Aux(Addr_Aux'length-2 downto 0);
                    Rd_En_K <= '1';
                    Rd_En_B <= '1';
                    Rd_En_N <= '1';
                    Wr_En_xK <= '0';
                    Wr_En_xB <= '0';
                when s6 => 
                    presente <= s7;
                when s7 =>
                    presente    <= s0;
                    Wr_En_xK  <= '1';
                    Wr_En_xB  <= '1';
                    Rd_En_K   <= '1';
                    Rd_En_B   <= '1';
                    Rd_En_N   <= '1'; 
                    Addr_Aux:=Addr_Aux+1;
                    Addr_Rd_K_Aux  := Addr_Rd_K_Aux+1;--3
                when s8 => 
                    En_Out <= '1';
                    presente <= s8;
                when others => null;
            end case;
        
       
    end if;
end if;
end process STat;
end RTL;