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
        RC0         : out std_logic_vector(0 to 15);
        RC1         : out std_logic_vector(0 to 15);
        R           : in std_logic_vector (3 downto 0);
        D           : in std_logic_vector (3 downto 0);
        Addr_rRd_0  : in std_logic_vector (4 downto 0);
        Addr_rRd_1  : in std_logic_vector (4 downto 0);
        rRd_En_0    : in std_logic;
        rRd_En_1    : in std_logic;
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
component Register_A
    generic(
        w:integer--width of word
    );
    port (
        DD_IN  : in  std_logic_vector (w-1 downto 0);
        DD_OUT : out std_logic_vector (w-1 downto 0);
        Clk    : in  std_logic

    );
end component Register_A;
component Register_Logic 
    
    port (
        DD_IN  : in  std_logic;
        DD_OUT : out std_logic;
        Clk    : in  std_logic

    );
end component Register_Logic;
    --Signals for two variables R_x0 and x1 
    --Two Memory Banks
signal    x0: std_logic_vector (15 downto 0);
signal    x1: std_logic_vector (15 downto 0);
signal    R_x0: std_logic_vector (15 downto 0);
signal    R_x1: std_logic_vector (15 downto 0);
signal    Rn_0,Rn_1 : STD_LOGIC_VECTOR (4 downto 0 ) :="00000";
signal    Addr_Wr_0,Addr_Wr_1 : STD_LOGIC_VECTOR (4 downto 0);
signal    Wr_En_0,Wr_En_1,Rst_0,Rst_1 : std_logic;
signal    Wr_REn_0,Wr_REn_1,RRst_0,RRst_1 : std_logic;

--
--Signal fos Register IN from Main Program    
signal Addr_Rd_0 : std_logic_vector (4 downto 0);
signal Addr_Rd_1 : std_logic_vector (4 downto 0);
signal Rd_En_0   : std_logic;
signal Rd_En_1   : std_logic;
type estado is (s0, s1,s2,s3,s4,s5);
signal presenteX0:estado:=s0;
signal presenteX1:estado:=s0;
begin

u_R0: MemBnk 
    generic map(w => 16,
                d => 32,
                a => 5
    )
    PORT MAP(   Wr_En    =>Wr_En_0,
                Rd_En    =>rRd_En_0,
                Rst      =>Rst_0,
                clk      =>clk,
                Addr_In  =>Addr_Wr_0,
                Addr_Out =>Addr_rRd_0,
                Data_in  =>x0,
                Data_Out =>RC0
    );
Rin0_EnWr:  Register_Logic  
    Port map (
    DD_IN  => Wr_REn_0,
    DD_OUT => Wr_En_0,
    Clk    => clk
    );
Rin0_EnRd:  Register_Logic  
    Port map (
    DD_IN  => rRd_En_0,
    DD_OUT => Rd_En_0,
    Clk    => clk
    );
Rin0_Rst:  Register_Logic  
    Port map (
    DD_IN  => RRst_0,
    DD_OUT => Rst_0,
    Clk    => clk
    );
Rin0_AdrrWr :  Register_A 
    generic map (
        w => 5
    ) 
    Port map (
    DD_IN  => Rn_0,
    DD_OUT => Addr_Wr_0,
    Clk    => clk
    );
Rin0_AdrrRd :  Register_A 
    generic map (
        w => 5
    ) 
    Port map (
    DD_IN  => Addr_rRd_0,
    DD_OUT => Addr_Rd_0,
    Clk    => clk
    );
Rin0_MB :  Register_A 
    generic map (
        w => 16
    ) 
    Port map (
    DD_IN  => R_x0,
    DD_OUT => x0,
    Clk    => clk
    );
---------
u_R1: MemBnk 
    generic map(w => 16,
                d => 32,
                a => 5
    )
    PORT MAP(   Wr_En    =>Wr_En_1,
                Rd_En    =>rRd_En_1,
                Rst      =>Rst_1,
                clk      =>clk,
                Addr_In  =>Addr_Wr_1,
                Addr_Out =>Addr_rRd_1,
                Data_in  =>x1,
                Data_Out =>RC1
    );
Rin1_EnWr:  Register_Logic  
    Port map (
    DD_IN  => Wr_REn_1,
    DD_OUT => Wr_En_1,
    Clk    => clk
    );
Rin1_EnRd:  Register_Logic  
    Port map (
    DD_IN  => rRd_En_1,
    DD_OUT => Rd_En_1,
    Clk    => clk
    );
Rin1_Rst:  Register_Logic  
    Port map (
    DD_IN  => RRst_1,
    DD_OUT => Rst_1,
    Clk    => clk
    );
Rin1_AdrrWr :  Register_A 
    generic map (
        w => 5
    ) 
    Port map (
    DD_IN  => Rn_1,
    DD_OUT => Addr_Wr_1,
    Clk    => clk
    );
Rin1_AdrrRd :  Register_A 
    generic map (
        w => 5
    ) 
    Port map (
    DD_IN  => Addr_rRd_1,
    DD_OUT => Addr_Rd_1,
    Clk    => clk
    );
Rin1_MB :  Register_A 
    generic map (
        w => 16
    ) 
    Port map (
    DD_IN  => R_x1,
    DD_OUT => x1,
    Clk    => clk
    );
---
process (x0,x1, clk,presenteX0, presenteX1)
variable i_0, i_1 : natural range 0 to 16 := 0;
variable nAux_0, nAux_1 : natural range 0 to 31 := 0;
begin
if (clk'event AND clk = '1') then    
        case presenteX0 is
            when s0 =>
                R_x0 <= "11111110"& R(3 downto 0) & D(3 downto 0);
                presenteX0 <= s1;
                Wr_REn_0   <='1';
                RRst_0     <='1';
                Rn_0       <="00000";
            when s1 =>
                if Rn_0 < R then 
                    if i_0 < 16 then                                                       
                        if R_x0(15)='1'  then    
                            presenteX0 <= s2;
                            R_x0 <= R_x0(R_x0'LENGTH-2 downto 0) & '0';
                        else
                            presenteX0 <= s1;
                            R_x0 <= R_x0(R_x0'LENGTH-2 downto 0) & '0';
                            i_0 := i_0 + 1;
                        end if;
                    else 
                        Wr_REn_0 <='0';
                        presenteX0 <= s3;
                        i_0 := 0;
                    end if;
                else
                    presenteX0 <= s4;
                end if;
            when s2 =>
                presenteX0 <= s1;
                i_0 := i_0 + 1;
                R_x0 <= R_x0(R_x0'LENGTH -1 downto 8) & (R_x0(7 downto 0)xor X"2D");            
            when s3 => 
                presenteX0 <= s1;
                Rn_0 <= Rn_0 + 1;
                Wr_REn_0 <='1';
            when s4 => 
                presenteX0 <= s5;
            when others => null;
        end case;
        case presenteX1 is
            when s0 =>
                R_x1 <= "11111110"& R(3 downto 0) & D(3 downto 0);
                presenteX1 <= s1;
                Wr_REn_1   <='1';
                RRst_1     <='1';
                Rn_1       <="00000";
            when s1 =>
                if Rn_1 < R then 
                    if i_1 < 16 then                                                       
                        if R_x1(15)='1'  then    
                            presenteX1 <= s2;
                            R_x1 <= R_x1(R_x1'LENGTH-2 downto 0) & '0';
                        else
                            presenteX1 <= s1;
                            R_x1 <= R_x1(R_x1'LENGTH-2 downto 0) & '0';
                            i_1 := i_1 + 1;
                        end if;
                    else 
                        Wr_REn_1 <='0';
                        presenteX1 <= s3;
                        i_1 := 0;
                    end if;
                else
                    presenteX1 <= s4;
                end if;
            when s2 =>
                presenteX1 <= s1;
                i_1 := i_1 + 1;
                R_x1 <= R_x1(R_x1'LENGTH -1 downto 8) & (R_x1(7 downto 0)xor X"53");            
            when s3 => 
                presenteX1 <= s1;
                Rn_1 <= Rn_1 + 1;
                Wr_REn_1 <='1';
            when s4 => 
                presenteX1 <= s5;
            when others => null;
        end case;
    end if;
end process;
end Main;
