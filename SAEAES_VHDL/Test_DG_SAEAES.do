onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns Data_Generate

add wave -noupdate /Data_Generate/presente
add wave -noupdate /Data_Generate/clk
add wave -noupdate /Data_Generate/Wr_en_Tx
add wave -noupdate /Data_Generate/Wr_en_ATx
add wave -noupdate /Data_Generate/Wr_en_K
add wave -noupdate /Data_Generate/Wr_en_N
add wave -noupdate -radix hexadecimal /Data_Generate/Data_In_Tx
add wave -noupdate -radix hexadecimal /Data_Generate/Data_In_Kn
add wave -noupdate -radix hexadecimal /Data_Generate/Addr_In_Kn
add wave -noupdate -radix hexadecimal /Data_Generate/Addr_In_Kn

run 5000
