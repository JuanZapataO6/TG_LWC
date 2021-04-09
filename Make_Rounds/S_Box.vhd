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
end S_Box;
architecture Main of S_Box is 

type estado is (start,s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12);
signal presente:estado:=s0;
signal Establish:std_logic_vector (4 DOWNTO 0):="00000";
signal   A0 : std_logic_vector (15 downto 0);
signal   B0 : std_logic_vector (15 downto 0);
signal   C0 : std_logic_vector (15 downto 0);
signal   D0 : std_logic_vector (15 downto 0);
signal   A1 : std_logic_vector (15 downto 0);
signal   B1 : std_logic_vector (15 downto 0);
signal   C1 : std_logic_vector (15 downto 0);
signal   D1 : std_logic_vector (15 downto 0);
begin
ASM: process (clk)
variable Addr_Aux :std_logic_vector (4 DOWNTO 0):="00000";
variable Flag_Aux :std_logic:='0';
begin
if (CLK'event AND CLK = '1') then 
    if En_In = '1' then  
        if Addr_Aux <= "11111"  then 
            case presente is 
                when s0 =>
                    presente  <= s1;
                    Addr_Aux  := '0'& x"0";
                    Addr_Rd_B <= Addr_Aux(3 downto 0);
                    En_Out    <='0';
                    Rd_En_B   <= '0';
                    Addr_Wr_B <= x"0";
                    Wr_En_B   <= '1';                   
                when s1=>
                    if Establish <= "00001" then 
                        presente <= s1; 
                        Addr_Aux  := Addr_Aux+1;
                        Establish <= Establish+1;
                        Addr_Rd_B <= Addr_Aux(3 downto 0);
                        Rd_En_B   <= '0';
                    else
                        presente  <= s2; 
                        Addr_Aux  := Addr_Aux+1;
                        Establish <= "00000";
                        Addr_Rd_B <= Addr_Aux(3 downto 0);
                        Rd_En_B   <= '0';
                    end if;
                when s2=>
                    if Establish <= "00111" then 
                        presente <= s2;
                        case Establish is
                            when "00000" => A0 <= Data_Out_B;
                            when "00001" => B0 <= Data_Out_B;
                            when "00010" => C0 <= Data_Out_B;
                            when "00011" => D0 <= Data_Out_B; 
                            when "00100" => A1 <= Data_Out_B;
                            when "00101" => B1 <= Data_Out_B;
                            when "00110" => C1 <= Data_Out_B;
                            when "00111" => D1 <= Data_Out_B; 
                            when others => null;
                        end case;
                        if Addr_Aux(2 downto 0) = "111" then  
                            Addr_Aux  := Addr_Aux;
                        else                             
                            Addr_Aux  := Addr_Aux+1;                                
                        end if;
                        Establish <= Establish+1;
                        Addr_Rd_B <= Addr_Aux(3 downto 0);
                        Rd_En_B   <= '0';
                    else
                        presente  <= s3; 
                        Addr_Aux  := Addr_Aux+1;
                        Establish <= "00000";
                        Addr_Rd_B <= Addr_Aux(3 downto 0);
                        Rd_En_B   <= '1';
                        Addr_Wr_B <= x"0";
                        Wr_En_B   <= '1';
                    end if;
                when s3=>
                    presente <= s4;
                    A0<= A0 xor (B0 AND C0);
                    A1<= A1 xor (B1 AND C1);
                when s4=>
                    presente <= s5;
                    B0 <= B0 xor (A0 or D0);
                    B1 <= B1 xor (A1 or D1);                    
                when s5=>
                    presente <= s6;
                    D0 <= D0 xor (B0 or C0);
                    D1 <= D1 xor (B1 or C1);
                when s6=>
                    presente <= s7;                    
                    C0 <= C0 xor (B0 and D0);
                    C1 <= C1 xor (B1 and D1);
                when s7=>
                    presente <= s8;
                    B0 <= B0 xor (A0 or C0);
                    B1 <= B1 xor (A1 or C1);
                when s8=>
                    presente <=s9;
                    A0 <= A0 xor (B0 or D0);
                    A1 <= A1 xor (B1 or D1);
                    Data_RIn_B <= B0;
                    Establish <= "00000";
                    --Addr_Aux  := '0' & x"8";
                    Addr_Rd_B <= x"8";
                    Rd_En_B   <= '1';
                    Addr_Wr_B <= Flag_Aux & Addr_Aux(2 downto 0);
                    Wr_En_B   <= '0';
                when s9=>
                    if Establish < "00111" then 
                        presente<= S9;
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
                        Addr_Rd_B <= x"8";
                        Rd_En_B   <= '1';
                        Addr_Wr_B <= Flag_Aux & Addr_Aux(2 downto 0);
                        Wr_En_B   <= '0';
                    else
                        if Flag_Aux = '1' then 
                            presente<=s11;
                            Wr_En_B   <= '0';
                        else
                            presente  <= s10;
                        end if;
                    end if;
                when s10 =>
                    presente  <= s1;
                    Addr_Aux  := '0'& x"8";
                    Addr_Rd_B <= Addr_Aux(3 downto 0);
                    Rd_En_B   <= '0';
                    Addr_Wr_B <= x"0";
                    Wr_En_B   <= '1';    
                    Flag_Aux  := '1';
                    Establish <= "00000";
                        --Wr_En_B   <= '0';
                when s11 =>
                    En_Out <= '1';
                    presente <= s12;
                    Addr_Aux :="00000";
                when s12 =>
                    En_Out <= '0';
                    presente <= s0;
                    Addr_Aux :="00000";
                    Establish <= "00000";
                    Flag_Aux  := '0';
                    Wr_En_B   <= '1'; 
                when others => null;
            end case;
        else
            
        end if;
    end if;
end if;
end process ASM;
end Main;