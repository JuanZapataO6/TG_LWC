LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
entity Data_Generate is

end Data_Generate;
architecture RTL of Data_Generate is 
component MemBnk_32
port( 
        Xin     : in  std_logic_vector (0 to 7);
        Address : in  std_logic_vector (0 to 4);
        Load    : in  std_logic;
        Rst     : in  std_logic;
        Clk     : in  std_logic;
        Xout    : out std_logic_vector (0 to 7)
         
    );
end component;
TYPE estado is (s0, s1);
SIGNAL presente:estado:=s0;
Signal Data_Out     : STD_LOGIC_VECTOR(7 DOWNTO 0);
Signal Data_In      : STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
Signal Address      : std_logic_vector (4 downto 0):="00000";
signal Load,RSt,Clk : std_logic;
begin

reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
end process reloj;
u1: MemBnk_32 Port Map (Xin     =>Data_In,
                        Address =>Address,
                        Load    =>Load,
                        Rst     =>Rst,
                        Clk     =>Clk,
                        Xout    =>Data_Out
                        );
STat: process (clk,presente)
begin 
        if clk 'event and clk = '1' then
            if Address <= "11111" then 
                case presente is 
                    when  s0 =>
                        presente <= s1;
                        Load     <= '1';
                        Rst      <= '0';
                        Data_In <= Data_In(Data_In'LENGTH-1 downto 5) & Address(Address'LENGTH-1 DOWNTO 0);
                    when s1 =>
                        presente <= s0;
                        Address  <= Address+1;
                        Load     <= '0';
                        Rst      <= '0';
                        Data_In <= Data_In(Data_In'LENGTH-1 downto 5) & Address(Address'LENGTH-1 DOWNTO 0);
                end case;
            else 
                Address <= (Address'RANGE => '0');
            end if;
        end if;
    end process STat;
end RTL;