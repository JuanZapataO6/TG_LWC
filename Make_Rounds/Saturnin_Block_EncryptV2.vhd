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
        Addr_Control    : in  std_logic_vector (3 downto 0);        
        Data_Out        : out std_logic
    );
end component MuxLogic;

TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7);
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
-----------------------------------------
--signals from Xor_Key to several Mux--
----------------------------------------- 
signal Data_In_DFK        : std_logic_vector (15 DOWNTO 0);
signal Data_In_DFB        : std_logic_vector (15 DOWNTO 0);
signal Addr_Wr_DFK        : std_logic_vector (3 DOWNTO 0);
signal Addr_Wr_DFB        : std_logic_vector (3 DOWNTO 0);
signal Wr_En_DFK          : std_logic;
signal Wr_En_DFB          : std_logic;
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
-- Signals Test Before
signal Test_Before_Data   : std_logic_vector (15 DOWNTO 0):=x"3333";
signal Test_Before_Adrr   : std_logic_vector (3 DOWNTO 0):=x"7";
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
        In_XorKey           =>Test_Before_Data,
        In_XorKeyRotated    =>Test_Before_Data,
        In_SBox             =>Test_Before_Data,
        In_MDS              =>Test_Before_Data,
        In_SRSheet          =>Test_Before_Data,
        In_SRSlice          =>Test_Before_Data,
        In_SRSheetInv       =>Test_Before_Data,
        In_SRSliceInv       =>Test_Before_Data,
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
        In_XorKey           =>Test_Before_Adrr,
        In_XorKeyRotated    =>Test_Before_Adrr,
        In_SBox             =>Test_Before_Adrr,
        In_MDS              =>Test_Before_Adrr,
        In_SRSheet          =>Test_Before_Adrr,
        In_SRSlice          =>Test_Before_Adrr,
        In_SRSheetInv       =>Test_Before_Adrr,
        In_SRSliceInv       =>Test_Before_Adrr,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Addr_RWr_B--Data_Out_Mux  
    );
--------------------------------------------------
--Mux One bit For Enable Write of the M. Bank xb--
--------------------------------------------------
uMuxWrB: MuxLogic
    Port Map( 
        In_DataForce        =>Wr_En_DFB,
        In_XorKey           =>Test_Before_Logic,
        In_XorKeyRotated    =>Test_Before_Logic,
        In_SBox             =>Test_Before_Logic,
        In_MDS              =>Test_Before_Logic,
        In_SRSheet          =>Test_Before_Logic,
        In_SRSlice          =>Test_Before_Logic,
        In_SRSheetInv       =>Test_Before_Logic,
        In_SRSliceInv       =>Test_Before_Logic,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Wr_REn_B--Data_Out_Mux  
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
        In_XorKey           =>Test_Before_Adrr,
        In_XorKeyRotated    =>Test_Before_Adrr,
        In_SBox             =>Test_Before_Adrr,
        In_MDS              =>Test_Before_Adrr,
        In_SRSheet          =>Test_Before_Adrr,
        In_SRSlice          =>Test_Before_Adrr,
        In_SRSheetInv       =>Test_Before_Adrr,
        In_SRSliceInv       =>Test_Before_Adrr,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Addr_RRd_B--Data_Out_Mux  
    );
--------------------------------------------------
--Mux One bit For Enable Read of the M. Bank xb--
--------------------------------------------------
uMuxRdB: MuxLogic
    Port Map( 
        In_DataForce        =>Test_Before_Logic,
        In_XorKey           =>Test_Before_Logic,
        In_XorKeyRotated    =>Test_Before_Logic,
        In_SBox             =>Test_Before_Logic,
        In_MDS              =>Test_Before_Logic,
        In_SRSheet          =>Test_Before_Logic,
        In_SRSlice          =>Test_Before_Logic,
        In_SRSheetInv       =>Test_Before_Logic,
        In_SRSliceInv       =>Test_Before_Logic,
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
        In_XorKeyRotated    =>Test_Before_Data,
        In_SBox             =>Test_Before_Data,
        In_MDS              =>Test_Before_Data,
        In_SRSheet          =>Test_Before_Data,
        In_SRSlice          =>Test_Before_Data,
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
        In_XorKeyRotated    =>Test_Before_Adrr,
        In_SBox             =>Test_Before_Adrr,
        In_MDS              =>Test_Before_Adrr,
        In_SRSheet          =>Test_Before_Adrr,
        In_SRSlice          =>Test_Before_Adrr,
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
        In_XorKeyRotated    =>Test_Before_Logic,
        In_SBox             =>Test_Before_Logic,
        In_MDS              =>Test_Before_Logic,
        In_SRSheet          =>Test_Before_Logic,
        In_SRSlice          =>Test_Before_Logic,
        In_SRSheetInv       =>Test_Before_Logic,
        In_SRSliceInv       =>Test_Before_Logic,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Wr_REn_k--Data_Out_Mux  
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
        In_XorKey           =>Test_Before_Adrr,
        In_XorKeyRotated    =>Test_Before_Adrr,
        In_SBox             =>Test_Before_Adrr,
        In_MDS              =>Test_Before_Adrr,
        In_SRSheet          =>Test_Before_Adrr,
        In_SRSlice          =>Test_Before_Adrr,
        In_SRSheetInv       =>Test_Before_Adrr,
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
        In_XorKey           =>Test_Before_Logic,
        In_XorKeyRotated    =>Test_Before_Logic,
        In_SBox             =>Test_Before_Logic,
        In_MDS              =>Test_Before_Logic,
        In_SRSheet          =>Test_Before_Logic,
        In_SRSlice          =>Test_Before_Logic,
        In_SRSheetInv       =>Test_Before_Logic,
        In_SRSliceInv       =>Test_Before_Logic,
        Addr_Control        =>Addr_Control,
        Data_Out            =>Rd_REn_k--Data_Out_Mux  
    );
STat: process(clk,presente)
begin
    if clk 'event and clk = '1' then 
            if Enable_generate ='1' then
                case presente is
                    when s0 =>
                        if Enable_DF = '1' then --Finish Data Force
                            presente <= s1;
                            Addr_Control <="0001";
                        else
                            presente <= s0;
                            Addr_Control <="0000";
                        end if;
                    when  s1 =>
                        if Enable_DF = '1' then 
                            presente <= s2;
                            Addr_Control <="0010";
                        else
                            presente <= s1;
                            Addr_Control <="0001";
                        end if;
                    when others => null;
                end case;
            end if;
    end if;
end process;
end Main; 
