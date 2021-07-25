library IEEE; 
use IEEE.std_logic_1164.all; 

package Definitions is 
function S_0 (z : in std_logic_vector) return std_logic_vector;
function S_1 (z : in std_logic_vector) return std_logic_vector;
function S_2 (z : in std_logic_vector) return std_logic_vector;
function S_3 (z : in std_logic_vector) return std_logic_vector;
procedure Sub (x:in std_logic_vector  ekey : out std_logic_vector);
procedure RotSub (x:in std_logic_vector ekey : out std_logic_vector);
end Definitions;

package body Definitions is
function