onerror {resume}
quietly WaveActivateNextPane {} 0

vsim -t ns saturnin_block_encrypt

add wave -noupdate /saturnin_block_encrypt/presente
add wave -noupdate /saturnin_block_encrypt/uXorKey/presente
add wave -noupdate /saturnin_block_encrypt/presente_SBox
add wave -noupdate /saturnin_block_encrypt/clk
add wave -noupdate /saturnin_block_encrypt/Rd_En_B
add wave -noupdate /saturnin_block_encrypt/Wr_En_B
add wave -noupdate -format Literal -color brown /saturnin_block_encrypt/Enable_XK
add wave -noupdate -format Literal -color brown /saturnin_block_encrypt/Enable_DF
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_Rin_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_In_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_Out_SB
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/state_Out_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Addr_Rd_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Addr_Wr_B

add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/uKey/r_memory
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encrypt/uBuff/r_memory
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encrypt/uXorKey/Data_RIn_B
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encrypt/uXorKey/Data_Out_B
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encrypt/uXorKey/Data_Out_K
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encrypt/uXorKey/Addr_Rd_B
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encrypt/uXorKey/Addr_Rd_K
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encrypt/uXorKey/Addr_Wr_B
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encrypt/uXorKey/c1_in


run 13000
