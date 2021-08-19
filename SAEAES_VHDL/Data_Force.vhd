library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
USE ieee.numeric_std.ALL;
use work.all;

entity Data_Force is
    port( 
        clk            :in  std_logic;
        DIn            :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        --Ports for Data Generate
        En_In          :in  std_logic;
        --Ports for MemBnk Write
        Data_Out       :out std_logic_vector (7 DOWNTO 0);
        Addr_Rd        :in  std_logic_vector (4 DOWNTO 0);
        Rd_En          :in  std_logic;
        --Ports Of fininish 
        En_Out      :out std_logic
    );
end Data_Force;
architecture RTL of Data_Force is 
component MemBnk
    generic(    
        w:integer;--width of word
        d:integer;--Numbers of words 
        a:integer --width of Address
    );
    port( 
        Wr_En    : in  std_logic;
        Rd_En    : in  std_logic;
        Rst      : in  std_logic;
        Clk      : in  std_logic;
        Addr_In  : in  std_logic_vector (a-1 downto 0);
        Addr_Out : in  std_logic_vector (a-1 downto 0);
        Data_in  : in  std_logic_vector (w-1 downto 0);
        Data_Out : out std_logic_vector (w-1 downto 0)
    );
end component MemBnk;
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

TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7);
SIGNAL presente:estado:=s0;
signal Addr_Wr,Addr_rWr      : std_logic_vector (4 DOWNTO 0):="00000";
signal Addr_rRd      : std_logic_vector (4 DOWNTO 0):="00000";
signal Data_In,Data_rIn     : std_logic_vector (7 DOWNTO 0);
signal Wr_En,rWr_En : std_logic;
signal rRd_En : std_logic;
signal En_rIn, Rst       : std_logic;

begin
uReg_In: Register_Logic
    port map(
        DD_IN  => En_In,
        DD_OUT => En_rIn,
        Clk    => clk
    );
uReg_Rd: Register_Logic
    port map(
        DD_IN  => Rd_En,
        DD_OUT => rRd_En,
        Clk    => clk
    );
uReg_Wr: Register_Logic
    port map(
        DD_IN  => Wr_En,
        DD_OUT => rWr_En,
        Clk    => clk
    );
uReg_AddrWr :Register_A
    generic map(
        w => 5--width of word
    )
    port map (
        DD_IN  =>Addr_Wr,
        DD_OUT =>Addr_rWr,
        Clk    =>clk
    );
uReg_AddrRd :Register_A
    generic map(
        w => 5--width of word
    )
    port map (
        DD_IN  =>Addr_Rd,
        DD_OUT =>Addr_rRd,
        Clk    =>clk
    );
uReg_DataIn :Register_A
    generic map(
        w => 8--width of word
    )
    port map(
        DD_IN  =>Data_In,
        DD_OUT =>Data_rIn,
        Clk    =>clk
    );
uReg_Data:MemBnk
    generic map(
        w => 8,
        d => 32,
        a => 5
    )
    Port Map (
        Wr_En    => rWr_En,
        Rd_En    => rRd_En,
        Rst      => Rst,
        Clk      => clk,
        Addr_In  => Addr_rWr,
        Addr_Out => Addr_rRd,
        Data_in  => Data_rIn,
        Data_Out => Data_Out
    );
    
STat: process(clk,presente)
variable Addr_Aux : std_logic_vector(5 downto 0):="000000";
begin
if clk 'event and clk = '1' then
    if Addr_Aux < "100000" then
        case presente is
               
            when s0 =>
                if En_In ='1' then
                    presente <= s1;
                    Addr_Wr  <= Addr_Aux(Addr_Aux'length -2 downto 0);
                    Wr_En    <= '0';
                    Data_In  <= DIn;
                else 
                    presente <= s0;
                    En_Out   <= '0';
                end if;
            when s1 =>
                presente <= s2;
                Addr_Aux  := Addr_Aux+1;
                Wr_En    <= '1';
            when s2 =>
                presente    <= s3;
            when s3 =>
                --En_Out <= '1';
                presente    <= s0;
            when others => null;
        end case;
    else 
        En_Out<= '1';
    end if;
end if;
end process STat;
end RTL;