onerror {resume}
quietly WaveActivateNextPane {} 0

vsim -t ns saturnin_block_encrypt

add wave -noupdate /saturnin_block_encrypt/presente
add wave -noupdate /saturnin_block_encrypt/presente_XOR
add wave -noupdate /saturnin_block_encrypt/presente_SBox
add wave -noupdate /saturnin_block_encrypt/clk
add wave -noupdate /saturnin_block_encrypt/Rd_En_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_Rin_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_In_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_Out_SB
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/state_Out_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Addr_Rd_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/a0_in
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/b0_in
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/c0_in
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/d0_in
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/a1_in
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/b1_in
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/c1_in
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/d1_in
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/a0_out
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/b0_out
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/c0_out
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/d0_out
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/a1_out
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/b1_out
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/c1_out
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/d1_out
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/uKey/r_memory
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/uBuff/r_memory

run 10000
