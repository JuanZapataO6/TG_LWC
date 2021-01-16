LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
entity Data_Generate is
    port (
        Clk         :in  std_logic;
        Rd_En       :in  std_logic;
        Ena_Out     :out std_logic;
        Addr_Out    :in  std_logic_vector(4 downto 0);
        Data_Out    :out STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
end Data_Generate;

architecture RTL of Data_Generate is 
component MemBnk_32
generic(    w:integer:=8;--width of word
            d:integer:=32;--Numbers of words 
            a:integer:=5 --width of Address
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

Signal Data_In            : STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
Signal Addr_In            : std_logic_vector (4 downto 0):="00000";
signal Load,RSt,Wr_en     : std_logic;
--signal clk                : std_logic;

begin

--reloj:process
--   begin
--   clk <= '0';
--    wait for 12.5 ns;
--    clk <= '1';
--    wait for 12.5 ns;
--end process reloj;

u1: MemBnk_32 Port Map (Wr_En    => Wr_En,
                        Rd_En    => Rd_En,      
                        Rst      => Rst,
                        Clk      => clk,
                        Addr_In  => Addr_In,
                        Addr_Out => Addr_Out,
                        Data_in  => Data_in,
                        Data_Out => Data_Out
                        );
STat: process (clk,presente,Addr_In)
variable Finish_En        : std_logic:= '0';
begin 
        if clk 'event and clk = '1' then
            if Addr_In < "11111" and Finish_En = '0' then 
                case presente is 
                    when  s0 =>
                        presente <= s1;
                        Wr_En    <= '0';
                        Rst      <= '1';
                        Data_In  <= Data_In(Data_In'LENGTH-1 downto 5) & Addr_In(Addr_In'LENGTH-1 DOWNTO 0);
                    when s1 =>
                        presente <= s0;
                        Addr_In  <= Addr_In+1;
                        Wr_En    <= '1';
                        Rst      <= '1';
                        Data_In  <= Data_In(Data_In'LENGTH-1 downto 5) & Addr_In(Addr_In'LENGTH-1 DOWNTO 0);
                end case;
            else 
                Ena_Out  <='1';
                Finish_En := '1';
  --              Address     <= (Address'RANGE => '0');
            end if;
        end if;
    end process STat;
end RTL;