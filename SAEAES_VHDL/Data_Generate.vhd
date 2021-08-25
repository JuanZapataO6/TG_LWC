LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
entity Data_Generate is 
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
end Data_Generate;

architecture RTL of Data_Generate is 
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
end component;
TYPE estado is (s0, s1);
SIGNAL presente:estado:=s0;
Signal Data_In_aTx        : STD_LOGIC_VECTOR (7 DOWNTO 0):=x"00";
Signal Data_In_Kn         : STD_LOGIC_VECTOR (7 DOWNTO 0):=x"00";
Signal Addr_In_Kn         : std_logic_vector (3 downto 0):="0000";
Signal Addr_In_aTx         : std_logic_vector (4 downto 0):="00000";
signal Load,RSt           : std_logic;
signal Wr_en_ATx          : std_logic;
Signal Wr_en_K            : std_logic;
Signal Wr_en_N            : std_logic;
begin

uAdd: MemBnk 
    generic map(
        w => 8,
        d => 32,
        a => 5
    )
    Port Map (
        Wr_En    => Wr_en_ATx,
        Rd_En    => Rd_En_A,      
        Rst      => Rst,
        Clk      => clk,
        Addr_In  => Addr_In_aTx,
        Addr_Out => Addr_Out_A,
        Data_in  => Data_In_aTx,
        Data_Out => Data_Out_A
    );
--memory bank for Key/Nonce
uKey: MemBnk 
    generic map(
        w => 8,
        d => 16,
        a => 4
    )
    Port Map (  
        Wr_En    => Wr_en_K,
        Rd_En    => Rd_En_K,      
        Rst      => Rst,
        Clk      => clk,
        Addr_In  => Addr_In_Kn,
        Addr_Out => Addr_Out_K,
        Data_in  => Data_In_Kn,
        Data_Out => Data_Out_K
    );
--memory bank for Key/Nonce
uNonce: MemBnk 
    generic map(
        w => 8,
        d => 16,
        a => 4
    )
    Port Map (
        Wr_En    => Wr_en_N,
        Rd_En    => Rd_En_N,      
        Rst      => Rst,
        Clk      => clk,
        Addr_In  => Addr_In_Kn,
        Addr_Out => Addr_Out_N,
        Data_in  => Data_In_Kn,
        Data_Out => Data_Out_N
    );

STat: process (clk,presente)
variable Finish_En  : std_logic:= '0';
variable Finish_No  : std_logic:= '0';
variable Addr_Aux   : std_logic_vector (5 downto 0) := "000000";      
begin 
        if clk 'event and clk = '1' then
            if Addr_Aux <= "11111" and Finish_En = '0' then 
                case presente is 
                    when  s0 =>
                        presente   <= s1;
                        Wr_en_ATx  <= '0';
                        Rst        <= '1';
                        Addr_Aux := Addr_Aux + 1;
                        if Addr_Aux > "010000" then
                            Wr_en_K    <= '1';
                            Wr_en_n    <= '1';
                        else
                            Wr_en_K    <= '0';
                            Wr_en_n    <= '0';
                        end if;
                        Data_In_aTx <= "000" & Addr_In_aTx(Addr_In_aTx'LENGTH-1 DOWNTO 0);
                        Data_In_Kn  <= "0000" & Addr_In_Kn(Addr_In_Kn'LENGTH-1 DOWNTO 0);
                    when s1 =>
                        presente    <= s0;
                        Data_In_aTx <= "000" & Addr_In_aTx(Addr_In_aTx'LENGTH-1 DOWNTO 0);
                        Data_In_Kn  <= "0000" & Addr_In_Kn(Addr_In_Kn'LENGTH-1 DOWNTO 0);
                        Addr_In_aTx  <= Addr_Aux (Addr_Aux'LENGTH-2 downto 0);
                        Addr_In_Kn  <= Addr_Aux (Addr_Aux'LENGTH-3 downto 0);
                        Wr_en_K     <= '1';
                        Wr_en_N     <= '1';
                        Wr_en_ATx   <= '1';
                        Rst         <= '1';
                end case;
            else 
                Ena_Out  <='1';
                Finish_En := '1';
                Wr_en_ATx  <= '1';
            end if;
        end if;
    end process STat;
end RTL;