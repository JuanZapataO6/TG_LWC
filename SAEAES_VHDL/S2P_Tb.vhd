LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity S2P_Tb is 
end S2P_Tb;

architecture RTL of S2P_Tb is
component S2P
    port(
        RSTn 	: IN std_logic;
        CLOCK 	: IN std_logic;
        SERIN 	: IN std_logic;
        PERRn 	: OUT std_logic;
        DRDY 	: OUT std_logic;
        DOUT 	: OUT std_logic_vector (7 downto 0)
        );
end component;
component Data_Force
    port( 
        clk            :in  std_logic;
        DIn        :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        --Ports for Data Generate
        En_In          :in  std_logic;
        --Ports for MemBnk Write
        Data_Out       :out std_logic_vector (7 DOWNTO 0);
        Addr_Rd        :in  std_logic_vector (4 DOWNTO 0);
        Rd_En          :in  std_logic;
        --Ports Of fininish 
        En_Out      :out std_logic
    );
end component;
TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;

signal  RSTn, SERIN, PERRn, DRDY : std_logic;
signal  DOUT : std_logic_vector (7 downto 0);
signal  D_OUT : std_logic_vector (7 downto 0);
signal  Addr_OUT : std_logic_vector (4 downto 0);
signal  Rd_En, En_DF : std_logic;
signal 	Clk  : STD_LOGIC := '0';
begin
reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
end process reloj;
u1: S2P 
    PORT MAP (
        RSTn 	=> RSTn,
        CLOCK 	=> Clk,
        SERIN 	=> SERIN,
        PERRn 	=> PERRn,
        DRDY 	=> DRDY,
        DOUT 	=> DOUT
    );
u2: Data_Force
    port map( 
        clk      =>clk,
        DIn      =>DOUT,
        En_In    =>DRDY,
        Data_Out =>D_OUT,
        Addr_Rd  =>Addr_OUT,
        Rd_En    =>Rd_En,
        En_Out   =>En_DF
    );
STAt: process(Clk,presente)
variable data :std_logic_vector(7 downto 0):=x"00";
variable index : integer range 0 to 8 := 0;
BEGIN
    if clk'event and clk='1' then 
        case presente is
            when s0=>
                presente<=S1;
                RSTn  <= '0';
                SERIN <= '1';
            when s1=>
                presente<=S2;
                RSTn  <= '1';
                SERIN <= '1';
            when s2=>
                if index < 8 then  
                    presente<=S2;
                    SERIN <= data(index);
                    index := index + 1;
                else 
                    presente <=s3;
                end if;
                RSTn  <= '1';
            when s3=>
                presente<=S4;
                data:= data + 1;
                index := 0;
                RSTn  <= '0';
            when s4=>
                presente<=S2;
                RSTn  <= '1';
                SERIN <= '1';
            when others => null; 
        end case;         
    end if;
end process STAt;
end architecture RTL; 