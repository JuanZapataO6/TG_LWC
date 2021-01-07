library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;

entity Make_Rounds is 
    port(
        RC0 : inout std_logic_vector(0 to 15);
        RC1 : inout std_logic_vector(0 to 15);
        R   : in std_logic_vector (3 downto 0);
        D   : in std_logic_vector (3 downto 0);
        CLK : in std_logic;
        Load: in std_logic
    );
    end Make_Rounds;
architecture Main of Make_Rounds is
    component MemBnk
        port (
            RCin    : in  std_logic_vector (0 to 15);
            Address : in  std_logic_vector (0 to 3);
            Load    : in  std_logic;
            Rst     : in  std_logic;
            Clk     : in  std_logic;
            RCout   : out std_logic_vector (0 to 15)
        );
    end component;
    signal    x0: std_logic_vector (15 downto 0);
    signal    x1: std_logic_vector (15 downto 0);
    signal    n : STD_LOGIC_VECTOR (0 to 3);
    signal    i : STD_LOGIC_VECTOR (7 DOWNTO 0);
    signal    Ld,Rst : std_logic;
    type estado is (s0, s1,s2,s3);
    signal presenteX0:estado:=s0;
    signal presenteX1:estado:=s0;
    begin

u_X0: MemBnk PORT MAP (RCin     => x0,
                        RCout   => RC0,
                        Address => n,
                        Rst     => Rst,
                        Clk     => CLK, 
                        Load    => Ld    
);
u_X1: MemBnk PORT MAP (RCin     => x1,
                        RCout   => RC1,
                        Address => n,
                        Rst     => Rst,
                        Clk     => CLK, 
                        Load    => Ld    
);
    process (x0,x1, CLK,presenteX0, presenteX1)
        begin
        if (CLK'event AND CLK = '1') then    
            if load = '1'then --El valor de Load se remplaza por el de n
                x0 <= "11111110"& R(3 downto 0) & D(3 downto 0);
                x1 <= "11111110"& R(3 downto 0) & D(3 downto 0);
            elsif i< 16 then
                case presenteX0 is
                    when s0 =>
                        i <= i + 1;
                        Ld <= '0';
                        if x0(15)='1'  then    
                            presenteX0 <= s1;
                            x0 <= x0(x0'LENGTH-2 downto 0) & '0';    
                        else
                            presenteX0 <= s0;
                            x0 <= x0(x0'LENGTH-2 downto 0) & '0';
                        end if;
                    when s1 =>
                        presenteX0 <= s0;
                        x0 <= x0(x0'LENGTH -1 downto 8) & (x0(7 downto 0)xor X"2D");
                    when others => null;
                end case;    
                case presenteX1 is
                    when s0 =>
                        if x1(15)='1' then
                            presenteX1 <= s1;
                            x1 <= x1(x1'LENGTH-2 downto 0) & '0';
                        else 
                            presenteX1 <= s0;
                            x1 <= x1(x1'LENGTH-2 downto 0) & '0';     
                        end if;
                    when s1 =>
                        presenteX1 <= s0;
                        x1 <= x1(x1'LENGTH -1 downto 8) & (x1(7 downto 0) xor X"53");
                    when others => null;
                    end case;
            else 
                    i<=(OTHERS => '0');
                    n <= n+1;
                    Ld <= '1';

            end if;
        end if;
    end process;
    --RC0 <= x0;
    --RC1 <= x1;
end Main;
