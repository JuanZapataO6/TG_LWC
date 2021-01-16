LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity Saturnin_Block_Encrypt is 
end Saturnin_Block_Encrypt;

architecture Main of Saturnin_Block_Encrypt is 

component Data_Generate
    port (
        Clk         :in  std_logic;
        Rd_En       :in  std_logic;
        Ena_Out     :out std_logic;
        Addr_Out    :in  std_logic_vector(4 downto 0);
        Data_Out    :out STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
end component;

component MemBnk_16
generic(   
    w:integer:=16;--width of word
    d:integer:=16;--Numbers of words 
    a:integer:=4 --width of Address
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

TYPE estado is (s0, s1,s2);
SIGNAL presente:estado:=s0;

signal clk : std_logic;
-- Signals for Generate Data
signal Rd_En_DG : std_logic:= '0';
signal Enable_Generate : std_logic;
signal Data_Test :std_logic_vector (7 DOWNTO 0);
signal Addr_Rd   :std_logic_vector (4 DOWNTO 0):= "00000";

-- Signals for MemBnk_16

signal Wr_En_k : std_logic:= '1';
signal Rd_En_k : std_logic:= '1';
signal Rst_k : std_logic:= '1';
signal Addr_Rd_k   :std_logic_vector (3 DOWNTO 0):= "0000";
signal Addr_Wr_k   :std_logic_vector (3 DOWNTO 0):= "0000";
signal Data_In_k   :std_logic_vector (15 DOWNTO 0):=x"0000";
signal Data_Out_k  :std_logic_vector (15 DOWNTO 0):=x"0000";

begin
reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
end process reloj;
u1: Data_Generate Port Map (Clk         => clk,
                            Rd_En       => Rd_En_DG,
                            Ena_Out     => Enable_Generate,
                            Addr_Out    => Addr_Rd,
                            Data_Out    => Data_Test
);
u2: MemBnk_16 Port Map (    Wr_En    => Wr_En_k,
                            Rd_En    => Rd_En_k,
                            Rst      => Rst_k,
                            Clk      => clk,
                            Addr_In  => Addr_Wr_k,
                            Addr_Out => Addr_Rd_k,
                            Data_in  => Data_In_k,
                            Data_out => Data_Out_k
);

    STat: process(clk,presente)
    variable Addr_Aux :std_logic_vector (4 DOWNTO 0):="00000";
    begin
        if clk 'event and clk = '1' then 
            if Enable_generate ='1' and Addr_Rd < "11111" then
                case presente is 
                    when s0 =>
                        presente <= s1;
                        Rd_En_DG<= '0';
                        Addr_Rd<=Addr_Rd+1;
                        Data_In_k <= Data_Test & Data_In_k(7 downto 0);  
                    when s1 =>
                        presente <= s2;
                        Addr_Wr_k <= Addr_Aux(Addr_Aux'length -2 downto 0);
                        Wr_En_k<= '0';
                        Rd_En_DG<= '0';
                        Data_In_k <=Data_In_k(15 downto 8) & Data_Test;
                    when s2 =>
                        presente <= s0;
                        Addr_Aux:=Addr_Aux+1;
                        Addr_Rd  <=Addr_Aux(Addr_Aux'length -2 downto 0)&'0';
                        --Data_In_k <=Data_In_k(15 downto 8) & Data_Test;
                end case;
            end if;
        end if;
    end process STat;
end Main;