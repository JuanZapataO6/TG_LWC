LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY Make_Rounds_TB IS
END Make_Rounds_TB;

ARCHITECTURE testbench OF Make_Rounds_TB IS

COMPONENT Make_Rounds 
PORT (
    RC0 : inout std_logic_vector(0 to 15);
    RC1 : inout std_logic_vector(0 to 15);
    R   : in std_logic_vector (3 downto 0);
    D   : in std_logic_vector (3 downto 0);
    clk : in std_logic;
    Load: in std_logic
);
END COMPONENT;

TYPE estado is (s0, s1,s2,s3);
SIGNAL presente:estado:=s0;

SIGNAL RC0,RC1  :STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL R,D      :STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL clk,Load :STD_LOGIC := '0';

BEGIN
-- Free running test clock
reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
    end process reloj;
    
-- Instance of design being tested
u1: Make_Rounds PORT MAP (RC0 => RC0,
                        RC1  => RC1,
                        R    => R,
                        D    => D,
                        clk  => clk, 
                        Load => Load    
                        );
STAt: PROCESS (clk,presente) -- Defino los estados 

BEGIN 
    
    if clk'event and clk='1' then  
        case presente is
            when s0=>
                presente<=S1; 
                R    <= x"A";
                D    <= x"6";
                Load <= '1'; 
            when s1=>
                presente<=S1;  
                R  <= x"A";
                D  <= x"6";
                Load<= '0';
            when others => null; 
        end case;         
    end if;

END PROCESS STAt;	
END testbench;