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

    Rd_En_eK    : out std_logic;
    Addr_Rd_eK  : out std_logic_vector (5 DOWNTO 0);
    Data_Out_eK : in  std_logic_vector (31 downto 0)
);
end AesEnc;
architecture RTL of AesEnc is
TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;
signal witness_eSe   : std_logic_vector (31 downto 0);
signal witness_eSe_0 : std_logic_vector (31 downto 0);
signal witness_eSe_1 : std_logic_vector (31 downto 0);
signal witness_eSe_2 : std_logic_vector (31 downto 0);
signal witness_eSe_3 : std_logic_vector (31 downto 0);
signal witness_eKe   : std_logic_vector (31 downto 0);
signal witness_eKe_0 : std_logic_vector (31 downto 0);
signal witness_eKe_1 : std_logic_vector (31 downto 0);
signal witness_eKe_2 : std_logic_vector (31 downto 0);
signal witness_eKe_3 : std_logic_vector (31 downto 0);
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
                Addr_Rd_eK <= Addr_Aux; --0--4
                Rd_En_eS <= '0';
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--0
            when s1 =>
                presente <= s2;
                Addr_Aux := Addr_Aux + 1; 
                Rd_En_eK <= '0';
                Addr_Rd_eK <= Addr_Aux; --1--5
                Rd_En_eS <= '0';
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--1
            when s2 => 
                presente <= s3;
                Addr_Aux := Addr_Aux + 1; 
                Rd_En_eK <= '0';
                Addr_Rd_eK <= Addr_Aux; --2 --6
                Rd_En_eS <= '0';
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--2
            when s3 => 
                presente <= s4;
                Addr_Aux := Addr_Aux + 1; 
                Rd_En_eK <= '0';
                Addr_Rd_eK <= Addr_Aux; --3--7
                Rd_En_eS <= '0';
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);--3
                eSAux(to_integer(unsigned(Addr_Aux_eS))) :=x"000000" & Data_Out_eS;
                witness_eSe <= eSAux(to_integer(unsigned(Addr_Aux_eS)));
                eKeyAux(to_integer(unsigned(Addr_Aux-3))) :=Data_Out_eK;
                witness_eKe <= eKeyAux(to_integer(unsigned(Addr_Aux-3)));
            when s4 => 
                presente <= s5;
                Rd_En_eK <= '0';
                Addr_Rd_eK <= Addr_Aux;
                Rd_En_eS <= '0';
                eSAux(to_integer(unsigned(Addr_Aux_eS))) :=x"0000" & Data_Out_eS & eSAux(to_integer(unsigned(Addr_Aux_eS)))(7 downto 0);
                witness_eSe <= eSAux(to_integer(unsigned(Addr_Aux_eS)));
                eKeyAux(to_integer(unsigned(Addr_Aux-2))) :=Data_Out_eK;
                witness_eKe <= eKeyAux(to_integer(unsigned(Addr_Aux-2)));
            when s5 =>    
                presente <= s6;
                Rd_En_eK <= '0';
                Addr_Rd_eK <= Addr_Aux;
                Rd_En_eS <= '0';
                eSAux(to_integer(unsigned(Addr_Aux_eS))) :=x"00" & Data_Out_eS & eSAux(to_integer(unsigned(Addr_Aux_eS)))(15 downto 0);
                witness_eSe <= eSAux(to_integer(unsigned(Addr_Aux_eS)));
                eKeyAux(to_integer(unsigned(Addr_Aux-1))) :=Data_Out_eK;
                witness_eKe <= eKeyAux(to_integer(unsigned(Addr_Aux-1)));
            when s6 =>
                presente <= s7;
                Rd_En_eK <= '0';
                Rd_En_eS <= '0';
                eSAux(to_integer(unsigned(Addr_Aux_eS))) :=Data_Out_eS & eSAux(to_integer(unsigned(Addr_Aux_eS)))(23 downto 0);
                witness_eSe <= eSAux(to_integer(unsigned(Addr_Aux_eS)));
                eKeyAux(to_integer(unsigned(Addr_Aux))) :=Data_Out_eK;
                witness_eKe <= eKeyAux(to_integer(unsigned(Addr_Aux)));
            when s7 =>
                if Addr_Aux_eS >= "11" then  
                    presente <= s8;
                else
                    presente <= s0;
                    Addr_Aux_eS := Addr_Aux_eS + 1;
                end if;
                Addr_Aux := Addr_Aux + 1;--4--8
                Addr_Rd_eS <= Addr_Aux(Addr_Aux'length-3 downto 0);
                witness_eSe_0 <= eSAux(0);
                witness_eSe_1 <= eSAux(1);
                witness_eSe_2 <= eSAux(2);
                witness_eSe_3 <= eSAux(3);
                
                witness_eKe_0 <= eKeyAux(to_integer(unsigned(Addr_Aux-4)));
                witness_eKe_1 <= eKeyAux(to_integer(unsigned(Addr_Aux-3)));
                witness_eKe_2 <= eKeyAux(to_integer(unsigned(Addr_Aux-2)));
                witness_eKe_3 <= eKeyAux(to_integer(unsigned(Addr_Aux-1)));
            when s8 =>
                presente <= s9;
                RK(eSAux(0),eKeyAux(0),eSAux(0));
                RK(eSAux(1),eKeyAux(1),eSAux(1));
                RK(eSAux(2),eKeyAux(2),eSAux(2));
                RK(eSAux(3),eKeyAux(3),eSAux(3));
                witness_eSe_0 <= eSAux(0);
                witness_eSe_1 <= eSAux(1);
                witness_eSe_2 <= eSAux(2);
                witness_eSe_3 <= eSAux(3);
                witness_eKe_0 <= eKeyAux(4);
                witness_eKe_1 <= eKeyAux(5);
                witness_eKe_2 <= eKeyAux(6);
                witness_eKe_3 <= eKeyAux(7);
            when s9 =>
                presente <= s10;
                SM(eSAux(0),eSAux(1),eSAux(2),eSAux(3),
                    TAux(0),TAux(1),TAux(2),TAux(3));
                witness_eSe_0 <= eSAux(0);
                witness_eSe_1 <= eSAux(1);
                witness_eSe_2 <= eSAux(2);
                witness_eSe_3 <= eSAux(3);
                witness_eKe_0 <= TAux(0);
                witness_eKe_1 <= TAux(1);
                witness_eKe_2 <= TAux(2);
                witness_eKe_3 <= TAux(3);
            when s10 =>
                presente <= s11;
                RK(TAux(0),eKeyAux(4),TAux(0));
                RK(TAux(1),eKeyAux(5),TAux(1));
                RK(TAux(2),eKeyAux(6),TAux(2));
                RK(TAux(3),eKeyAux(7),TAux(3));
                witness_eSe_0 <= eSAux(0);
                witness_eSe_1 <= eSAux(1);
                witness_eSe_2 <= eSAux(2);
                witness_eSe_3 <= eSAux(3);
                witness_eKe_0 <= TAux(0);
                witness_eKe_1 <= TAux(1);
                witness_eKe_2 <= TAux(2);
                witness_eKe_3 <= TAux(3);
                witness_eKe <= eSAux(2);
            when s11 =>
                presente <= s12;
                witness_eKe <= eSAux(3);
            when others => null;
        end case;
    end if;
end if;
end process;                
end RTL;