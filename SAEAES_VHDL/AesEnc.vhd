LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use ieee.std_logic_misc.all;
use work.Definitions.all;
entity AesEnc is
port (      
    En_In   : in std_logic; -- Flag for start FMS
    En_Out  : out std_logic;
    Clk     : in std_logic; -- Clock signal 
    --Read Memory bank of key from DataGenerate 
    Wr_En_eS   : out std_logic;
    Data_In_eS : out std_logic_vector (7 downto 0);  
    Addr_Wr_eS : out std_logic_vector (3 DOWNTO 0);

    Rd_En_eS    : out std_logic;
    Addr_Rd_eS  : out std_logic_vector (3 DOWNTO 0);
    Data_Out_eS : in  std_logic_vector (7 downto 0);

    --Rd_En : in std_logic;
    --Data_Out_T : out std_logic_vector (31 downto 0);
    --Index_T    : in std_logic_vector (5 DOWNTO 0);

    Rd_En_eK    : out std_logic;
    Addr_Rd_eK  : out std_logic_vector (5 DOWNTO 0);
    Data_Out_eK : in  std_logic_vector (31 downto 0)
);
end AesEnc;
architecture RTL of AesEnc is
TYPE estado is (s0,s1,s2,s3,s4,s5,s5_1,s6,s7,s7_1,s7_2,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,
                s21,s22,s23,s24,s25,s26,s27,s28,s29,s30,
                s31,s32,s33,s34,s35,s36,s37,s38,s39,
                s40,s41,s42,s43,s44,s45,s46,s47,s48,s49);
SIGNAL presente:estado:=s0;
begin 
STat: process (clk,presente)
type word is array (0 to 3) of std_logic_vector (31 downto 0);
type Words is array (0 to 43) of std_logic_vector (31 downto 0);
variable eSAux : word;
variable TAux : word;
variable eKeyAux : Words;
variable Addr_Aux_eS: std_logic_vector (1 downto 0) := "00";
variable Addr_Aux   : std_logic_vector (5 downto 0) := "000000";

begin 
if clk 'event and clk = '1' then
    if En_In = '1' then 
        case presente is
            when s0 =>
                presente <= s1;
                Rd_En_eK <= '0';
                Addr_Rd_eK <= Addr_Aux; --0
            when s1 =>
                presente <= s2;
                Addr_Aux := Addr_Aux + 1; 
                Rd_En_eK <= '0';
                Addr_Rd_eK <= Addr_Aux; --1
            when s2 => 
                presente <= s3;
                Addr_Aux := Addr_Aux + 1; 
                Rd_En_eK <= '0';
                Addr_Rd_eK <= Addr_Aux;--2 
            when s3 =>
                presente <=s4;
                Addr_Aux := Addr_Aux + 1;
                Addr_Rd_eK <= Addr_Aux;
            when s4=>
                Addr_Aux := Addr_Aux + 1;--3
                if Addr_Aux <= x"2B" then  
                    presente <= s4;
                    Rd_En_eK <= '0';
                    Addr_Rd_eK <= Addr_Aux;
                elsif Addr_Aux >= x"2E" then  
                    presente <= s5;
                    Rd_En_eK <= '1';
                end if;
                eKeyAux(to_integer(unsigned(Addr_Aux-4))) :=Data_Out_eK;
            when s5 => 
                presente <= s5_1;
                Rd_En_eK <= '1';                
                Rd_En_es <= '0';
                eKeyAux(to_integer(unsigned(Addr_Aux-3))) :=Data_Out_eK;
            when s5_1 => 
                presente <= s6;
                Addr_Aux := "000000";
                Rd_En_eK <= '1';                
            when s6 =>    
                presente <= s7;
                Rd_En_es <= '0';                
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);
            when s7 =>    
                presente <= s7_1;
                Rd_En_es <= '0';
                Addr_Aux := Addr_Aux + 1;--1
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--1
            when s7_1 =>
                presente <= s7_2;
                Rd_En_es <= '0';
                Addr_Aux := Addr_Aux + 1;--2
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--2
            when s7_2 =>
                presente <= s8;
                Rd_En_es <= '0';
                Addr_Aux := Addr_Aux + 1;--3
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--3
            when s8 =>
                presente <= s9;
                Rd_En_es <= '0';
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);
                eSAux(to_integer(unsigned(Addr_Aux_eS))):= x"000000" & Data_Out_eS;
                
            when s9 =>
                presente <= s10;
                Rd_En_es <= '1';
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);
                eSAux(to_integer(unsigned(Addr_Aux_eS))):= x"0000" & Data_Out_eS & eSAux(to_integer(unsigned(Addr_Aux_eS)))(7 downto 0);
                
            when s10 =>
                presente <= s11;
                Rd_En_es <= '1';
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);
                eSAux(to_integer(unsigned(Addr_Aux_eS))):= x"00" & Data_Out_eS & eSAux(to_integer(unsigned(Addr_Aux_eS)))(15 downto 0);
                
            when s11 =>
                presente <= s12;
                Rd_En_es <= '1';
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);
                eSAux(to_integer(unsigned(Addr_Aux_eS))):= Data_Out_eS & eSAux(to_integer(unsigned(Addr_Aux_eS)))(23 downto 0);
                
            when s12 =>
                if Addr_Aux_eS = "11" then
                    presente <= s13;
                else 
                    presente <= s6;
                    Addr_Aux_eS := Addr_Aux_eS + 1; 
                    Addr_Aux := Addr_Aux + 1;
                end if;
            when s13 =>
                presente <= s14;
                RK(eSAux(0),eKeyAux(0),eSAux(0));
                RK(eSAux(1),eKeyAux(1),eSAux(1));
                RK(eSAux(2),eKeyAux(2),eSAux(2));
                RK(eSAux(3),eKeyAux(3),eSAux(3));
            when s14 =>
                presente <= s15;
                SM(eSAux(0),eSAux(1),eSAux(2),eSAux(3),
                    TAux(0),TAux(1),TAux(2),TAux(3));
            when s15 =>
                presente <= s16;
                RK(TAux(0),eKeyAux(4),TAux(0));
                RK(TAux(1),eKeyAux(5),TAux(1));
                RK(TAux(2),eKeyAux(6),TAux(2));
                RK(TAux(3),eKeyAux(7),TAux(3));
            when s16 =>
                presente <= s17;
                SM(TAux(0),TAux(1),TAux(2),TAux(3),
                    eSAux(0),eSAux(1),eSAux(2),eSAux(3));
            when s17 =>
                presente <= s18;
                RK(eSAux(0),eKeyAux(8),eSAux(0));
                RK(eSAux(1),eKeyAux(9),eSAux(1));
                RK(eSAux(2),eKeyAux(10),eSAux(2));
                RK(eSAux(3),eKeyAux(11),eSAux(3));
            when s18 =>
                presente <= s19;
                SM(eSAux(0),eSAux(1),eSAux(2),eSAux(3),
                    TAux(0),TAux(1),TAux(2),TAux(3));
            when s19 =>
                presente <= s20;
                RK(TAux(0),eKeyAux(12),TAux(0));
                RK(TAux(1),eKeyAux(13),TAux(1));
                RK(TAux(2),eKeyAux(14),TAux(2));
                RK(TAux(3),eKeyAux(15),TAux(3));
            when s20 =>
                presente <= s21;
                SM(TAux(0),TAux(1),TAux(2),TAux(3),
                    eSAux(0),eSAux(1),eSAux(2),eSAux(3));
            when s21 =>
                presente <= s22;
                RK(eSAux(0),eKeyAux(16),eSAux(0));
                RK(eSAux(1),eKeyAux(17),eSAux(1));
                RK(eSAux(2),eKeyAux(18),eSAux(2));
                RK(eSAux(3),eKeyAux(19),eSAux(3));
            when s22 =>
                presente <= s23;
                SM(eSAux(0),eSAux(1),eSAux(2),eSAux(3),
                    TAux(0),TAux(1),TAux(2),TAux(3));
            when s23 =>
                presente <= s24;
                RK(TAux(0),eKeyAux(20),TAux(0));
                RK(TAux(1),eKeyAux(21),TAux(1));
                RK(TAux(2),eKeyAux(22),TAux(2));
                RK(TAux(3),eKeyAux(23),TAux(3));
            when s24 =>
                presente <= s25;
                SM(TAux(0),TAux(1),TAux(2),TAux(3),
                    eSAux(0),eSAux(1),eSAux(2),eSAux(3));
            when s25 =>
                presente <= s26;
                RK(eSAux(0),eKeyAux(24),eSAux(0));
                RK(eSAux(1),eKeyAux(25),eSAux(1));
                RK(eSAux(2),eKeyAux(26),eSAux(2));
                RK(eSAux(3),eKeyAux(27),eSAux(3));
            when s26 =>
                presente <= s27;
                SM(eSAux(0),eSAux(1),eSAux(2),eSAux(3),
                    TAux(0),TAux(1),TAux(2),TAux(3));
            when s27 =>
                presente <= s28;
                RK(TAux(0),eKeyAux(28),TAux(0));
                RK(TAux(1),eKeyAux(29),TAux(1));
                RK(TAux(2),eKeyAux(30),TAux(2));
                RK(TAux(3),eKeyAux(31),TAux(3));
            when s28 =>
                presente <= s29;
                SM(TAux(0),TAux(1),TAux(2),TAux(3),
                    eSAux(0),eSAux(1),eSAux(2),eSAux(3));     
            when s29 =>
                presente <= s30;
                RK(eSAux(0),eKeyAux(32),eSAux(0));
                RK(eSAux(1),eKeyAux(33),eSAux(1));
                RK(eSAux(2),eKeyAux(34),eSAux(2));
                RK(eSAux(3),eKeyAux(35),eSAux(3));
            when s30 =>
                presente <= s31;
                SM(eSAux(0),eSAux(1),eSAux(2),eSAux(3),
                    TAux(0),TAux(1),TAux(2),TAux(3));
            when s31 =>
                presente <= s32;
                RK(TAux(0),eKeyAux(36),TAux(0));
                RK(TAux(1),eKeyAux(37),TAux(1));
                RK(TAux(2),eKeyAux(38),TAux(2));
                RK(TAux(3),eKeyAux(39),TAux(3));
            when s32 =>
                presente <= s33;
                SS(TAux(0),TAux(1),TAux(2),TAux(3),
                    eSAux(0),eSAux(1),eSAux(2),eSAux(3));
            when s33 =>
                presente <= s34;
                RK(eSAux(0),eKeyAux(40),eSAux(0));
                RK(eSAux(1),eKeyAux(41),eSAux(1));
                RK(eSAux(2),eKeyAux(42),eSAux(2));
                RK(eSAux(3),eKeyAux(43),eSAux(3));
                Addr_Aux   :="000000";
                Addr_Aux_eS:= "00";
            when s34 =>
                presente   <= s35;
                Addr_Wr_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--0
                Wr_En_eS   <= '0';
                Data_In_eS <= eSAux(to_integer(unsigned(Addr_Aux_eS)))(7 downto 0);
            when s35 =>
                presente   <= s36;
                Addr_Aux   := Addr_Aux+1; --1
                Addr_Wr_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--1
                Wr_En_eS   <= '0';
                Data_In_eS <= eSAux(to_integer(unsigned(Addr_Aux_eS)))(15 downto 8);
            when s36 =>
                presente   <= s37;
                Addr_Aux   := Addr_Aux+1; --1
                Addr_Wr_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--2
                Wr_En_eS   <= '0';
                Data_In_eS <= eSAux(to_integer(unsigned(Addr_Aux_eS)))(23 downto 16);
            when s37 =>
                presente   <= s38;
                Addr_Aux   := Addr_Aux+1; --1
                Addr_Wr_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--3
                Wr_En_eS   <= '0';
                Data_In_eS <= eSAux(to_integer(unsigned(Addr_Aux_eS)))(31 downto 24);
            when s38 =>
                presente   <= s39;
                Wr_En_eS   <= '1';
            when s39 =>
                presente   <= s40;
                Wr_En_eS   <= '1';
            when s40 =>
                if Addr_Aux_eS < "11" then
                    presente   <= s34;
                else 
                    presente   <= s41;
                    En_Out <='1';
                end if; 
                Addr_Aux    := Addr_Aux+1; --1
                Addr_Aux_eS := Addr_Aux_eS+1;
            when s41 =>
                presente   <= s42;
                En_Out <='0';
            when s42 =>
                if En_In <= '1' then
                    presente   <= s5_1;
                else 
                    presente <= s42;
                    En_Out <='0';    
                end if;
            when others => null;
        end case;
    end if;
end if;
end process;                
end RTL;