LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity Saturnin_Tb is 
    port(
        En_Ad    :in  std_logic;
        Rd_En : IN std_logic;
        Addr_Rd : IN std_logic_vector (3 DOWNTO 0);
        Sel_O      : Out  std_logic_vector (3 downto 0);
        Data_Out_T : Out std_logic_vector (15 downto 0);
        A0 : out std_logic_vector (15 downto 0);
        B0 : out std_logic_vector (15 downto 0);
        C0 : out std_logic_vector (15 downto 0);
        D0 : out std_logic_vector (15 downto 0);
        A1 : out std_logic_vector (15 downto 0);
        B1 : out std_logic_vector (15 downto 0);
        C1 : out std_logic_vector (15 downto 0);
        D1 : out std_logic_vector (15 downto 0);
        Hex0 :out std_logic_vector(6 downto 0);
        Hex1 :out std_logic_vector(6 downto 0);
        Hex2 :out std_logic_vector(6 downto 0);
        Hex3 :out std_logic_vector(6 downto 0);
        clk : IN std_logic;
        --SERIN 	: IN std_logic
        En 	: IN std_logic;
        Addr_Rd_Ct : IN std_logic_vector (5 DOWNTO 0);
        Rd_En_Ct : IN std_logic;
        Data_Out_Ct: OUT std_logic_vector (15 downto 0)
        
    );
end Saturnin_Tb;

architecture RTL of Saturnin_Tb is
component Saturnin_Block_EncryptV2
    port(
        En_Ad :in  std_logic;
        Rd_En : IN std_logic;
        Addr_Rd : IN std_logic_vector (3 DOWNTO 0);
        Data_Out_T : Out std_logic_vector (15 downto 0);
        Sel_O      : Out  std_logic_vector (3 downto 0);
        RSTn  : IN std_logic;
        clk   : IN std_logic;
        SERIN : IN std_logic;
        A0 : out std_logic_vector (15 downto 0);
        B0 : out std_logic_vector (15 downto 0);
        C0 : out std_logic_vector (15 downto 0);
        D0 : out std_logic_vector (15 downto 0);
        A1 : out std_logic_vector (15 downto 0);
        B1 : out std_logic_vector (15 downto 0);
        C1 : out std_logic_vector (15 downto 0);
        D1 : out std_logic_vector (15 downto 0);
        Rd_En_Ct   : IN std_logic;
        Addr_Rd_Ct : IN std_logic_vector  (5 DOWNTO 0);
        Data_rOut_Ct: OUT std_logic_vector (15 downto 0));
end component;

TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;
function BCD2Seg (BCD : in std_logic_vector) return std_logic_vector is
        variable Seg : std_logic_vector(6 downto 0) ;
begin
    if    BCD= x"0" then Seg :="0000001";
    elsif BCD= x"1" then Seg :="1001111";
    elsif BCD= x"2" then Seg :="0010010";
    elsif BCD= x"3" then Seg :="0000110";
    elsif BCD= x"4" then Seg :="1001100";
    elsif BCD= x"5" then Seg :="0100100";
    elsif BCD= x"6" then Seg :="0100000";
    elsif BCD= x"7" then Seg :="0001111";
    elsif BCD= x"8" then Seg :="0000000";
    elsif BCD= x"9" then Seg :="0001100";
    elsif BCD= x"A" then Seg :="0001000";
    elsif BCD= x"B" then Seg :="1100000";
    elsif BCD= x"C" then Seg :="0110001";
    elsif BCD= x"D" then Seg :="1000010";
    elsif BCD= x"E" then Seg :="0110000";
    elsif BCD= x"F" then Seg :="0111000";
    else  Seg := "0000000"; 
    end if;
    return Seg;
end function;

signal RSTn, SERIN : std_logic;
signal Data_Out: std_logic_vector (15 downto 0);
--signal 	Clk  : STD_LOGIC := '0';
begin
--reloj:process
--begin
--clk <= '0';
--wait for 12.5 ns;
--clk <= '1';
--wait for 12.5 ns;
--end process reloj;
u1: Saturnin_Block_EncryptV2
    PORT MAP (
        En_Ad => En_Ad,
        Rd_En   =>Rd_En,
        Addr_Rd => Addr_Rd,
        Data_Out_T=> Data_Out,
        Sel_O => Sel_O,
        RSTn  => RSTn,
        clk   => clk,
        SERIN => SERIN,
        A0 =>A0,
        B0 => B0,
        C0 => C0,
        D0 => D0,
        A1 => A1,
        B1 => B1,
        C1 => C1,
        D1 => D1,
        Rd_En_Ct   => Rd_En_Ct,
        Addr_Rd_Ct => Addr_Rd_Ct,
        Data_rOut_Ct=> Data_Out_Ct
    );
STAt: process(Clk,presente)
variable data :std_logic_vector(7 downto 0):=x"00";
variable index : integer range 0 to 8 := 0;
BEGIN
    if clk'event and clk='1' then 
        Hex0<= BCD2Seg(Data_Out(3 downto 0));
        Hex1<= BCD2Seg(Data_Out(7 downto 4));
        Hex2<= BCD2Seg(Data_Out(11 downto 8));
        Hex3<= BCD2Seg(Data_Out(15 downto 12));
        Data_Out_T <= Data_Out;
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