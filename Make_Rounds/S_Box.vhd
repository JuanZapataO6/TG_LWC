library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;
--
entity S_Box is
    port(
        --Verificar entradas tipo arreglo 
        a0_in   : in  std_logic_vector(15 downto 0);
        a1_in   : in  std_logic_vector(15 downto 0);
        b0_in   : in  std_logic_vector(15 downto 0);
        b1_in   : in  std_logic_vector(15 downto 0);
        c0_in   : in  std_logic_vector(15 downto 0);
        c1_in   : in  std_logic_vector(15 downto 0);
        d0_in   : in  std_logic_vector(15 downto 0);
        d1_in   : in  std_logic_vector(15 downto 0);
        a0_out  : out std_logic_vector(15 downto 0);
        a1_out  : out std_logic_vector(15 downto 0);
        b0_out  : out std_logic_vector(15 downto 0);
        b1_out  : out std_logic_vector(15 downto 0);
        c0_out  : out std_logic_vector(15 downto 0);
        c1_out  : out std_logic_vector(15 downto 0);
        d0_out  : out std_logic_vector(15 downto 0);
        d1_out  : out std_logic_vector(15 downto 0);
        En_SBox_in : in  std_logic;
        En_SBox_out : out  std_logic:= '1';
        clk     : in  std_logic
    );
end S_Box;
architecture Main of S_Box is 
    
    type estado is (s0,s1,s2,s3,s4,s5,s6,s7,s8);
    signal presente:estado:=s0;
    
    begin
    ASM: process (a0_in,b0_in,c0_in,d0_in,
            a1_in,b1_in,c1_in,d1_in,
            clk,presente)
    variable a0_in_aux,b0_in_aux,c0_in_aux,d0_in_aux,
            a1_in_aux,b1_in_aux,c1_in_aux,d1_in_aux : std_logic_vector(15 downto 0);
    variable En_SBox_out_Aux : std_logic := '1';
    begin
        if (CLK'event AND CLK = '1') then
            if En_SBox_in ='0' then 
                case presente is 
                    when s0 =>
                        if En_SBox_out_Aux ='1' then
                            presente<= s1;
                        else 
                            presente<= s0;
                        end if;
                    when s1=>
                        presente <= s2;
                        En_SBox_out <= '1';
                        En_SBox_out_Aux := '1';
                        a0_in_aux   :=a0_in;
                        a1_in_aux   :=a1_in;
                        b0_in_aux   :=b0_in;
                        b1_in_aux   :=b1_in;
                        c0_in_aux   :=c0_in;
                        c1_in_aux   :=c1_in;
                        d0_in_aux   :=d0_in;
                        d1_in_aux   :=d1_in;
                    when s2=>
                        presente <= s3;
                        En_SBox_out <= '1';
                        En_SBox_out_Aux := '1';
                        a0_in_aux := a0_in_aux xor (b0_in_aux AND c0_in_aux);
                        a1_in_aux := a1_in_aux xor (b1_in_aux AND c1_in_aux);
                    when s3=>
                        presente <= s4;
                        En_SBox_out <= '1';
                        En_SBox_out_Aux := '1';
                        a0_out   <=a0_in_aux;
                        a1_out   <=a1_in_aux;
                        b0_in_aux := b0_in_aux xor (a0_in_aux or d0_in_aux);
                        b1_in_aux := b1_in_aux xor (a1_in_aux or d1_in_aux);
                    when s4=>
                        presente <= s5;
                        En_SBox_out <= '1';
                        En_SBox_out_Aux := '1';
                        b0_out  <=b0_in_aux;
                        b1_out  <=b1_in_aux;
                        d0_in_aux := d0_in_aux xor (b0_in_aux or c0_in_aux);
                        d1_in_aux := d1_in_aux xor (b1_in_aux or c1_in_aux);
                    when s5=>
                        presente <= s6;
                        En_SBox_out <= '1';
                        En_SBox_out_Aux := '1';
                        d0_out   <=d0_in_aux;
                        d1_out   <=d1_in_aux;
                        c0_in_aux := c0_in_aux xor (b0_in_aux and d0_in_aux);
                        c1_in_aux := c1_in_aux xor (b1_in_aux and d1_in_aux);
                    when s6=>
                        presente <= s7;
                        En_SBox_out <= '1';
                        En_SBox_out_Aux := '1';
                        c0_out <=c0_in_aux;
                        c1_out <=c1_in_aux;
                        b0_in_aux := b0_in_aux xor (a0_in_aux or c0_in_aux);
                        b1_in_aux := b1_in_aux xor (a1_in_aux or c1_in_aux);
                    when s7=>
                        presente <= s8;
                        En_SBox_out <= '0';
                        En_SBox_out_Aux := '1';
                        a0_in_aux := a0_in_aux xor (b0_in_aux or d0_in_aux);
                        a1_in_aux := a1_in_aux xor (b1_in_aux or d1_in_aux);
                    when s8=>
                        presente <=s0;
                        a0_out <= a0_in_aux;
                        a1_out <= a1_in_aux;
                        b0_out <= b0_in_aux;
                        b1_out <= b1_in_aux;
                        c0_out <= c0_in_aux;
                        c1_out <= c1_in_aux;
                        d0_out <= d0_in_aux;
                        d1_out <= d1_in_aux;
                        En_SBox_out <= '0';
                        En_SBox_out_Aux := '0';
                    when others => null;
                end case;
            else
                    En_SBox_out_Aux := '1';
                    En_SBox_out <= '1';
            end if;
        end if;
    end process ASM;
end Main;