LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 
entity MemBnk is
    port( 
        RCin    : in  std_logic_vector (0 to 15);
        Address : in  std_logic_vector (0 to 3);
        Load    : in  std_logic;
        --Read    in  std_logic;        
        Rst     : in  std_logic;
        Clk     : in  std_logic;
        RCout   : out std_logic_vector (0 to 15)
        --Addout  out std_logic_vector (0 to 3) 
    );

    end MemBnk ;
architecture RTL of MemBnk is 
    type t_memory is array (0 to 31) of std_logic_vector (0 to 15);
    signal r_memory: t_memory;
    begin
        process (clk)
        begin 
        if (CLK'event AND CLK = '1') then
            if Rst = '1' then 
                r_memory(to_integer(signed(Address)))<= (others=>'0');    
            elsif load = '1' then 
                r_memory(to_integer(signed(Address)))<= RCin;
            else
                RCout<=r_memory(to_integer(signed(Address)));
            end if;
        end if ;
        end process;
end architecture RTL;
