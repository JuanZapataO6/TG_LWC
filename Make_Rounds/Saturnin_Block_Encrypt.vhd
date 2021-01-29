LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
library work;
use work.Saturnin_Functions.all;

entity Saturnin_Block_Encrypt is 
end Saturnin_Block_Encrypt;

architecture Main of Saturnin_Block_Encrypt is 

component Data_Generate
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
end component;

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

TYPE estado is (s0, s1,s2,s3,s4,s5);
SIGNAL presente:estado:=s0;
signal presente_XOR :estado:=s0;
signal clk : std_logic;
-- Signals for Generate Data
signal Rd_En_DGK        : std_logic:= '0';
signal Rd_En_DGB        : std_logic:= '0';
signal Enable_Generate  : std_logic;
signal Data_In_DGK        : std_logic_vector (7 DOWNTO 0);
signal Data_In_DGB        : std_logic_vector (7 DOWNTO 0);
signal Addr_Rd_DGK        : std_logic_vector (4 DOWNTO 0):= "00000";
signal Addr_Rd_DGB        : std_logic_vector (4 DOWNTO 0):= "00000";
-- Signals for MemBnk_K
signal Wr_En_k     : std_logic:= '1';
signal Rd_En_k     : std_logic:= '1';
signal Rst_k       : std_logic:= '1';
signal Addr_Rd_k   :std_logic_vector (3 DOWNTO 0):= "0000";
signal Addr_Wr_k   :std_logic_vector (3 DOWNTO 0):= "0000";
signal Data_In_k   :std_logic_vector (15 DOWNTO 0):=x"0000";
signal Data_Out_Sk   :std_logic_vector (15 DOWNTO 0):=x"0000";
-- Signals for MemBnk_B
signal Wr_En_B     : std_logic:= '1';
signal Rd_En_B     : std_logic:= '1';
signal Rst_B       : std_logic:= '1';
signal Addr_Rd_B   : std_logic_vector (3 DOWNTO 0):= "0000";
signal Addr_Wr_B   : std_logic_vector (3 DOWNTO 0):= "0000";
signal Data_In_B   : std_logic_vector (15 DOWNTO 0):=x"0000";
signal Data_Out_SB : std_logic_vector (15 DOWNTO 0):=x"0000";
-- Signals for Xor_Key
signal state_Out   : std_logic_vector (15 DOWNTO 0):=x"0000";
begin
reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
end process reloj;
u1: Data_Generate Port Map (Clk           => clk,
                            Rd_En_K       => Rd_En_DGK,
                            Rd_En_B       => Rd_En_DGB,
                            Ena_Out       => Enable_Generate,
                            Addr_Out_K    => Addr_Rd_DGK,
                            Addr_Out_B    => Addr_Rd_DGB,
                            Data_Out_K    => Data_In_DGK,
                            Data_Out_B    => Data_In_DGB
                            );
uBuff: MemBnk 
    generic map(w => 16,
                d => 16,
                a => 4
    )
    Port Map (              Wr_En    => Wr_En_B,
                            Rd_En    => Rd_En_B,
                            Rst      => Rst_B,
                            Clk      => clk,
                            Addr_In  => Addr_Wr_B,
                            Addr_Out => Addr_Rd_B,
                            Data_in  => Data_In_B,
                            Data_out => Data_Out_SB
    );
uKey: MemBnk 
    generic map(w => 16,
                d => 16,
                a => 4
    )
    Port Map (              Wr_En    => Wr_En_k,
                            Rd_En    => Rd_En_k,
                            Rst      => Rst_k,
                            Clk      => clk,
                            Addr_In  => Addr_Wr_k,
                            Addr_Out => Addr_Rd_k,
                            Data_in  => Data_In_k,
                            Data_out => Data_Out_Sk
    );

STat: process(clk,presente)
    variable Addr_Aux :std_logic_vector (4 DOWNTO 0):="00000";
    begin
        if clk 'event and clk = '1' then 
            if Enable_generate ='1' and Addr_Aux <= "1111" then
                case presente is 
                    when s0 =>
                        presente    <= s1;
                        Rd_En_DGK   <= '0';
                        Rd_En_DGB   <= '0';
                        Addr_Rd_DGK <= Addr_Rd_DGK+1;
                        Addr_Rd_DGB <= Addr_Rd_DGB+1;
                        Data_In_K   <= Data_In_DGK & Data_In_k(7 downto 0);  
                        Data_In_B   <= Data_In_DGB & Data_In_B(7 downto 0);  
                    when s1 =>                        
                        presente    <= s2;
                        Addr_Wr_B   <= Addr_Aux(Addr_Aux'length -2 downto 0);
                        Addr_Wr_k   <= Addr_Aux(Addr_Aux'length -2 downto 0);
                        Wr_En_k     <= '0';
                        Wr_En_B     <= '0';
                        Rd_En_DGK   <= '0';
                        Rd_En_DGB   <= '0';
                        Data_In_k   <=Data_In_k(15 downto 8) & Data_In_DGK;
                        Data_In_B   <=Data_In_B(15 downto 8) & Data_In_DGB;
                    when s2 =>
                        presente <= s0;
                        Addr_Aux:=Addr_Aux+1;
                        Addr_Rd_DGK<=Addr_Aux(Addr_Aux'length -2 downto 0)&'0';
                        Addr_Rd_DGB<=Addr_Aux(Addr_Aux'length -2 downto 0)&'0';
                    when others => null;
                end case;
            elsif presente = s0 and Enable_generate ='1' then 
                presente  <= s1;
                Rd_En_DGK <= '0';
                Rd_En_DGB <= '0';
                --Incio XOR_Key
                --Rd_En_B   <= '0'; -- Lectura Banco Buff
                --Rd_En_K   <= '0'; -- Lectura Banco Key 
                --Wr_En_B   <= '0'; -- Escritura Banco Buff

                Data_In_K <= Data_In_DGK & Data_In_k(7 downto 0);
                Data_In_B <= Data_In_DGB & Data_In_B(7 downto 0); 
                
            else   
                if Enable_Generate = '1' then  
                    case presente_XOR is 
                    when s0 =>-- STAR 
                        presente_XOR <= s1;
                        Addr_Rd_B <= x"0";
                        Addr_Rd_k <= x"0";
                        Addr_Wr_B <= x"0";
                        Addr_Wr_B <= x"0";
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s1 =>
                        if Addr_Rd_B<="1111" then
                            presente_XOR <= s2;
                            Rd_En_B   <= '0';
                            Rd_En_K   <= '0';
                            Wr_En_B   <= '1';
                            Wr_En_k   <= '1';
                        end if;
                    when s2 =>
                        presente_XOR <= s3;
                        XOR_Key(Data_Out_SB,Data_Out_Sk,state_Out);                        
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s3 =>
                        presente_XOR <= s4;
                        XOR_Key(Data_Out_SB,Data_Out_Sk,state_Out); 
                        Data_In_B <=state_Out;
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s4 =>
                        presente_XOR <= s5;
                        XOR_Key(Data_Out_SB,Data_Out_Sk,state_Out); 
                        Data_In_B <=state_Out;
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '0';
                        Wr_En_k   <= '1';
                    when s5 =>
                        presente_XOR <= s1;
                        Addr_Rd_B <= Addr_Rd_B + 1;
                        Addr_Rd_k <= Addr_Rd_k + 1;
                        Addr_Wr_B <= Addr_Wr_B + 1;                        
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when others => null;
                    end case;
                end if;
                
            end if;
        end if;
    end process STat;
end Main;