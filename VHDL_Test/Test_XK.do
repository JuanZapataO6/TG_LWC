onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns Saturnin_Block_EncryptV2
add wave -noupdate /saturnin_block_encryptv2/clk
add wave -noupdate /saturnin_block_encryptv2/Data_F/presente
add wave -noupdate /saturnin_block_encryptv2/UXorKey/presente
add wave -noupdate /saturnin_block_encryptv2/UMDS/presente
add wave -noupdate /saturnin_block_encryptv2/USBox/presente
add wave -noupdate /saturnin_block_encryptv2/USR_Slice/presente
add wave -noupdate /saturnin_block_encryptv2/USR_Slice_Inv/presente
add wave -noupdate /saturnin_block_encryptv2/USR_Sheet/presente
add wave -noupdate /saturnin_block_encryptv2/USR_Sheet_Inv/presente
add wave -noupdate /saturnin_block_encryptv2/presente
add wave -noupdate /saturnin_block_encryptv2/UXorKey_Rotated/presente
add wave -noupdate /saturnin_block_encryptv2/clk
add wave -noupdate /saturnin_block_encryptv2/Rd_En_B
add wave -noupdate /saturnin_block_encryptv2/Wr_En_B
add wave -noupdate -format Literal -color brown /saturnin_block_encryptv2/Enable_XKR
add wave -noupdate -format Literal -color brown /saturnin_block_encryptv2/En_XKR_Main
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_Rin_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_In_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_Out_SB
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Rd_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Wr_B

add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encryptv2/uKey/r_memory
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encryptv2/uBuff/r_memory
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/UXorKey_Rotated/Data_RIn_B
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/UXorKey_Rotated/Data_Out_B
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/UXorKey_Rotated/Data_Out_K
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/UXorKey_Rotated/Addr_Rd_B
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/UXorKey_Rotated/Addr_Rd_K
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/UXorKey_Rotated/Addr_Wr_B

run 200000
