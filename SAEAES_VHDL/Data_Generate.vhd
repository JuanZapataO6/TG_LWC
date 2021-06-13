LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
entity Data_Generate is
    port (
        Clk           :in  std_logic;
        Rd_En_K       :in  std_logic;
        Rd_En_B       :in  std_logic;
        Ena_Out       :out std_logic;
        Addr_Out_K    :in  std_logic_vector(4 downto 0);
        Addr_Out_B    :in  std_logic_vector(4 downto 0);
        Data_Out_K    :out STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_B    :out STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
end Data_Generate;

architecture RTL of Data_Generate is 
component MemBnk
generic(    w:integer;--width of word
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

Signal Data_In            : STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
Signal Data_In_B          : STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
Signal Addr_In            : std_logic_vector (4 downto 0):="00000";
Signal Addr_In_B          : std_logic_vector (4 downto 0):="00000";
signal Load,RSt           : std_logic;
signal Wr_en_K            : std_logic;
Signal Wr_en_B            : std_logic;
--signal clk                : std_logic;

begin

--reloj:process
--begin
--    clk <= '0';
--    wait for 12.5 ns;
--    clk <= '1';
  --  wait for 12.5 ns;
--end process reloj;

uKey: MemBnk 
    generic map(w => 8,
                d => 32,
                a => 5
    )
    Port Map (Wr_En    => Wr_En_K,
                Rd_En    => Rd_En_K,      
                Rst      => Rst,
                Clk      => clk,
                Addr_In  => Addr_In,
                Addr_Out => Addr_Out_K,
                Data_in  => Data_in,
                Data_Out => Data_Out_K
                );
uBuf: MemBnk 
    generic map(w => 8,
                d => 32,
                a => 5
                )
    Port Map (Wr_En    => Wr_En_B,
                Rd_En    => Rd_En_B,      
                Rst      => Rst,
                Clk      => clk,
                Addr_In  => Addr_In_B,
                Addr_Out => Addr_Out_B,
                Data_in  => Data_in_B,
                Data_Out => Data_Out_B
                );
STat: process (clk,presente,Addr_In)
variable Finish_En  : std_logic:= '0';
variable Finish_No  : std_logic:= '0';
variable Addr_Aux   : std_logic_vector (5 downto 0) := "000000";      
begin 
        if clk 'event and clk = '1' then
            if Addr_Aux <= "11111" and Finish_En = '0' then 
                case presente is 
                    when  s0 =>
                        presente <= s1;
                        Wr_En_K  <= '0';
                        Wr_En_B  <= '0';
                        Rst      <= '1';
                        Addr_Aux := Addr_Aux + 1;
                        if Addr_Aux= "100000" then
                            Data_In_B<= x"80";
                        else
                            Data_In_B <= '0' & Data_In_B(Data_In'LENGTH-2 downto 5) & '0' & Addr_In(Addr_In'LENGTH-2 DOWNTO 0);
                        end if;
                        Data_In  <= Data_In(Data_In'LENGTH-1 downto 5) & Addr_In(Addr_In'LENGTH-1 DOWNTO 0);
                    when s1 =>
                        presente <= s0;
                        Data_In_B<= '0' & Data_In(Data_In'LENGTH-2 downto 5) & '0'& Addr_In(Addr_In'LENGTH-2 DOWNTO 0);
                        Addr_In  <= Addr_Aux (Addr_Aux'LENGTH-2 downto 0);
                        Addr_In_B  <= Addr_Aux (Addr_Aux'LENGTH-2 downto 0);
                        Wr_En_K  <= '1';
                        Wr_En_B  <= '1';
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