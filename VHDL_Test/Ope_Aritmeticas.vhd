library IEEE; 
use IEEE.std_logic_1164.all; 

package Ope_Aritmeticas is 
function vector_to_natural (v:in std_logic_vector) return natural; 
function natural_to_vector(nat : in natural; length : in natural) 
                            return std_logic_vector; 
procedure vector_add ( signal v1, v2 : in std_logic_vector (1 downto 0); 
                        variable v_result : out std_logic_vector(1 downto 0)); 
end Ope_Aritmeticas; 

package body Ope_Aritmeticas is
    function vector_to_natural (v:in std_logic_vector) return natural is 
        variable aux : natural:=0; 
        begin
            for i in v'range loop 
                if v(i)='1' then
                    aux := aux + (2**i); 
                end if; 
            end loop; 
        return aux; 
    end vector_to_natural; 
    function natural_to_vector (nat : in natural; length : in natural) 
                            return std_logic_vector is
        variable v: std_logic_vector(length-1 downto 0); 
        variable cociente, aux, i, resto: natural; 
        begin
            aux:= nat; 
            i:=0; 
            while(aux/=0) and(i<length) loop
                cociente := aux/2; 
                resto := aux mod 2; 
                if resto=0 then v(i):='0'; 
                else v(i):='1'; 
                end if; 
                i := i+1; 
                aux := cociente; 
            end loop; 
            for j in i to length-1 loop
                v(j):='0'; 
            end loop; 
            return v; 
    end natural_to_vector; 

    procedure vector_add ( signal v1, v2 :in std_logic_vector (1 downto 0); 
                        variable v_result : out std_logic_vector (1 downto 0)) is
    variable suma,long: natural; 
    begin
        long:=v1'length;
        suma:= vector_to_natural(v1) + vector_to_natural(v2);
        v_result := natural_to_vector(suma,long);
    end vector_add;
end Ope_Aritmeticas;

