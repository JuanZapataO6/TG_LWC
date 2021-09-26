library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use work.all;
--
entity RC_X is
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B  : out std_logic_vector(3 downto 0);
        Data_RIn_B : out std_logic_vector (15 downto 0);
        Wr_En_B    : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B  : out std_logic_vector(3 downto 0);
        Rd_En_B    : out std_logic;
        Data_Out_B : in std_logic_vector (15 downto 0);
        --Ports For Control Component
        i_Control : in std_logic_vector(4 DOWNTO 0);
        clk   : in std_logic; 
        En_In : in std_logic;
        En_Out : out std_logic
    );
end RC_X;
architecture Main of RC_X is 
component Make_Rounds is 
    port(
        RC0         : out std_logic_vector(0 to 15);
        RC1         : out std_logic_vector(0 to 15);
        R           : in std_logic_vector (3 downto 0);
        D           : in std_logic_vector (3 downto 0);
        Addr_RRd_0  : in std_logic_vector (4 downto 0);
        Addr_RRd_1  : in std_logic_vector (4 downto 0);
        rRd_En_0    : in std_logic;
        rRd_En_1    : in std_logic;
        clk         : in std_logic);
end component Make_Rounds;
TYPE estado is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;
signal RC0 : std_logic_vector (15 downto 0);
signal RC1 : std_logic_vector (15 downto 0);
signal R_MR : std_logic_vector (3 downto 0):=x"A";
signal D_MR : std_logic_vector (3 downto 0):=x"6";
signal Rd_En_MR0,Rd_En_MR1 : std_logic;
begin
--
uMKRd: Make_Rounds
    port map (
        RC0         =>RC0,
        RC1         =>RC1,
        R           =>R_MR,
        D           =>D_MR,
        Addr_RRd_0  =>i_Control,--Addr_Rd,--
        Addr_RRd_1  =>i_Control,--Addr_Rd,--
        rRd_En_0    =>Rd_En_MR0,--Rd_En,--
        rRd_En_1    =>Rd_En_MR1,--Rd_En,--
        clk         =>clk);

process(clk,presente)
begin
    if clk 'event and clk = '1' then 
        if En_In = '1' then  
            case presente is 
                when s0 =>--start no signals 
                    presente  <= s1;
                    Addr_Rd_B <= x"0";
                    Addr_Wr_B <= x"0";
                    Data_RIn_B <= x"8787";
                    En_Out <= '0';
                    Rd_En_B   <= '1';
                    Wr_En_B   <= '1';
                    Rd_En_MR0 <= '1';
                    Rd_En_MR1 <= '1';              
                when s1=>
                    presente <= s2;
                    Addr_Rd_B <=x"0";
                    Addr_Wr_B <=x"0";
                    Wr_En_B   <='1';
                    Rd_En_B   <='0';
                    Rd_En_MR0 <='0';
                    Rd_En_MR1 <='1';
                    En_Out    <='0';
                when s2 =>
                    presente  <= s3;
                    Addr_Rd_B <=x"8";
                    Addr_Wr_B <=x"0";
                    Data_RIn_B <= x"8787";
                    En_Out <= '0';
                    Rd_En_B  <= '0';
                    Rd_En_MR0 <= '1';
                    Rd_En_MR1 <= '0';
                    Wr_En_B   <= '1';                
                when s3=>
                    presente <= s4;
                    Addr_Rd_B <=x"8";
                    Addr_Wr_B <=x"0";
                    Wr_En_B   <='1';
                    Rd_En_B   <='1';
                    En_Out    <='0';
                when s4=>
                    presente <= s5;
                    Addr_Rd_B <=x"8";
                    Addr_Wr_B <=x"0";
                    Wr_En_B   <='1';
                    Rd_En_B   <='1';
                    En_Out    <='0';
                when s5=>
                    presente <= s6;
                    Addr_Rd_B <=x"8";
                    Data_RIn_B <=RC0 XOR Data_Out_B;--
                    Addr_Wr_B <=x"0";
                    Wr_En_B   <='0';
                    Rd_En_B   <='0';
                    En_Out    <='0';
                when s6=>
                    presente <= s7;
                    Addr_Rd_B <=x"8";
                    Data_RIn_B <=RC1 XOR Data_Out_B;--  
                    Addr_Wr_B <=x"8";
                    Wr_En_B   <='0';
                    Rd_En_B   <='0';
                    En_Out    <='0';
                when s7=>
                    presente <= s8;
                    Addr_Rd_B <=x"8";
                    Addr_Wr_B <=x"0";
                    Wr_En_B   <='1';
                    Rd_En_B   <='0';
                    En_Out    <='1';
                when s8=>
                    presente <= s0;
                    Addr_Rd_B <=x"8";
                    Addr_Wr_B <=x"0";
                    Wr_En_B   <='1';
                    Rd_En_B   <='0';
                    En_Out    <='0';
                when others => null;
            end case;
        end if;
    end if;
end process;
end Main; 