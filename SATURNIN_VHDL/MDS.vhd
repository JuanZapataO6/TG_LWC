library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;
entity MDS is 
        port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        --Ports For Control Component 
        clk         : in std_logic;
        En_In       : in std_logic;
        En_Out      : out std_logic
    );
end MDS;


architecture Main of MDS is 

type estado is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
signal presente:estado:=s0;
begin
ASM: process (clk)
variable Addr_Aux :std_logic_vector (4 DOWNTO 0):="00000";
variable Flag_Aux :std_logic:='0';
variable Establish:std_logic_vector (4 DOWNTO 0):="00000";
variable x0: std_logic_vector (15 downto 0);
variable x1: std_logic_vector (15 downto 0);
variable x2: std_logic_vector (15 downto 0);
variable x3: std_logic_vector (15 downto 0);
variable x4: std_logic_vector (15 downto 0);
variable x5: std_logic_vector (15 downto 0);
variable x6: std_logic_vector (15 downto 0);
variable x7: std_logic_vector (15 downto 0);
variable x8: std_logic_vector (15 downto 0);
variable x9: std_logic_vector (15 downto 0);
variable xa: std_logic_vector (15 downto 0);
variable xb: std_logic_vector (15 downto 0);
variable xc: std_logic_vector (15 downto 0);
variable xd: std_logic_vector (15 downto 0);
variable xe: std_logic_vector (15 downto 0);
variable xf: std_logic_vector (15 downto 0);
variable xAux_1: std_logic_vector (15 downto 0);
variable xAux_2: std_logic_vector (15 downto 0);
begin
if (CLK'event AND CLK = '1') then 
    if En_In = '1' then  
        if Addr_Aux <= "11111"  then 
            case presente is 
                when s0 =>
                    presente  <= s1;
                    Addr_Rd_B <= x"0";
                    Addr_Wr_B <= x"0";
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
                    presente <= s5;
                    Addr_Aux  := Addr_Aux+1;--3
                    Addr_Rd_B <=Addr_Aux(3 downto 0);
                    Addr_Wr_B <=Addr_Aux(3 downto 0);
                    Wr_En_B   <='1';
                    Rd_En_B   <='0';
                    En_Out    <='0';
                when s5=>
                    if Establish <= "01111" then 
                        case Establish is
                            when "00000" => x0 := Data_Out_B;
                            when "00001" => x1 := Data_Out_B;
                            when "00010" => x2 := Data_Out_B;
                            when "00011" => x3 := Data_Out_B; 
                            when "00100" => x4 := Data_Out_B;
                            when "00101" => x5 := Data_Out_B;
                            when "00110" => x6 := Data_Out_B;
                            when "00111" => x7 := Data_Out_B;
                            when "01000" => x8 := Data_Out_B;
                            when "01001" => x9 := Data_Out_B;
                            when "01010" => xa := Data_Out_B;
                            when "01011" => xb := Data_Out_B; 
                            when "01100" => xc := Data_Out_B;
                            when "01101" => xd := Data_Out_B;
                            when "01110" => xe := Data_Out_B;
                            when "01111" => xf := Data_Out_B; 
                            when others => null;
                        end case;
                        if Addr_Aux(3 downto 0) = "1111" then  
                            Addr_Aux  := Addr_Aux;
                            Rd_En_B   <='1';
                            Wr_En_B   <='1';
                        else                             
                            Addr_Aux  := Addr_Aux+1;
                            Rd_En_B   <='0';
                            Wr_En_B   <='1';
                        end if;
                        presente <= s5;
                        Establish := Establish+1;
                        Addr_Rd_B <=Addr_Aux(3 downto 0);
                        Addr_Wr_B <=Addr_Aux(3 downto 0);
                    else
                        presente  <= s6; 
                        Addr_Aux  := Addr_Aux+1;
                        Establish := "00000";
                        Addr_Rd_B <= Addr_Aux(3 downto 0);
                        Rd_En_B   <= '1';
                        Addr_Wr_B <= x"0";
                        Wr_En_B   <= '1';
                    end if;
                when s6 =>
                    presente <=s7;
                    x8:=x8 xor xc;
                    x9:=x9 xor xd;
                    xa:=xa xor xe;
                    xb:=xb xor xf;
                    x0:=x0 xor x4;
                    x1:=x1 xor x5;
                    x2:=x2 xor x6;
                    x3:=x3 xor x7;
                when s7 =>
                    presente <=s8;
                    xAux_1 := x4;
                    xAux_2 := xc;
                    x4:=x5;
                    x5:=x6;
                    x6:=x7;
                    x7:=xAux_1 xor x4;
                    xc:=xd;
                    xd:=xe;
                    xe:=xf;
                    xf:=xAux_2 xor xc;
                when s8 =>
                    presente <=s9;
                    x4:=x4 xor x8;
                    x5:=x5 xor x9;
                    x6:=x6 xor xa;
                    x7:=x7 xor xb;
                    xc:=xc xor x0;
                    xd:=xd xor x1;
                    xe:=xe xor x2;
                    xf:=xf xor x3;
                when s9 =>
                    presente <=s10;
                    xAux_1 := x0;
                    xAux_2 := x8;
                    x0:=x1;
                    x1:=x2;
                    x2:=x3;
                    x3:=xAux_1 xor x0;
                    x8:=x9;
                    x9:=xa;
                    xa:=xb;
                    xb:=xAux_2 xor x8;
                when s10 =>
                    presente <=s11;
                    xAux_1 := x0;
                    xAux_2 := x8;
                    x0:=x1;
                    x1:=x2;
                    x2:=x3;
                    x3:=xAux_1 xor x0;
                    x8:=x9;
                    x9:=xa;
                    xa:=xb;
                    xb:=xAux_2 xor x8;
                when s11 =>
                    presente <=s12;
                    x8:=x8 xor xc;
                    x9:=x9 xor xd;
                    xa:=xa xor xe;
                    xb:=xb xor xf;
                    x0:=x0 xor x4;
                    x1:=x1 xor x5;
                    x2:=x2 xor x6;
                    x3:=x3 xor x7;
                    Addr_Wr_B <= x"0";
                    Wr_En_B <='0';
                    Establish :="00000";
                when s12 =>
                    presente <=s13;
                    x4:=x4 xor x8;
                    x5:=x5 xor x9;
                    x6:=x6 xor xa;
                    x7:=x7 xor xb;
                    xc:=xc xor x0;
                    xd:=xd xor x1;
                    xe:=xe xor x2;
                    xf:=xf xor x3;
                when s13 =>
                    presente <=s14;
                    Addr_Aux  := "00000";
                    Establish := "00000";
                    Wr_En_B   <= '0';
                    Addr_Wr_B <=Addr_Aux(3 downto 0);
                    En_Out <= '0';
                    Data_RIn_B <= x0;
                when s14 =>
                    if Establish < "01111" then 
                        presente<= s14;
                        case Establish is
                            when "00000" => Data_RIn_B <= x1;
                            when "00001" => Data_RIn_B <= x2;
                            when "00010" => Data_RIn_B <= x3; 
                            when "00011" => Data_RIn_B <= x4;
                            when "00100" => Data_RIn_B <= x5;
                            when "00101" => Data_RIn_B <= x6;
                            when "00110" => Data_RIn_B <= x7;
                            when "00111" => Data_RIn_B <= x8;
                            when "01000" => Data_RIn_B <= x9;
                            when "01001" => Data_RIn_B <= xa;
                            when "01010" => Data_RIn_B <= xb;
                            when "01011" => Data_RIn_B <= xc;
                            when "01100" => Data_RIn_B <= xd;
                            when "01101" => Data_RIn_B <= xe;
                            when "01110" => Data_RIn_B <= xf;
                            when others => null;
                        end case; 
                        Addr_Aux  := Addr_Aux + 1;
                        Establish := Establish + 1;
                        Addr_Rd_B <= x"8";
                        Rd_En_B   <= '1';
                        Addr_Wr_B <= Addr_Aux(3 downto 0);
                        Wr_En_B   <= '0';
                    else
                        presente  <= s15;
                        En_Out <= '1';
                        Wr_En_B   <= '1';
                    end if;
                when s15 => 
                    Wr_En_B   <= '1';
                    En_Out <= '0';
                    Establish := "00000";
                    presente <= s16;
                when s16 => 
                    Wr_En_B   <= '1';
                    En_Out <= '0';
                    presente <= s0;
                when s20 => 
                    Wr_En_B   <= '1';
                    En_Out <= '1';
                    presente <= s20;
                when others => null;
            end case;
        end if;
    end if;
end if;
end process;


end architecture;
