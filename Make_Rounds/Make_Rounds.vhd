library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
USE ieee.numeric_std.ALL; 
use ieee.std_logic_arith.all;
use work.all;

entity Make_Rounds is 
    port(
        RC0         : inout std_logic_vector(0 to 15);
        RC1         : inout std_logic_vector(0 to 15);
        R           : in std_logic_vector (3 downto 0);
        D           : in std_logic_vector (3 downto 0);
        Addr_Out0   : in std_logic_vector (4 downto 0);
        Addr_Out1   : in std_logic_vector (4 downto 0);
        Rd_En_0     : in std_logic;
        Rd_En_1     : in std_logic;
        Load        : in std_logic;
        clk         : in std_logic
    );
    end Make_Rounds;
architecture Main of Make_Rounds is
    component MemBnk
        generic(w:integer;--width of word
                d:integer;--Numbers of words 
                a:integer --width of Address
        );
        port( 
        Wr_En    : in  std_logic;
        Rd_En    : in  std_logic;
        Rst      : in  std_logic;
        clk      : in  std_logic;
        Addr_In  : in  std_logic_vector (a-1 downto 0);
        Addr_Out : in  std_logic_vector (a-1 downto 0);
        Data_in  : in  std_logic_vector (w-1 downto 0);
        Data_Out : out std_logic_vector (w-1 downto 0)
        );  
    end component;
    --Signals for two variables x0 and x1 
    --Two Memory Banks
    signal    x0: std_logic_vector (15 downto 0);
    signal    x1: std_logic_vector (15 downto 0);
    signal    n_0,n_1 : STD_LOGIC_VECTOR (0 to 4) :="00000";
    signal    Wr_En_0,Wr_En_1,Rst : std_logic;
    
    type estado is (s0, s1,s2,s3);
    signal presenteX0:estado:=s0;
    signal presenteX1:estado:=s0;
    begin

u_X0: MemBnk 
    generic map(w => 16,
                d => 32,
                a => 5
    )
    PORT MAP(   Wr_En    =>Wr_En_0,
                Rd_En    =>Rd_En_0,
                Rst      =>Rst,
                clk      =>clk,
                Addr_In  =>n_0,
                Addr_Out =>Addr_Out0,
                Data_in  =>x0,
                Data_Out =>RC0
    );
u_X1: MemBnk 
    generic map(w => 16,
                d => 32,
                a => 5
    )
    PORT MAP (  Wr_En    =>Wr_En_1,
                Rd_En    =>Rd_En_1,
                Rst      =>Rst,
                clk      =>clk,
                Addr_In  =>n_1,
                Addr_Out =>Addr_Out1,
                Data_in  =>x1,
                Data_Out =>RC1
    );
    process (x0,x1, clk,presenteX0, presenteX1)
        variable i_0, i_1 : natural range 0 to 16 := 0;
        variable nAux_0, nAux_1 : natural range 0 to 31 := 0;
        begin
        if (clk'event AND clk = '1') then    
            
            if Load = '1'then --El valor de Load se remplaza por el de n
                x0 <= "11111110"& R(3 downto 0) & D(3 downto 0);
                x1 <= "11111110"& R(3 downto 0) & D(3 downto 0);
            else
                if n_0 < R then 
                    if i_0 < 16 then
                        case presenteX0 is
                            when s0 =>
                                Wr_En_0 <='1';
                                Rst     <='1';                                
                                if x0(15)='1'  then    
                                    presenteX0 <= s1;
                                    x0 <= x0(x0'LENGTH-2 downto 0) & '0';    
                                else
                                    presenteX0 <= s0;
                                    Wr_En_0 <='0';
                                    i_0 := i_0 + 1;
                                    x0 <= x0(x0'LENGTH-2 downto 0) & '0';
                                end if;
                            when s1 =>
                                presenteX0 <= s0;
                                Wr_En_0 <='0';
                                i_0 := i_0 + 1;
                                x0 <= x0(x0'LENGTH -1 downto 8) & (x0(7 downto 0)xor X"2D");
                            when others => null;
                        end case;
                    else 
                        i_0  :=0;                        
                        n_0  <= n_0+1;                        
                        Rst     <='1';
                    end if;
                end if;
                if n_1< R then
                    if i_1 < 16 then   
                    case presenteX1 is
                        when s0 =>
                            
                            Wr_En_1 <='1';
                            Rst     <='1';
                            if x1(15)='1' then
                                presenteX1 <= s1;
                                x1 <= x1(x1'LENGTH-2 downto 0) & '0';
                            else 
                                presenteX1 <= s0;
                                Wr_En_1 <='0';
                                i_1 := i_1 + 1;
                                x1 <= x1(x1'LENGTH-2 downto 0) & '0';     
                            end if;
                        when s1 =>
                            presenteX1 <= s0;
                            Wr_En_1 <='0';
                            i_1 := i_1 + 1;
                            x1 <= x1(x1'LENGTH -1 downto 8) & (x1(7 downto 0) xor X"53");
                        when others => null;
                    end case;
                    else 
                        i_1  :=0;
                        n_1  <= n_1+1;                        
                        Rst     <='1';
                    end if;
                end if;
            end if;
        end if;
    end process;
    --RC0 <= x0;
    --RC1 <= x1;
end Main;
