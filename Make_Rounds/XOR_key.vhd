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
        --Ports for Memory Bank Read xb
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Data_ROut_B : In std_logic_vector (0 to 15);
        Rd_En_B     : out std_logic;
        Addr_Out_K  : out std_logic_vector(3 downto 0);
        
        Data_Out_B  : in std_logic_vector (0 to 15);
        Data_Out_K  
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic;
        state_out   : out std_logic_vector (0 to 15)
        
    );
end XOR_key;
architecture Main of XOR_key is 
signal i : std_logic_vector(3 downto 0);
type estado is (s0, s1,s2,s3);
signal presente:estado:=s0;
begin
STat process (Clk)
variable Addr_Aux :std_logic_vector (4 DOWNTO 0):="00000";
begin
if (CLK'event AND CLK = '1') then 
    if En_In = '1' then  
        if Addr_Aux <= '1111' then 
            case presente is 
                when s0 =>-- STAR 
                    presente_XOR <= s1;
                    Addr_Rd_B <= x"0";
                    Addr_Rd_k <= x"0";
                    Addr_Wr_B <= x"0";
                    Addr_Wr_k <= x"0";
                    Rd_En_B   <= '0';
                    Rd_En_K   <= '0';
                    Wr_En_B   <= '1';
                    Wr_En_k   <= '1';
                when s1 =>                        
                    presente_XOR <= s2;
                    Rd_En_B   <= '1';
                    Rd_En_K   <= '1';
                    Wr_En_B   <= '1';
                    Wr_En_k   <= '1';                        
                    when s2 =>
                        presente_XOR <= s3;                 
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s3 =>
                        presente_XOR <= s4;                        
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s4 =>
                        presente_XOR <= s5;  
                        Data_RIn_B <=state_In_B;                      
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s5 =>
                        presente_XOR <= s6;
                        Data_RIn_B <=state_In_B;
                        --Addr_Rd_B <= Addr_Rd_B + 1;
                        --Addr_Rd_k <= Addr_Rd_k + 1;
                        --Addr_Wr_B <= Addr_Wr_B + 1;                        
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '0';
                        Wr_En_k   <= '1';
                        En_SBox := '1';
                    when s6 =>
                        presente_XOR <= s1;
                        Data_RIn_B <=state_In_B;
                        Addr_Rd_B <= Addr_Rd_B + 1;
                        Addr_Rd_k <= Addr_Rd_k + 1;
                        Addr_Wr_B <= Addr_Wr_B + 1;                        
                        Rd_En_B   <= '0';
                        Rd_En_K   <= '0';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';                        
                        if Addr_Rd_B = "1111" then
                            En_in_XK  <= '1';
                            En_SBox := '0';
                            Addr_Rd_B <= x"0";
                            Addr_Rd_k <= x"0";
                            Addr_Wr_B <= x"0";
                            Addr_Wr_B <= x"0";
                            --Rd_En_B   <= '0';
                        end if;
                when others => null;
                end case;
                state_out <= state XOR key;
                En_Out <='1';
        else 
                En_Out <= '0';
        end if;
    end if;
end if;
end process STat;
end Main;