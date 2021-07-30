LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 
entity MemBnk is
    generic(    w:integer;--width of word
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
end MemBnk ;
architecture RTL of MemBnk is 
type t_memory is array (0 to d-1) of std_logic_vector (0 to w-1);
signal r_memory: t_memory;
begin
    --Read Registers
    process (clk,Rd_En)
    begin 
        if (CLK'event AND CLK = '1') then
            if Rd_En = '0' then 
                Data_Out<=r_memory(to_integer(unsigned(Addr_Out)));
            end if;
        end if ;
    end process;
    --Write Registers 
    process (clk,Wr_En)
    begin 
        if (CLK'event AND CLK = '1') then
            if Wr_En = '0' then          
                r_memory(to_integer(unsigned(Addr_In)))<= Data_In;
            elsif Rst = '0' then 
                r_memory(to_integer(unsigned(Addr_In)))<=(others=>'0');
            end if;
        end if ;
    end process;
end architecture RTL;
