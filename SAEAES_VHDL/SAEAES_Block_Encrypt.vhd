LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity SAEAES_Block_Encrypt is 

end SAEAES_Block_Encrypt;

architecture Main of SAEAES_Block_Encrypt is 
component Data_Generate
    port (
        Clk           :in  std_logic;
        Rd_En_K       :in  std_logic;
        Rd_En_B       :in  std_logic;
        Rd_En_A       :in  std_logic;
        Rd_En_N       :in  std_logic;
        Ena_Out       :out std_logic;
        Addr_Out_K    :in  std_logic_vector(3 downto 0);
        Addr_Out_N    :in  std_logic_vector(3 downto 0);
        Addr_Out_A    :in  std_logic_vector(4 downto 0);
        Addr_Out_B    :in  std_logic_vector(4 downto 0);
        Data_Out_K    :out STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_B    :out STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_A    :out STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_N    :out STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
end component Data_Generate;
component AesKey
    port (      
        En_In : in std_logic; -- Flag for start FMS
        Ena_Out : out std_logic;--Flag Finish
        Clk : in std_logic; -- Clock signal 
        --Read Memory bank of key from DataGenerate 
        Rd_En_K : out std_logic;
        Data_in_K : in std_logic_vector (7 downto 0);  
        Addr_Rd_K : out std_logic_vector (3 DOWNTO 0);
        --Output Memory Bank yourself
        Rd_En_eK : in std_logic;
        Addr_Rd_eK : in std_logic_vector (5 DOWNTO 0);
        Data_Out_eK : out std_logic_vector (31 downto 0) 
    );
end component AesKey;

TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;
signal clk : std_logic;
--signal from Data_Generate until AesKey
signal Rd_En_K      : std_logic;
signal Rd_En_B      : std_logic;
signal Rd_En_A      : std_logic;
signal Rd_En_N      : std_logic;
signal Ena_Out      : std_logic;
signal Addr_Out_K   : std_logic_vector(3 downto 0);
signal Addr_Out_N   : std_logic_vector(3 downto 0);
signal Addr_Out_A   : std_logic_vector(4 downto 0);
signal Addr_Out_B   : std_logic_vector(4 downto 0);
signal Data_Out_K   : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Data_Out_B   : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Data_Out_A   : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Data_Out_N   : STD_LOGIC_VECTOR(7 DOWNTO 0);
Signal Rd_En_eK     : std_logic;  
Signal Addr_Rd_eK   : std_logic_vector (5 DOWNTO 0);
Signal Data_Out_eK  : std_logic_vector (31 downto 0);
Signal Ena_AK       : std_logic;
begin

reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
end process reloj;
uDataGenerate : Data_Generate
    port map (
        Clk         => Clk,
        Rd_En_K     => Rd_En_K,
        Rd_En_B     => Rd_En_B,
        Rd_En_A     => Rd_En_A,
        Rd_En_N     => Rd_En_N,
        Ena_Out     => Ena_Out,
        Addr_Out_K  => Addr_Out_K,
        Addr_Out_N  => Addr_Out_N,
        Addr_Out_A  => Addr_Out_A,
        Addr_Out_B  => Addr_Out_B,
        Data_Out_K  => Data_Out_K,
        Data_Out_B  => Data_Out_B,
        Data_Out_A  => Data_Out_A,
        Data_Out_N  => Data_Out_N
    );
uAesKey :AesKey
    port map (      
        En_In => Ena_Out,
        Ena_Out => Ena_AK,
        Clk => Clk, 
        Rd_En_K => Rd_En_K, --From DataGenerate
        Data_in_K => Data_Out_K,--From DataGenerate
        Addr_Rd_K => Addr_Out_K,--From DataGenerate
        Rd_En_eK =>  Rd_En_eK,
        Addr_Rd_eK => Addr_Rd_eK,
        Data_Out_eK => Data_Out_eK
    );
STat: process(clk,presente)
begin
    if clk 'event and clk = '1' then 
        if Ena_Out ='1' then
            case presente is
                when  s0 =>
                    if Ena_AK = '1' then --Finish Data Force
                        presente <= s1;
                    else
                        presente <= s0;
                    end if;
                when others => null;
            end case;
        end if;
    end if;
end process;

end Main;
