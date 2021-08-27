LIBRARY ieee;
library work;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
use ieee.std_logic_misc.all;
use work.all;
entity SAEAES_Block_TB is 
    PORT (
        Rd_En : IN std_logic;
        Addr_Rd : IN std_logic_vector (3 DOWNTO 0);
        Data_Out : Out std_logic_vector (7 downto 0);
        RSTn  : IN std_logic;
        clk   : IN std_logic;
        SERIN : IN std_logic;
        Rd_En_Ct   : IN std_logic;
        Addr_Rd_Ct : IN std_logic_vector  (5 DOWNTO 0);
        Data_rOut_Ct: OUT std_logic_vector (7 downto 0)
    );
end SAEAES_Block_TB;

architecture Main of SAEAES_Block_TB is 
component Data_Generate
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
end component Data_Generate;
component S2P
    port(
        RSTn 	: IN std_logic;
        CLOCK 	: IN std_logic;
        SERIN 	: IN std_logic;
        PERRn 	: OUT std_logic;
        DRDY 	: OUT std_logic;
        DOUT 	: OUT std_logic_vector (7 downto 0)
    );
end component S2P;
component Data_Force
    port( 
        clk     :in  std_logic;
        DIn     :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        --Ports for Data Generate
        En_In   :in  std_logic;
        --Ports for MemBnk Write
        Data_Out:out std_logic_vector (7 DOWNTO 0);
        Addr_Rd :in  std_logic_vector (4 DOWNTO 0);
        Rd_En   :in  std_logic;
        --Ports Of fininish 
        En_Out  :out std_logic
    );
end component ;
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
        --Rd_En : in std_logic;
        --Data_Out_T : out std_logic_vector (7 downto 0);
        --Index_T    : in std_logic_vector (3 DOWNTO 0);

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

        --Rd_En : in std_logic;
        --Data_Out_T : out std_logic_vector (31 downto 0);
        --Index_T    : in std_logic_vector (5 DOWNTO 0);

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
        Addr_Rd_No   : out std_logic_vector(3 downto 0);
        Data_Out_No  : in  std_logic_vector(7 downto 0);
        Rd_En_No     : out std_logic;
        Rst_S       : out std_logic;
        En_In       : in std_logic;
        En_Out      : out std_logic;
        En_Out_1    : out std_logic;
        clk         : in std_logic
    );
end component Hash;
component Encrypt
    port(
        Addr_Rd_eS  : out std_logic_vector(3 downto 0);
        Data_Out_eS : in  std_logic_vector(7 downto 0);
        Rd_En_eS    : out std_logic;
        --Rd_En : in std_logic;
        --Data_Out_T : out std_logic_vector (7 downto 0);
        --Index_T    : in std_logic_vector (5 DOWNTO 0);       
        Addr_Rd_Bf  : out std_logic_vector(4 downto 0);
        Data_Out_Bf : in  std_logic_vector(7 downto 0);
        Rd_En_Bf    : out std_logic;
        Data_In_Ct  : out std_logic_vector(7  downto 0);
        Addr_Wr_Ct  : out std_logic_vector(5 downto 0);
        Wr_En_Ct    : out std_logic;
        Data_In_S   : out std_logic_vector(7  downto 0);
        Addr_Wr_S   : out std_logic_vector(3 downto 0);
        Wr_En_S     : out std_logic;
        En_In       : in std_logic;
        En_Out      : out std_logic;
        En_Out_1    : out std_logic;
        clk         : in std_logic
    );
end component Encrypt;
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
--signal clk : std_logic;
--Signals for Serial convert Paralell
signal PERRn, DRDY : std_logic;
signal DOUT : std_logic_vector (7 downto 0);
signal En_DF : std_logic; --LogicPin for anoucement finish DataForce, Save Data from Serial In 
signal En_DG : std_logic; --LogicPin for anoucement finish DataGenerate, Nonce,Key, AddText
signal En_AK : std_logic; --LogicPin for anoucement finish AesKey
signal En_AE : std_logic; --LogicPin for anoucement finish AesEnc
signal En_Hash : std_logic;
signal En_Hash_1 : std_logic;
Signal En_Encrypt   : std_logic;
Signal En_Encrypt_1 : std_logic;
signal Rst_eS : std_logic := '1';
signal rRst_eS : std_logic := '1';
signal Rst_S : std_logic := '1';
signal Rst : std_logic := '1';
----Signals for AesKey with memorybank in this script 
--Data Generate Nonce, AddText, Key, BufferMesasagge
signal Rd_En_Ad, rRd_En_Ad : std_logic; --LogicPin for read Key from DG
signal Rd_En_No, rRd_En_No : std_logic; --LogicPin for read Key from DG
signal Rd_En_Ke, rRd_En_Ke : std_logic; --LogicPin for read Key from DG
signal Rd_En_Bf, rRd_En_Bf : std_logic; --LogicPin for read Key from DG

signal Addr_Rd_Ad,Addr_rRd_Ad : std_logic_vector(4 downto 0);
signal Addr_Rd_No,Addr_rRd_No : std_logic_vector(3 downto 0);
signal Addr_Rd_Ke,Addr_rRd_Ke : std_logic_vector(3 downto 0);
signal Addr_Rd_Bf,Addr_rRd_Bf : std_logic_vector(4 downto 0);

signal Data_Out_Ad,Data_rOut_Ad : std_logic_vector(7 downto 0);
signal Data_Out_No,Data_rOut_No : std_logic_vector(7 downto 0);
signal Data_Out_Ke,Data_rOut_Ke : std_logic_vector(7 downto 0);
signal Data_Out_Bf,Data_rOut_Bf : std_logic_vector(7 downto 0);

signal Wr_En_eK, rWr_En_eK : std_logic;
signal Addr_Wr_eK,Addr_rWr_eK : std_logic_vector (5 DOWNTO 0);
signal Data_In_eK,Data_rIn_eK : std_logic_vector (31 downto 0);

signal Rd_En_eK, rRd_En_eK : std_logic;
signal Addr_Rd_eK,Addr_rRd_eK : std_logic_vector (5 DOWNTO 0);
signal Data_Out_eK,Data_rOut_eK : std_logic_vector (31 downto 0);

--Signals for S (state) with memorybank in this script 
signal Wr_En_eS, rWr_En_eS : std_logic;
signal Addr_Wr_eS,Addr_rWr_eS : std_logic_vector (3 DOWNTO 0);
signal Data_In_eS,Data_rIn_eS : std_logic_vector (7 downto 0);

signal Rd_En_eS, rRd_En_eS : std_logic;
signal Addr_Rd_eS,Addr_rRd_eS : std_logic_vector (3 DOWNTO 0);
signal Data_Out_eS : std_logic_vector (7 downto 0);--Without Register because in the Demux there is a FF

signal Wr_En_Ct, rWr_En_Ct : std_logic;
signal Addr_Wr_Ct,Addr_rWr_Ct : std_logic_vector (5 DOWNTO 0);
signal Data_In_Ct,Data_rIn_Ct : std_logic_vector (7 downto 0);

signal rRd_En_Ct : std_logic;
signal Addr_rRd_Ct : std_logic_vector (5 DOWNTO 0);
signal Data_Out_Ct : std_logic_vector (7 downto 0);

--Signals For Mux En_Rd_eS
signal eS_Rd_AE         : std_logic;
signal eS_Rd_Hash       : std_logic;
signal eS_Rd_Encrypt    : std_logic;
--Signals For Mux Addr_Rd_eS
signal eS_AddrRd_AE     : std_logic_vector(3 downto 0);
Signal eS_AddrRd_Hash   : std_logic_vector(3 downto 0);
Signal eS_AddrRd_Encrypt: std_logic_vector(3 downto 0);
--Signals For DeMux Data_Out_eS
signal DataOut_eS_AE      : std_logic_vector(7 downto 0);
signal DataOut_eS_Hash    : std_logic_vector(7 downto 0);
signal DataOut_eS_Encrypt : std_logic_vector(7 downto 0);
--Signal of control from ControlPath to Mux's and Demux
signal Addr_Control : std_logic_vector (1 downto 0);

signal Data_Flag0_eK  : std_logic_vector(31 downto 0);
signal Data_Flag1_eK  : std_logic_vector(31 downto 0);

--Signals For Mux En_Wr_eS
signal eS_Wr_AE         : std_logic:='1';
signal eS_Wr_Hash       : std_logic:='1';
signal eS_Wr_Encrypt    : std_logic;
--Signals For Mux Addr_Wr_eS
signal eS_AddrWr_AE     : std_logic_vector(3 downto 0):=x"F";
Signal eS_AddrWr_Hash   : std_logic_vector(3 downto 0);
Signal eS_AddrWr_Encrypt: std_logic_vector(3 downto 0):=x"F";
--Signals For DeMux Data_In_eS
signal DataIn_eS_AE     : std_logic_vector(7 downto 0);
signal DataIn_eS_Hash   : std_logic_vector(7 downto 0);
signal DataIn_eS_Encrypt: std_logic_vector(7 downto 0);
--Signal Data dont collition in DeMux
--
signal Addr_Test    : std_logic_vector(3 downto 0):=x"F";
signal Logic_Test   : std_logic:= '1';
signal Data_Test    : std_logic_vector(7 downto 0);

signal Flag_Hash    : std_logic;
signal Flag_Encrypt : std_logic;
signal Flag_AesEnc  : std_logic;
signal Flag_AesKey  : std_logic;
begin
uS2P: S2P 
    PORT MAP (
        RSTn 	=> RSTn,
        CLOCK 	=> Clk,
        SERIN 	=> SERIN,
        PERRn 	=> PERRn,
        DRDY 	=> DRDY,
        DOUT 	=> DOUT
    );
uDF: Data_Force
    port map( 
        clk      =>clk,
        DIn      =>DOUT,
        En_In    =>DRDY,
        Data_Out =>Data_Out_Bf,
        Addr_Rd  =>Addr_rRd_Bf,
        Rd_En    =>rRd_En_Bf,
        En_Out   =>En_DF
    );
--Read Nonce value
uReg_Rd_No : Register_Logic
    port map(
        DD_IN  => Rd_En_No,
        DD_OUT => rRd_En_No,
        Clk    => clk
    );
uReg_AddrRd_No :Register_A
    generic map(
        w => 4--width of word
    )
    port map (
        DD_IN  =>Addr_Rd_No,
        DD_OUT =>Addr_rRd_No,
        Clk    =>clk
    );
Reg_DataOut_No :Register_A
    generic map(
        w => 8--width of word
    )
    port map (
        DD_IN  =>Data_Out_No,
        DD_OUT =>Data_rOut_No,
        Clk    =>clk
    );
--Read TextAdd Value
uReg_Rd_Ad : Register_Logic
    port map(
        DD_IN  => Rd_En_Ad,
        DD_OUT => rRd_En_Ad,
        Clk    => clk
    );
uReg_AddrRd_Ad :Register_A
    generic map(
        w => 5--width of word
    )
    port map (
        DD_IN  =>Addr_Rd_Ad,
        DD_OUT =>Addr_rRd_Ad,
        Clk    =>clk
    );
Reg_DataOut_Ad :Register_A
    generic map(
        w => 8--width of word
    )
    port map (
        DD_IN  =>Data_Out_Ad,
        DD_OUT =>Data_rOut_Ad,
        Clk    =>clk
    );
--Read messagge value
uReg_Rd_Bf : Register_Logic
    port map(
        DD_IN  => Rd_En_Bf,
        DD_OUT => rRd_En_Bf,
        Clk    => clk
    );
uReg_AddrRd_Bf :Register_A
    generic map(
        w => 5--width of word
    )
    port map (
        DD_IN  =>Addr_Rd_Bf,
        DD_OUT =>Addr_rRd_Bf,
        Clk    =>clk
    );
Reg_DataOut_Bf :Register_A
    generic map(
        w => 8--width of word
    )
    port map (
        DD_IN  =>Data_Out_Bf,
        DD_OUT =>Data_rOut_Bf,
        Clk    =>clk
    );
--Registers for Memory Bank Key Value
uReg_Rd_Ke : Register_Logic
    port map(
        DD_IN  => Rd_En_Ke,
        DD_OUT => rRd_En_Ke,
        Clk    => clk
    );
uReg_AddrRd_Ke :Register_A
    generic map(
        w => 4--width of word
    )
    port map (
        DD_IN  =>Addr_Rd_Ke,
        DD_OUT =>Addr_rRd_Ke,
        Clk    =>clk
    );
Reg_DataOut_Ke :Register_A
    generic map(
        w => 8--width of word
    )
    port map (
        DD_IN  =>Data_Out_Ke,
        DD_OUT =>Data_rOut_Ke,
        Clk    =>clk
    );
--Read eKey value
uReg_Rd_eK : Register_Logic
    port map(
        DD_IN  => Rd_En_eK,
        DD_OUT => rRd_En_eK,
        Clk    => clk
    );
uReg_AddrRd_eK :Register_A
    generic map(
        w => 6--width of word
    )
    port map (
        DD_IN  =>Addr_Rd_eK,
        DD_OUT =>Addr_rRd_eK,
        Clk    =>clk
    );
Reg_DataOut_eK :Register_A
    generic map(
        w => 32--width of word
    )
    port map (
        DD_IN  =>Data_Out_eK,
        DD_OUT =>Data_rOut_eK,
        Clk    =>clk
    );
--Write eKey value
uReg_Wr_eK : Register_Logic
    port map(
        DD_IN  => Wr_En_eK,
        DD_OUT => rWr_En_eK,
        Clk    => clk
    );
uReg_AddrWr_eK :Register_A
    generic map(
        w => 6--width of word
    )
    port map (
        DD_IN  =>Addr_Wr_eK,
        DD_OUT =>Addr_rWr_eK,
        Clk    =>clk
    );
Reg_DataIn_eK :Register_A
    generic map(
        w => 32--width of word
    )
    port map (
        DD_IN  =>Data_In_eK,
        DD_OUT =>Data_rIn_eK,
        Clk    =>clk
    );
--Read eSe value Demux, in PinOut have a FF
uReg_Rd_eS : Register_Logic
    port map(
        DD_IN  => Rd_En_eS,
        DD_OUT => rRd_En_eS,
        Clk    => clk
    );
uReg_AddrRd_eS :Register_A
    generic map(
        w => 4--width of word
    )
    port map (
        DD_IN  =>Addr_Rd_eS,
        DD_OUT =>Addr_rRd_eS,
        Clk    =>clk
    );
--Write eSe value
uReg_Wr_eS : Register_Logic
    port map(
        DD_IN  => Wr_En_eS,
        DD_OUT => rWr_En_eS,
        Clk    => clk
    );
uReg_AddrWr_eS :Register_A
    generic map(
        w => 4--width of word
    )
    port map (
        DD_IN  =>Addr_Wr_eS,
        DD_OUT =>Addr_rWr_eS,
        Clk    =>clk
    );
Reg_DataIn_eS :Register_A
    generic map(
        w => 8--width of word
    )
    port map (
        DD_IN  =>Data_In_eS,
        DD_OUT =>Data_rIn_eS,
        Clk    =>clk
    );
--Read Ct value
uReg_Rd_Ct : Register_Logic
    port map(
        DD_IN  => Rd_En,--Rd_En_Ct,
        DD_OUT => rRd_En_Ct,
        Clk    => clk
    );
uReg_AddrRd_Ct :Register_A
    generic map(
        w => 6--width of word
    )
    port map (
        DD_IN  =>Addr_Rd_Ct,
        DD_OUT =>Addr_rRd_Ct,
        Clk    =>clk
    );
Reg_DataOut_Ct :Register_A
    generic map(
        w => 8--width of word
    )
    port map (
        DD_IN  =>Data_Out_Ct,
        DD_OUT =>Data_rOut_Ct,
        Clk    =>clk
    );
--Write Ct value
uReg_Wr_Ct : Register_Logic
    port map(
        DD_IN  => Wr_En_Ct,
        DD_OUT => rWr_En_Ct,
        Clk    => clk
    );
uReg_AddrWr_Ct :Register_A
    generic map(
        w => 6--width of word
    )
    port map (
        DD_IN  =>Addr_Wr_Ct,
        DD_OUT =>Addr_rWr_Ct,
        Clk    =>clk
    );
Reg_DataIn_Ct :Register_A
    generic map(
        w => 8--width of word
    )
    port map (
        DD_IN  =>Data_In_Ct,
        DD_OUT =>Data_rIn_Ct,
        Clk    =>clk
    );
--

uMux_Rd_eS : MuxLogic
    port map(
        In_0    => eS_Rd_AE, --In for AesEnc
        In_1    => eS_Rd_Hash, --In for Hash 
        In_2    => eS_Rd_Encrypt,-- Logic_Test, ---
        In_3    => Rd_En,-- Logic_Test, ---
        Address => Addr_Control,
        Data_Out=> Rd_En_eS
    );
uMux_AddrRd_eS : Mux
    generic map(
        w => 4
    )
    port map(
        In_0     => eS_AddrRd_AE, --In for AesEnc
        In_1     => eS_AddrRd_Hash, --In for Hash 
        In_2     => eS_AddrRd_Encrypt,
        In_3     => Addr_Rd,--Addr_Test,--
        Address  => Addr_Control,
        Data_Out => Addr_Rd_eS
    );
uDeMux_DOut_eS : DeMux
    generic map(    
            w => 8--width of word
    )
    port map( 
        Out_0   => DataOut_eS_AE,
        Out_1   => DataOut_eS_Hash,
        Out_2   => DataOut_eS_Encrypt,
        Out_3   => Data_Out,--Data_Test,--
        clk     => Clk,
        Address => Addr_Control,
        Data_In => Data_Out_eS
    );
uMux_Wr_eS : MuxLogic
    port map(
        In_0     => Es_Wr_AE, --In for AesEnc
        In_1     => Es_Wr_Hash, --In for Hash 
        In_2     => Es_Wr_Encrypt,--Logic_Test,--
        In_3     => Logic_Test,
        Address  => Addr_Control,
        Data_Out => Wr_En_eS
    );
uMux_AddrWr_eS : Mux
    generic map (
        w=> 4
    )
    port map(
        In_0    => eS_AddrWr_AE, --In for AesEnc
        In_1    => eS_AddrWr_Hash, --In for Hash 
        In_2    => eS_AddrWr_Encrypt,
        In_3    => Addr_Test,
        Address => Addr_Control,
        Data_Out=> Addr_Wr_eS
    );
uMux_DIn_eS : Mux
    generic map (
        w=> 8
    )
    port map(
        In_0    => DataIn_eS_AE, --In for AesEnc
        In_1    => DataIn_eS_Hash, --In for Hash 
        In_2    => DataIn_eS_Encrypt,
        In_3    => Data_Test,
        Address => Addr_Control,
        Data_Out=> Data_In_eS
    );

uDataGenerate  : Data_Generate
    port map (
        Clk         => Clk,
        Rd_En_K     => rRd_En_Ke,
        Rd_En_A     => rRd_En_Ad,
        Rd_En_N     => rRd_En_No,
        Ena_Out     => En_DG,
        Addr_Out_K  => Addr_rRd_Ke,
        Addr_Out_N  => Addr_rRd_No,
        Addr_Out_A  => Addr_rRd_Ad,
        Data_Out_K  => Data_Out_Ke,
        Data_Out_A  => Data_Out_Ad,
        Data_Out_N  => Data_Out_No
    );
uAesKey :AesKey
    port map(      
    En_In   => En_DG,
    En_Out  => En_AK,
    Clk     => Clk,
    --Read Memory bank of key from DataGenerate 
    Rd_En_K   => Rd_En_Ke,
    Data_in_K => Data_rOut_Ke,
    Addr_Rd_K => Addr_Rd_Ke,
    
    --Rd_En  => Rd_En,
    --Data_Out_T => Data_Out,
    --Index_T    => Addr_Rd,
    --Output Memory Bank yourself
    Wr_En_eK   => Wr_En_eK,
    Addr_Wr_eK => Addr_Wr_eK,
    Data_In_eK => Data_In_eK
    );
uHash : Hash 
    port map (
    Addr_Rd_eS  =>eS_AddrRd_Hash,
    Data_Out_eS =>DataOut_eS_Hash,
    Rd_En_eS    =>eS_Rd_Hash,
    Addr_Rd_Ad  =>Addr_Rd_Ad,
    Data_Out_Ad =>Data_rOut_Ad,
    Rd_En_Ad    =>Rd_En_Ad,
    Data_In_S   =>DataIn_eS_Hash,
    Addr_Wr_S   =>eS_AddrWr_Hash,
    Wr_En_S     =>eS_Wr_Hash,
    Addr_Rd_No  =>Addr_Rd_No,
    Data_Out_No =>Data_rOut_No,
    Rd_En_No    =>Rd_En_No,
    Rst_S       =>Rst_S,
    En_In       =>Flag_Hash,
    En_Out      =>En_Hash,
    En_Out_1    =>En_Hash_1,
    clk         =>clk
    );
uAesEnc : AesEnc 
    port map(      
        En_In   => Flag_AesEnc,
        En_Out  => En_AE,
        Clk     => Clk,
        --Read Memory bank of key from DataGenerate 
        Wr_En_eS   => Es_Wr_AE,
        Data_In_eS => DataIn_eS_AE,
        Addr_Wr_eS => eS_AddrWr_AE,

        Rd_En_eS    => eS_Rd_AE,
        Addr_Rd_eS  => eS_AddrRd_AE,
        Data_Out_eS => DataOut_eS_AE,

        --Rd_En      =>Rd_En, 
        --Data_Out_T =>Data_Out, 
        --Index_T    =>Addr_Rd,
        
        Rd_En_eK    => Rd_En_eK,
        Addr_Rd_eK  => Addr_Rd_eK,
        Data_Out_eK => Data_rOut_eK
    );
uEncrypt : Encrypt
    port map (
        Addr_Rd_eS   =>eS_AddrRd_Encrypt,
        Data_Out_eS  =>DataOut_eS_Encrypt,
        Rd_En_eS     =>eS_Rd_Encrypt,

        Addr_Rd_Bf   =>Addr_Rd_Bf,
        Data_Out_Bf  =>Data_rOut_Bf,
        Rd_En_Bf     =>Rd_En_Bf,

        Data_In_Ct   =>Data_In_Ct,
        Addr_Wr_Ct   =>Addr_Wr_Ct,
        Wr_En_Ct     =>Wr_En_Ct,

        Data_In_S   =>DataIn_eS_Encrypt,
        Addr_Wr_S   =>eS_AddrWr_Encrypt,
        Wr_En_S     =>eS_Wr_Encrypt,

        En_In       =>Flag_Encrypt,
        En_Out      =>En_Encrypt,
        En_Out_1    =>En_Encrypt_1,
        clk         =>clk
    );
ueKey: MemBnk
    generic map(
        w => 32, --Witdth of words
        d => 44, --Numbers of Words
        a => 6   --Witdth of Address
    )
    Port Map (  
        Wr_En    => rWr_En_eK,   --signal 
        Rd_En    => rRd_En_eK,   --port 
        Rst      => Rst,        --signal 
        Clk      => clk,        --port
        Addr_In  => Addr_rWr_eK, --signal 
        Addr_Out => Addr_rRd_eK, --port
        Data_in  => Data_rIn_eK, --signal 
        Data_Out => Data_Out_eK --port
    );
ueSe: MemBnk
    generic map(
        w => 8, --Witdth of words
        d => 16, --Numbers of Words
        a => 4   --Witdth of Address
    )
    Port Map (  
        Wr_En    => rWr_En_eS,   --signal 
        Rd_En    => rRd_En_eS,   --port 
        Rst      => Rst_eS,        --signal 
        Clk      => clk,        --port
        Addr_In  => Addr_rWr_eS, --signal 
        Addr_Out => Addr_rRd_eS, --port
        Data_in  => Data_rIn_eS, --signal 
        Data_Out => Data_Out_eS --port
    );
uCt: MemBnk
    generic map(
        w => 8, --Witdth of words
        d => 40, --Numbers of Words
        a => 6   --Witdth of Address
    )
    Port Map (  
        Wr_En    => rWr_En_Ct,   --signal 
        Rd_En    => rRd_En_Ct,   --port 
        Rst      => Rst,        --signal 
        Clk      => clk,        --port
        Addr_In  => Addr_rWr_Ct, --signal 
        Addr_Out => Addr_rRd_Ct, --port
        Data_in  => Data_rIn_Ct, --signal 
        Data_Out => Data_Out_Ct--port
    );
STat: process(clk,presente)
begin
    if clk 'event and clk = '1' then 
        if En_DF ='1' then
            case presente is
                when s0 =>
                    if En_AK = '1' then --Finish AesKey
                        Flag_Hash <= '1';
                        presente <= s1;
                        Addr_Control <="01";
                    else
                        Flag_Hash <= '0';
                        presente <= s0;
                    end if;
                when s1 =>
                    if En_Hash_1 = '1' then 
                        presente <= s3;
                        Addr_Control <="00";
                        Flag_Hash <= '0';
                        Flag_AesEnc <= '1';
                    elsif En_Hash = '1' then --Finish Data Force
                        presente <= s2;
                        Addr_Control <="00";
                        Flag_Hash <= '0';
                        Flag_AesEnc <= '1';
                    else
                        presente <= s1;
                        Flag_AesEnc <= '0';
                        Addr_Control <="01";
                    end if;
                when s2 =>
                    if En_AE = '1' then --Finish Data Force
                        presente <= s1;
                        Addr_Control <="01";
                        Flag_Hash <= '1';
                        Flag_AesEnc <= '0';
                    else
                        presente <= s2;
                        Flag_AesEnc <= '1';
                        Addr_Control <="00";
                    end if;
                when s3 =>
                    if En_AE = '1' then --Finish Data Force
                        presente <= s4;
                        Addr_Control <="01";
                        Flag_Hash <= '1';
                        Flag_AesEnc <= '0';
                    else
                        presente <= s3;
                        Flag_AesEnc <= '1';
                        Addr_Control <="00";
                    end if;
                when s4 =>
                    if En_Hash_1 = '1' then --Finish Data Force
                        presente <= s5;
                        Addr_Control <="00";
                        Flag_AesEnc <= '1';
                        Flag_Hash <= '0';
                    else
                        presente <= s4;
                        Flag_AesEnc <= '0';
                        Flag_Hash <= '1';
                        Addr_Control <="01";
                    end if;
                when s5 =>
                    if En_AE = '1' then --Finish Data Force
                        presente <= s6;
                        --Addr_Control <="10"; 
                        Flag_Encrypt <= '1';
                        Flag_AesEnc <= '0';
                    else
                        presente <= s5;
                        Flag_AesEnc <= '1';
                        Addr_Control <="00";
                    end if;
                when s6 =>
                    if En_Encrypt_1 = '1' then 
                        presente <= s7;
                        Addr_Control <="00";
                        Flag_Encrypt <= '0';
                        Flag_AesEnc  <= '1';
                        --presente <= s20;
                    elsif En_Encrypt = '1' then --Finish Data Force
                        presente <= s5;
                        Addr_Control <="00";
                        Flag_AesEnc  <= '1';
                        Flag_Encrypt <= '0';
                        --presente <= s20;
                    else
                        presente <= s6;
                        Flag_AesEnc <= '0';
                        Addr_Control <="10";
                        Flag_Encrypt <= '1';
                    end if;
                when s7 =>
                    if En_AE = '1' then --Finish Data Force
                        presente <= s8;
                        --Addr_Control <="10";
                        Flag_Encrypt <= '1';
                        Flag_AesEnc <= '0';
                    else
                        presente <= s7;
                        Flag_AesEnc <= '1';
                        Addr_Control <="00";
                        Flag_Encrypt <= '0';
                        --presente <= s20;
                    end if;
                when s8 =>
                    if En_Encrypt_1 = '1' then --Finish Data Force
                        presente <= s20;
                        Addr_Control <="11";
                        Flag_Encrypt <= '0';
                        Flag_AesEnc <= '0';
                    else
                        presente <= s8;
                        Flag_AesEnc <= '0';
                        Addr_Control <="10";
                        Flag_Encrypt <= '1';
                        --presente <= s20;
                    end if;
                when s20 =>
                    Addr_Control <="11";
                    Flag_Encrypt <= '0';
                    Flag_AesEnc <= '0';
                    Flag_Hash <= '0';
                    Flag_AesKey <= '0';

                when others => null;
            end case;
        end if;
    end if;
end process;

end Main;
