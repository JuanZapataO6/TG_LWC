library IEEE; 
use IEEE.std_logic_1164.all; 
package Saturnin_Functions is 
    procedure WrRd_On_MB(signal Addr_Wr, Addr_Rd : in std_logic_vector(3 downto 0);
    signal Data_In : in std_logic_vector (15 downto 0);
    signal Data_In : out std_logic_vector (15 downto 0);
    variable Finish_En : out std_logic;
    signal Wr_En, Rd_En, Rst, Clk : in std_logic);
end package;
component Register_A
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
end component MemBnk; 
package body Saturnin_Functions is
begin 
procedure
end Saturnin_Functions;