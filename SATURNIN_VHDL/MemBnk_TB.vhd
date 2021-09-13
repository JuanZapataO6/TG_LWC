LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity MemBnk_TB is
end MemBnk_TB ;

architecture testbench of MemBnk_TB is 

component MemBnk
port (
    RCin    : in  std_logic_vector (0 to 15);
    Address : in  std_logic_vector (0 to 3);
    Load    : in  std_logic;
    Rst     : in  std_logic;
    Clk     : in  std_logic;
    RCout   : out std_logic_vector (0 to 15)
);
end component;

TYPE estado is (s0, s1,s2,s3);
SIGNAL presente:estado:=s0;

SIGNAL RCin,RCout   :STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL Address      :STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL Clk,Load,Rst :STD_LOGIC := '0';

BEGIN
-- Free running test clock
reloj:process
    begin
    Clk <= '0';
    wait for 12.5 ns;
    Clk <= '1';
    wait for 12.5 ns;
end process reloj;
    
-- Instance of design being tested
u1: MemBnk PORT MAP (RCin => RCin,
                        RCout   => RCout,
                        Address => Address,
                        Rst     => Rst,
                        Clk     => Clk, 
                        Load    => Load    
                        );
STAt: PROCESS (Clk,presente) -- Defino los estados 

BEGIN 
    
    if Clk'event and Clk='1' then  
        case presente is
            when s0=>
                presente  <= S1; 
                RCin      <= x"FFFF";
                Address   <= "0000";
                Rst       <= '0';
                Load      <= '1'; 
            when s1=>
                presente  <= S2; 
                RCin      <= x"FF00";
                Address   <= "0001";
                Rst       <= '0';
                Load      <= '1';
            when s2=>
                presente  <= S3; 
                RCin      <= x"FF00";
                Address   <= "0000";
                Rst       <= '0';
                Load      <= '0';
            when s3=>
                presente  <= S0; 
                RCin      <= x"FFFF";
                Address   <= "0001";
                Rst       <= '0';
                Load      <= '0'; 
            when others => null; 
        end case;         
    end if;

END PROCESS STAt;	
END testbench;
