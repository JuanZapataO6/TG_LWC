library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;
--
entity S_Box is
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B  : out std_logic_vector(3 downto 0);
        Data_RIn_B : out std_logic_vector (15 downto 0);
        Wr_En_B    : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B  : out std_logic_vector(3 downto 0);
        Rd_En_B    : out std_logic;
        Data_Out_B : in std_logic_vector (15 downto 0);
        --Ports For Control Component 
        clk   : in std_logic; 
        En_In : in std_logic;
        En_Out : out std_logic
    );
end S_Box;
architecture Main of S_Box is 

type estado is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
signal presente:estado:=s0;
signal Establish:std_logic_vector (4 DOWNTO 0):="00000";

begin
ASM: process (clk)
variable Addr_Aux :std_logic_vector (4 DOWNTO 0):="00000";
variable Flag_Aux :std_logic:='0';
variable A0 : std_logic_vector (15 downto 0);
variable B0 : std_logic_vector (15 downto 0);
variable C0 : std_logic_vector (15 downto 0);
variable D0 : std_logic_vector (15 downto 0);
variable A1 : std_logic_vector (15 downto 0);
variable B1 : std_logic_vector (15 downto 0);
variable C1 : std_logic_vector (15 downto 0);
variable D1 : std_logic_vector (15 downto 0);
begin
if (CLK'event AND CLK = '1') then 
    if En_In = '1' then  
            case presente is 
                when s0 =>
                    presente  <= s1;
                    Addr_Rd_B <= x"0";
                    Addr_Wr_B <= x"F";
                    Addr_Aux  := "00000";
                    Data_RIn_B <= x"8787";
                    En_Out <= '0';
                    Rd_En_B   <= '1';
                    Wr_En_B   <= '1';
                when s1=>
                    presente <= s2;
                    Addr_Rd_B <=Addr_Aux(3 downto 0);
                    Addr_Wr_B <=Addr_Aux(3 downto 0);
                    Wr_En_B   <='1';
                    Rd_En_B   <='0';
                    En_Out    <='0';
                when s2=>
                    presente <= s3;
                    Addr_Aux  := Addr_Aux+1;--1
                    Addr_Rd_B <=Addr_Aux(3 downto 0);
                    Addr_Wr_B <=Addr_Aux(3 downto 0);
                    Wr_En_B   <='1';
                    Rd_En_B   <='0';
                    En_Out    <='0';
                when s3=>
                    presente <= s4;
                    Addr_Aux  := Addr_Aux+1;--2
                    Addr_Rd_B <=Addr_Aux(3 downto 0);
                    Addr_Wr_B <=Addr_Aux(3 downto 0);
                    Wr_En_B   <='1';
                    Rd_En_B   <='0';
                    En_Out    <='0';
                when s4=>
                    presente <= s6;
                    Addr_Aux  := Addr_Aux+1;--3
                    Addr_Rd_B <=Addr_Aux(3 downto 0);
                    Addr_Wr_B <=Addr_Aux(3 downto 0);
                    Wr_En_B   <='1';
                    Rd_En_B   <='0';
                    En_Out    <='0';
                when s5=>
                    presente <= s6;
                    Addr_Aux  := Addr_Aux+1;--4
                    Addr_Rd_B <= Addr_Aux(3 downto 0);
                    Addr_Wr_B <=Addr_Aux(3 downto 0);
                    Wr_En_B   <='1';
                    Rd_En_B   <='0';
                    En_Out    <='0';
                when s6=>
                    if Establish <= "00111" then 
                        case Establish is
                            when "00000" => A0 :=Data_Out_B;--x"FFFF";--
                            when "00001" => B0 :=Data_Out_B;--x"EEEE";--
                            when "00010" => C0 :=Data_Out_B;--x"DDDD";--
                            when "00011" => D0 :=Data_Out_B;--x"CCCC";-- 
                            when "00100" => A1 :=Data_Out_B;--x"BBBB";--
                            when "00101" => B1 :=Data_Out_B;--x"AAAA";--
                            when "00110" => C1 :=Data_Out_B;--x"6666";--
                            when "00111" => D1 :=Data_Out_B;--x"5555";-- 
                            when others => null;
                        end case;
                        if Addr_Aux(2 downto 0) = "111" then  
                            Addr_Aux  := Addr_Aux;--x"111";--
                            Rd_En_B   <= '1';
                        else                             
                            Addr_Aux  := Addr_Aux+1;
                            Rd_En_B   <='0';
                            Wr_En_B   <='1';                              
                        end if;
                        presente <= s6;
                        Establish <= Establish+1;
                        Addr_Rd_B <=Addr_Aux(3 downto 0);
                        Addr_Wr_B <=Addr_Aux(3 downto 0);
                    else
                        presente  <= s7; 
                        Addr_Aux  := Addr_Aux+1;
                        Establish <= "00000";
                        Addr_Rd_B <= Addr_Aux(3 downto 0);
                        Addr_Wr_B <= Addr_Aux(3 downto 0);
                        Wr_En_B   <= '1';
                    end if;
                when s7 =>
                    En_Out   <='0';
                    presente <= s8;
                    A0:= A0 xor (B0 AND C0);
                    A1:= A1 xor (B1 AND C1);
                when s8=>
                    presente <= s9;
                    B0 := B0 xor (A0 or D0);
                    B1 := B1 xor (A1 or D1);
                when s9=>
                    presente <= s10;
                    D0 := D0 xor (B0 or C0);
                    D1 := D1 xor (B1 or C1);
                when s10=>
                    presente <= s11;
                    C0 := C0 xor (B0 and D0);
                    C1 := C1 xor (B1 and D1);
                when s11=>
                    presente <= s12;
                    B0 := B0 xor (A0 or C0);
                    B1 := B1 xor (A1 or C1);
                when s12=>
                    presente <=s13;
                    A0 := A0 xor (B0 or D0);
                    A1 := A1 xor (B1 or D1);
                    Data_RIn_B <= B0;
                    --Addr_Aux  := '0' & x"8";
                    Addr_Rd_B <= x"8";
                    Rd_En_B   <= '1';
                    Addr_Wr_B <= Flag_Aux & Addr_Aux(2 downto 0);
                    Wr_En_B   <= '0';
                when s13=>
                    if Establish < "00111" then 
                        case Establish is
                            when "00000" => Data_RIn_B <= C0;
                            when "00001" => Data_RIn_B <= D0;
                            when "00010" => Data_RIn_B <= A0;
                            when "00011" => Data_RIn_B <= D1; 
                            when "00100" => Data_RIn_B <= B1;
                            when "00101" => Data_RIn_B <= A1;
                            when "00110" => Data_RIn_B <= C1;
                            when others => null;
                        end case; 
                        Addr_Aux  := Addr_Aux + 1;
                        Establish <= Establish + 1;
                        presente<= S13;
                        Addr_Rd_B <= x"8";
                        Rd_En_B   <= '1';
                        Addr_Wr_B <= Flag_Aux & Addr_Aux(2 downto 0);
                        Wr_En_B   <= '0';
                    else
                        if Flag_Aux = '1' then 
                            presente<=s15;
                            Wr_En_B   <= '0';
                        else
                            Establish <= "00000";
                            presente  <= s14;
                        end if;
                    end if;
            when s14 =>
                presente  <= s1;
                Addr_Aux  := '0'& x"8";
                Addr_Rd_B <= Addr_Aux(3 downto 0);
                Rd_En_B   <= '0';
                Addr_Wr_B <= x"0";
                Wr_En_B   <= '1';
                Flag_Aux  := '1';
                Establish <= "00000";
                Wr_En_B   <= '0';
            when s15 =>
                En_Out <= '1';
                presente <= s16;
                Addr_Aux :="00000";
            when s16 =>
                En_Out <= '0';
                presente <= s0;
                Addr_Aux :="00000";
                Establish<="00000";
                Flag_Aux := '0';
                Wr_En_B  <= '1';
                Rd_En_B  <= '1'; 
            when others => null;
            end case;
        end if;
end if;
end process ASM;
end Main;