onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns SAEAES_Block_Encrypt 

add wave -noupdate /SAEAES_Block_Encrypt/presente
add wave -noupdate /SAEAES_Block_Encrypt/uAesKey/presente
add wave -noupdate /SAEAES_Block_Encrypt/uHash/presente
add wave -noupdate /SAEAES_Block_Encrypt/uAesEnc/presente
add wave -noupdate /SAEAES_Block_Encrypt/uEncrypt/presente
add wave -noupdate /SAEAES_Block_Encrypt/clk
add wave -noupdate -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Addr_Control
add wave -noupdate /SAEAES_Block_Encrypt/uAesKey/En_In
add wave -noupdate /SAEAES_Block_Encrypt/uAesKey/En_out
add wave -noupdate /SAEAES_Block_Encrypt/uHash/En_In
add wave -noupdate /SAEAES_Block_Encrypt/uHash/En_out
add wave -noupdate /SAEAES_Block_Encrypt/uAesEnc/En_In
add wave -noupdate /SAEAES_Block_Encrypt/uAesEnc/En_out
add wave -noupdate /SAEAES_Block_Encrypt/uEncrypt/En_In
add wave -noupdate /SAEAES_Block_Encrypt/uEncrypt/En_out

add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/ueSe/r_memory

add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uEncrypt/Rd_En_Bf
add wave -noupdate -format Literal -color brown  -radix hexadecimal /SAEAES_Block_Encrypt/uEncrypt/Rd_En_eS
add wave -noupdate -format Literal -color blue   -radix hexadecimal /SAEAES_Block_Encrypt/uEncrypt/Wr_En_S 

add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uEncrypt/Addr_Rd_Bf
add wave -noupdate -format Literal -color brown  -radix hexadecimal /SAEAES_Block_Encrypt/uEncrypt/Addr_Rd_eS
add wave -noupdate -format Literal -color blue   -radix hexadecimal /SAEAES_Block_Encrypt/uEncrypt/Addr_Wr_S

add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uEncrypt/Data_Out_Bf
add wave -noupdate -format Literal -color brown -radix hexadecimal /SAEAES_Block_Encrypt/uEncrypt/Data_Out_eS
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uEncrypt/Data_In_S

add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Rd_En_S
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Addr_Rd_S
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Data_Out_S
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Rd_En_S
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Addr_Wr_S
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/Data_In_S

add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Addr_Rd_eK
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Addr_Rd_S
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/Data_Out_eK
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/Data_Out_eK
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Data_Out_S
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/Data_Out_eS

run 40000
