LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity DG_Tb is 
    port( 
        Clk   : in STD_LOGIC := '0';
        Rd_En_K :in  std_logic;
        Rd_En_A :in  std_logic;
        Rd_En_N :in  std_logic;
        Ena_Out :out std_logic;
        Hex0 :out std_logic_vector(6 downto 0);
        Hex1 :out std_logic_vector(6 downto 0);
        Hex2 :out std_logic_vector(6 downto 0);
        Hex3 :out std_logic_vector(6 downto 0);
        Hex4 :out std_logic_vector(6 downto 0);
        Hex5 :out std_logic_vector(6 downto 0);
        Addr_Out :in  std_logic_vector(4 downto 0)
        
    );
end DG_Tb;

architecture RTL of DG_Tb is
component Data_Generate
    port (
        Clk           :in  std_logic;
        Rd_En_K       :in  std_logic;
        Rd_En_A       :in  std_logic;
        Rd_En_N       :in  std_logic;
        Ena_Out       :out std_logic;
        Addr_Out_K    :in  std_logic_vector(3 downto 0);
        Addr_Out_N    :in  std_logic_vector(3 downto 0);
        Addr_Out_A    :in  std_logic_vector(4 downto 0);
        Data_Out_K    :out STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_A    :out STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_N    :out STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
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
signal  Data_Out_K :STD_LOGIC_VECTOR(7 DOWNTO 0);
signal  Data_Out_A :STD_LOGIC_VECTOR(7 DOWNTO 0);
signal  Data_Out_N :STD_LOGIC_VECTOR(7 DOWNTO 0);

Signal Addr_Out_K :std_logic_vector(3 downto 0);
Signal Addr_Out_N :std_logic_vector(3 downto 0);
Signal Addr_Out_A :std_logic_vector(4 downto 0);
        
begin

u1: Data_Generate
    port map (
        Clk           =>Clk,
        Rd_En_K       =>Rd_En_K,
        Rd_En_A       =>Rd_En_A,
        Rd_En_N       =>Rd_En_N,
        Ena_Out       =>Ena_Out,
        Addr_Out_K    =>Addr_Out_K,
        Addr_Out_N    =>Addr_Out_N,
        Addr_Out_A    =>Addr_Out_A,
        Data_Out_K    =>Data_Out_K,
        Data_Out_A    =>Data_Out_A,
        Data_Out_N    =>Data_Out_N
    );
STAt: process(Clk,presente)
variable data :std_logic_vector(7 downto 0):=x"00";
variable index : integer range 0 to 8 := 0;
BEGIN
    if clk'event and clk='1' then 
        Hex0<= BCD2Seg(Data_Out_K(3 downto 0));
        Hex1<= BCD2Seg(Data_Out_K(Data_Out_K'length-1 downto 4));
        Hex2<= BCD2Seg(Data_Out_A(3 downto 0));
        Hex3<= BCD2Seg(Data_Out_A(Data_Out_A'length-1 downto 4));
        Hex4<= BCD2Seg(Data_Out_N(3 downto 0));
        Hex5<= BCD2Seg(Data_Out_N(Data_Out_N'length-1 downto 4));
        Addr_Out_A <=Addr_Out;
        Addr_Out_K <=Addr_Out(Addr_Out'length-2 downto 0);
        Addr_Out_N <=Addr_Out(Addr_Out'length-2 downto 0);
    end if;
end process STAt;
end architecture RTL; 