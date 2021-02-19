LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

entity Saturnin_Block_Encrypt is 
end Saturnin_Block_Encrypt;

architecture Main of Saturnin_Block_Encrypt is 
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
component XOR_key
    port(
        state      : in  std_logic_vector (0 to 15);
        key        : in  std_logic_vector (0 to 15);
        clk        : in  std_logic;
        En_In      : in  std_logic;
        En_Out     : out std_logic;  
        state_out  : out std_logic_vector (0 to 15)        
    );
end component XOR_key;
component S_Box
    port(
        --Verificar entradas tipo arreglo 
        a0_in   : in  std_logic_vector(15 downto 0);
        a1_in   : in  std_logic_vector(15 downto 0);
        b0_in   : in  std_logic_vector(15 downto 0);
        b1_in   : in  std_logic_vector(15 downto 0);
        c0_in   : in  std_logic_vector(15 downto 0);
        c1_in   : in  std_logic_vector(15 downto 0);
        d0_in   : in  std_logic_vector(15 downto 0);
        d1_in   : in  std_logic_vector(15 downto 0);
        a0_out  : out    std_logic_vector(15 downto 0);
        a1_out  : out    std_logic_vector(15 downto 0);
        b0_out  : out    std_logic_vector(15 downto 0);
        b1_out  : out    std_logic_vector(15 downto 0);
        c0_out  : out    std_logic_vector(15 downto 0);
        c1_out  : out    std_logic_vector(15 downto 0);
        d0_out  : out    std_logic_vector(15 downto 0);
        d1_out  : out    std_logic_vector(15 downto 0);
        En_SBox_in  : in  std_logic;
        En_SBox_out : out  std_logic;
        clk     : in     std_logic
    );
end component S_Box;
TYPE estado is (s0, s1,s2,s3,s4,s5,s6,s7);
SIGNAL presente:estado:=s0;
signal presente_XOR :estado:=s0;
signal presente_SBOX :estado:=s0;
signal clk : std_logic;
-- Signals for Generate Data
signal Rd_En_DGK        : std_logic:= '0';
signal Rd_En_DGB        : std_logic:= '0';
signal Enable_Generate  : std_logic;
signal Data_In_DGK        : std_logic_vector (7 DOWNTO 0);
signal Data_In_DGB        : std_logic_vector (7 DOWNTO 0);
signal Addr_Rd_DGK        : std_logic_vector (4 DOWNTO 0):= "00000";
signal Addr_Rd_DGB        : std_logic_vector (4 DOWNTO 0):= "00000";
-- Signals for MemBnk_K
signal Wr_En_k     : std_logic:= '1';
signal Rd_En_k     : std_logic:= '1';
signal Rst_k       : std_logic:= '1';
signal Addr_Rd_k   :std_logic_vector (3 DOWNTO 0):= "0000";
signal Addr_Wr_k   :std_logic_vector (3 DOWNTO 0):= "0000";
signal Data_RIn_k  :std_logic_vector (15 DOWNTO 0):=x"7777";
signal Data_In_K   :std_logic_vector (15 DOWNTO 0):=x"7777";
signal Data_Out_Sk   :std_logic_vector (15 DOWNTO 0):=x"7777";
-- Signals for MemBnk_B
signal Wr_En_B     : std_logic:= '1';
signal Rd_En_B     : std_logic:= '1';
signal Rst_B       : std_logic:= '1';
signal Addr_Rd_B   : std_logic_vector (3 DOWNTO 0):= "0000";
signal Addr_Wr_B   : std_logic_vector (3 DOWNTO 0):= "0000";
signal Data_RIn_B   : std_logic_vector (15 DOWNTO 0):=x"7777";
signal Data_In_B   : std_logic_vector (15 DOWNTO 0):=x"7777";
signal Data_Out_SB : std_logic_vector (15 DOWNTO 0):=x"7777";
-- Signals for Xor_Key
signal state_Out_B   : std_logic_vector (15 DOWNTO 0):=x"7777";
signal state_Out_K   : std_logic_vector (15 DOWNTO 0):=x"7777";
signal state_In_B    : std_logic_vector (15 DOWNTO 0):=x"7777";
signal En_in_XK      : std_logic:='1';
signal En_Out_XK     : std_logic;
-- Signals for S_BOX
signal a0_in,b0_in,c0_in,d0_in   : std_logic_vector (15 DOWNTO 0):=x"7777";
signal a1_in,b1_in,c1_in,d1_in   : std_logic_vector (15 DOWNTO 0):=x"7777";
signal En_SBox_in,En_SBox_out    : std_logic := '1' ;
signal a0_out,b0_out,c0_out,d0_out   : std_logic_vector (15 DOWNTO 0):=x"7777";
signal a1_out,b1_out,c1_out,d1_out   : std_logic_vector (15 DOWNTO 0):=x"7777";
begin
reloj:process
    begin
    clk <= '0';
    wait for 12.5 ns;
    clk <= '1';
    wait for 12.5 ns;
end process reloj;
RinB_MB: Register_A 
    generic map (
        w => 16
    ) 
    Port map (
    DD_IN  => Data_RIn_B,
    DD_OUT => Data_In_B,
    Clk    => clk
    );
RinK_MB: Register_A 
    generic map (
        w => 16
    ) 
    Port map (
    DD_IN  => Data_RIn_K,
    DD_OUT => Data_In_K,
    Clk    => clk
    );
RinB_XK: Register_A 
    generic map (
        w => 16
    ) 
    Port map (
    DD_IN  => Data_Out_SB,
    DD_OUT => state_Out_B,
    Clk    => clk
    );
RinK_XK: Register_A 
    generic map (
        w => 16
    ) 
    Port map (
        DD_IN  => Data_Out_Sk,
        DD_OUT => state_Out_K,
        Clk    => clk
    );
u1: Data_Generate Port Map (Clk           => clk,
                            Rd_En_K       => Rd_En_DGK,
                            Rd_En_B       => Rd_En_DGB,
                            Ena_Out       => Enable_Generate,
                            Addr_Out_K    => Addr_Rd_DGK,
                            Addr_Out_B    => Addr_Rd_DGB,
                            Data_Out_K    => Data_In_DGK,
                            Data_Out_B    => Data_In_DGB
                            );
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
uKey: MemBnk 
    generic map(w => 16,
                d => 16,
                a => 4
    )
    Port Map (              Wr_En    => Wr_En_k,
                            Rd_En    => Rd_En_k,
                            Rst      => Rst_k,
                            Clk      => clk,
                            Addr_In  => Addr_Wr_k,
                            Addr_Out => Addr_Rd_k,
                            Data_in  => Data_In_k,
                            Data_out => Data_Out_Sk
    );
Xor_Ftn : XOR_key
    port map (
        state     => state_Out_B,
        clk       => clk,
        En_In     => En_in_XK,
        En_Out    => En_Out_XK,
        key       => state_Out_K,    
        state_out => state_In_B
    ); 
u1_SBox : S_Box
    port map (
        a0_in   =>a0_in,
        a1_in   =>a1_in,
        b0_in   =>b0_in,
        b1_in   =>b1_in,
        c0_in   =>c0_in,
        c1_in   =>c1_in,
        d0_in   =>d0_in,
        d1_in   =>d1_in,
        a0_out  =>a0_out,
        a1_out  =>a1_out,
        b0_out  =>b0_out,
        b1_out  =>b1_out,
        c0_out  =>c0_out,
        c1_out  =>c1_out,
        d0_out  =>d0_out,
        d1_out  =>d1_out,
        En_SBox_in  =>En_SBox_in, 
        En_SBox_out =>En_SBox_out,
        clk     =>Clk
    );
STat: process(clk,presente)
    variable Addr_Aux :std_logic_vector (4 DOWNTO 0):="00000";
    variable Establish:std_logic_vector (4 DOWNTO 0):="00000";
    variable En_SBox :std_logic;
    variable En_SBox_In_Aux :std_logic;
    begin
        if clk 'event and clk = '1' then 
            if Enable_generate ='1' and Addr_Aux <= "1111" then
                case presente is 
                    when s0 =>
                        presente    <= s1;
                        Rd_En_DGK   <= '0';
                        Rd_En_DGB   <= '0';
                        Addr_Rd_DGK  <= Addr_Rd_DGK+1;
                        Addr_Rd_DGB  <= Addr_Rd_DGB+1;
                    when s1 =>
                        presente    <= s2;
                        Rd_En_DGK   <= '0';
                        Rd_En_DGB   <= '0';
                        Wr_En_k     <= '1';
                        Wr_En_B     <= '1';
                        Data_RIn_K   <= Data_RIn_k(15 downto 8) & Data_In_DGK;  
                        Data_RIn_B   <= Data_RIn_B(15 downto 8) & Data_In_DGB; 
                    when s2 =>
                        presente    <= s3;
                        Rd_En_DGK   <= '1';
                        Rd_En_DGB   <= '1';
                        Data_RIn_K   <= Data_In_DGK & Data_RIn_k(7 downto 0);  
                        Data_RIn_B   <= Data_In_DGB & Data_RIn_B(7 downto 0);  
                    when s3 =>                        
                        presente    <= s4;
                        Addr_Wr_B   <= Addr_Aux(Addr_Aux'length -2 downto 0);
                        Addr_Wr_k   <= Addr_Aux(Addr_Aux'length -2 downto 0);                        
                        Rd_En_DGK   <= '0';
                        Rd_En_DGB   <= '0';
                        Wr_En_k     <= '0';
                        Wr_En_B     <= '0';
                    when s4 =>
                        presente <= s0;
                        Wr_En_k     <= '1';
                        Wr_En_B     <= '1';
                        Addr_Aux:=Addr_Aux+1;
                        Addr_Rd_DGK<=Addr_Aux(Addr_Aux'length -2 downto 0)&'0';
                        Addr_Rd_DGB<=Addr_Aux(Addr_Aux'length -2 downto 0)&'0';
                    when others => null;
                end case;
            elsif presente = s0 and Enable_generate ='1' then 
                presente  <= s1;
                Rd_En_DGK <= '0';
                Rd_En_DGB <= '0';
                En_in_XK  <= '0';                
            elsif En_in_XK = '0'  then   
                if Enable_Generate = '1' then  
                    case presente_XOR is 
                    when s0 =>-- STAR 
                        presente_XOR <= s1;
                        Addr_Rd_B <= x"0";
                        Addr_Rd_k <= x"0";
                        Addr_Wr_B <= x"0";
                        Addr_Wr_k <= x"0";
                        Rd_En_B   <= '0';
                        Rd_En_K   <= '0';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s1 =>                        
                        presente_XOR <= s2;
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';                        
                    when s2 =>
                        presente_XOR <= s3;                 
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s3 =>
                        presente_XOR <= s4;                        
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s4 =>
                        presente_XOR <= s5;  
                        Data_RIn_B <=state_In_B;                      
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s5 =>
                        presente_XOR <= s6;
                        Data_RIn_B <=state_In_B;
                        --Addr_Rd_B <= Addr_Rd_B + 1;
                        --Addr_Rd_k <= Addr_Rd_k + 1;
                        --Addr_Wr_B <= Addr_Wr_B + 1;                        
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '0';
                        Wr_En_k   <= '1';
                        En_SBox := '1';
                    when s6 =>
                        presente_XOR <= s1;
                        Data_RIn_B <=state_In_B;
                        Addr_Rd_B <= Addr_Rd_B + 1;
                        Addr_Rd_k <= Addr_Rd_k + 1;
                        Addr_Wr_B <= Addr_Wr_B + 1;                        
                        Rd_En_B   <= '0';
                        Rd_En_K   <= '0';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';                        
                        if Addr_Rd_B = "1111" then
                            En_in_XK  <= '1';
                            En_SBox := '0';
                            Addr_Rd_B <= x"0";
                            Addr_Rd_k <= x"0";
                            Addr_Wr_B <= x"0";
                            Addr_Wr_B <= x"0";
                            --Rd_En_B   <= '0';
                        end if;
                    when others => null;
                    end case;
                end if;
            elsif En_SBox = '0' then 
                if Enable_Generate = '1' then  
                    case presente_SBOX is 
                    when s0 =>-- STAR 
                    if Establish < "00001" then 
                        presente_SBOX <= s0;
                        Rd_En_B   <= '0';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                        Establish := Establish+1;
                    else 
                        presente_SBOX <= s1;
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                        Establish := "00000";
                    end if;
                    when s1 =>                        
                        presente_SBOX <= s1;
                        case Addr_Rd_B(Addr_Rd_B'length-2 downto 0) is
                            when "000" => 
                                if Establish <= "00001" then  
                                    a0_in <= state_Out_B;
                                    --Addr_Rd_B <= Addr_Rd_B + 1;
                                    Establish := Establish+1;
                                    Rd_En_B   <= '0';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                else 
                                    Addr_Rd_B <= Addr_Rd_B + 1;
                                    presente_SBOX <= s1;
                                    Rd_En_B   <= '1';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                    Establish := "00000";
                                end if;
                            when "001" =>
                                if Establish <= "00001" then
                                    Establish := Establish+1;
                                    Rd_En_B   <= '0';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                else
                                    b0_in <= state_Out_B;
                                    Addr_Rd_B <= Addr_Rd_B + 1;
                                    presente_SBOX <= s1;
                                    Rd_En_B   <= '1';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                    Establish := "00000";
                                end if;
                            when "010" =>
                                if Establish <= "00001" then
                                    Establish := Establish+1;                                    
                                    Rd_En_B   <= '0';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                else
                                    c0_in <= state_Out_B;
                                    Addr_Rd_B <= Addr_Rd_B + 1;
                                    presente_SBOX <= s1;
                                    Rd_En_B   <= '1';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                    Establish := "00000";
                                end if;
                            when "011" =>
                                if Establish <= "00001" then
                                    Establish := Establish+1;
                                    Rd_En_B   <= '0';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                else                        
                                    d0_in <= state_Out_B;
                                    Addr_Rd_B <= Addr_Rd_B + 1;
                                    presente_SBOX <= s1;
                                    Rd_En_B   <= '1';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                    Establish := "00000";
                                end if;
                            when "100" =>
                                if Establish <= "00001" then
                                    Establish := Establish+1;
                                    Rd_En_B   <= '0';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                else
                                    a1_in <= state_Out_B;
                                    Addr_Rd_B <= Addr_Rd_B + 1;
                                    presente_SBOX <= s1;
                                    Rd_En_B   <= '1';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                    Establish := "00000";
                                end if;
                            when "101" =>
                                if Establish <= "00001" then
                                    Establish := Establish+1;
                                    Rd_En_B   <= '0';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                else
                                    b1_in <= state_Out_B;
                                    Addr_Rd_B <= Addr_Rd_B + 1;
                                    presente_SBOX <= s1;
                                    Rd_En_B   <= '1';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                    Establish := "00000";
                                end if;
                            when "110" =>
                                if Establish <= "00001" then---Esto lo puedo convertir en una funcion 
                                    Establish := Establish+1;
                                    Rd_En_B   <= '0';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                else
                                    c1_in <= state_Out_B;
                                    Addr_Rd_B <= Addr_Rd_B + 1;
                                    presente_SBOX <= s1;
                                    Rd_En_B   <= '0';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                    Establish := "00000";
                                end if;
                            when "111" =>
                                if Establish <= "00001" then
                                    Establish := Establish+1;
                                    Rd_En_B   <= '0';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                else
                                    d1_in <= state_Out_B;
                                    Addr_Rd_B <= Addr_Rd_B + 1;
                                    if Addr_Rd_B(3) = '0' then                                     
                                        Addr_Wr_B <=x"0" ;
                                    else 
                                        Addr_Wr_B <=x"8" ;
                                    end if;                                        --Addr_Rd_B <=x"0";
                                    En_SBox_in <= '0';
                                    presente_SBOX <= s2;
                                    --En_SBox_in <= '1';
                                    --En_SBox_In_Aux <= '1';
                                    Rd_En_B   <= '1';
                                    Rd_En_K   <= '1';
                                    Wr_En_B   <= '1';
                                    Wr_En_k   <= '1';
                                    Establish := "00000";
                                end if;
                            when others => null;
                        end case;
                    when s2 =>
                    if En_SBox_out ='0' then
                        En_SBox_in <= '1';
                        En_SBox_In_Aux := '1';
                        --if En_SBox_In_Aux = '1' then                         
                        presente_SBOX <= s3; 
                        --else
                        --    presente_SBOX <= s2;                           
                    end if; 
                    --else 
                       -- En_SBox_In_Aux := '0';
                    --end if;

                    when s3 =>
                        --if En_SBox_out ='0' then
                          --  if En_SBox_In_Aux = '1' then 
                                case Addr_Wr_B(Addr_Wr_B'length-2 downto 0) is
                                    when "000" =>
                                        presente_SBOX <= s3;
                                        En_SBox_in <= '1';
                                        En_SBox_In_Aux := '1';
                                        Data_RIn_B <= b0_out;
                                        Rd_En_B    <= '1';
                                        Rd_En_K    <= '1';
                                        Wr_En_B    <= '0';
                                        Wr_En_k    <= '1';
                                        Addr_Wr_B <= Addr_Wr_B + 1;
                                    when "001" =>
                                        presente_SBOX <= s3;
                                        En_SBox_in <= '1';
                                        En_SBox_In_Aux := '1';
                                        Data_RIn_B <= c0_out;
                                        Rd_En_B    <= '1';
                                        Rd_En_K    <= '1';
                                        Wr_En_B    <= '0';
                                        Wr_En_k    <= '1';
                                        Addr_Wr_B <= Addr_Wr_B + 1;
                                    when "010" =>
                                        presente_SBOX <= s3;
                                        En_SBox_in <= '1';
                                        En_SBox_In_Aux := '1';
                                        Data_RIn_B <= d0_out;
                                        Rd_En_B    <= '1';
                                        Rd_En_K    <= '1';
                                        Wr_En_B    <= '0';
                                        Wr_En_k    <= '1';
                                        Addr_Wr_B <= Addr_Wr_B + 1;
                                    when "011" =>
                                        presente_SBOX <= s3;
                                        En_SBox_in <= '1';
                                        En_SBox_In_Aux := '1';
                                        Data_RIn_B <= a0_out;
                                        Rd_En_B    <= '1';
                                        Rd_En_K    <= '1';
                                        Wr_En_B    <= '0';
                                        Wr_En_k    <= '1';
                                        Addr_Wr_B <= Addr_Wr_B + 1;
                                    when "100" =>
                                        presente_SBOX <= s3;
                                        En_SBox_in <= '1';
                                        En_SBox_In_Aux := '1';
                                        Data_RIn_B <= d1_out;
                                        Rd_En_B    <= '1';
                                        Rd_En_K    <= '1';
                                        Wr_En_B    <= '0';
                                        Wr_En_k    <= '1';
                                        Addr_Wr_B <= Addr_Wr_B + 1;
                                    when "101" =>
                                        presente_SBOX <= s3;
                                        En_SBox_in <= '1';
                                        En_SBox_In_Aux := '1';
                                        Data_RIn_B <= b1_out;
                                        Rd_En_B    <= '1';
                                        Rd_En_K    <= '1';
                                        Wr_En_B    <= '0';
                                        Wr_En_k    <= '1';
                                        Addr_Wr_B <= Addr_Wr_B + 1;
                                    when "110" =>
                                        presente_SBOX <= s3;
                                        En_SBox_in <= '1';
                                        En_SBox_In_Aux := '1';
                                        Data_RIn_B <= a1_out;                                        
                                        Rd_En_B    <= '1';
                                        Rd_En_K    <= '1';
                                        Wr_En_B    <= '0';
                                        Wr_En_k    <= '1';
                                        Addr_Wr_B <= Addr_Wr_B + 1;
                                    when "111" =>
                                        if Addr_Rd_B(3)='1' then
                                            presente_SBOX <= s0;                                                                                        
                                            En_SBox_in <= '1';
                                            En_SBox_In_Aux := '1';
                                            Data_RIn_B <= c1_out;
                                            Rd_En_B    <= '1';
                                            Rd_En_K    <= '1';
                                            Wr_En_B    <= '1';
                                            Wr_En_k    <= '1';
                                            Addr_Wr_B  <= Addr_Wr_B + 1;
                                        else 
                                            presente_SBOX <= s4;
                                            En_SBox_in <= '1';
                                            En_SBox_In_Aux := '1';
                                            Addr_Rd_B <= x"0";
                                            Addr_Rd_k <= x"0";
                                            Addr_Wr_B <= x"0";
                                            Addr_Wr_B <= x"0";
                                        end if;
                                    when others => null;
                                end case; 
                            --end if; 
                        --else 
                          --En_SBox_In_Aux := '1';                           
                        --end if; 
                    when s4 =>
                        presente_SBOX <= s5;
                        --Data_In_B <=state_In_B;
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s5 =>
                        presente_SBOX <= s6;                        
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                    when s6 =>
                        presente_SBOX <= s7;
                        --Data_In_B <=state_In_B;
                        --Addr_Rd_B <= Addr_Rd_B + 1;
                        --Addr_Rd_k <= Addr_Rd_k + 1;
                        --Addr_Wr_B <= Addr_Wr_B + 1;                        
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                        En_SBox := '1';
                    when s7 =>
                        presente_SBOX <= s1;
                        --Data_In_B <=state_In_B;
                        Addr_Rd_B <= Addr_Rd_B + 1;
                        Addr_Rd_k <= Addr_Rd_k + 1;
                        Addr_Wr_B <= Addr_Wr_B + 1;                        
                        Rd_En_B   <= '1';
                        Rd_En_K   <= '1';
                        Wr_En_B   <= '1';
                        Wr_En_k   <= '1';
                        En_SBox := '1';
                        if Addr_Rd_B = "1111" then
                            En_in_XK  <= '1';
                        end if;
                    when others => null;
                    end case;
                end if;
                
            end if;
        end if;
    end process STat;
end Main;