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

    Rst_S       : out std_logic;
    En_In       : in std_logic;
    En_Out      : out std_logic;
    clk         : in std_logic
);
end Hash;

architecture RTL of Hash is 
TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;


begin
STat: process (clk)

variable Addr_eS_Aux : std_logic_vector(4 downto 0):="00000";
begin
    if clk 'event and clk = '1' then 
        if En_In ='1' then  
            case presente is 
                when  s0 =>
                    presente <= s1;
                    Rst_S <= '0';
                    Wr_En_S <= '1';
                    Addr_Wr_S <= x"0";
                when  s1 =>
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
                    Addr_Rd_Ad <= Addr_eS_Aux;
                    Addr_Rd_eS <=  Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);

                when  s3 =>
                    presente <= s4;
                    Rst_S    <= '1';
                    Rd_En_Ad <= '1';
                    Rd_En_eS <= '1';
                    Wr_En_S  <= '1';
                    Addr_Wr_S  <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                    --Data_In_S  <= Data_Out_eS XOR Data_Out_Ad;
                    --Addr_eS_Aux:= Addr_eS_Aux + 1;
                    --Addr_Wr_S  <= Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0) - 1;
                    --Addr_Rd_Ad <= Addr_eS_Aux;
                    --Addr_Rd_eS <=  Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                when  s4 =>
                    presente <= s5;
                when  s5 =>
                    if  Addr_eS_Aux < "1000" then
                        presente <= s3;
                        Wr_En_S  <= '0';
                        Rst_S    <= '1';
                        Rd_En_Ad <= '0';
                        Rd_En_eS <= '0';
                        Addr_eS_Aux:= Addr_eS_Aux + 1;
                        Addr_Rd_Ad <= Addr_eS_Aux;
                        Addr_Rd_eS <=  Addr_eS_Aux(Addr_eS_Aux'length-2 downto 0);
                        Data_In_S  <= Data_Out_eS XOR Data_Out_Ad;
                    else
                        presente <= s6;
                    end if;                     
                    
                    
                    
                when others => null;
            end case;
        end if;
    end if;
end process;
end RTL;