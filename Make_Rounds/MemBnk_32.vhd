LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 
entity MemBnk_32 is
    port( 
        Xin     : in  std_logic_vector (0 to 7);
        Address : in  std_logic_vector (0 to 4);
        Xout    : out std_logic_vector (0 to 7);
        Load    : in  std_logic;
        Rst     : in  std_logic;
        Clk     : in  std_logic       
    );

    end MemBnk_32 ;
architecture RTL of MemBnk_32 is 
    type t_memory is array (0 to 31) of std_logic_vector (0 to 7);
    signal r_memory: t_memory;
    begin
        process (clk)
        begin 
        if (CLK'event AND CLK = '1') then
            if Rst = '1' then 
                r_memory(to_integer(unsigned(Address)))<= (others=>'0');    
            elsif load = '1' then 
                r_memory(to_integer(unsigned(Address)))<= Xin;
                Xout<=r_memory(to_integer(unsigned(Address)));
            else
                Xout<=r_memory(to_integer(unsigned(Address)));
            end if;
        end if ;
        end process;
end architecture RTL;
