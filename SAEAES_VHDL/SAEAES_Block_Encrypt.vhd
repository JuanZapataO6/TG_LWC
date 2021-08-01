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
        En_In   : in std_logic; -- Flag for start FMS
        En_Out : out std_logic;
        Clk : in std_logic; -- Clock signal 
        --Read Memory bank of key from DataGenerate 
        Rd_En_K : out std_logic;
        Data_in_K : in std_logic_vector (7 downto 0);  
        Addr_Rd_K : out std_logic_vector (3 DOWNTO 0);
        --Output Memory Bank yourself
        Wr_En_eK : out std_logic;
        Addr_Wr_eK : out std_logic_vector (5 DOWNTO 0);
        Data_In_eK : out std_logic_vector (31 downto 0)
    );
end component AesKey;
component AesEnc
    port (      
        En_In   : in std_logic; -- Flag for start FMS
        En_Out  : out std_logic;
        Clk     : in std_logic; -- Clock signal 
        --Read Memory bank of key from DataGenerate 
        Wr_En_eS   : out std_logic;
        Data_In_eS : out std_logic_vector (7 downto 0);  
        Addr_Wr_eS : out std_logic_vector (3 DOWNTO 0);

        Rd_En_eS    : out std_logic;
        Addr_Rd_eS : out std_logic_vector (3 DOWNTO 0);
        Data_Out_eS : in  std_logic_vector (7 downto 0);

        Rd_En_eK    : out std_logic;
        Addr_Rd_eK  : out std_logic_vector (5 DOWNTO 0);
        Data_Out_eK : in  std_logic_vector (31 downto 0)
    );
end component AesEnc;
component Hash
    port (
        Addr_Rd_eS   : out std_logic_vector(3 downto 0);
        Data_Out_eS  : in  std_logic_vector(7 downto 0);
        Rd_En_eS     : out std_logic;
        Addr_Rd_Ad   : out std_logic_vector(4 downto 0);
        Data_Out_Ad  : in  std_logic_vector(7 downto 0);
        Rd_En_Ad     : out std_logic;
        Data_In_S   : out std_logic_vector(7  downto 0);
        Addr_Wr_S   : out std_logic_vector(3 downto 0);
        Wr_En_S     : out std_logic;
        Rst_S       : out std_logic;
        En_In       : in std_logic;
        En_Out      : out std_logic;
        clk         : in std_logic
    );
end component Hash;
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
component Register_Logic 
    
    port (
        DD_IN  : in  std_logic;
        DD_OUT : out std_logic;
        Clk    : in  std_logic

    );
end component Register_Logic;
component Mux
    generic(    
            w:integer--width of word    
        );
    port(
        In_0    : in  std_logic_vector (w-1 downto 0);
        In_1    : in  std_logic_vector (w-1 downto 0);
        In_2    : in  std_logic_vector (w-1 downto 0);
        In_3    : in  std_logic_vector (w-1 downto 0);
        Address : in  std_logic_vector (1 downto 0);
        Data_Out    : out std_logic_vector (w-1 downto 0)
    );
end component Mux;
component MuxLogic
    port(
        In_0   : in  std_logic;
        In_1   : in  std_logic;
        In_2   : in  std_logic;
        In_3   : in  std_logic;
        Address    : in  std_logic_vector (1 downto 0);
        Data_Out        : out std_logic
    );
end component MuxLogic;
component DeMux
    generic(    
            w:integer--width of word    
        );
    port(
        Out_0   : Out std_logic_vector (w-1 downto 0);
        Out_1   : Out std_logic_vector (w-1 downto 0);
        Out_2   : Out std_logic_vector (w-1 downto 0);
        Out_3   : Out std_logic_vector (w-1 downto 0);
        clk     : in  std_logic;
        Address : in  std_logic_vector (1 downto 0);
        Data_In : in  std_logic_vector (w-1 downto 0)
    );
end component DeMux;
TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;
signal clk : std_logic;
--signals Data_Generate component 
signal Rd_En_K      : std_logic; --LogicPin for read Key from DG
signal Rd_En_B      : std_logic; --LogicPin for read Buf from DG
--signal Rd_En_A      : std_logic; --LogicPin for read AddText from DG
signal Rd_En_N      : std_logic; --LogicPin for read Nonce from DG
signal En_DG        : std_logic; --LogicPin for anoucement finish DG
signal Addr_Out_K   : std_logic_vector(3 downto 0); 
signal Addr_Out_N   : std_logic_vector(3 downto 0);
--signal Addr_Out_A   : std_logic_vector(4 downto 0);
signal Addr_Out_B   : std_logic_vector(4 downto 0);
signal Data_Out_K   : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Data_Out_B   : STD_LOGIC_VECTOR(7 DOWNTO 0);
--signal Data_Out_A   : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal Data_Out_N   : STD_LOGIC_VECTOR(7 DOWNTO 0);

--Signals for AesKey with memorybank in this script 
Signal En_AK        : std_logic;
signal Rst          : std_logic;
----Signals for AesKey with memorybank in this script 
Signal En_Hash      : std_logic;
signal Rst_eS       : std_logic;
--
Signal En_AE        : std_logic;
Signal Rd_En_Ad     : std_logic;
Signal Addr_Rd_Ad   : std_logic_vector (4 DOWNTO 0);
Signal Data_Out_Ad  : std_logic_vector (7 downto 0);

--
Signal Rd_En_eK     : std_logic;
Signal Addr_Rd_eK   : std_logic_vector (5 DOWNTO 0);
Signal Data_Out_eK  : std_logic_vector (31 downto 0);

Signal Wr_En_eK     : std_logic;
Signal Addr_Wr_eK   : std_logic_vector (5 DOWNTO 0);
Signal Data_In_eK   : std_logic_vector (31 downto 0);

--Signals for S (state) with memorybank in this script 

Signal Rd_En_S      : std_logic;
Signal Addr_Rd_S    : std_logic_vector (3 DOWNTO 0);
Signal Data_Out_S   : std_logic_vector (7 downto 0);

Signal Wr_En_S      : std_logic;
Signal Addr_Wr_S    : std_logic_vector (3 DOWNTO 0);
Signal Data_In_S    : std_logic_vector (7 downto 0);

--Signal of control from ControlPath to Mux's and Demux
signal Addr_Control : std_logic_vector (1 downto 0);
--Signals For Mux En_Rd_eK
signal eK_Rd_AE     : std_logic;
signal eK_Rd_Hash   : std_logic;
--Signals For Mux Addr_Rd_eK
signal eK_AddrRd_AE  : std_logic_vector(5 downto 0);
Signal eK_AddrRd_Hash: std_logic_vector(5 downto 0);
--Signals For DeMux Data_Out_eK
signal DataIn_eK_AE   : std_logic_vector(31 downto 0);
signal DataIn_eK_Hash : std_logic_vector(31 downto 0);
signal Data_Flag0_eK  : std_logic_vector(31 downto 0);
signal Data_Flag1_eK  : std_logic_vector(31 downto 0);
--Signals For Mux En_Rd_eS
signal eS_Rd_AE     : std_logic;
signal eS_Rd_Hash   : std_logic;
--Signals For Mux Addr_Rd_eS
signal eS_AddrRd_AE  : std_logic_vector(3 downto 0);
Signal eS_AddrRd_Hash: std_logic_vector(3 downto 0);
--Signals For DeMux Data_Out_eS
signal DataOut_eS_AE   : std_logic_vector(7 downto 0);
signal DataOut_eS_Hash : std_logic_vector(7 downto 0);
--Signals For Mux En_Wr_eS
signal eS_Wr_AE     : std_logic;
signal eS_Wr_Hash   : std_logic;
--Signals For Mux Addr_Wr_eS
signal eS_AddrWr_AE  : std_logic_vector(3 downto 0):=x"F";
Signal eS_AddrWr_Hash: std_logic_vector(3 downto 0);
--Signals For DeMux Data_In_eS
signal DataIn_eS_AE   : std_logic_vector(7 downto 0);
signal DataIn_eS_Hash : std_logic_vector(7 downto 0);
--Signal Data dont collition in DeMux
signal Data_Flag0_eS   : std_logic_vector(7 downto 0);
signal Data_Flag1_eS : std_logic_vector(7 downto 0);

begin

reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
end process reloj;
uMux_eK_Rd : MuxLogic
    port map(
        In_0   => eK_Rd_AE, --In for AesEnc
        In_1   => eK_Rd_Hash, --In for Hash 
        In_2   => eK_Rd_AE,
        In_3   => eK_Rd_AE,
        Address    => Addr_Control,
        Data_Out        => Rd_En_eK
    );
uMux_eK_Addr : Mux
    generic map(
        w => 6
    )
    port map(
        In_0   => eK_AddrRd_AE, --In for AesEnc
        In_1   => eK_AddrRd_Hash, --In for Hash 
        In_2   => eK_AddrRd_AE,
        In_3   => eK_AddrRd_AE,
        Address    => Addr_Control,
        Data_Out        => Addr_Rd_eK
    );
uDeMux_eKey  : DeMux
    generic map(    
            w => 32--width of word
    )
    port map( 
        Out_0   => DataIn_eK_AE,
        Out_1   => DataIn_eK_Hash,
        Out_2   => Data_Flag0_eK,
        Out_3   => Data_Flag1_eK,
        clk     => clk,
        Address => Addr_Control,
        Data_In => Data_Out_eK
    );
uMux_eS_Rd : MuxLogic
    port map(
        In_0    => eS_Rd_AE, --In for AesEnc
        In_1    => eS_Rd_Hash, --In for Hash 
        In_2    => eS_Rd_AE,
        In_3    => eS_Rd_AE,
        Address => Addr_Control,
        Data_Out=> Rd_En_S
    );
uMux_eSRd_Addr : Mux
    generic map(
        w => 4
    )
    port map(
        In_0   => eS_AddrRd_AE, --In for AesEnc
        In_1   => eS_AddrRd_Hash, --In for Hash 
        In_2   => eS_AddrRd_AE,
        In_3   => eS_AddrRd_AE,
        Address    => Addr_Control ,
        Data_Out        => Addr_Rd_S
    );
uDeMux_eSe_DOut  : DeMux
    generic map(    
            w => 8--width of word
    )
    port map( 
        Out_0   => DataOut_eS_AE,
        Out_1   => DataOut_eS_Hash,
        Out_2   => Data_Flag0_eS,
        Out_3   => Data_Flag1_eS,
        clk     => Clk,
        Address => Addr_Control,
        Data_In => Data_Out_S
    );
uMux_eS_Wr : MuxLogic
    port map(
        In_0   => Es_Wr_AE, --In for AesEnc
        In_1   => Es_Wr_Hash, --In for Hash 
        In_2   => Es_Wr_AE,
        In_3   => eK_Rd_AE,
        Address    => Addr_Control,
        Data_Out        => Wr_En_S
    );
uMux_eSWr_Adrr : Mux
    generic map (
        w=> 4
    )
    port map(
        In_0    => eS_AddrWr_AE, --In for AesEnc
        In_1    => eS_AddrWr_Hash, --In for Hash 
        In_2    => eS_AddrWr_AE,
        In_3    => eS_AddrWr_AE,
        Address => Addr_Control,
        Data_Out=> Addr_Wr_S
    );
uMux_eS_DataIn : Mux
    generic map (
        w=> 8
    )
    port map(
        In_0   => DataIn_eS_AE, --In for AesEnc
        In_1   => DataIn_eS_Hash, --In for Hash 
        In_2   => DataIn_eS_AE,
        In_3   => DataIn_eS_AE,
        Address  => Addr_Control,
        Data_Out        => Data_In_S
    );

uDataGenerate   : Data_Generate
    port map (
        Clk         => Clk,
        Rd_En_K     => Rd_En_K,
        Rd_En_B     => Rd_En_B,
        Rd_En_A     => Rd_En_Ad,
        Rd_En_N     => Rd_En_N,
        Ena_Out     => En_DG,
        Addr_Out_K  => Addr_Out_K,
        Addr_Out_N  => Addr_Out_N,
        Addr_Out_A  => Addr_Rd_Ad,
        Addr_Out_B  => Addr_Out_B,
        Data_Out_K  => Data_Out_K,
        Data_Out_B  => Data_Out_B,
        Data_Out_A  => Data_Out_Ad,
        Data_Out_N  => Data_Out_N
    );
uAesKey :AesKey
    port map(      
    En_In   => En_DG,
    En_Out  => En_AK,
    Clk     => Clk,
    --Read Memory bank of key from DataGenerate 
    Rd_En_K => Rd_En_K,
    Data_in_K => Data_Out_K,
    Addr_Rd_K => Addr_Out_K,
    --Output Memory Bank yourself
    Wr_En_eK =>  Wr_En_eK,
    Addr_Wr_eK => Addr_Wr_eK,
    Data_In_eK => Data_In_eK
    );
uHash : Hash 
    port map (
    Addr_Rd_eS  =>eS_AddrRd_Hash,
    Data_Out_eS =>DataOut_eS_Hash,
    Rd_En_eS    =>eS_Rd_Hash,
    Addr_Rd_Ad  =>Addr_Rd_Ad,
    Data_Out_Ad =>Data_Out_Ad,
    Rd_En_Ad    =>Rd_En_Ad,
    Data_In_S   =>DataIn_eS_Hash,
    Addr_Wr_S   =>eS_AddrWr_Hash,
    Wr_En_S     =>eS_Wr_Hash,
    Rst_S       =>Rst_eS,
    En_In       =>En_AK,
    En_Out      =>En_Hash,
    clk         =>clk
    );
uAesEnc : AesEnc 
    port map(      
        En_In   => En_Hash,
        En_Out  => En_AE,
        Clk     => Clk,
        --Read Memory bank of key from DataGenerate 
        Wr_En_eS   => Es_Wr_AE,
        Data_In_eS => DataIn_eS_AE,
        Addr_Wr_eS => eS_AddrWr_AE,

        Rd_En_eS    => eS_Rd_AE,
        Addr_Rd_eS  => eS_AddrRd_AE,
        Data_Out_eS => DataOut_eS_AE,

        Rd_En_eK    => eK_Rd_AE,
        Addr_Rd_eK  => eK_AddrRd_AE,
        Data_Out_eK => DataIn_eK_AE
    );
ueKey: MemBnk
    generic map(
        w => 32, --Witdth of words
        d => 44, --Numbers of Words
        a => 6   --Witdth of Address
    )
    Port Map (  
        Wr_En    => Wr_En_eK,   --signal 
        Rd_En    => Rd_En_eK,   --port 
        Rst      => Rst,        --signal 
        Clk      => clk,        --port
        Addr_In  => Addr_Wr_eK, --signal 
        Addr_Out => Addr_Rd_eK, --port
        Data_in  => Data_In_eK, --signal 
        Data_Out => Data_Out_eK --port
    );
ueSe: MemBnk
    generic map(
        w => 8, --Witdth of words
        d => 16, --Numbers of Words
        a => 4   --Witdth of Address
    )
    Port Map (  
        Wr_En    => Wr_En_S,   --signal 
        Rd_En    => Rd_En_S,   --port 
        Rst      => Rst_eS,        --signal 
        Clk      => clk,        --port
        Addr_In  => Addr_Wr_S, --signal 
        Addr_Out => Addr_Rd_S, --port
        Data_in  => Data_In_S, --signal 
        Data_Out => Data_Out_S --port
    );
STat: process(clk,presente)
begin
    if clk 'event and clk = '1' then 
        if En_DG ='1' then
            case presente is
                when  s0 =>
                    if En_AK = '1' then --Finish Data Force
                        presente <= s1;
                        Addr_Control <="01";
                    else
                        presente <= s0;
                    end if;
                when  s1 =>
                    if En_Hash = '1' then --Finish Data Force
                        presente <= s2;
                        Addr_Control <="00";
                    else
                        presente <= s1;
                    end if;
                when others => null;
            end case;
        end if;
    end if;
end process;

end Main;
