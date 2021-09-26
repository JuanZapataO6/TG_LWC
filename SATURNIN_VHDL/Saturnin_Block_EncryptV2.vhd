LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity Saturnin_Block_EncryptV2 is
    PORT (
        En_Ad      : IN std_logic;
        Rd_En      : IN std_logic;
        Addr_Rd    : IN std_logic_vector (3 DOWNTO 0);
        Data_Out_T : Out std_logic_vector (15 downto 0);
        RSTn 	   : IN std_logic;
        clk 	   : IN std_logic;
        SERIN 	   : IN std_logic;
        Rd_En_Ct   : IN std_logic;
        Addr_Rd_Ct : IN std_logic_vector  (5 DOWNTO 0);
        Data_rOut_Ct: OUT std_logic_vector (15 downto 0));
end Saturnin_Block_EncryptV2;
architecture Main of Saturnin_Block_EncryptV2 is 
component S2P 
    PORT (
        RSTn  : IN std_logic;
        CLOCK : IN std_logic;
        SERIN : IN std_logic;
        PERRn : OUT std_logic;
        DRDY  : OUT std_logic;
        DOUT  : OUT std_logic_vector (7 downto 0));
end component S2P;
component DataS2P 
    port( 
        clk      :in  std_logic;
        En_Ad    :in  std_logic;
        DIn      :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        En_In    :in  std_logic;
        Data_Out :out std_logic_vector (7 DOWNTO 0);
        Addr_Rd  :in  std_logic_vector (3 DOWNTO 0);
        Rd_En    :in  std_logic;
        En_Out   :out std_logic);
end component DataS2P;
component Register_A
    generic(
        w:integer--width of word
    );
    port (
        DD_IN  : in  std_logic_vector (w-1 downto 0);
        DD_OUT : out std_logic_vector (w-1 downto 0);
        Clk    : in  std_logic);
end component Register_A;
component Register_Logic 
    port (
        DD_IN  : in  std_logic;
        DD_OUT : out std_logic;
        Clk    : in  std_logic);
end component Register_Logic;
component Data_Generate
    port (
        Clk           :in  std_logic;
        Rd_En_K       :in  std_logic;
        Rd_En_N       :in  std_logic;
        En_Out       :out std_logic;
        Addr_Rd_N    :in  std_logic_vector(3 downto 0);
        Addr_Rd_K    :in  std_logic_vector(4 downto 0);
        Data_Out_K    :out STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_N    :out STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
end component Data_Generate;
component Data_Force
    port( 
        clk         :in  std_logic;
        En_In       :in  std_logic;
        Rd_En_K   :out std_logic;
        Rd_En_B   :out std_logic;
        Rd_En_N   :out std_logic;
        Addr_Rd_K :out std_logic_vector(4 downto 0);
        Addr_Rd_B :out std_logic_vector(3 downto 0);
        Addr_Rd_N :out std_logic_vector(3 downto 0);
        Data_Out_K :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_B :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_Out_N :in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        Data_rIn_xK :out std_logic_vector (15 DOWNTO 0);
        Data_rIn_xB :out std_logic_vector (15 DOWNTO 0);
        Addr_Wr_xB  :out std_logic_vector (3 DOWNTO 0);
        Addr_Wr_xK  :out std_logic_vector (3 DOWNTO 0);
        Wr_En_xK    :out std_logic;
        Wr_En_xB    :out std_logic;
        En_Out  :out std_logic);
end component Data_Force;
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
        Data_Out : out std_logic_vector (w-1 downto 0));
end component MemBnk;
component Mux
    generic(    
            w:integer--width of word    
        );
    port(
        In_0 : in  std_logic_vector (w-1 downto 0);
        In_1 : in  std_logic_vector (w-1 downto 0);
        In_2 : in  std_logic_vector (w-1 downto 0);
        In_3 : in  std_logic_vector (w-1 downto 0);
        In_4 : in  std_logic_vector (w-1 downto 0);
        In_5 : in  std_logic_vector (w-1 downto 0);
        In_6 : in  std_logic_vector (w-1 downto 0);
        In_7 : in  std_logic_vector (w-1 downto 0);
        In_8 : in  std_logic_vector (w-1 downto 0);
        In_9 : in  std_logic_vector (w-1 downto 0);
        In_A : in  std_logic_vector (w-1 downto 0);
        Sel  : in  std_logic_vector (3 downto 0);
        DOut : out std_logic_vector (w-1 downto 0));   
end component Mux;
component MuxLogic
    port(
        In_0 : in  std_logic;
        In_1 : in  std_logic;
        In_2 : in  std_logic;
        In_3 : in  std_logic;
        In_4 : in  std_logic;
        In_5 : in  std_logic;
        In_6 : in  std_logic;
        In_7 : in  std_logic;
        In_8 : in  std_logic;
        In_9 : in  std_logic;
        In_A : in  std_logic;
        Sel  : in  std_logic_vector (3 downto 0);
        DOut : out std_logic);
end component MuxLogic;
component DeMux
    generic(
        w:integer --width of word
    );
    port( 
        Out_0 : Out std_logic_vector (w-1 downto 0);
        Out_1 : Out std_logic_vector (w-1 downto 0);
        Out_2 : Out std_logic_vector (w-1 downto 0);
        Out_3 : Out std_logic_vector (w-1 downto 0);
        Out_4 : Out std_logic_vector (w-1 downto 0);
        Out_5 : Out std_logic_vector (w-1 downto 0);
        Out_6 : Out std_logic_vector (w-1 downto 0);
        Out_7 : Out std_logic_vector (w-1 downto 0);
        Out_8 : Out std_logic_vector (w-1 downto 0);
        Out_9 : Out std_logic_vector (w-1 downto 0);
        Out_A : Out std_logic_vector (w-1 downto 0);
        DIn   : in  std_logic_vector (w-1 downto 0);
        Sel   : in  std_logic_vector (3 downto 0));
end component DeMux;
component XOR_key  
    port (
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_rIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Addr_Rd_K   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Rd_En_k     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        Data_Out_K  : in std_logic_vector (0 to 15);
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic);
end component XOR_key;
component XOR_key_Rotated  
    port (
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_rIn_B  : out std_logic_vector (15 downto 0);
        Wr_En_B     : out std_logic;
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Addr_Rd_K   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Rd_En_k     : out std_logic;
        Data_Out_B  : in std_logic_vector (15 downto 0);
        Data_Out_K  : in std_logic_vector (15 downto 0);
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic);
end component XOR_key_Rotated;
component S_Box is
    port (
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_rIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic);
end component S_Box;
component MDS is 
        port (
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_rIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic);
end component MDS;
component SR_Slice is
    port (
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_rIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic);
end component SR_Slice;
component SR_Slice_Inv is
    port (
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_rIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic);
end component SR_Slice_Inv;
component SR_Sheet is
    port (
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_rIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (15 downto 0);
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic);
end component SR_Sheet;
component SR_Sheet_Inv is
    port (
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_rIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (15 downto 0);
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic);
end component SR_Sheet_Inv;
component RC_X is
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B  : out std_logic_vector(3 downto 0);
        Data_RIn_B : out std_logic_vector (15 downto 0);
        Wr_En_B    : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B  : out std_logic_vector(3 downto 0);
        Rd_En_B    : out std_logic;
        Data_Out_B : in std_logic_vector (15 downto 0);
        --Ports For Control Component
        i_Control : in std_logic_vector(4 DOWNTO 0);
        clk   : in std_logic; 
        En_In : in std_logic;
        En_Out : out std_logic);
end component RC_X;
TYPE estado is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;
--
signal PERRn, DRDY : std_logic;
signal Rst : std_logic:='1';
signal DOUT : std_logic_vector (7 downto 0);
signal En_S2P : std_logic;
signal En_DG  : std_logic;
signal En_DF  : std_logic:='0';
signal Addr_Control  : std_logic_vector (3 downto 0):="0000";
signal Sel  : std_logic_vector (3 downto 0):="0000";
--
signal Addr_Rd_N : std_logic_vector (3 DOWNTO 0);
signal Data_Out_N : std_logic_vector (7 DOWNTO 0);
signal Rd_En_N : std_logic;
--
signal Addr_rRd_N : std_logic_vector (3 DOWNTO 0);
signal Data_rOut_N : std_logic_vector (7 DOWNTO 0);
signal rRd_En_N : std_logic;
--
signal Addr_Rd_K : std_logic_vector (4 DOWNTO 0);
signal Data_Out_K : std_logic_vector (7 DOWNTO 0);
signal Rd_En_K : std_logic;
--
signal Addr_rRd_K : std_logic_vector (4 DOWNTO 0);
signal Data_rOut_K : std_logic_vector (7 DOWNTO 0);
signal rRd_En_K : std_logic;
--
signal Addr_Rd_B : std_logic_vector (3 DOWNTO 0);
signal Data_Out_B : std_logic_vector (7 DOWNTO 0);
signal Rd_En_B : std_logic;
--
signal Addr_Wr_xB   : std_logic_vector (3 DOWNTO 0);
signal Data_In_xB   : std_logic_vector (15 DOWNTO 0);
signal Wr_En_xB     : std_logic:= '1'; --after Register
---
signal Addr_rWr_xB   : std_logic_vector (3 DOWNTO 0);
signal Data_rIn_xB   : std_logic_vector (15 DOWNTO 0);
signal rWr_En_xB     : std_logic:= '1';--Before Register
--
signal Addr_Wr_xK   : std_logic_vector (3 DOWNTO 0);
signal Data_In_xK   : std_logic_vector (15 DOWNTO 0);
signal Wr_En_xK     : std_logic:= '1'; --after Register
---
signal Addr_rWr_xK   : std_logic_vector (3 DOWNTO 0);
signal Data_rIn_xK   : std_logic_vector (15 DOWNTO 0);
signal rWr_En_xK     : std_logic:= '1';--Before Register
--
signal Addr_Rd_xB   : std_logic_vector (3 DOWNTO 0);
signal Data_Out_xB   : std_logic_vector (15 DOWNTO 0);
signal Rd_En_xB     : std_logic:= '1'; --after Register
---
signal Addr_rRd_xB   : std_logic_vector (3 DOWNTO 0);
signal rRd_En_xB     : std_logic:= '1';--Before Register
signal Data_rOut_xB   : std_logic_vector (15 DOWNTO 0);
--
signal Addr_Rd_xK   : std_logic_vector (3 DOWNTO 0);
signal Data_Out_xK   : std_logic_vector (15 DOWNTO 0);
signal Rd_En_xK     : std_logic:= '1'; --after Register
--
signal Addr_rRd_xK   : std_logic_vector (3 DOWNTO 0);
signal rRd_En_xK     : std_logic:= '1';--Before Register
signal Data_rOut_xK   : std_logic_vector (15 DOWNTO 0);
--
signal En_DF_Flag   : std_logic:='0';
-----------------------------------------
signal DataIn_DF_xK  : std_logic_vector (15 DOWNTO 0);
signal DataIn_DF_xB  : std_logic_vector (15 DOWNTO 0):= x"BBBB";
signal AddrWr_DF_xK  : std_logic_vector (3 DOWNTO 0);
signal AddrWr_DF_xB  : std_logic_vector (3 DOWNTO 0);
signal WrEn_DF_xK    : std_logic;
signal WrEn_DF_xB    : std_logic;
------------------------------------------- 
signal AddrWr_SB_xB : std_logic_vector (3 DOWNTO 0):=x"4";
signal DataIn_SB_xB : std_logic_vector (15 DOWNTO 0):=x"1111";
signal WrEn_SB_xB   : std_logic:='1';
signal AddrRd_SB_xB : std_logic_vector (3 DOWNTO 0);
signal DataOut_SB_xB: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal RdEn_SB_xB   : std_logic;
signal AddrWr_rSB_xB : std_logic_vector (3 DOWNTO 0):=x"F";
signal DataIn_rSB_xB : std_logic_vector (15 DOWNTO 0):=x"1111";
signal WrEn_rSB_xB   : std_logic;
signal En_SB        : std_logic:='0';
signal En_SB_Flag   : std_logic:='0';
-----------------------------------------
signal AddrWr_XK_xB : std_logic_vector (3 DOWNTO 0);
signal DataIn_XK_xB : std_logic_vector (15 DOWNTO 0);
signal AddrRd_XK_xB : std_logic_vector (3 DOWNTO 0);
signal AddrRd_XK_xK : std_logic_vector (3 DOWNTO 0);
signal DataOut_XK_xB: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal DataOut_XK_xK: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal WrEn_XK_xB   : std_logic;
signal RdEn_XK_xB   : std_logic;
signal RdEn_XK_xK   : std_logic;
signal En_XK        : std_logic:='0';
signal En_XK_Flag   : std_logic:='0';
-----------------------------------------
signal AddrWr_MDS_xB : std_logic_vector (3 DOWNTO 0):=x"4";
signal DataIn_MDS_xB : std_logic_vector (15 DOWNTO 0):=x"1111";
signal WrEn_MDS_xB   : std_logic:='1';
signal AddrRd_MDS_xB : std_logic_vector (3 DOWNTO 0);
signal DataOut_MDS_xB: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal RdEn_MDS_xB   : std_logic;
signal En_MDS        : std_logic:='0';
signal En_MDS_Flag   : std_logic:='0';
-----------------------------------------
signal AddrWr_SRS_xB : std_logic_vector (3 DOWNTO 0):=x"4";
signal DataIn_SRS_xB : std_logic_vector (15 DOWNTO 0):=x"1111";
signal WrEn_SRS_xB   : std_logic:='1';
signal AddrRd_SRS_xB : std_logic_vector (3 DOWNTO 0);
signal DataOut_SRS_xB: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal RdEn_SRS_xB   : std_logic;
signal En_SRS        : std_logic:='0';
signal En_SRS_Flag   : std_logic:='0';
--------------------------------------------
signal AddrWr_SRSI_xB : std_logic_vector (3 DOWNTO 0):=x"4";
signal DataIn_SRSI_xB : std_logic_vector (15 DOWNTO 0):=x"1111";
signal WrEn_SRSI_xB   : std_logic:='1';
signal AddrRd_SRSI_xB : std_logic_vector (3 DOWNTO 0);
signal DataOut_SRSI_xB: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal RdEn_SRSI_xB   : std_logic;
signal En_SRSI        : std_logic:='0';
signal En_SRSI_Flag   : std_logic:='0';
--------------------------------------------
signal AddrWr_RC_xB : std_logic_vector (3 DOWNTO 0):=x"4";
signal DataIn_RC_xB : std_logic_vector (15 DOWNTO 0):=x"1111";
signal WrEn_RC_xB   : std_logic:='1';
signal AddrRd_RC_xB : std_logic_vector (3 DOWNTO 0);
signal DataOut_RC_xB: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal RdEn_RC_xB   : std_logic;
signal En_RC        : std_logic:='0';
signal En_RC_Flag   : std_logic:='0';
signal i_Control    : std_logic_vector(4 DOWNTO 0) := "00000";
----------------------------------------
signal AddrWr_XKR_xB : std_logic_vector (3 DOWNTO 0);
signal DataIn_XKR_xB : std_logic_vector (15 DOWNTO 0);
signal AddrRd_XKR_xB : std_logic_vector (3 DOWNTO 0);
signal AddrRd_XKR_xK : std_logic_vector (3 DOWNTO 0);
signal DataOut_XKR_xB: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal DataOut_XKR_xK: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal WrEn_XKR_xB   : std_logic;
signal RdEn_XKR_xB   : std_logic;
signal RdEn_XKR_xK   : std_logic;
signal En_XKR        : std_logic:='0';
signal En_XKR_Flag   : std_logic:='0';
----------------------------------------
signal AddrWr_SRSH_xB : std_logic_vector (3 DOWNTO 0):=x"4";
signal DataIn_SRSH_xB : std_logic_vector (15 DOWNTO 0):=x"1111";
signal WrEn_SRSH_xB   : std_logic:='1';
signal AddrRd_SRSH_xB : std_logic_vector (3 DOWNTO 0);
signal DataOut_SRSH_xB: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal RdEn_SRSH_xB   : std_logic;
signal En_SRSH        : std_logic:='0';
signal En_SRSH_Flag   : std_logic:='0';
--------------------------------------------
signal AddrWr_SRSHI_xB : std_logic_vector (3 DOWNTO 0):=x"4";
signal DataIn_SRSHI_xB : std_logic_vector (15 DOWNTO 0):=x"1111";
signal WrEn_SRSHI_xB   : std_logic:='1';
signal AddrRd_SRSHI_xB : std_logic_vector (3 DOWNTO 0);
signal DataOut_SRSHI_xB: std_logic_vector (15 DOWNTO 0):=x"FEFE";
signal RdEn_SRSHI_xB   : std_logic;
signal En_SRSHI        : std_logic:='0';
signal En_SRSHI_Flag   : std_logic:='0';
---------------------------------------------------
signal Data_Out_Sk   :std_logic_vector (15 DOWNTO 0);
signal Test_Before_Data   : std_logic_vector (15 DOWNTO 0):=x"5555";
signal Test_Before_Data_0   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Data_A   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Data_B   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Data_C   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Data_D   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Data_E   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Data_F   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Data_G   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Data_H   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Data_I   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Data_J   : std_logic_vector (15 DOWNTO 0):=x"3333";

signal Test_Before_Adrr   : std_logic_vector (3 DOWNTO 0):=x"3";
signal Test_Before_Logic  : std_logic :='1';
begin
uReg_Rd_K : Register_Logic
    port map(
        DD_IN  => Rd_En_K,
        DD_OUT => rRd_En_K,
        Clk    => clk);
uReg_AddrRd_K:  Register_A 
    generic map (   
        w => 5) 
    Port map (  
        DD_IN  => Addr_Rd_K,
        DD_OUT => Addr_rRd_K,
        Clk    => clk);
uReg_DataOut_K :Register_A
    generic map(
        w => 8)
    port map (
        DD_IN  =>Data_Out_K,
        DD_OUT =>Data_rOut_K,
        Clk    =>clk);
uReg_Rd_N : Register_Logic
    port map(
        DD_IN  => Rd_En_N,
        DD_OUT => rRd_En_N,
        Clk    => clk);
uReg_AddrRd_N:  Register_A 
    generic map (   
        w => 4) 
    Port map (  
        DD_IN  => Addr_Rd_N,
        DD_OUT => Addr_rRd_N,
        Clk    => clk);
uReg_DataOut_N :Register_A
    generic map(
        w => 8)
    port map (
        DD_IN  =>Data_Out_N,
        DD_OUT =>Data_rOut_N,
        Clk    =>clk);
--
uReg_Rd_xK : Register_Logic
    port map(
        DD_IN  => Rd_En_xK,
        DD_OUT => rRd_En_xK,
        Clk    => clk);
uReg_AddrRd_xK:  Register_A 
    generic map (   
        w => 4) 
    Port map (  
        DD_IN  => Addr_Rd_xK,--Addr_Rd,--
        DD_OUT => Addr_rRd_xK,
        Clk    => clk);
uReg_DataOut_xK :Register_A
    generic map(
        w => 16)
    port map (
        DD_IN  =>Data_Out_xK,
        DD_OUT =>Data_rOut_xK,
        Clk    =>clk);
--
uReg_Rd_xB : Register_Logic
    port map(
        DD_IN  => Rd_En_xB,--Rd_En,--
        DD_OUT => rRd_En_xB,
        Clk    => clk);
uReg_AddrRd_xB:  Register_A 
    generic map (   
        w => 4) 
    Port map (  
        DD_IN  => Addr_Rd_xB,--Addr_Rd,--
        DD_OUT => Addr_rRd_xB,
        Clk    => clk);
uReg_DataOut_xB :Register_A
    generic map(
        w => 16)
    port map (
        DD_IN  =>Data_Out_xB,
        DD_OUT =>Data_rOut_xB,--Data_Out_T,--
        Clk    =>clk);
--
uReg_Wr_xK : Register_Logic
    port map(
        DD_IN  => Wr_En_xK,
        DD_OUT => rWr_En_xK,
        Clk    => clk);
uReg_AddrWr_xK:  Register_A 
    generic map (   
        w => 4) 
    Port map (  
        DD_IN  => Addr_Wr_xK,
        DD_OUT => Addr_rWr_xK,
        Clk    => clk);
uReg_DataIn_xK :Register_A
    generic map(
        w => 16)
    port map (
        DD_IN  =>Data_In_xK,
        DD_OUT =>Data_rIn_xK,
        Clk    =>clk);
--
uReg_Wr_SB : Register_Logic
    port map(
        DD_IN  => WrEn_SB_xB,
        DD_OUT => WrEn_rSB_xB,
        Clk    => clk);
uReg_AddrWr_SB:  Register_A 
    generic map (   
        w => 4) 
    Port map (  
        DD_IN  => AddrWr_SB_xB,
        DD_OUT => AddrWr_rSB_xB,
        Clk    => clk);
uReg_DataIn_SB :Register_A
    generic map(
        w => 16)
    port map (
        DD_IN  =>DataIn_SB_xB,
        DD_OUT =>DataIn_rSB_xB,
        Clk    =>clk);
--
uReg_Wr_xB : Register_Logic
    port map(
        DD_IN  => Wr_En_xB,
        DD_OUT => rWr_En_xB,
        Clk    => clk);
uReg_AddrWr_xB:  Register_A 
    generic map (   
        w => 4) 
    Port map (  
        DD_IN  => Addr_Wr_xB,
        DD_OUT => Addr_rWr_xB,
        Clk    => clk);
uReg_DataIn_xB :Register_A
    generic map(
        w => 16)
    port map (
        DD_IN  =>Data_In_xB,
        DD_OUT =>Data_rIn_xB,
        Clk    =>clk);
--
uS2P: S2P 
    PORT MAP (
        RSTn 	=> RSTn,
        CLOCK 	=> Clk,
        SERIN 	=> SERIN,
        PERRn 	=> PERRn,
        DRDY 	=> DRDY,
        DOUT 	=> DOUT);
--  
uDG: Data_Generate 
    port map (
        Clk        => Clk, 
        Rd_En_K    => rRd_En_K, 
        Rd_En_N    => rRd_En_N, 
        En_Out     => En_DG, 
        Addr_Rd_N  => Addr_rRd_N, 
        Addr_Rd_K  => Addr_rRd_K, 
        Data_Out_K => Data_Out_K, 
        Data_Out_N => Data_Out_N);
--
uDS2P: DataS2P
    port map (
        clk      =>clk,
        DIn      =>DOUT,
        En_Ad    =>En_Ad,
        En_In    =>DRDY,
        Data_Out =>Data_Out_B,--Data_Out,--Data_Out_Bf,--
        Addr_Rd  =>Addr_Rd_B,--Addr_Rd,--Addr_Rd_Bf,--
        Rd_En    =>Rd_En_B,--Rd_En,--Rd_En_Bf,--
        En_Out   =>En_S2P);
--
uDF: Data_Force 
    Port Map ( 
        clk         =>clk,
        En_In       =>En_DF_Flag,
        Rd_En_K     =>Rd_En_K,
        Rd_En_B     =>Rd_En_B,
        Rd_En_N     =>Rd_En_N,
        Addr_Rd_K   =>Addr_Rd_K,
        Addr_Rd_B   =>Addr_Rd_B,
        Addr_Rd_N   =>Addr_Rd_N,
        Data_Out_K  =>Data_rOut_K,
        Data_Out_B  =>Data_Out_B,
        Data_Out_N  =>Data_rOut_N,
        Data_rIn_xK =>Data_In_xK,
        Data_rIn_xB =>DataIn_DF_xB,--Data_In_xB,--
        Addr_Wr_xB  =>AddrWr_DF_xB,--Addr_Wr_xB,--
        Addr_Wr_xK  =>Addr_Wr_xK,
        Wr_En_xK    =>Wr_En_xK,
        Wr_En_xB    =>WrEn_DF_xB,--Wr_En_xB,--
        En_Out      =>En_DF);

--
uXorKey: XOR_key
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   => AddrWr_XK_xB,--Addr_Wr_xB,--
        Data_RIn_B  => DataIn_XK_xB,--Data_In_xB,--
        Wr_En_B     => WrEn_XK_xB,--Wr_En_xB,--
        Addr_Rd_B   => AddrRd_XK_xB,
        Addr_Rd_K   => AddrRd_XK_xK,
        Rd_En_B     => RdEn_XK_xB,
        Rd_En_k     => RdEn_XK_xK,
        Data_Out_B  => DataOut_XK_xB,
        Data_Out_K  => DataOut_XK_xK,
        --Ports For Control Component 
        clk         => Clk, 
        En_In       => En_XK_Flag,
        En_Out      => En_XK);
--
uSBox: S_Box
    port map ( 
        Addr_Wr_B =>AddrWr_SB_xB,--Addr_Wr_xB,--
        Data_rIn_B=>DataIn_SB_xB,--Data_In_xB,--
        Wr_En_B   =>WrEn_SB_xB,--Wr_En_xB,--
        Addr_Rd_B =>AddrRd_SB_xB,
        Rd_En_B   =>RdEn_SB_xB,
        Data_Out_B=>DataOut_SB_xB,
        clk =>clk,
        En_In =>En_SB_Flag,
        En_Out =>En_SB);
--
uMDS: MDS 
        port map (
        Addr_Wr_B =>AddrWr_MDS_xB,--Addr_Wr_xB,--
        Data_RIn_B=>DataIn_MDS_xB,--Data_In_xB,--
        Wr_En_B   =>WrEn_MDS_xB,--Wr_En_xB,--
        Addr_Rd_B =>AddrRd_MDS_xB,
        Rd_En_B   =>RdEn_MDS_xB,
        Data_Out_B=>DataOut_MDS_xB,
        clk =>clk,
        En_In  =>En_MDS_Flag,
        En_Out  =>En_MDS);
--
uSRS: SR_Slice 
    port map(
        Addr_Wr_B   =>AddrWr_SRS_xB,--Addr_Wr_xB,--
        Data_rIn_B  =>DataIn_SRS_xB,--Data_In_xB,--
        Wr_En_B     =>WrEn_SRS_xB,--Wr_En_xB,--
        Addr_Rd_B   =>AddrRd_SRS_xB,
        Rd_En_B     =>RdEn_SRS_xB,
        Data_Out_B  =>DataOut_SRS_xB,
        clk         =>clk,
        En_In       =>En_SRS_Flag,
        En_Out      =>En_SRS);
--
uSRSI: SR_Slice_Inv
    port map(
        Addr_Wr_B   =>AddrWr_SRSI_xB,--Addr_Wr_xB,--
        Data_rIn_B  =>DataIn_SRSI_xB,--Data_In_xB,--
        Wr_En_B     =>WrEn_SRSI_xB,--Wr_En_xB,--
        Addr_Rd_B   =>AddrRd_SRSI_xB,
        Rd_En_B     =>RdEn_SRSI_xB,
        Data_Out_B  =>DataOut_SRSI_xB,
        clk         =>clk,
        En_In       =>En_SRSI_Flag,
        En_Out      =>En_SRSI);
--
uMK: RC_X
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B =>AddrWr_RC_xB,--Addr_Wr_xB,-- ,
        Data_RIn_B=>DataIn_RC_xB,--Data_In_xB,-- ,
        Wr_En_B   =>WrEn_RC_xB,--Wr_En_xB,-- ,
        Addr_Rd_B =>AddrRd_RC_xB,
        Rd_En_B   =>RdEn_RC_xB,
        Data_Out_B=>DataOut_RC_xB,
        i_Control =>i_Control,
        clk   =>clk,
        En_In =>En_RC_Flag,
        En_Out =>En_RC);
--
uXorKeyR: XOR_key_Rotated
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   => AddrWr_XKR_xB,--Addr_Wr_xB,--
        Data_RIn_B  => DataIn_XKR_xB,--Data_In_xB,--
        Wr_En_B     => WrEn_XKR_xB,--Wr_En_xB,--
        Addr_Rd_B   => AddrRd_XKR_xB,
        Addr_Rd_K   => AddrRd_XKR_xK,
        Rd_En_B     => RdEn_XKR_xB,
        Rd_En_k     => RdEn_XKR_xK,
        Data_Out_B  => DataOut_XKR_xB,
        Data_Out_K  => DataOut_XKR_xK,
        --Ports For Control Component 
        clk         => Clk, 
        En_In       => En_XKR_Flag,
        En_Out      => En_XKR);
--
uSRSH: SR_Sheet
    port map(
        Addr_Wr_B   =>AddrWr_SRSH_xB,--Addr_Wr_xB,--
        Data_rIn_B  =>DataIn_SRSH_xB,--Data_In_xB,--
        Wr_En_B     =>WrEn_SRSH_xB,--Wr_En_xB,--
        Addr_Rd_B   =>AddrRd_SRSH_xB,
        Rd_En_B     =>RdEn_SRSH_xB,
        Data_Out_B  =>DataOut_SRSH_xB,
        clk         =>clk,
        En_In       =>En_SRSH_Flag,
        En_Out      =>En_SRSH);
        --
uSRSHI: SR_Sheet_Inv
    port map(
        Addr_Wr_B   =>AddrWr_SRSHI_xB,--Addr_Wr_xB,--
        Data_rIn_B  =>DataIn_SRSHI_xB,--Data_In_xB,--
        Wr_En_B     =>WrEn_SRSHI_xB,--Wr_En_xB,--
        Addr_Rd_B   =>AddrRd_SRSHI_xB,
        Rd_En_B     =>RdEn_SRSHI_xB,
        Data_Out_B  =>DataOut_SRSHI_xB,
        clk         =>clk,
        En_In       =>En_SRSHI_Flag,
        En_Out      =>En_SRSHI);
--
uxB: MemBnk 
    generic map(
        w => 16,
        d => 16,
        a => 4)
    Port Map (  Wr_En    => rWr_En_xB,--WrEn_SB_xB,--
                Rd_En    => rRd_En_xB,--Rd_En,--
                Rst      => Rst,
                Clk      => clk,
                Addr_In  => Addr_rWr_xB,--AddrWr_SB_xB,--
                Addr_Out => Addr_rRd_xB,--Addr_Rd,--
                Data_in  => Data_rIn_xB,--DataIn_SB_xB,--
                Data_out => Data_Out_xB);--Data_Out_T);--
-------------------------------------
uxK: MemBnk 
    generic map(
        w => 16,
        d => 16,
        a => 4)
    Port Map (  Wr_En    => rWr_En_xK,
                Rd_En    => rRd_En_xK,
                Rst      => Rst,
                Clk      => clk,
                Addr_In  => Addr_rWr_xK,
                Addr_Out => Addr_rRd_xK,
                Data_in  => Data_rIn_xK,
                Data_out => Data_Out_xK);--Data_Out_T);--
--Port Map Component Mux For Write on M. Bank Xb--
uMux_DataIn_xB: Mux
    generic map(
            w => 16)
    Port Map( 
        In_0=>DataIn_DF_xB,
        In_1=>DataIn_rSB_xB,
        In_2=>DataIn_XK_xB,
        In_3=>DataIn_MDS_xB,
        In_4=>DataIn_SRS_xB,
        In_5=>DataIn_SRSI_xB,
        In_6=>DataIn_RC_xB,
        In_7=>DataIn_XKR_xB,
        In_8=>DataIn_SRSH_xB,
        In_9=>DataIn_SRSHI_xB,
        In_A=>Test_Before_Data,
        Sel =>Sel,
        DOut=>Data_In_xB);--Data_Out_Mux);
uMuxAdrrWr_xB: Mux
    generic map(
        w => 4
        )
    Port Map( 
        In_0=>AddrWr_DF_xB,
        In_1=>AddrWr_rSB_xB,
        In_2=>AddrWr_XK_xB,
        In_3=>AddrWr_MDS_xB,
        In_4=>AddrWr_SRS_xB,
        In_5=>AddrWr_SRSI_xB,
        In_6=>AddrWr_RC_xB,
        In_7=>AddrWr_XKR_xB,
        In_8=>AddrWr_SRSH_xB,
        In_9=>AddrWr_SRSHI_xB,
        In_A=>Test_Before_Adrr,
        Sel =>Sel,
        DOut =>Addr_Wr_xB--Data_Out_Mux  
    );
uMuxWr_xB: MuxLogic
    Port Map( 
        In_0=>WrEn_DF_xB,
        In_1=>WrEn_rSB_xB,
        In_2=>WrEn_XK_xB,
        In_3=>WrEn_MDS_xB,
        In_4=>WrEn_SRS_xB,
        In_5=>WrEn_SRSI_xB,
        In_6=>WrEn_RC_xB,
        In_7=>WrEn_XKR_xB,
        In_8=>WrEn_SRSH_xB,
        In_9=>WrEn_SRSHI_xB,
        In_A=>Test_Before_Logic,
        Sel =>Sel,
        DOut =>Wr_En_xB--Data_Out_Mux  
    );
----
uDeMux_RdB: DeMux
    generic map(    
            w =>16--width of word    
        )
    port map ( 
        Out_0=>Test_Before_Data_0,
        Out_1=>DataOut_SB_xB,
        Out_2=>DataOut_XK_xB,
        Out_3=>DataOut_MDS_xB,
        Out_4=>DataOut_SRS_xB,
        Out_5=>DataOut_SRSI_xB,
        Out_6=>DataOut_RC_xB,
        Out_7=>DataOut_XKR_xB,
        Out_8=>DataOut_SRSH_xB,
        Out_9=>DataOut_SRSHI_xB,
        Out_A=>Data_Out_T,--Test_Before_Data_9,--
        Sel => Sel,
        DIn => Data_rOut_xB);
uMuxAdrrRd_xB: Mux
    generic map(
        w => 4
        )
    Port Map( 
        In_0=>Test_Before_Adrr,
        In_1=>AddrRd_SB_xB,
        In_2=>AddrRd_XK_xB,
        In_3=>AddrRd_MDS_xB,
        In_4=>AddrRd_SRS_xB,
        In_5=>AddrRd_SRSI_xB,
        In_6=>AddrRd_RC_xB,
        In_7=>AddrRd_XKR_xB,
        In_8=>AddrRd_SRSH_xB,
        In_9=>AddrRd_SRSHI_xB,
        In_A=>Addr_Rd,--Test_Before_Adrr,--
        Sel =>Sel,
        DOut =>Addr_Rd_xB--Data_Out_Mux  
    );
uMuxRd_xB: MuxLogic
    Port Map( 
        In_0=>Test_Before_Logic,
        In_1=>RdEn_SB_xB,
        In_2=>RdEn_XK_xB,
        In_3=>RdEn_MDS_xB,
        In_4=>RdEn_SRS_xB,
        In_5=>RdEn_SRSI_xB,
        In_6=>RdEn_RC_xB,
        In_7=>RdEn_XKR_xB,
        In_8=>RdEn_SRSH_xB,
        In_9=>RdEn_SRSHI_xB,
        In_A=>Rd_En,
        Sel =>Sel,
        DOut =>Rd_En_xB);
--
uDeMux_RdK: DeMux
    generic map(    
            w =>16--width of word    
        )
    port map ( 
        Out_0=>Test_Before_Data_A,
        Out_1=>Test_Before_Data_B,
        Out_2=>DataOut_XK_xK,
        Out_3=>Test_Before_Data_C,
        Out_4=>Test_Before_Data_D,
        Out_5=>Test_Before_Data_E,
        Out_6=>Test_Before_Data_F,
        Out_7=>DataOut_XKR_xK,
        Out_8=>Test_Before_Data_H,
        Out_9=>Test_Before_Data_I,
        Out_A=>Test_Before_Data_J,--Data_Out_T,--
        Sel =>Sel,
        DIn =>Data_rOut_xK
    );
uMuxAdrrRd_xK: Mux
    generic map(
        w => 4
        )
    Port Map( 
        In_0=>Test_Before_Adrr,
        In_1=>Test_Before_Adrr,
        In_2=>AddrRd_XK_xK,
        In_3=>Test_Before_Adrr,
        In_4=>Test_Before_Adrr,
        In_5=>Test_Before_Adrr,
        In_6=>Test_Before_Adrr,
        In_7=>AddrRd_XKR_xK,
        In_8=>Test_Before_Adrr,
        In_9=>Test_Before_Adrr,
        In_A=>Test_Before_Adrr,--Addr_Rd,--
        Sel =>Sel,
        DOut=>Addr_Rd_xK--Data_Out_Mux  
    );
uMuxRd_xK: MuxLogic
    Port Map( 
        In_0=>Test_Before_Logic,
        In_1=>Test_Before_Logic,
        In_2=>RdEn_XK_xK,
        In_3=>Test_Before_Logic,
        In_4=>Test_Before_Logic,
        In_5=>Test_Before_Logic,
        In_6=>Test_Before_Logic,
        In_7=>RdEn_XKR_xK,
        In_8=>Test_Before_Logic,
        In_9=>Test_Before_Logic,
        In_A=>Test_Before_Logic,--Rd_En,--
        Sel =>Sel,
        DOut =>Rd_En_xK--Data_Out_Mux  
    );
--
STat: process(clk,presente)
variable R_MR : std_logic_vector (3 downto 0):=x"A";
variable D_MR : std_logic_vector (3 downto 0):=x"6";
begin
    if clk 'event and clk = '1' then
            if En_DG ='1' and En_S2P = '1' then
                case presente is
                    when  s0 =>
                        if En_DF = '1' then --Finish Data Force
                            En_XK_Flag <='1';
                            En_DF_Flag <='0';
                            presente <= S1;
                        else
                            En_DF_Flag <= '1';
                            presente <= s0;
                            Sel <="0000";
                        end if;
                    when  s1 =>
                        if En_XK =  '1' then 
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            presente <= s2;
                        else
                            presente <= s1;
                            En_XK_Flag <='1';
                            En_DF_Flag <='0';
                            Sel <= "0010";
                        end if;
                    when  s2 =>
                        if En_SB = '1' then 
                            En_MDS_Flag <= '1';
                            En_SB_Flag <= '0';
                            presente <= s3;
                        else
                            presente <= s2;
                            En_SB_Flag <='1';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            Sel <= "0001";
                        end if;
                    when  s3  =>
                        if En_MDS = '1' then
                            En_MDS_Flag <= '0'; 
                            En_SB_Flag <='1';
                            presente <= s4;    
                        else
                            presente <= s3;
                            En_MDS_Flag <= '1'; 
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            Sel <= "0011";
                        end if;
                    when  s4  =>
                        if En_SB = '1' then
                            En_SB_Flag <= '0';
                            if i_Control(0) = '0' then
                                En_SRS_Flag <= '1';
                                presente <= s5;
                            else 
                                En_SRSH_Flag <= '1';
                                presente <= s11;
                                Addr_Control <="0100";
                            end if;
                        else
                            presente <= s4;
                            En_MDS_Flag <= '0'; 
                            En_SB_Flag <='1';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            Sel <= "0001";
                        end if;
                    when  s5  =>
                        if En_SRS = '1' then
                            En_MDS_Flag <= '1'; 
                            En_SRS_Flag <= '0';
                            presente <= s6;
                        else
                            En_SRS_Flag <='1';
                            En_MDS_Flag <='0'; 
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            presente <= s5;
                            Sel<="0100";
                        end if;
                    when  s6  =>
                        if En_MDS = '1' then
                            En_MDS_Flag <= '0'; 
                            En_SRSI_Flag <= '1';
                            presente <= s7;
                        else
                            En_SRS_Flag <='0';
                            En_MDS_Flag <='1'; 
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            presente <= s6;
                            Sel <= "0011";
                        end if;
                    when  s7  =>
                        if En_SRSI = '1' then
                            En_RC_Flag <= '1';
                            En_SRSI_Flag <= '0';
                            presente <= s8;
                        else
                            En_SRSI_Flag <='1';
                            En_SRS_Flag <='0';
                            En_MDS_Flag <='0';
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            presente <= s7;
                            Sel<="0101";
                        end if;
                    when  s8  =>
                        if En_RC = '1' then
                            En_RC_Flag <= '0'; 
                            En_XKR_Flag <= '1';
                            presente <= s9;
                        else
                            En_RC_Flag <='1';
                            En_SRSI_Flag <='0';
                            En_SRS_Flag <='0';
                            En_MDS_Flag <='0';
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            presente <= s8;
                            Sel<="0110";
                        end if;
                    when  s9  =>
                        if En_XKR = '1' then
                            En_XKR_Flag <= '0'; 
                            i_Control <= i_Control+1;
                            presente <= s10;
                        else
                            En_XKR_Flag <= '1'; 
                            En_RC_Flag <='0';
                            En_SRSI_Flag <='0';
                            En_SRS_Flag <='0';
                            En_MDS_Flag <='0';
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            presente <= s9;
                            Sel<="0111";
                        end if;
                    when s10 =>
                            if i_Control < R_MR then  
                                presente <= s2;
                                En_SB_Flag <= '1';
                            else 
                                En_XKR_Flag <= '0';
                                presente     <= s20;
                            end if; 
                    when s11 =>
                        if En_SRSH = '1' then
                            En_MDS_Flag <= '1'; 
                            En_SRSH_Flag <= '0';
                            presente <= s12;
                        else
                            En_SRSH_Flag <='1';
                            En_XKR_Flag <= '0'; 
                            En_RC_Flag <='0';
                            En_SRSI_Flag <='0';
                            En_SRS_Flag <='0';
                            En_MDS_Flag <='0';
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            presente <= s11;
                            Sel <= "1000";
                        end if;
                    when s12  =>
                        if En_MDS = '1' then
                            En_MDS_Flag <= '0'; 
                            En_SRSHI_Flag <= '1';
                            presente <= s13;
                        else
                            En_SRSH_Flag <='0';
                            En_XKR_Flag <= '0'; 
                            En_RC_Flag <='0';
                            En_SRSI_Flag <='0';
                            En_SRS_Flag <='0';
                            En_MDS_Flag <='1';
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            presente <= s12;
                            Sel <= "0011";
                        end if;
                    when s13  =>
                        if En_SRSHI = '1' then 
                            En_SRSHI_Flag <= '0';
                            En_RC_Flag <= '1'; 
                            presente     <= s14;
                        else
                            En_SRSHI_Flag <= '1';
                            En_SRSH_Flag <='0';
                            En_XKR_Flag <= '0'; 
                            En_RC_Flag <='0';
                            En_SRSI_Flag <='0';
                            En_SRS_Flag <='0';
                            En_MDS_Flag <='0';
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            presente <= s13;
                            Sel <= "1001";
                        end if;
                    when  s14  =>
                        if En_RC = '1' then
                            En_RC_Flag <= '0'; 
                            En_XK_Flag <= '1';
                            presente <= s15;
                        else
                            En_RC_Flag <='1';
                            En_SRSHI_Flag<='0';
                            En_SRSH_Flag <='0';
                            En_SRSI_Flag <='0';
                            En_SRS_Flag <='0';
                            En_MDS_Flag <='0';
                            En_SB_Flag <='0';
                            En_XK_Flag <='0';
                            En_DF_Flag <='0';
                            presente <= s14;
                            Sel<="0110";
                        end if;
                    when  s15  =>
                        if En_XK = '1' then
                            En_XK_Flag <= '0'; 
                            i_Control <= i_Control+1;
                            presente <= s10;
                        else
                            En_XK_Flag <= '0'; 
                            En_RC_Flag <='0';
                            En_SRSI_Flag <='0';
                            En_SRS_Flag <='0';
                            En_MDS_Flag <='0';
                            En_SB_Flag <='0';
                            En_XK_Flag <='1';
                            En_DF_Flag <='0';
                            presente <= s15;
                            Sel<="0010";
                        end if;
                    when s20 =>
                        presente <= s20;
                        Sel <="1111";
                        Data_rOut_Ct <= DataIn_SB_xB;
                    when others => null;
                end case;
            end if;
    end if;
end process;
end Main; 
