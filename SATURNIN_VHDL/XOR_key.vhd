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
variable Establish :std_logic_vector (4 downto 0):="00000";
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
begin
if (CLK'event AND CLK = '0') then 
    if En_In = '1' then  
        case presente is 
            when s0 =>-- STAR 
                presente  <= s1;
                Addr_Aux  := "00000";
                Addr_Rd_B <= x"0";
                Addr_Rd_K <= x"0";
                Addr_Wr_B <= x"0";
                En_Out <= '0';
                Rd_En_B   <= '1';
                Rd_En_K   <= '1';
                Wr_En_B   <= '1';
            when s1 => 
                presente  <= s2;
                Addr_Aux  := "00000";
                Addr_Rd_B <= Addr_Aux(3 downto 0);
                Addr_Rd_K <= Addr_Aux(3 downto 0);
                Addr_Wr_B <= Addr_Aux(3 downto 0);
                En_Out <= '0';
                Rd_En_B   <= '0';
                Rd_En_K   <= '0';
                Wr_En_B   <= '1';
            when s2 =>
                presente  <= s3;
                --Addr_Aux  :=  Addr_Aux+1;
                Addr_Rd_B <= Addr_Aux(3 downto 0);
                Addr_Rd_K <= Addr_Aux(3 downto 0);
                Addr_Wr_B <= Addr_Aux(3 downto 0);
                En_Out <= '0';
                Rd_En_B   <= '0';
                Rd_En_K   <= '0';
                Wr_En_B   <= '1';
            when s3 =>
                presente  <= s4;
                Addr_Aux  :=  Addr_Aux+1;
                Addr_Rd_B <= Addr_Aux(3 downto 0);
                Addr_Rd_K <= Addr_Aux(3 downto 0);
                Addr_Wr_B <= Addr_Aux(3 downto 0);
                En_Out <= '0';
                Rd_En_B   <= '0';
                Rd_En_K   <= '0';
                Wr_En_B   <= '1';
            when s4 =>
                presente  <= s5;
                Addr_Aux  :=  Addr_Aux+1;
                Addr_Rd_B <= Addr_Aux(3 downto 0);
                Addr_Rd_K <= Addr_Aux(3 downto 0);
                Addr_Wr_B <= Addr_Aux(3 downto 0);
                En_Out <= '0';
                Rd_En_B   <= '0';
                Rd_En_K   <= '0';
                Wr_En_B   <= '1';
            when s5 =>
                if Establish <= "01111" then 
                        case Establish is
                            when "00000" => x0 := Data_Out_B XOR Data_Out_K;
                            when "00001" => x1 := Data_Out_B XOR Data_Out_K;
                            when "00010" => x2 := Data_Out_B XOR Data_Out_K;
                            when "00011" => x3 := Data_Out_B XOR Data_Out_K; 
                            when "00100" => x4 := Data_Out_B XOR Data_Out_K;
                            when "00101" => x5 := Data_Out_B XOR Data_Out_K;
                            when "00110" => x6 := Data_Out_B XOR Data_Out_K;
                            when "00111" => x7 := Data_Out_B XOR Data_Out_K;
                            when "01000" => x8 := Data_Out_B XOR Data_Out_K;
                            when "01001" => x9 := Data_Out_B XOR Data_Out_K;
                            when "01010" => xa := Data_Out_B XOR Data_Out_K;
                            when "01011" => xb := Data_Out_B XOR Data_Out_K; 
                            when "01100" => xc := Data_Out_B XOR Data_Out_K;
                            when "01101" => xd := Data_Out_B XOR Data_Out_K;
                            when "01110" => xe := Data_Out_B XOR Data_Out_K;
                            when "01111" => xf := Data_Out_B XOR Data_Out_K; 
                            when others => null;
                        end case;
                        if Addr_Aux(3 downto 0) = "1111" then  
                            Addr_Aux  := Addr_Aux;
                            Rd_En_B   <='1';
                            Rd_En_K   <= '0';
                            Wr_En_B   <='1';
                        else                             
                            Addr_Aux  := Addr_Aux+1;
                            Rd_En_B   <='0';
                            Rd_En_K   <='0';
                            Wr_En_B   <='1';
                        end if;
                        presente <= s5;
                        Establish := Establish+1;
                        Addr_Rd_B <=Addr_Aux(3 downto 0);
                        Addr_Rd_K <=Addr_Aux(3 downto 0);
                        Addr_Wr_B <=Addr_Aux(3 downto 0);
                    else
                        presente  <= s6; 
                        Addr_Aux  := "00000";
                        Establish := "00000";
                        Addr_Rd_B <= Addr_Aux(3 downto 0);
                        Addr_Rd_K <= Addr_Aux(3 downto 0);
                        Addr_Wr_B <= Addr_Aux (3 downto 0);
                        Data_RIn_B <= x0;
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '0';
                    end if;
            when s6 =>
                presente  <= s7;
                Addr_Aux  := Addr_Aux+1;
                Rd_En_B   <= '1';
                Addr_Wr_B <= Addr_Aux (3 downto 0);
                Wr_En_B   <= '0';
                Data_RIn_B <= x1;
            when s7 => 
                if Establish <= "01101" then 
                    presente<= s7;
                    case Establish is 
                        when "00000" => Data_RIn_B <= x2;
                        when "00001" => Data_RIn_B <= x3;
                        when "00010" => Data_RIn_B <= x4;
                        when "00011" => Data_RIn_B <= x5;
                        when "00100" => Data_RIn_B <= x6;
                        when "00101" => Data_RIn_B <= x7;
                        when "00110" => Data_RIn_B <= x8;
                        when "00111" => Data_RIn_B <= x9;
                        when "01000" => Data_RIn_B <= xa;
                        when "01001" => Data_RIn_B <= Xb;
                        when "01010" => Data_RIn_B <= xc;
                        when "01011" => Data_RIn_B <= xd;
                        when "01100" => Data_RIn_B <= xe;
                        when "01101" => Data_RIn_B <= Xf;
                        when others => null;
                    end case; 
                    Addr_Aux  := Addr_Aux + 1;
                    Establish := Establish + 1;
                    Rd_En_B   <= '1';
                    Rd_En_K   <= '1';
                    Addr_Wr_B <= Addr_Aux (3 downto 0);
                    Wr_En_B   <= '0';
                else
                    presente  <= s8;
                    En_Out <= '1';
                    Wr_En_B   <= '1';
                end if;
            when s8 =>
                presente <= s0;
                En_Out <= '0';
                Establish :="00000";
                when others => null;
        end case;
        end if;
    end if;
end process STat;
end Main;   