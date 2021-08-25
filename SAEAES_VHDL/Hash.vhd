LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use ieee.std_logic_misc.all;
entity Hash is 
port (
    Addr_Rd_eS   : out std_logic_vector(3 downto 0);
    Data_Out_eS  : in  std_logic_vector(7 downto 0);
    Rd_En_eS     : out std_logic;

    Addr_Rd_Ad   : out std_logic_vector(4 downto 0);
    Data_Out_Ad  : in  std_logic_vector(7 downto 0);
    Rd_En_Ad     : out std_logic;
    
    Data_In_S   : out std_logic_vector(7  downto 0);
    Addr_Wr_S   : out std_logic_vector(3 downto 0);
    Wr_En_S     : out std_logic;

    Addr_Rd_No   : out std_logic_vector(3 downto 0);
    Data_Out_No  : in  std_logic_vector(7 downto 0);
    Rd_En_No     : out std_logic;

    Rst_S       : out std_logic;
    En_In       : in std_logic;
    En_Out      : out std_logic;
    En_Out_1    : out std_logic;
    clk         : in std_logic
);
end Hash;

architecture RTL of Hash is 
TYPE estado is (s0,s1,s2,s3,s4,s5,s6,s6_1,s7,s8,s9,s10,s11,s11_0,s12,s13,s13_0,s14,s15,s16,s16_1,s17,s18,s19,
s20,s21,s22,s22_1,s23,s24,s24_1,s25,s26,s27,s28,s29);
SIGNAL presente:estado:=s0;


begin
STat: process (clk)

variable Addr_eS_Aux : std_logic_vector(4 downto 0):="00000";
variable Addr_aD_Aux : std_logic_vector(4 downto 0):="00000";
begin
    if clk 'event and clk = '1' then
        if En_In ='1' then
            case presente is
                when s0 =>
                    presente <= s1;
                    Rst_S <= '0';
                    Wr_En_S <= '1';
                    Addr_Wr_S <= x"0";
                when s1 =>
                    if Addr_eS_Aux < "10000" then --AES_BLOCK in origin program 16
                        presente <=s1;
                        Rst_S <= '0';
                        Wr_En_S <= '1';
                        Addr_eS_Aux:=Addr_eS_Aux+1;
                        Addr_Wr_S <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    else
                        presente <= s2;
                        Rst_S <= '1';
                    end if;
                when s2 =>
                    presente <= s3;
                    Rd_En_Ad <= '0';
                    Rd_En_eS <= '0';
                    Rst_S <= '1';
                    Addr_eS_Aux:="00000";
                    Addr_aD_Aux:="00000";
                    Addr_Rd_Ad <= Addr_aD_Aux;
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                when s3 =>
                    presente <= s4;
                    Rst_S    <= '1';
                    Rd_En_Ad <= '1';
                    Rd_En_eS <= '1';
                    Wr_En_S  <= '1';
                    Addr_Wr_S  <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    --Addr_Rd_Ad <= Addr_aD_Aux;
                when s4 =>
                    presente <= s5;
                when s5 =>
                    presente <= s6_1;
                when s6_1 =>
                    presente <= s6;
                when s6 =>
                    if Addr_aD_Aux >= x"1F" then-- Test "1F"
                        presente <= s9;
                    elsif  Addr_eS_Aux(2 downto 0) = "111" then
                        presente <= s7;
                        En_Out <='1';
                    else                        
                        presente <= s3;                        
                    end if;
                    Wr_En_S  <= '0';
                    Rst_S    <= '1';
                    Rd_En_Ad <= '0';
                    Rd_En_eS <= '0';
                    Addr_eS_Aux:= Addr_eS_Aux + 1;
                    Addr_aD_Aux:= Addr_aD_Aux + 1;
                    Addr_Rd_Ad <= Addr_aD_Aux;
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    Data_In_S  <= Data_Out_eS XOR Data_Out_Ad;
                when s7 =>
                    Addr_eS_Aux := "00000";
                    presente <= s8;
                    Wr_En_S  <= '1';
                    En_Out <='0';
                when s8 =>
                    if  En_In = '1' then
                        presente <= s3;
                        Rd_En_Ad <= '0';
                        Rd_En_eS <= '0';
                        Rst_S <= '1';
                        Addr_Rd_Ad <= Addr_aD_Aux;
                        Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);    
                    else
                        presente <= s8;
                        En_Out <='0';
                    end if;
                when s9 => 
                    presente <= s10;
                    Rd_En_eS <= '0';
                    Addr_Rd_eS <= "1111";
                when s10 => 
                    presente <= s11;
                when s11 => 
                    presente <= s11_0;
                when s11_0 => 
                    presente <= s12;
                when s12 =>
                    presente <= s13;
                    Addr_Wr_S <="1111";
                    Wr_En_S <='0';
                    Data_In_S <= Data_Out_eS XOR x"01"; 
                when s13 =>
                    presente <= s13_0;
                    Addr_Wr_S <=x"0";
                    Wr_En_S <='1';
                when s13_0 =>
                    presente <= s14;
                    Addr_Wr_S <=x"0";
                    Wr_En_S <='1';
                when s14 =>
                    presente <= s15;
                    Addr_Wr_S <=x"0";
                    Wr_En_S <='1';
                    En_Out_1<= '1';
                when s15 =>
                    if  En_In = '1' then
                        presente <= s16;
                    else 
                        presente <= s15;
                    end if;
                    Addr_Wr_S <=x"0";
                    Wr_En_S <='1';
                    En_Out_1<= '0';
                    Addr_eS_Aux:="00000";
                    Addr_aD_Aux:="00000";
                    Rd_En_No <= '0';
                    Rd_En_eS <= '0';
                    Rst_S <= '1';
                    Addr_Rd_No <= Addr_aD_Aux(Addr_aD_Aux'length-2 downto 0);
                    Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                when s16 =>
                    presente <= s16_1;
                    --Rd_En_No <= '0';
                    --Rd_En_eS <= '0';
                    --Rst_S <= '1';
                    Rst_S    <= '1';
                    Rd_En_No <= '1';
                    Rd_En_eS <= '1';
                    Wr_En_S  <= '1';
                    Addr_Wr_S  <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    --Addr_Rd_No <= Addr_aD_Aux(Addr_aD_Aux'length-2 downto 0);
                    --Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                when s16_1 =>
                    presente <= s17;
                --when s16_2 =>
                    --presente <= s6_3;
                --when s6_3 =>
                    --presente <= s17;
                when s17 =>
                    presente <= s18;
                    Rst_S    <= '1';
                    Rd_En_No <= '1';
                    Rd_En_eS <= '1';
                    Wr_En_S  <= '1';
                    Addr_Wr_S  <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                when s18 =>
                    presente <= s19;
                when s19 =>
                    if Addr_aD_Aux <= x"E" then 
                        presente <= s16;
                        Wr_En_S  <= '0';
                        Rst_S    <= '1';
                        Rd_En_No <= '0';
                        Rd_En_eS <= '0';
                        Addr_eS_Aux:= Addr_eS_Aux + 1;
                        Addr_aD_Aux:= Addr_aD_Aux + 1;
                        Addr_Rd_No <= Addr_aD_Aux(Addr_aD_Aux'length-2 downto 0);
                        Addr_Rd_eS <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                        Data_In_S  <= Data_Out_No XOR Data_Out_eS;
                    else 
                        presente <= s20;
                        Addr_eS_Aux:="00000";
                        Addr_aD_Aux:="00000";
                    end if;
                when s20 => 
                    presente <= s21;
                    Rd_En_eS <= '0';
                    Addr_Rd_eS <= "1111";
                when s21 => 
                    presente <= s22;
                when s22 => 
                    presente <= s22_1;
                when s22_1 => 
                    presente <= s23;
                when s23 =>
                    presente <= s24;
                    Addr_Wr_S <="1111";
                    Wr_En_S <='0';
                    Data_In_S <= Data_Out_eS XOR x"03"; 
                when s24 =>
                    presente <= s24_1;
                    Addr_Wr_S <=x"0";
                    Wr_En_S <='1';
                when s24_1 =>
                    presente <= s25;
                when s25 =>
                    presente <= s26;
                    Addr_Wr_S <=x"0";
                    Wr_En_S <='1';
                    En_Out_1<= '1';
                when s26 =>
                    if  En_In = '1' then
                        presente <= s27;
                    else 
                        presente <= s26;
                    end if;
                    Addr_Wr_S <=x"0";
                    Wr_En_S <='1';
                    En_Out_1<= '0';
                    Addr_eS_Aux:="00000";
                    Addr_aD_Aux:="00000";
                when others => null;
            end case;
        end if;
    end if;
end process;
end RTL;