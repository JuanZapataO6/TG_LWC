library IEEE;
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
USE ieee.numeric_std.ALL;
use work.all;

entity Data_Force is
   
    port( 
        clk            :in  std_logic;
        --Ports for Data Generate
        Rd_En_DGK      :out std_logic;
        Rd_En_DGB      :out std_logic;
        En_In_DF       :in  std_logic;
        Addr_Rd_DGK    :out std_logic_vector(4 downto 0);
        Addr_Rd_DGB    :out std_logic_vector(4 downto 0);
        Data_In_DGK    :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_In_DGB    :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        --Ports for MemBnk Write
        Data_RIn_K     :out std_logic_vector (15 DOWNTO 0);
        Data_RIn_B     :out std_logic_vector (15 DOWNTO 0);
        Addr_Wr_B      :out std_logic_vector (3 DOWNTO 0);
        Addr_Wr_k      :out std_logic_vector (3 DOWNTO 0);
        Wr_En_k        :out std_logic;
        Wr_En_B        :out std_logic;
        --Ports Of fininish 
        Enable_DF      :out std_logic
    );
end Data_Force;
architecture RTL of Data_Force is 
TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7);
SIGNAL presente:estado:=s0;
begin
STat: process(clk,presente)
variable Addr_Aux        :std_logic_vector (4 DOWNTO 0):="00000";
variable Addr_Rd_DGK_Aux :std_logic_vector (4 downto 0):="00000";
variable Addr_Rd_DGB_Aux :std_logic_vector (4 downto 0):="00000";
variable Data_RIn_K_Aux  :std_logic_vector (15 DOWNTO 0):= x"7777";
variable Data_RIn_B_Aux  :std_logic_vector (15 DOWNTO 0):= x"7777";
        
begin
if clk 'event and clk = '1' then 
    if En_In_DF ='1' then  
        if Addr_Aux <= "1111" then
            case presente is 
                when s0 =>
                    presente    <= s1;
                    Rd_En_DGK   <= '0';
                    Rd_En_DGB   <= '0';
                    Wr_En_k     <= '1';
                    Wr_En_B     <= '1';         
                    Addr_Rd_DGK  <= Addr_Rd_DGK_Aux;
                    Addr_Rd_DGB  <= Addr_Rd_DGB_Aux;              
                when s1 =>
                    presente    <= s2;
                    Rd_En_DGK   <= '0';
                    Rd_En_DGB   <= '0';
                    Wr_En_k     <= '1';
                    Wr_En_B     <= '1';
                    Addr_Rd_DGK_Aux  := Addr_Rd_DGK_Aux+1;
                    Addr_Rd_DGB_Aux  := Addr_Rd_DGB_Aux+1;
                    Addr_Rd_DGK  <= Addr_Rd_DGK_Aux;
                    Addr_Rd_DGB  <= Addr_Rd_DGB_Aux;                    
                when s2 =>
                    presente    <= s3;
                    Rd_En_DGK   <= '1';
                    Rd_En_DGB   <= '1'; 
                    Data_RIn_K_Aux  := Data_RIn_K_Aux(15 downto 8) & Data_In_DGK;  
                    Data_RIn_B_Aux  := Data_RIn_B_Aux(15 downto 8) & Data_In_DGB;                 
                    Data_RIn_K  <= Data_RIn_K_Aux;  
                    Data_RIn_B  <= Data_RIn_B_Aux; 
                when s3 =>
                    presente    <= s4;  
                    Data_RIn_K_Aux   := Data_In_DGK & Data_RIn_K_Aux(7 downto 0);  
                    Data_RIn_B_Aux   := Data_In_DGB & Data_RIn_B_Aux(7 downto 0);                            
                    Data_RIn_K   <= Data_RIn_K_Aux;  
                    Data_RIn_B   <= Data_RIn_B_Aux;
                    Addr_Wr_B   <= Addr_Aux(Addr_Aux'length -2 downto 0);
                    Addr_Wr_k   <= Addr_Aux(Addr_Aux'length -2 downto 0);
                    Rd_En_DGK   <= '1';
                    Rd_En_DGB   <= '1';
                    Wr_En_k     <= '0';
                    Wr_En_B     <= '0';
                when s4 =>
                    presente <= s0;
                    Wr_En_k     <= '1';
                    Wr_En_B     <= '1';
                    Addr_Aux:=Addr_Aux+1;                
                    Addr_Rd_DGK_Aux:=Addr_Aux(Addr_Aux'length -2 downto 0)&'0';
                    Addr_Rd_DGB_Aux:=Addr_Aux(Addr_Aux'length -2 downto 0)&'0';
                when others => null;
            end case;
        else 
            Enable_DF <= '1';
        end if;
    end if;
end if;
end process STat;
end RTL;