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
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Addr_Rd_K   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Rd_En_k     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        Data_Out_K  : in std_logic_vector (0 to 15);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end XOR_key;
architecture Main of XOR_key is 
signal i : std_logic_vector(3 downto 0);
type estado is (s0, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10);
signal presente:estado:=s0;
begin
STat: process (Clk)
variable Addr_Aux :std_logic_vector (4 DOWNTO 0):="00000";
begin
if (CLK'event AND CLK = '1') then 
    if En_In = '1' then  
            case presente is 
                when s0 =>-- STAR 
                    presente  <= s1;
                    Addr_Rd_B <= x"0";
                    Addr_Rd_k <= x"0";
                    Addr_Wr_B <= x"0";
                    Addr_Aux  := "00000";
                    Rd_En_B   <= '0';
                    Rd_En_K   <= '0';
                    Wr_En_B   <= '1';
                when s1 => 
                    presente <= s2;
                    Addr_Aux  := Addr_Aux+1;
                    Addr_Rd_B <= Addr_Aux(3 downto 0);
                    Addr_Rd_k <= Addr_Aux(3 downto 0);
                    Rd_En_B   <= '0';
                    Rd_En_K   <= '0';
                    Wr_En_B   <= '1';          
                when s2 =>
                    presente <= s3;
                    --Data_RIn_B <=Data_Out_B XOR Data_Out_K;
                    Addr_Aux   := Addr_Aux+1;
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_k  <= Addr_Aux(3 downto 0);                  
                    Rd_En_B    <= '0';
                    Rd_En_K    <= '0';
                    Wr_En_B    <= '1';                    
                when s3 =>
                    presente <= s4;                        
                    Data_RIn_B <= Data_Out_B XOR Data_Out_K;
                    Addr_Aux   := Addr_Aux+1;
                    --Addr_Wr_B  <= Addr_Aux(3 downto 0)-4; 
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_k  <= Addr_Aux(3 downto 0);                 
                    Rd_En_B    <= '0';
                    Rd_En_K    <= '0';
                    Wr_En_B    <= '1';
                when s4 =>
                    presente <= s5;  
                    Data_RIn_B <=Data_Out_B XOR Data_Out_K;
                    Addr_Aux   := Addr_Aux+1;
                    Addr_Wr_B  <= Addr_Aux(3 downto 0)-4; 
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_k  <= Addr_Aux(3 downto 0);
                    Rd_En_B    <= '0';
                    Rd_En_K    <= '0';
                    Wr_En_B    <= '0';
                when s5 =>
                    presente <= s6;
                    Data_RIn_B <=Data_Out_B XOR Data_Out_K;
                    Addr_Aux   := Addr_Aux+1;
                    Addr_Wr_B  <= Addr_Aux(3 downto 0)-4; 
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_k  <= Addr_Aux(3 downto 0);                 
                    Rd_En_B    <= '0';
                    Rd_En_K    <= '0';
                    Wr_En_B    <= '0';                   
                when s6 =>
                    Data_RIn_B <=Data_Out_B XOR Data_Out_K;
                    Addr_Aux   := Addr_Aux+1;
                    Addr_Wr_B  <= Addr_Aux(3 downto 0)-4; 
                    Addr_Rd_B  <= Addr_Aux(3 downto 0);
                    Addr_Rd_k  <= Addr_Aux(3 downto 0);                 
                    Rd_En_B    <= '0';
                    Rd_En_K    <= '0';
                    Wr_En_B    <= '0'; 
                    
                    if Addr_Aux >= "10000" then
                        presente <= s7;
                    else 
                        presente <= s4;
                    end if; 
                when s7 =>
                    presente <= s8;
                    Data_RIn_B <=Data_Out_B XOR Data_Out_K;
                    Addr_Aux   := Addr_Aux+1;
                    Addr_Wr_B  <= Addr_Aux(3 downto 0)-4;                 
                    Rd_En_B    <= '1';
                    Rd_En_K    <= '1';
                    Wr_En_B    <= '0'; 
                when s8 =>
                    presente <= s9;
                    Data_RIn_B <=Data_Out_B XOR Data_Out_K;
                    Addr_Aux   := Addr_Aux+1;
                    Addr_Wr_B  <= Addr_Aux(3 downto 0)-4;                 
                    Rd_En_B    <= '1';
                    Rd_En_K    <= '1';
                    Wr_En_B    <= '1'; 
                when s9 =>
                    presente <= s10;
                    En_Out <= '1';
                    Addr_Aux   := "00000";
                    Addr_Wr_B  <= "0000";                 
                    Addr_Rd_B  <= "0000";
                    Addr_Rd_K  <= "0000";
                    Rd_En_B    <= '1';
                    Rd_En_K    <= '1';
                    Wr_En_B    <= '1'; 
                when s10 =>
                    presente <= s0;
                    En_Out <= '0';
                    Addr_Aux   := "00000";
                    Addr_Wr_B  <= "0000";                 
                    Addr_Rd_B  <= "0000";
                    Addr_Rd_K  <= "0000";
                    Rd_En_B    <= '1';
                    Rd_En_K    <= '1';
                    Wr_En_B    <= '1';     
                when others => null;
            end case;
        end if;
    end if;
end process STat;
end Main;