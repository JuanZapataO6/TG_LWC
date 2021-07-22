LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use work.Saturnin_Functions.all;

entity SAEAES_Block_Encrypt is 

end SAEAES_Block_Encrypt;

architecture Main of SAEAES_Block_Encrypt is 

component Data_Force
    
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
end component Data_Force;
TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;
signal clk : std_logic;
CONSTANT M0 is array (255 downto 0, 31 downto 0) of std_logic;
CONSTANT M1 is array (255 downto 0, 31 downto 0) of std_logic;
CONSTANT M2 is array (255 downto 0, 31 downto 0) of std_logic;
CONSTANT M3 is array (255 downto 0, 31 downto 0) of std_logic;
STat: process(clk,presente)
begin
    if clk 'event and clk = '1' then 
            if Enable_generate ='1' then
                case presente is
                    when  s0 =>
                        if Enable_DF = '1' then --Finish Data Force
                            En_XK_Main <='1';
                            presente <= s1;
                            R_MR <= x"A";
                            D_MR <= x"6";
                            Load_MR <= '1'; 
                            Addr_Control <="0001";
                        else
                            presente <= s0;
                            Addr_Control <="0000";
                            Load_MR <= '1'; 
                            R_MR <= x"A";
                            D_MR <= x"6";
                        end if;
                    end case;
                    end if;
                    end if;
                    end process;

end Main;
