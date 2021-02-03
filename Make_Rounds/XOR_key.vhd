library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity XOR_key is 
    port (
        --Addr_Out_B  : out std_logic_vector(3 downto 0);
        --Addr_Out_K  : out std_logic_vector(3 downto 0);
        --Addr_In_B   : out std_logic_vector(3 downto 0);
        state      : in std_logic_vector (0 to 15);
        key        : in std_logic_vector (0 to 15);
        clk        : in std_logic; 
        En_In      : in std_logic;
        En_Out     : out std_logic;
        state_out  : out std_logic_vector (0 to 15)
        
    );
end XOR_key;
architecture Main of XOR_key is 
signal i : std_logic_vector(3 downto 0);
type estado is (s0, s1,s2,s3);
signal presente:estado:=s0;
begin
    process (Clk)
    begin
    if (CLK'event AND CLK = '1') then 
        if En_In = '0' then 
            state_out <= state XOR key;
            En_Out <='1';
        else 
            En_Out <= '0';
        end if;
    end if;
end process;
end Main;