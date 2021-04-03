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
type estado is (s0, s1,s2,s3,s4,s5,s6,s7);
signal presente:estado:=s0;
begin
STat: process (Clk)
variable Addr_Aux :std_logic_vector (3 DOWNTO 0):="0000";
begin
if (CLK'event AND CLK = '1') then 
    if En_In = '1' then  
        if Addr_Aux <= "1111" then 
            case presente is 
                when s0 =>-- STAR 
                    presente <= s1;
                    Addr_Rd_B <= x"0";
                    Addr_Rd_k <= x"0";
                    Addr_Wr_B <= x"0";
                    Addr_Aux  := x"0";
                    Rd_En_B   <= '0';
                    Rd_En_K   <= '0';
                    Wr_En_B   <= '1';
                when s1 =>                        
                    presente <= s2;
                    Addr_Aux  := Addr_Aux +1;
                    Addr_Rd_B <= Addr_Aux;
                    --Addr_Wr_B <= Addr_Aux;
                    Addr_Rd_k <= x"F";--Addr_Aux;
                    --Addr_Wr_B <= x"0";
                    Rd_En_B   <= '0';
                    Rd_En_K   <= '0';
                    Wr_En_B   <= '1';                       
                when s2 =>
                    presente <= s3;                    
                    Rd_En_B   <= '1';
                    Rd_En_K   <= '1';
                    Wr_En_B   <= '1';
                when s3 =>
                    presente <= s4;                        
                    --Data_RIn_B <=Data_Out_B XOR Data_Out_K;
                    Rd_En_B   <= '1';
                    Rd_En_K   <= '1';
                    Wr_En_B   <= '1';
                when s4 =>
                    presente <= s5;  
                    Data_RIn_B <=Data_Out_B XOR Data_Out_K;
                    Rd_En_B   <= '1';
                    Rd_En_K   <= '1';
                    Wr_En_B   <= '0';
                                        
                when s5 =>
                    presente <= s6;
                    Addr_Wr_B <= Addr_Aux;
                    Data_RIn_B <=Data_Out_B XOR Data_Out_K;
                    Rd_En_B   <= '1';
                    Rd_En_K   <= '1';
                    Wr_En_B   <= '0';                    
                when s6 =>
                    presente <= s1;
                    --Data_RIn_B <=Data_Out_B XOR Data_Out_K;                       
                    Addr_Aux  := Addr_Aux +1;
                    Addr_Rd_B <= Addr_Aux;
                    Addr_Wr_B <= Addr_Aux;
                    Rd_En_B   <= '0';
                    Rd_En_K   <= '0';
                    Wr_En_B   <= '1';
                    --if Addr_Rd_B = "1111" then
                    --    En_in_XK  <= '1';
                    --    --En_SBox := '0';
                    --    Addr_Rd_B <= x"0";
                        --Addr_Rd_k <= x"0";
                      --  Addr_Wr_B <= x"0";
                        --Rd_En_B   <= '0';
                    --end if;
                when others => null;
            end case;
                --state_out <= state XOR key;
                --En_Out <='1';
        else 
                En_Out <= '1';
        end if;
    end if;
end if;
end process STat;
end Main;