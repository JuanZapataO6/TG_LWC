library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;
--
entity SR_Sheet is
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (15 downto 0);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end SR_Sheet;
architecture Main of SR_Sheet is 

--
signal x4: std_logic_vector (15 downto 0);
signal x5: std_logic_vector (15 downto 0);
signal x6: std_logic_vector (15 downto 0);
signal x7: std_logic_vector (15 downto 0);
--
signal x8: std_logic_vector (15 downto 0);
signal x9: std_logic_vector (15 downto 0);
signal xa: std_logic_vector (15 downto 0);
signal xb: std_logic_vector (15 downto 0);
signal xc: std_logic_vector (15 downto 0);
signal xd: std_logic_vector (15 downto 0);
signal xe: std_logic_vector (15 downto 0);
signal xf: std_logic_vector (15 downto 0);
type estado is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
signal presente:estado:=s0;
begin
ASM: process (clk)
variable Addr_Aux :std_logic_vector (4 DOWNTO 0):="00000";
variable Flag_Aux :std_logic:='0';
variable Establish:std_logic_vector (4 DOWNTO 0):="00000";
begin
if (CLK'event AND CLK = '1') then 
    if En_In = '1' then  
        if Addr_Aux <= "11111"  then 
            case presente is 
                when s0 =>
                    presente  <= s1;
                    Addr_Rd_B <= x"0";
                    Addr_Wr_B <= x"0";
                    Addr_Aux  := "00100";
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
                when s5 =>
                    if Establish <= "01011" then 
                        presente <= s5;
                        case Establish is
                            when "00000" => x4 <= Data_Out_B(11 downto 0)& Data_Out_B(15 downto 12);
                            when "00001" => x5 <= Data_Out_B(11 downto 0)& Data_Out_B(15 downto 12);
                            when "00010" => x6 <= Data_Out_B(11 downto 0)& Data_Out_B(15 downto 12);
                            when "00011" => x7 <= Data_Out_B(11 downto 0)& Data_Out_B(15 downto 12);
                            when "00100" => x8 <= Data_Out_B(7 downto 0 )& Data_Out_B(15 downto 8 );
                            when "00101" => x9 <= Data_Out_B(7 downto 0 )& Data_Out_B(15 downto 8 );
                            when "00110" => xa <= Data_Out_B(7 downto 0 )& Data_Out_B(15 downto 8 );
                            when "00111" => xb <= Data_Out_B(7 downto 0 )& Data_Out_B(15 downto 8 );
                            when "01000" => xc <= Data_Out_B(3 downto 0 )& Data_Out_B(15 downto 4 );
                            when "01001" => xd <= Data_Out_B(3 downto 0 )& Data_Out_B(15 downto 4 );
                            when "01010" => xe <= Data_Out_B(3 downto 0 )& Data_Out_B(15 downto 4 );
                            when "01011" => xf <= Data_Out_B(3 downto 0) & Data_Out_B(15 downto 4 );
                            when others => null;
                        end case;
                        if Addr_Aux(3 downto 0) = "1111" then  
                            Addr_Aux  := Addr_Aux;
                        else                             
                            Addr_Aux  := Addr_Aux+1;
                        end if;
                        Establish := Establish+1;
                        Addr_Rd_B <= Addr_Aux(3 downto 0);
                        Rd_En_B   <= '0';
                    else
                        presente  <= s6; 
                        Addr_Aux  := "00100";
                        Establish := "00000";
                        Addr_Rd_B <= Addr_Aux(3 downto 0);
                        Rd_En_B   <= '1';
                        Addr_Wr_B <= Addr_Aux(3 downto 0);
                        Wr_En_B   <= '0';
                        Data_RIn_B <= x4;
                    end if;
                when s6 =>
                    presente  <= s7;
                    Addr_Aux  := Addr_Aux+1;
                    Rd_En_B   <= '1';
                    Addr_Wr_B <= Addr_Aux (3 downto 0);
                    --Establish <= Establish +1;
                    Wr_En_B   <= '0';
                    Data_RIn_B <= x5;
                when s7 => 
                    if Establish <= "01001" then 
                        presente<= s7;
                        case Establish is 
                            when "00000" => Data_RIn_B <= x6;
                            when "00001" => Data_RIn_B <= x7;
                            when "00010" => Data_RIn_B <= x8;
                            when "00011" => Data_RIn_B <= x9;
                            when "00100" => Data_RIn_B <= xa;
                            when "00101" => Data_RIn_B <= xb;
                            when "00110" => Data_RIn_B <= xc;
                            when "00111" => Data_RIn_B <= xd;
                            when "01000" => Data_RIn_B <= xe;
                            when "01001" => Data_RIn_B <= xf;
                            when others => null;
                        end case; 
                        Addr_Aux  := Addr_Aux + 1;
                        Establish := Establish + 1;
                        Addr_Rd_B <= x"8";
                        Rd_En_B   <= '1';
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
end if;
end process ASM;
end Main;