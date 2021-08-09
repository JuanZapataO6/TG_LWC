LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use ieee.std_logic_misc.all;
entity Encrypt is 
port (
    Addr_Rd_eS   : out std_logic_vector(3 downto 0);
    Data_Out_eS  : in  std_logic_vector(7 downto 0);
    Rd_En_eS     : out std_logic;

    Addr_Rd_Bf   : out std_logic_vector(4 downto 0);
    Data_Out_Bf  : in  std_logic_vector(7 downto 0);
    Rd_En_Bf     : out std_logic;
    
    Data_In_Ct   : out std_logic_vector(7  downto 0);
    Addr_Wr_Ct   : out std_logic_vector(5 downto 0);
    Wr_En_Ct     : out std_logic;

    Data_In_S   : out std_logic_vector(7  downto 0);
    Addr_Wr_S   : out std_logic_vector(3 downto 0);
    Wr_En_S     : out std_logic;

    En_In       : in std_logic;
    En_Out      : out std_logic;
    En_Out_1    : out std_logic;
    clk         : in std_logic
);
end Encrypt;

architecture RTL of Encrypt is 
TYPE estado is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,
s20,s21,s22,s23,s24,s25,s26,s27,s28,s29);

SIGNAL presente:estado:=s0;
--signal Addr_Bf_Aux : std_logic_vector(5 downto 0):="000000";

begin
STat: process (clk)
type Words is array (0 to 39) of std_logic_vector (7 downto 0);
variable Ct : Words;variable eKeyAux : Words;
variable Addr_eS_Aux : std_logic_vector(4 downto 0):="00000";
variable Addr_Bf_Aux : std_logic_vector(5 downto 0):="000000";
begin
    if clk 'event and clk = '1' then
        if En_In ='1' then
            case presente is
                when s0 =>
                    presente <= s1;
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    Addr_Rd_Bf <= Addr_Bf_Aux(Addr_Bf_Aux'length-2 downto 0);
                    Addr_Wr_S  <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    Wr_En_S  <= '1';
                    Rd_En_eS <= '1';
                    Rd_En_Bf <= '1';
                when s1 =>
                    presente <= s2;
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    Addr_Rd_Bf <= Addr_Bf_Aux(Addr_Bf_Aux'length-2 downto 0);
                    Addr_Wr_S  <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    Wr_En_S  <= '1';
                    Rd_En_eS <= '0';
                    Rd_En_Bf <= '0';
                when s2 =>
                    presente <= s3;
                    Rd_En_Bf <= '1';
                    Rd_En_eS <= '1';
                    Wr_En_S  <= '1';
                    Addr_Wr_S  <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                when s3 =>
                    presente <= s4;
                when s4 =>
                    if Addr_Bf_Aux >= x"1F" then
                        presente <= s7;
                    elsif  Addr_eS_Aux(Addr_eS_Aux'length-3 downto 0) = "111" then
                        presente <= s5;
                        En_Out <='1';
                    else                        
                        presente <= s1;                        
                    end if;
                    Wr_En_S  <= '0';
                    Rd_En_eS <= '0';
                    Rd_En_Bf <= '0';
                    Addr_eS_Aux:= Addr_eS_Aux + 1;
                    Addr_Bf_Aux:= Addr_Bf_Aux + 1;
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    Addr_Rd_Bf <= Addr_Bf_Aux(Addr_Bf_Aux'length-2 downto 0);
                    Ct(to_integer(unsigned(Addr_Bf_Aux-1))) := Data_Out_eS XOR Data_Out_Bf;
                    Data_In_S  <= Data_Out_eS XOR Data_Out_Bf;
                when s5 =>
                    presente <= s6;
                    Wr_En_S  <= '1';
                    En_Out <='0';
                when s6 =>
                    if En_In = '1' then
                        presente <= s1;
                        --Rd_En_Bf <= '0';
                        --Rd_En_eS <= '0';
                        --Rst_S <= '1';
                        Addr_eS_Aux := "00000";
                    else
                        Addr_eS_Aux := "00000";
                        presente <= s5;
                        En_Out <='0';
                        Addr_Wr_Ct <= Addr_Bf_Aux;
                    end if;
                when s7 =>
                    presente <= s8;
                    Wr_En_S  <= '0';
                    Rd_En_eS <= '0';
                    Rd_En_Bf <= '1';
                    Addr_eS_Aux:= "11111";
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    Addr_Wr_Ct <= Addr_Bf_Aux;
                when s8 =>
                    presente <= s9;
                    Wr_En_S  <= '1';
                    Rd_En_eS <= '1';
                    Rd_En_Bf <= '1';
                when s9 =>
                    presente <= s10;
                    Wr_En_S  <= '1';
                    Rd_En_eS <= '1';
                    Rd_En_Bf <= '1';
                    Addr_Wr_S  <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                when s10 =>
                    presente <= s11; 
                    Wr_En_S  <= '0';
                    Rd_En_eS <= '1';
                    Rd_En_Bf <= '1';
                    Data_In_S  <= Data_Out_eS XOR x"01";
                when s11 =>
                    presente <= s12; 
                    Wr_En_S  <= '1';
                    Rd_En_eS <= '1';
                    Rd_En_Bf <= '1';
                when s12 =>
                    presente <= s13;
                    En_Out_1 <= '1';
                    Wr_En_S  <= '1';
                    Rd_En_eS <= '1';
                    Rd_En_Bf <= '1';
                when s13 =>
                    presente <= s14;
                    En_Out_1 <= '0';
                    Addr_eS_Aux := "00000";
                    Wr_En_S  <= '1';
                    Rd_En_Bf <= '1';
                    Rd_En_eS <= '0';                    
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                when s14 =>
                    presente <= s15;
                    En_Out_1 <= '0';
                    Wr_En_S  <= '1';
                    Rd_En_eS <= '0';
                    --Addr_eS_Aux := "00000";                    
                    Addr_eS_Aux := Addr_eS_Aux + 1;
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    Rd_En_Bf <= '1';
                when s15 =>
                    presente <= s16;
                    En_Out_1 <= '0';
                    Addr_eS_Aux := Addr_eS_Aux + 1;
                    Wr_En_S  <= '1';
                    Rd_En_Bf <= '1';
                    Rd_En_eS <= '0';                    
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                when s16 =>
                if Addr_eS_Aux(Addr_eS_Aux'length-3 downto 0) = "111" then
                    presente <= s17;
                else
                    presente <= s16;
                end if;
                    En_Out_1 <= '0';
                    Addr_eS_Aux := Addr_eS_Aux + 1;
                    Addr_Bf_Aux:= Addr_Bf_Aux + 1;
                    Wr_En_S  <= '1';
                    Rd_En_Bf <= '1';
                    Rd_En_eS <= '0';
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    Addr_Wr_Ct <= Addr_Bf_Aux;
                    Ct(to_integer(unsigned(Addr_Bf_Aux-1))) := Data_Out_eS;
                when s17 =>
                    presente <= s18;
                    Wr_En_S  <= '1';
                    Rd_En_Bf <= '1';
                    Rd_En_eS <= '1';
                    Addr_Bf_Aux:= Addr_Bf_Aux + 1;
                    Addr_Wr_Ct <= Addr_Bf_Aux;
                    Ct(to_integer(unsigned(Addr_Bf_Aux-1))) := Data_Out_eS;
                when s18 =>
                    presente <= s19;
                    Wr_En_S  <= '1';
                    Rd_En_Bf <= '1';
                    Rd_En_eS <= '1';
                    Addr_Wr_Ct <= Addr_Bf_Aux;
                    Ct(to_integer(unsigned(Addr_Bf_Aux))) := Data_Out_eS;
                when s19 =>
                    presente <= s20;
                    Wr_En_Ct  <= '0';
                    Rd_En_Bf <= '1';
                    Rd_En_eS <= '1';
                    Addr_Bf_Aux:= "000000";
                    Addr_Wr_Ct <= Addr_Bf_Aux;
                    Data_In_Ct <= Ct(to_integer(unsigned(Addr_Bf_Aux)));
                when s20 =>
                    Wr_En_Ct  <= '0';
                    Rd_En_Bf <= '1';
                    Rd_En_eS <= '1';
                    Addr_Bf_Aux:= Addr_Bf_Aux+1;
                    Addr_Wr_Ct <= Addr_Bf_Aux;
                    Data_In_Ct <= Ct(to_integer(unsigned(Addr_Bf_Aux)));
                if  Addr_Bf_Aux = x"27" then 
                    presente <= s21;
                else 
                    presente <= s20;
                end if;
                when others => null;
            end case;
        end if;
    end if;
end process;
end RTL;