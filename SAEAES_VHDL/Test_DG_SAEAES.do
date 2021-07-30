onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns SAEAES_Block_Encrypt 

add wave -noupdate /SAEAES_Block_Encrypt/presente
add wave -noupdate /SAEAES_Block_Encrypt/uAesKey/presente
add wave -noupdate /SAEAES_Block_Encrypt/uHash/presente
add wave -noupdate /SAEAES_Block_Encrypt/clk
add wave -noupdate /SAEAES_Block_Encrypt/uAesKey/En_out
add wave -noupdate /SAEAES_Block_Encrypt/Rd_en_K
add wave -noupdate /SAEAES_Block_Encrypt/Addr_Out_K
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uDataGenerate/uBuf/r_memory
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uDataGenerate/uAdd/r_memory
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uDataGenerate/uKey/r_memory
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uDataGenerate/uNonce/r_memory
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesKey/Data_RIn_K
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesKey/Data_In_K
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesKey/Data_In_eK
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/ueKey/r_memory
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesKey/Addr_Wr_eK
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/ueSe/r_memory
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Addr_Control

add wave -noupdate /SAEAES_Block_Encrypt/uHash/Rst_S
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uHash/Addr_Wr_S
add wave -noupdate /SAEAES_Block_Encrypt/eK_Rd_Hash
add wave -noupdate /SAEAES_Block_Encrypt/uAesKey/Rd_en_K
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/Addr_Wr_S
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/eS_AddrWr_Hash
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uHash/Addr_Rd_Ad

add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uHash/Addr_Rd_eS
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uHash/Data_Out_eS
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uHash/Data_Out_Ad
add wave -noupdate -format Literal -color brown -radix hexadecimal /SAEAES_Block_Encrypt/uHash/Data_In_S
add wave -noupdate /SAEAES_Block_Encrypt/uAesKey/Wr_en_eK

run 8000
