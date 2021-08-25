LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use ieee.std_logic_misc.all;
use work.Definitions.all;
entity AesKey is
port (      
    En_In   : in std_logic; -- Flag for start FMS
    En_Out  : out std_logic;
    Clk     : in std_logic; -- Clock signal 
    --Read Memory bank of key from DataGenerate 
    Rd_En_K   : out std_logic;
    Data_In_K : in std_logic_vector (7 downto 0);
    Addr_Rd_K : out std_logic_vector (3 DOWNTO 0);
    --Output Memory Bank yourself
    --Rd_En : in std_logic;
    --Data_Out_T : out std_logic_vector (7 downto 0);
    --Index_T    : in std_logic_vector (3 DOWNTO 0);

    Wr_En_eK : out std_logic;
    Addr_Wr_eK : out std_logic_vector (5 DOWNTO 0);
    Data_In_eK : out std_logic_vector (31 downto 0)
);
end AesKey;
architecture RTL of AesKey is

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
TYPE estado is (s0,s0_0,s0_1, s1,s2,s3,s4,s5,s6,s7,s8,s_8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;
begin 
--Component for AesKey Places for 32 bits 

STat: process (clk,presente)
type word is array (0 to 43) of std_logic_vector (31 downto 0);
variable eKeyAux : word;
type C_rcon is array (0 to 10) of std_logic_vector (7 downto 0);
constant rcon : C_rcon:=(
    x"00",x"01",x"02",x"04",x"08",x"10",x"20",x"40",x"80",x"1b",x"36"
);

variable Finish_En  : std_logic:= '0';
variable Addr_Aux   : std_logic_vector (5 downto 0) := "000000";      
variable Addr_Aux_eK: std_logic_vector (5 downto 0) := "000000";
begin 
if clk 'event and clk = '1' then
    if En_In = '1' then      
        case presente is
            when s0 =>
                presente<= s0_0;
            when s0_0 =>
                presente<= s0_1;
            when s0_1 =>
                presente <= s1;
                Rd_En_K <= '0';
                Addr_Rd_K <= Addr_Aux(Addr_Aux'length-3 downto 0);
            when s1 => 
                presente <= s2;
                Rd_En_K <= '0';
                Addr_Aux := Addr_Aux + 1;--1
                Addr_Rd_K <= Addr_Aux(Addr_Aux'length-3 downto 0);--1
            when s2 => 
                presente <= s3;
                Rd_En_K <= '0';
                Addr_Aux := Addr_Aux + 1; 
                Addr_Rd_K <= Addr_Aux(Addr_Aux'length-3 downto 0);--2
            when s3 => 
                presente <= s4;
                Rd_En_K <= '0';
                Addr_Aux := Addr_Aux + 1;
                Addr_Rd_K <= Addr_Aux(Addr_Aux'length-3 downto 0);--3
            when s4 => 
                presente <= s5;
                Rd_En_K <= '0';
                Addr_Rd_K <= Addr_Aux(Addr_Aux'length-3 downto 0);--3
                eKeyAux(to_integer(unsigned(Addr_Aux_eK))) := x"000000" & Data_In_K;
            when s5 => 
                presente <= s6;
                Rd_En_K <= '1';
                Addr_Rd_K <= Addr_Aux(Addr_Aux'length-3 downto 0);
                eKeyAux(to_integer(unsigned(Addr_Aux_eK))) :=x"0000" & Data_In_K & eKeyAux(to_integer(unsigned(Addr_Aux_eK)))(7 downto 0);
            when s6 => 
                presente <= s7;
                Rd_En_K <= '1';
                Addr_Rd_K <= Addr_Aux(Addr_Aux'length-3 downto 0);
                eKeyAux(to_integer(unsigned(Addr_Aux_eK))):= x"00" & Data_In_K & eKeyAux(to_integer(unsigned(Addr_Aux_eK)))(15 downto 0);
            when s7 => 
                presente <= s8;
                Rd_En_K <= '1';
                Addr_Rd_K <= Addr_Aux(Addr_Aux'length-3 downto 0);
                eKeyAux(to_integer(unsigned(Addr_Aux_eK))) := Data_In_K & eKeyAux(to_integer(unsigned(Addr_Aux_eK)))(23 downto 0);
            when s8 => 
                presente <= s_8;
                Rd_En_K <= '1';                
                eKeyAux(to_integer(unsigned(Addr_Aux_eK))) := Data_In_K & eKeyAux(to_integer(unsigned(Addr_Aux_eK)))(23 downto 0);
            when s_8=>
                presente <= s9;
                Rd_En_K <= '1';
                Wr_En_eK <= '0';                
                Data_In_eK <= eKeyAux(to_integer(unsigned(Addr_Aux_eK))); 
                Addr_Wr_eK <= Addr_Aux_eK;
                Addr_Aux := Addr_Aux + 1;--4
            when s9 => 
                if Addr_Aux_eK = "000011" then  
                    presente <= s10;
                else
                    presente <= s0_1;
                end if;
                --Rd_En_K <= '1';
                Wr_En_eK <= '1';
                Addr_Aux_eK := Addr_Aux_eK + 1; 
                Addr_Wr_eK <= Addr_Aux_eK;
                Addr_Rd_K <= Addr_Aux(Addr_Aux'length-3 downto 0);
            when s10 => 
                Wr_En_eK <= '1';
                presente <= s11;
                Addr_Wr_eK <= Addr_Aux_eK;
                RotSub(eKeyAux(to_integer(unsigned(Addr_Aux_eK - 1))),
                                eKeyAux(to_integer(unsigned(Addr_Aux_eK))));
            when s11 => 
                presente <= s12;
                Wr_En_eK <= '0';
                Addr_Wr_eK <= Addr_Aux_eK;
                eKeyAux(to_integer(unsigned(Addr_Aux_eK))) := eKeyAux(to_integer(unsigned(Addr_Aux_eK-4)))
                                xor eKeyAux(to_integer(unsigned(Addr_Aux_eK)))
                                xor x"000000" & rcon(to_integer(unsigned(Addr_Aux_eK(Addr_Aux_eK'length-1 downto 2))));
                Data_In_eK <= eKeyAux(to_integer(unsigned(Addr_Aux_eK)));
            when s12 => 
                presente <= s13;
                Addr_Aux_eK := Addr_Aux_eK+1;--5
                Addr_Wr_eK <= Addr_Aux_eK; 
                Wr_En_eK <= '0';
                eKeyAux(to_integer(unsigned(Addr_Aux_eK))) := eKeyAux(to_integer(unsigned(Addr_Aux_eK-4))) 
                                xor eKeyAux(to_integer(unsigned(Addr_Aux_eK-1))); 
                Data_In_eK <= eKeyAux(to_integer(unsigned(Addr_Aux_eK)));
            when s13 => 
                presente <= s14;                
                Addr_Aux_eK := Addr_Aux_eK+1;--6
                Addr_Wr_eK <= Addr_Aux_eK;
                Wr_En_eK <= '0';
                eKeyAux(to_integer(unsigned(Addr_Aux_eK))) := eKeyAux(to_integer(unsigned(Addr_Aux_eK-4))) 
                                xor eKeyAux(to_integer(unsigned(Addr_Aux_eK-1))); 
                Data_In_eK <= eKeyAux(to_integer(unsigned(Addr_Aux_eK)));
            when s14 =>
                presente <= s15;
                Addr_Aux_eK := Addr_Aux_eK+1;--7
                Addr_Wr_eK <= Addr_Aux_eK;
                Wr_En_eK <= '0';
                eKeyAux(to_integer(unsigned(Addr_Aux_eK))) := eKeyAux(to_integer(unsigned(Addr_Aux_eK-4))) 
                                xor eKeyAux(to_integer(unsigned(Addr_Aux_eK-1))); 
                Data_In_eK <= eKeyAux(to_integer(unsigned(Addr_Aux_eK)));
            when s15 =>
                if Addr_Aux_eK < x"2B" then  
                    presente <= s10;
                else 
                    presente <= s16;
                    En_Out <='1';
                end if; 
                Addr_Aux_eK := Addr_Aux_eK+1;--8
                Addr_Wr_eK <= Addr_Aux_eK;
                Wr_En_eK   <= '1';
                --En_Out <= '1';
            when others => null;
        end case;
    end if;
end if;
end process;
end RTL;