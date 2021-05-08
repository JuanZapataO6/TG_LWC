LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;


entity Saturnin_Block_EncryptV2 is 
end Saturnin_Block_EncryptV2;
architecture Main of Saturnin_Block_EncryptV2 is 
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
end component Data_Generate;
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
end component MemBnk; 
component Mux
    generic(    
            w:integer--width of word    
        );
    port( 
        In_DataForce    : in  std_logic_vector (w-1 downto 0);
        In_XorKey       : in  std_logic_vector (w-1 downto 0);
        In_XorKeyRotated: in  std_logic_vector (w-1 downto 0);
        In_SBox         : in  std_logic_vector (w-1 downto 0);
        In_MDS          : in  std_logic_vector (w-1 downto 0);
        In_SRSheet      : in  std_logic_vector (w-1 downto 0);
        In_SRSlice      : in  std_logic_vector (w-1 downto 0);
        In_SRSheetInv   : in  std_logic_vector (w-1 downto 0);
        In_SRSliceInv   : in  std_logic_vector (w-1 downto 0);
        In_RC           : in  std_logic_vector (w-1 downto 0);
        Addr_Control    : in  std_logic_vector (3 downto 0);        
        Data_Out        : out std_logic_vector (w-1 downto 0)
    );
end component Mux;
component MuxLogic
    port( 
        In_DataForce    : in  std_logic;
        In_XorKey       : in  std_logic;
        In_XorKeyRotated: in  std_logic;
        In_SBox         : in  std_logic;
        In_MDS          : in  std_logic;
        In_SRSheet      : in  std_logic;
        In_SRSlice      : in  std_logic;
        In_SRSheetInv   : in  std_logic;
        In_SRSliceInv   : in  std_logic;
        In_RC           : in  std_logic;
        Addr_Control    : in  std_logic_vector (3 downto 0);        
        Data_Out        : out std_logic
    );
end component MuxLogic;
component DeMux
    generic(    
            w:integer--width of word    
        );
    port( 
        Out_DataForce    : Out std_logic_vector (w-1 downto 0);
        Out_XorKey       : Out std_logic_vector (w-1 downto 0);
        Out_XorKeyRotated: Out std_logic_vector (w-1 downto 0);
        Out_SBox         : Out std_logic_vector (w-1 downto 0);
        Out_MDS          : Out std_logic_vector (w-1 downto 0);
        Out_SRSheet      : Out std_logic_vector (w-1 downto 0);
        Out_SRSlice      : Out std_logic_vector (w-1 downto 0);
        Out_SRSheetInv   : Out std_logic_vector (w-1 downto 0);
        Out_SRSliceInv   : Out std_logic_vector (w-1 downto 0);
        Out_RC           : Out std_logic_vector (w-1 downto 0);
        clk              : in  std_logic;
        Addr_Control     : in  std_logic_vector (3 downto 0);        
        Data_In          : in  std_logic_vector (w-1 downto 0)
    );
end component DeMux;
component XOR_key  
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Addr_Rd_K   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Rd_En_k     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        Data_Out_K  : in std_logic_vector (0 to 15);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end component XOR_key;
component XOR_key_Rotated  
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Addr_Rd_K   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Rd_En_k     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        Data_Out_K  : in std_logic_vector (0 to 15);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end component XOR_key_Rotated;
component S_Box is
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end component S_Box;
component MDS is 
        port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end component MDS;
component SR_Slice is
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end component SR_Slice;
component SR_Slice_Inv is
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (0 to 15);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end component SR_Slice_Inv;
component SR_Sheet is
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (15 downto 0);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end component SR_Sheet;
component SR_Sheet_Inv is
    port (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   : out std_logic_vector(3 downto 0);
        Data_RIn_B  : out std_logic_vector (0 to 15);
        Wr_En_B     : out std_logic;
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   : out std_logic_vector(3 downto 0);
        Rd_En_B     : out std_logic;
        Data_Out_B  : in std_logic_vector (15 downto 0);
        --Ports For Control Component 
        clk         : in std_logic; 
        En_In       : in std_logic;
        En_Out      : out std_logic        
    );
end component SR_Sheet_Inv;
component Make_Rounds is 
    port(
        RC0         : out std_logic_vector(0 to 15);
        RC1         : out std_logic_vector(0 to 15);
        R           : in std_logic_vector (3 downto 0);
        D           : in std_logic_vector (3 downto 0);
        Addr_RRd_0  : in std_logic_vector (4 downto 0);
        Addr_RRd_1  : in std_logic_vector (4 downto 0);
        Rd_REn_0     : in std_logic;
        Rd_REn_1     : in std_logic;
        Load        : in std_logic;
        clk         : in std_logic
    );
end component Make_Rounds;
TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20);
SIGNAL presente:estado:=s0;
signal clk : std_logic;
-----------------------------------------------------
----------------signals for control mux--------------
--from DataForce to SaturninBlock (Address Control)--
-----------------------------------------------------
signal Enable_DF        : std_logic;
signal Addr_Control     : std_logic_vector (3 downto 0);
--------------------------------------------
--signals for Data Force and Data Generate--
--------------------------------------------
signal Enable_Generate    : std_logic;
signal Data_In_DGK        : std_logic_vector (7 DOWNTO 0);
signal Data_In_DGB        : std_logic_vector (7 DOWNTO 0);
signal Addr_Rd_DGB        : std_logic_vector (4 DOWNTO 0);
signal Addr_Rd_DGK        : std_logic_vector (4 DOWNTO 0);
signal Rd_En_DGB          : std_logic:= '0';
signal Rd_En_DGK          : std_logic:= '0';
-----------------------------------------
--signals from DataForce to several Mux--
----------------------------------------- 
signal Data_In_DFK        : std_logic_vector (15 DOWNTO 0);
signal Data_In_DFB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Wr_DFK        : std_logic_vector (3 DOWNTO 0);
signal Addr_Wr_DFB        : std_logic_vector (3 DOWNTO 0);
signal Wr_En_DFK          : std_logic;
signal Wr_En_DFB          : std_logic;
-------------------------------------------
--signals from ControlPath to Memory Bank--
------------------------------------------- 
signal Addr_Wr_RCB        : std_logic_vector (3 DOWNTO 0);
signal Data_In_RCB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Rd_RCB        : std_logic_vector (3 DOWNTO 0);
signal Data_Out_RCB       : std_logic_vector (15 DOWNTO 0);
signal Wr_En_RCB          : std_logic;
signal Rd_En_RCB          : std_logic;
signal Enable_RC          : std_logic;
--signal En_SRS_Main         : std_logic:='0';
-------------------------------------------
--signals from ControlPath to Make Rounds--
------------------------------------------- 
signal RC0         : std_logic_vector (0 to 15);
signal RC1         : std_logic_vector (0 to 15);
signal R_MR        : std_logic_vector (3 downto 0);
signal D_MR        : std_logic_vector (3 downto 0);
signal Addr_Rd_MR0 : std_logic_vector (4 downto 0);
signal Addr_Rd_MR1 : std_logic_vector (4 downto 0);
signal Rd_En_MR0   : std_logic;
signal Rd_En_MR1   : std_logic;
signal Load_MR        : std_logic;
-----------------------------------------------
--signals from Xor_Key_Rotated to several Mux--
----------------------------------------------- 
signal Addr_Wr_XKRB        : std_logic_vector (3 DOWNTO 0);
signal Data_In_XKRB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Rd_XKRK        : std_logic_vector (3 DOWNTO 0);
signal Addr_Rd_XKRB        : std_logic_vector (3 DOWNTO 0);
signal Data_Out_XKRB       : std_logic_vector (15 DOWNTO 0);
signal Data_Out_XKRK       : std_logic_vector (15 DOWNTO 0);
signal Wr_En_XKRB          : std_logic;
signal Rd_En_XKRB          : std_logic;
signal Rd_En_XKRK          : std_logic;
signal Enable_XKR          : std_logic;
signal Enable_XKR_Main     : std_logic;
-----------------------------------------
--signals from Xor_Key to several Mux--
----------------------------------------- 
signal Addr_Wr_XKB        : std_logic_vector (3 DOWNTO 0);
signal Data_In_XKB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Rd_XKK        : std_logic_vector (3 DOWNTO 0);
signal Addr_Rd_XKB        : std_logic_vector (3 DOWNTO 0);
signal Data_Out_XKB       : std_logic_vector (15 DOWNTO 0);
signal Data_Out_XKK       : std_logic_vector (15 DOWNTO 0);
signal Wr_En_XKB          : std_logic;
signal Rd_En_XKB          : std_logic;
signal Rd_En_XKK          : std_logic;
signal Enable_XK          : std_logic;
-----------------------------------------
--signals from S_Box to several Mux--
----------------------------------------- 
signal Addr_Wr_SBB        : std_logic_vector (3 DOWNTO 0);
signal Data_In_SBB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Rd_SBB        : std_logic_vector (3 DOWNTO 0);
signal Data_Out_SBB       : std_logic_vector (15 DOWNTO 0);
signal Wr_En_SBB          : std_logic;
signal Rd_En_SBB          : std_logic;
signal Enable_SB          : std_logic;
signal En_SB_Main         : std_logic:='0';
-----------------------------------------
--signals from MDS to several Mux--
----------------------------------------- 
signal Addr_Wr_MDSB        : std_logic_vector (3 DOWNTO 0);
signal Data_In_MDSB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Rd_MDSB        : std_logic_vector (3 DOWNTO 0);
signal Data_Out_MDSB       : std_logic_vector (15 DOWNTO 0);
signal Wr_En_MDSB          : std_logic;
signal Rd_En_MDSB          : std_logic;
signal Enable_MDS          : std_logic;
signal En_MDS_Main         : std_logic:='0';
-----------------------------------------
--signals from SR_Slice to several Mux--
----------------------------------------- 
signal Addr_Wr_SRSB        : std_logic_vector (3 DOWNTO 0);
signal Data_In_SRSB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Rd_SRSB        : std_logic_vector (3 DOWNTO 0);
signal Data_Out_SRSB       : std_logic_vector (15 DOWNTO 0);
signal Wr_En_SRSB          : std_logic;
signal Rd_En_SRSB          : std_logic;
signal Enable_SRS          : std_logic;
signal En_SRS_Main         : std_logic:='0';
--------------------------------------------
--signals from SR_Slice_Inv to several Mux--
-------------------------------------------- 
signal Addr_Wr_SRSIB        : std_logic_vector (3 DOWNTO 0);
signal Data_In_SRSIB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Rd_SRSIB        : std_logic_vector (3 DOWNTO 0);
signal Data_Out_SRSIB       : std_logic_vector (15 DOWNTO 0);
signal Wr_En_SRSIB          : std_logic;
signal Rd_En_SRSIB          : std_logic;
signal Enable_SRSI          : std_logic;
signal En_SRSI_Main         : std_logic:='0';
----------------------------------------
--signals from SR_Sheet to several Mux--
---------------------------------------- 
signal Addr_Wr_SRSHB        : std_logic_vector (3 DOWNTO 0);
signal Data_In_SRSHB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Rd_SRSHB        : std_logic_vector (3 DOWNTO 0);
signal Data_Out_SRSHB       : std_logic_vector (15 DOWNTO 0);
signal Wr_En_SRSHB          : std_logic;
signal Rd_En_SRSHB          : std_logic;
signal Enable_SRSH          : std_logic;
signal En_SRSH_Main         : std_logic:='0';
--------------------------------------------
--signals from SR_Sheet_Inv to several Mux--
-------------------------------------------- 
signal Addr_Wr_SRSHIB        : std_logic_vector (3 DOWNTO 0);
signal Data_In_SRSHIB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Rd_SRSHIB        : std_logic_vector (3 DOWNTO 0);
signal Data_Out_SRSHIB       : std_logic_vector (15 DOWNTO 0);
signal Wr_En_SRSHIB          : std_logic;
signal Rd_En_SRSHIB          : std_logic;
signal Enable_SRSHI          : std_logic;
signal En_SRSHI_Main         : std_logic:='0';
---------------------------------------------------
-------Signals for MemBnk_B With Registers In------
---------------------------------------------------
-- For write On Bank 
signal Wr_En_B     : std_logic:= '1'; --after Register
signal Wr_REn_B     : std_logic:= '1';--Before Register
-- For Read on Bank 
signal Rd_En_B     : std_logic:= '1';
signal Rd_REn_B     : std_logic:= '1';
-- For Reset All Position 
signal Rst_B       : std_logic:= '1';
signal Rst_RB       : std_logic:= '1';
-- Address For Read On Bank 
signal Addr_Rd_B   : std_logic_vector (3 DOWNTO 0);
signal Addr_RRd_B   : std_logic_vector (3 DOWNTO 0);
-- Address For Write On Bank
signal Addr_Wr_B   : std_logic_vector (3 DOWNTO 0);
signal Addr_RWr_B   : std_logic_vector (3 DOWNTO 0);
-- Data In for Write On Bank with memory space 
signal Data_RIn_B   : std_logic_vector (15 DOWNTO 0);
signal Data_In_B   : std_logic_vector (15 DOWNTO 0);
-- Data Out with from bank with memory space 
signal Data_Out_SB : std_logic_vector (15 DOWNTO 0);
--signal Data_ROut_SB : std_logic_vector (15 DOWNTO 0);
---------------------------------------------------
------- Signals For MemBnk_k With Registers In-----
--------------------------------------------------- 
signal Wr_En_k     : std_logic;
signal Wr_REn_k     : std_logic;
--
signal Rd_En_k     : std_logic;
signal Rd_REn_k     : std_logic;
--
signal Rst_k       : std_logic;
signal Rst_Rk       : std_logic;
--
signal Addr_Rd_k   :std_logic_vector (3 DOWNTO 0);
signal Addr_RRd_k   :std_logic_vector (3 DOWNTO 0);
--
signal Addr_Wr_k   :std_logic_vector (3 DOWNTO 0);
signal Addr_RWr_k   :std_logic_vector (3 DOWNTO 0);
--
signal Data_RIn_k  :std_logic_vector (15 DOWNTO 0);
signal Data_In_K   :std_logic_vector (15 DOWNTO 0);
--
signal Data_Out_Sk   :std_logic_vector (15 DOWNTO 0);
--signal Data_ROut_Sk   :std_logic_vector (15 DOWNTO 0);
-- Signals Test Before
signal Test_Before_Data   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Adrr   : std_logic_vector (3 DOWNTO 0):=x"3";
signal Test_Before_Logic  : std_logic :='1';
begin
------------------------------
--Process For internal Clock--
------------------------------
reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
end process reloj;
---------------------------------------------
--In Register For Memory Bank on Buffer(Xb)--
---------------------------------------------
RinB_MB :  Register_A 
    generic map (
        w => 16
    ) 
    Port map (
    DD_IN  => Data_RIn_B,
    DD_OUT => Data_In_B,
    Clk    => clk
    );
------------------------------------------
--In Register For Memory Bank on Key(Xk)--
------------------------------------------
RinK_MB :  Register_A 
    generic map (
        w => 16
    ) 
    Port map (
    DD_IN  => Data_RIn_k,
    DD_OUT => Data_In_K,
    Clk    => clk
    );
----------------------------------------------    
--Register In For Enable Write on M. Bank xb--
----------------------------------------------   
RinB_EnWr :  Register_Logic  
    Port map (
    DD_IN  => Wr_REn_B,
    DD_OUT => Wr_En_B,
    Clk    => clk
    );
---------------------------------------------    
--Register In For Enable Read on M. Bank xb--
--------------------------------------------- 
RinB_EnRd :  Register_Logic  
    Port map (
    DD_IN  => Rd_REn_B,
    DD_OUT => Rd_En_B,
    Clk    => clk
    );
---------------------------------------    
--Register In For Reset on M. Bank xb--
--------------------------------------- 
RinB_Rst :  Register_Logic  
    Port map (
    DD_IN  => Rst_RB,
    DD_OUT => Rst_B,
    Clk    => clk
    );
------------------------------------------------------    
--Register For Address Point Write of the M. Bank xb--
------------------------------------------------------
RinB_AdrrWr :  Register_A 
    generic map (
        w => 4
    ) 
    Port map (
    DD_IN  => Addr_RWr_B,
    DD_OUT => Addr_Wr_B,
    Clk    => clk
    );
-----------------------------------------------------
--Register For Address Point Read of the M. Bank xb--
-----------------------------------------------------
RinB_AdrrRd :  Register_A 
    generic map (
        w => 4
    ) 
    Port map (
    DD_IN  => Addr_RRd_B,
    DD_OUT => Addr_Rd_B,
    Clk    => clk
    );
----------------------------------------------    
--Register In For Enable Write on M. Bank xk--
---------------------------------------------- 
RinK_EnWr :  Register_Logic  
    Port map (
    DD_IN  => Wr_REn_k,
    DD_OUT => Wr_En_k,
    Clk    => clk
    );
---------------------------------------------    
--Register In For Enable Read on M. Bank xk--
---------------------------------------------
RinK_EnRd :  Register_Logic  
    Port map (
    DD_IN  => Rd_REn_k,
    DD_OUT => Rd_En_K,
    Clk    => clk
    );
---------------------------------------    
--Register In For Reset on M. Bank xk--
--------------------------------------- 
RinK_Rst :  Register_Logic  
    Port map (
    DD_IN  => Rst_Rk,
    DD_OUT => Rst_k,
    Clk    => clk
    );
------------------------------------------------------    
--Register For Address Point Write of the M. Bank xk--
------------------------------------------------------
RinK_AdrrWr :  Register_A 
    generic map (
        w => 4
    ) 
    Port map (
    DD_IN  => Addr_RWr_K,
    DD_OUT => Addr_Wr_k,
    Clk    => clk
    );
-----------------------------------------------------
--Register For Address Point Read of the M. Bank xk--
-----------------------------------------------------
RinK_AdrrRd :  Register_A 
    generic map (
        w => 4
    ) 
    Port map (
    DD_IN  => Addr_RRd_K,
    DD_OUT => Addr_Rd_k,
    Clk    => clk
    );
------------------------------------    
--Port Map Component Data Generate--
------------------------------------    
Data_Ge: Data_Generate Port Map (
                            Clk           => clk,
                            Rd_En_K       => Rd_En_DGK,
                            Rd_En_B       => Rd_En_DGB,
                            Ena_Out       => Enable_Generate,
                            Addr_Out_K    => Addr_Rd_DGK,
                            Addr_Out_B    => Addr_Rd_DGB,
                            Data_Out_K    => Data_In_DGK,
                            Data_Out_B    => Data_In_DGB
                            );
---------------------------------    
--Port Map Component Data Force--
---------------------------------
Data_F: Data_Force Port Map (
        clk            =>clk,
        --Ports for Data Generate
        Rd_En_DGK      => Rd_En_DGK,
        Rd_En_DGB      => Rd_En_DGB,
        En_In_DF       => Enable_generate,
        Addr_Rd_DGK    => Addr_Rd_DGK,
        Addr_Rd_DGB    => Addr_Rd_DGB,
        Data_In_DGK    => Data_In_DGK,
        Data_In_DGB    => Data_In_DGB,
        --Ports for MemBnk Write
        Data_RIn_K     =>Data_In_DFK,
        Data_RIn_B     =>Data_In_DFB,
        Addr_Wr_B      =>Addr_Wr_DFB,
        Addr_Wr_k      =>Addr_Wr_DFK,
        Wr_En_k        =>Wr_En_DFK,
        Wr_En_B        =>Wr_En_DFB,

        Enable_DF      => Enable_DF
                );

-------------------------------------    
--Port Map Component Make Rounds xb--
-------------------------------------
uMake_Rounds : Make_Rounds port map(
        RC0         => RC0 ,
        RC1         => RC1 ,
        R           => R_MR ,
        D           => D_MR,
        Addr_RRd_0  => Addr_Rd_MR0,
        Addr_RRd_1  => Addr_Rd_MR1,
        Rd_REn_0     => Rd_En_MR0,
        Rd_REn_1     => Rd_En_MR1,
        Load        => Load_MR,
        clk         => clk    
    );

-------------------------------------    
--Port Map Component Memory Bank xb--
-------------------------------------
uBuff: MemBnk 
    generic map(w => 16,
                d => 16,
                a => 4
    )
    Port Map (  Wr_En    => Wr_En_B,
                Rd_En    => Rd_En_B,
                Rst      => Rst_B,
                Clk      => clk,
                Addr_In  => Addr_Wr_B,
                Addr_Out => Addr_Rd_B,
                Data_in  => Data_In_B,
                Data_out => Data_Out_SB
            );
-------------------------------------    
--Port Map Component Memory Bank xk--
-------------------------------------
uKey: MemBnk 
    generic map(w => 16,
                d => 16,
                a => 4
            )
    Port Map (  Wr_En    => Wr_En_k,
                Rd_En    => Rd_En_k,
                Rst      => Rst_k,
                Clk      => clk,
                Addr_In  => Addr_Wr_k,
                Addr_Out => Addr_Rd_k,
                Data_in  => Data_In_k,
                Data_out => Data_Out_Sk
            );

--------------------------------------------------    
--Port Map Component Mux For Write on M. Bank Xb--
--------------------------------------------------
uMux_WrB: Mux
    generic map(
            w => 16
        )
    Port Map( 
        In_DataForce        =>Data_In_DFB,
        In_XorKey           =>Data_In_XKB,
        In_SBox             =>Data_In_SBB,
        In_MDS              =>Data_In_MDSB,
        In_SRSlice          =>Data_In_SRSB,
        In_SRSliceInv       =>Data_In_SRSIB,        
        In_RC               =>Data_In_RCB ,
        In_XorKeyRotated    =>Data_In_XKRB,
        In_SRSheetInv       =>Data_In_SRSHIB,
        In_SRSheet          =>Data_In_SRSHB,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Data_RIn_B--Data_Out_Mux  
    );
--------------------------------------------------
--Mux  For Address Point Write of the M. Bank xb--
--------------------------------------------------
uMuxAdrr_WrB: Mux
    generic map(
        w => 4
        )
    Port Map( 
        In_DataForce        =>Addr_Wr_DFB,
        In_XorKey           =>Addr_Wr_XKB,
        In_SBox             =>Addr_Wr_SBB,
        In_MDS              =>Addr_Wr_MDSB,
        In_SRSlice          =>Addr_Wr_SRSB,
        In_SRSliceInv       =>Addr_Wr_SRSIB,
        In_RC               =>Addr_Wr_RCB,
        In_XorKeyRotated    =>Addr_Wr_XKRB,
        In_SRSheetInv       =>Addr_Wr_SRSHIB,
        In_SRSheet          =>Addr_Wr_SRSHB,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Addr_RWr_B--Data_Out_Mux  
    );
--------------------------------------------------
--Mux One bit For Enable Write of the M. Bank xb--
--------------------------------------------------
uMuxWrB: MuxLogic
    Port Map( 
        In_DataForce        =>Wr_En_DFB,
        In_XorKey           =>Wr_En_XKB,
        In_SBox             =>Wr_En_SBB,
        In_MDS              =>Wr_En_MDSB,
        In_SRSlice          =>Wr_En_SRSB,
        In_SRSliceInv       =>Wr_En_SRSIB,
        In_RC               =>Wr_En_RCB,
        In_XorKeyRotated    =>Wr_En_XKRB,
        In_SRSheetInv       =>Wr_En_SRSHIB,
        In_SRSheet          =>Wr_En_SRSHB,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Wr_REn_B--Data_Out_Mux  
    );
--------------------------------------    
--DeMux For Read from Memory Bank Xb--
--------------------------------------
uDeMux_RdB: DeMux
    generic map(    
            w =>16--width of word    
        )
    port map ( 
        Out_DataForce    =>Test_Before_Data,
        Out_XorKey       =>Data_Out_XKB,
        Out_SBox         =>Data_Out_SBB,
        Out_MDS          =>Data_Out_MDSB,
        Out_SRSlice      =>Data_Out_SRSB,
        Out_SRSliceInv   =>Data_Out_SRSIB,
        Out_RC           =>Data_Out_RCB,-- In this case the performance like Register A  (Syncronus)
        Out_XorKeyRotated=>Data_Out_XKRB,
        Out_SRSheetInv   =>Data_Out_SRSHIB,
        Out_SRSheet      =>Data_Out_SRSHB,
        clk              => clk,
        Addr_Control     =>Addr_Control,      
        Data_In          =>Data_Out_SB
    );
--------------------------------------------------
--Mux  For Address Point Read of the M. Bank xb--
--------------------------------------------------
uMuxAdrr_RdB: Mux
    generic map(
        w => 4
        )
    Port Map( 
        In_DataForce        =>Test_Before_Adrr,
        In_XorKey           =>Addr_Rd_XKB,
        In_SBox             =>Addr_Rd_SBB,
        In_MDS              =>Addr_Rd_MDSB,
        In_SRSlice          =>Addr_Rd_SRSB,
        In_SRSliceInv       =>Addr_Rd_SRSIB,
        In_RC               =>Addr_Rd_RCB,
        In_XorKeyRotated    =>Addr_Rd_XKRB,
        In_SRSheetInv       =>Addr_Rd_SRSHIB,
        In_SRSheet          =>Addr_Rd_SRSHB,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Addr_RRd_B--Data_Out_Mux  
    );
--------------------------------------------------
--Mux One bit For Enable Read of the M. Bank xb--
--------------------------------------------------
uMuxRdB: MuxLogic
    Port Map( 
        In_DataForce        =>Test_Before_Logic,
        In_XorKey           =>Rd_En_XKB,
        In_SBox             =>Rd_En_SBB,
        In_MDS              =>Rd_En_MDSB,
        In_SRSlice          =>Rd_En_SRSB,
        In_SRSliceInv       =>Rd_En_SRSIB,
        In_RC               =>Rd_En_RCB,
        In_XorKeyRotated    =>Rd_En_XKRB,
        In_SRSheetInv       =>Rd_En_SRSHIB,
        In_SRSheet          =>Rd_En_SRSHB,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Rd_REn_B--Data_Out_Mux  
    );
--------------------------------------------------    
--Port Map Component Mux For Write on M. Bank Xk--
--------------------------------------------------
uMux_WrK: Mux
    generic map(
            w => 16
        )
    Port Map( 
        In_DataForce        =>Data_In_DFK,
        In_XorKey           =>Test_Before_Data,
        In_SRSheet          =>Test_Before_Data,
        In_XorKeyRotated    =>Test_Before_Data,
        In_MDS              =>Test_Before_Data,
        In_SBox             =>Test_Before_Data,
        In_SRSlice          =>Test_Before_Data,
        In_RC               =>Test_Before_Data,
        In_SRSheetInv       =>Test_Before_Data,
        In_SRSliceInv       =>Test_Before_Data,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Data_RIn_k--Data_Out_Mux  
    );
--------------------------------------------------
--Mux  For Address Point Write of the M. Bank xk--
--------------------------------------------------
uMuxAdrr_Wrk: Mux
    generic map(
        w => 4
        )
    Port Map( 
        In_DataForce        =>Addr_Wr_DFK,
        In_XorKey           =>Test_Before_Adrr,
        In_SRSheet          =>Test_Before_Adrr,
        In_XorKeyRotated    =>Test_Before_Adrr,
        In_MDS              =>Test_Before_Adrr,
        In_SBox             =>Test_Before_Adrr,
        In_SRSlice          =>Test_Before_Adrr,
        In_RC               =>Test_Before_Adrr,
        In_SRSheetInv       =>Test_Before_Adrr,
        In_SRSliceInv       =>Test_Before_Adrr,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Addr_RWr_k--Data_Out_Mux  
    );
--------------------------------------------------
--Mux One bit For Enable Write of the M. Bank xk--
--------------------------------------------------
uMuxWrk: MuxLogic
    Port Map( 
        In_DataForce        =>Wr_En_DFK,
        In_XorKey           =>Test_Before_Logic,
        In_SRSheet          =>Test_Before_Logic,
        In_XorKeyRotated    =>Test_Before_Logic,
        In_MDS              =>Test_Before_Logic,
        In_SBox             =>Test_Before_Logic,
        In_SRSlice          =>Test_Before_Logic,
        In_SRSheetInv       =>Test_Before_Logic,
        In_RC               =>Test_Before_Logic,
        In_SRSliceInv       =>Test_Before_Logic,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Wr_REn_k--Data_Out_Mux  
    );
--------------------------------------    
--DeMux For Read from Memory Bank Xb--
--------------------------------------
uDeMux_RdK: DeMux
    generic map(    
            w => 16--width of word    
        )
    port map( 
        Out_DataForce    =>Test_Before_Data,
        Out_XorKey       =>Data_Out_XKK,
        Out_XorKeyRotated=>Data_Out_XKRK,
        Out_SBox         =>Test_Before_Data,        
        Out_MDS          =>Test_Before_Data,
        Out_SRSheet      =>Test_Before_Data,
        Out_SRSlice      =>Test_Before_Data,
        Out_SRSheetInv   =>Test_Before_Data,
        Out_SRSliceInv   =>Test_Before_Data,
        clk              =>clk,
        Addr_Control     =>Addr_Control,      
        Data_In          =>Data_Out_Sk
    );
--------------------------------------------------
--Mux  For Address Point Read of the M. Bank xk--
--------------------------------------------------
uMuxAdrr_Rdk: Mux
    generic map(
        w => 4
        )
    Port Map( 
        In_DataForce        =>Test_Before_Adrr,
        In_XorKey           =>Addr_Rd_XKK,
        In_XorKeyRotated    =>Addr_Rd_XKRK,
        In_SRSheet          =>Test_Before_Adrr,        
        In_MDS              =>Test_Before_Adrr,
        In_SBox             =>Test_Before_Adrr,
        In_SRSlice          =>Test_Before_Adrr,
        In_SRSheetInv       =>Test_Before_Adrr,
        In_RC               =>Test_Before_Adrr,
        In_SRSliceInv       =>Test_Before_Adrr,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Addr_RRd_K--Data_Out_Mux  
    );
--------------------------------------------------
--Mux One bit For Enable Read of the M. Bank xb--
--------------------------------------------------
uMuxRdk: MuxLogic
    Port Map( 
        In_DataForce        =>Test_Before_Logic,
        In_XorKey           =>Rd_En_XKK,
        In_XorKeyRotated    =>Rd_En_XKRK,
        In_SRSheet          =>Test_Before_Logic,
        In_MDS              =>Test_Before_Logic,
        In_SBox             =>Test_Before_Logic,
        In_SRSlice          =>Test_Before_Logic,
        In_SRSheetInv       =>Test_Before_Logic,
        In_SRSliceInv       =>Test_Before_Logic,
        In_RC               =>Test_Before_Logic,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Rd_REn_k--Data_Out_Mux  
    );
---------------------
--Component XOR_KEY--
---------------------
UXorKey: XOR_key
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   => Addr_Wr_XKB,
        Data_RIn_B  => Data_In_XKB,
        Wr_En_B     => Wr_En_XKB,
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   => Addr_Rd_XKB,
        Addr_Rd_K   => Addr_Rd_XKK,
        Rd_En_B     => Rd_En_XKB,
        Rd_En_k     => Rd_En_XKK,
        Data_Out_B  => Data_Out_XKB,
        Data_Out_K  => Data_Out_XKK,
        --Ports For Control Component 
        clk         => Clk, 
        En_In       => Enable_DF,
        En_Out      => Enable_XK        
    );
-----------------------------
--Component XOR_Key_Rotated--
-----------------------------
UXorKey_Rotated: XOR_key_Rotated
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   => Addr_Wr_XKRB,
        Data_RIn_B  => Data_In_XKRB,
        Wr_En_B     => Wr_En_XKRB,
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   => Addr_Rd_XKRB,
        Addr_Rd_K   => Addr_Rd_XKRK,
        Rd_En_B     => Rd_En_XKRB,
        Rd_En_k     => Rd_En_XKRK,
        Data_Out_B  => Data_Out_XKRB,
        Data_Out_K  => Data_Out_XKRK,
        --Ports For Control Component 
        clk         => Clk, 
        En_In       => Enable_XKR_Main,
        En_Out      => Enable_XKR        
    );
---------------------
--Component S_Box--
---------------------
USBox: S_Box
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   => Addr_Wr_SBB,
        Data_RIn_B  => Data_In_SBB,
        Wr_En_B     => Wr_En_SBB,
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   => Addr_Rd_SBB,
        Rd_En_B     => Rd_En_SBB,
        Data_Out_B  => Data_Out_SBB,
        --Ports For Control Component 
        clk         => Clk, 
        En_In       => En_SB_Main,
        En_Out      => Enable_SB        
    );
---------------------
--Component MDS--
---------------------
UMDS: MDS
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   => Addr_Wr_MDSB,
        Data_RIn_B  => Data_In_MDSB,
        Wr_En_B     => Wr_En_MDSB,
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   => Addr_Rd_MDSB,
        Rd_En_B     => Rd_En_MDSB,
        Data_Out_B  => Data_Out_MDSB,
        --Ports For Control Component 
        clk         => Clk, 
        En_In       => En_MDS_Main,
        En_Out      => Enable_MDS        
    );
----------------------
--Component SR_Slice--
----------------------  
USR_Slice: SR_Slice
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   => Addr_Wr_SRSB,
        Data_RIn_B  => Data_In_SRSB,
        Wr_En_B     => Wr_En_SRSB,
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   => Addr_Rd_SRSB,
        Rd_En_B     => Rd_En_SRSB,
        Data_Out_B  => Data_Out_SRSB,
        --Ports For Control Component 
        clk         => Clk, 
        En_In       => En_SRS_Main,
        En_Out      => Enable_SRS        
    );
--------------------------
--Component SR_Slice_Inv--
--------------------------  
USR_Slice_Inv: SR_Slice_Inv
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   => Addr_Wr_SRSIB,
        Data_RIn_B  => Data_In_SRSIB,
        Wr_En_B     => Wr_En_SRSIB,
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   => Addr_Rd_SRSIB,
        Rd_En_B     => Rd_En_SRSIB,
        Data_Out_B  => Data_Out_SRSIB,
        --Ports For Control Component 
        clk         => Clk, 
        En_In       => En_SRSI_Main,
        En_Out      => Enable_SRSI        
    );
----------------------
--Component SR_Sheet--
----------------------  
USR_Sheet: SR_Sheet
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   => Addr_Wr_SRSHB,
        Data_RIn_B  => Data_In_SRSHB,
        Wr_En_B     => Wr_En_SRSHB,
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   => Addr_Rd_SRSHB,
        Rd_En_B     => Rd_En_SRSHB,
        Data_Out_B  => Data_Out_SRSHB,
        --Ports For Control Component 
        clk         => Clk, 
        En_In       => En_SRSH_Main,
        En_Out      => Enable_SRSH        
    );
--------------------------
--Component SR_Sheet_Inv--
--------------------------    
USR_Sheet_Inv: SR_Sheet_Inv
    port map (
        --Ports for Memory Bank Write Xb
        Addr_Wr_B   => Addr_Wr_SRSHIB,
        Data_RIn_B  => Data_In_SRSHIB,
        Wr_En_B     => Wr_En_SRSHIB,
        --Ports for Memory Bank Read xb and xk
        Addr_Rd_B   => Addr_Rd_SRSHIB,
        Rd_En_B     => Rd_En_SRSHIB,
        Data_Out_B  => Data_Out_SRSHIB,
        --Ports For Control Component 
        clk         => Clk, 
        En_In       => En_SRSHI_Main,
        En_Out      => Enable_SRSHI        
    );
STat: process(clk,presente)
variable i_Control : std_logic_vector(4 DOWNTO 0) := "00000";
begin
    if clk 'event and clk = '1' then 
            if Enable_generate ='1' then
                case presente is
                    when  s0 =>
                        if Enable_DF = '1' then --Finish Data Force
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
                    when  s1 =>
                        if Enable_XK = '1' then 
                            presente <= s2;
                            En_SB_Main <= '1';
                            Addr_Control <="0010";
                        else
                            presente <= s1;
                            Addr_Control <="0001";
                        end if;
                    when  s2 =>
                        if Enable_SB = '1' then 
                            En_MDS_Main <= '1';
                            En_SB_Main <= '0';
                            presente <= s3;
                            Addr_Control <="0011";
                        else
                            presente <= s2;
                            Addr_Control <="0010";
                        end if;
                    when  s3  =>
                        if Enable_MDS = '1' then
                            En_SB_Main <= '1'; 
                            presente <= s4;
                            Addr_Control <="0010";
                        else
                            --En_MDS_Main <= '0';
                            presente <= s3;
                            Addr_Control <="0011";
                        end if;
                    when  s4  =>
                        if Enable_SB = '1' then
                            En_SB_Main <= '0';                             
                            if i_Control(0) = '0' then 
                                En_SRS_Main <= '1';
                                presente <= s5;
                                Addr_Control <="0100";
                            else 
                                En_SRSH_Main <= '1';
                                presente <= s15;
                                Addr_Control <="0100";
                            end if;
                        else
                            En_MDS_Main <= '0';
                            presente <= s4;
                            Addr_Control <="0010";
                        end if;
                    when  s5  =>
                        if Enable_SRS = '1' then
                            En_MDS_Main <= '1'; 
                            En_SRS_Main <= '0';
                            presente <= s6;
                            Addr_Control <="0011";
                        else
                            --En_MDS_Main <= '1';
                            presente <= s5;
                            Addr_Control <="0100";
                        end if;
                    when  s6  =>
                        if Enable_MDS = '1' then
                            En_MDS_Main <= '0'; 
                            En_SRSI_Main <= '1';
                            presente <= s7;
                            Addr_Control <="0101";
                        else
                            En_MDS_Main <= '1';
                            presente <= s6;
                            Addr_Control <="0011";
                        end if;
                    when  s7  =>
                        if Enable_SRSI = '1' then 
                            En_SRSI_Main <= '0'; 
                            Addr_Rd_MR0  <= i_Control;
                            Rd_En_MR0    <= '0';
                            Addr_Rd_RCB  <= x"0";
                            Rd_En_RCB    <= '0'; 
                            presente     <= s8;
                            Addr_Control <="1000";
                        else
                            En_MDS_Main <= '0'; 
                            En_SRSI_Main <= '1';
                            presente <= s7;
                            Addr_Control <="0101";
                        end if;
                    when  s8  =>
                            --RC           <=       RC0 XOR Data_Out_SB; 
                            Addr_Rd_MR1  <= i_Control;
                            Rd_En_MR1    <= '0';
                            Addr_Rd_RCB  <= x"8";
                            Rd_En_RCB    <= '0'; 
                            presente     <=s9;
                            Addr_Control <="1000"; 
                    when  s9  =>
                            --Data_In_RCB  <= RC0 XOR Data_Out_SB; 
                            Addr_Rd_MR1  <=i_Control;
                            Rd_En_RCB    <= '1'; 
                            Rd_En_MR1    <='0';
                            presente     <=s10;
                            Addr_Control <="1000";
                    when  s10 =>
                            Data_In_RCB  <= RC0 XOR Data_Out_SB; 
                            Addr_Rd_MR1  <=i_Control;
                            Rd_En_MR1    <='0';
                            Addr_Wr_RCB  <=x"0";
                            Wr_En_RCB    <= '0';
                            presente     <=s11;
                            Addr_Control <="1000";
                    when  s11 =>
                            Data_In_RCB  <= RC1 XOR Data_Out_SB; 
                            Addr_Rd_MR1  <=i_Control;
                            Rd_En_MR1    <='0';
                            Addr_Wr_RCB  <=x"8";
                            Wr_En_RCB    <= '0';
                            presente     <=s12;
                            Addr_Control <="1000";
                    when  s12 =>
                            --Data_In_RCB  <= RC1 XOR Data_Out_SB; 
                            Addr_Rd_MR1  <=i_Control;
                            Rd_En_MR1    <='1';
                            Addr_Wr_RCB  <=x"0";
                            Wr_En_RCB    <= '0';
                            presente     <=s13;
                            Addr_Control <="0110";
                    when s13 =>
                            --Data_In_RCB  <= RC1 XOR Data_Out_SB; 
                            if Enable_XKR = '1' then  
                                Addr_Rd_MR1  <=i_Control;
                                Rd_En_MR1    <='1';
                                Addr_Wr_RCB  <=x"0";
                                Wr_En_RCB    <= '0';
                                presente     <=s14;
                                Addr_Control <="0111";
                            else 
                                Enable_XKR_Main <= '1';
                                presente     <=s13;
                                Addr_Control <="0110";
                            end if;
                    when s14 =>
                            i_Control := i_Control+1;
                            if i_Control < R_MR then  
                                Addr_Rd_MR1  <=i_Control;
                                presente <= s2;
                                En_SB_Main <= '1';
                                Addr_Control <="0010";
                            else 
                                Enable_XKR_Main <= '1';
                                presente     <= s20;
                                Addr_Control <= "0110";
                            end if; 
                    when s15 =>
                        if Enable_SRSH = '1' then
                            En_MDS_Main <= '1'; 
                            En_SRSH_Main <= '0';
                            presente <= s16;
                            Addr_Control <="0011";
                        else
                            --En_MDS_Main <= '1';
                            presente <= s15;
                            Addr_Control <="0111";
                        end if;
                    when  s16  =>
                        if Enable_MDS = '1' then
                            En_MDS_Main <= '0'; 
                            En_SRSHI_Main <= '1';
                            presente <= s17;
                            Addr_Control <="1001";
                        else
                            En_MDS_Main <= '1';
                            presente <= s16;
                            Addr_Control <="0011";
                        end if;
                    when others => null;
                end case;
            end if;
    end if;
end process;
end Main; 
