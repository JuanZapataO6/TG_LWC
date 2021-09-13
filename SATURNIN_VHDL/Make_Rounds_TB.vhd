LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY Make_Rounds_TB IS
END Make_Rounds_TB;

ARCHITECTURE testbench OF Make_Rounds_TB IS
--Declarate Components 
COMPONENT Make_Rounds 
port(
        RC0         : inout std_logic_vector(0 to 15);
        RC1         : inout std_logic_vector(0 to 15);
        R           : in std_logic_vector (3 downto 0);
        D           : in std_logic_vector (3 downto 0);
        Addr_Out0   : in std_logic_vector (4 downto 0);
        Addr_Out1   : in std_logic_vector (4 downto 0);
        Rd_En_0     : in std_logic;
        Rd_En_1     : in std_logic;
        Load        : in std_logic;
        clk         : in std_logic
    );
END COMPONENT;

TYPE estado is (s0, s1,s2,s3);
SIGNAL presente:estado:=s0;
--Signals Make Rounds 
SIGNAL RC0,RC1   :STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL R,D       :STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL Addr_Out0 :std_logic_vector (4 downto 0);
SIGNAL Addr_Out1 :std_logic_vector (4 downto 0);
SIGNAL clk,load  :STD_LOGIC := '0';
SIGNAL Rd_En_0   :std_logic;
SIGNAL Rd_En_1   :std_logic;
--Signals "in" for MemBank_32 "xk, xb"
--signal buf_key      :STD_LOGIC_VECTOR(15 DOWNTO 0);

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
u1: Make_Rounds PORT MAP (  RC0         => RC0,
                            RC1         => RC1,
                            R           => R,
                            D           => D,
                            Addr_Out0   => Addr_Out0,
                            Addr_Out1   => Addr_Out1,
                            Rd_En_0     => Rd_En_0,
                            Rd_En_1     => Rd_En_1,
                            clk         => clk,
                            Load        => Load
                        );

STAt: PROCESS (clk,presente) -- Defino los estados 

BEGIN 
    
    if clk'event and clk='1' then  
        case presente is
            when s0 =>
                presente<=S1;
                R       <= x"A";
                D       <= x"6";
                Load    <= '1'; 
            when s1 =>
                presente<=S1;  
                R       <= x"A";
                D       <= x"6";
                Load    <= '0';
            when others => null; 
        end case;         
    end if;

END PROCESS STAt;	
END testbench;