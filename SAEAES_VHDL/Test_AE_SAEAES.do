onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns SAEAES_Block_Encrypt 

add wave -noupdate /SAEAES_Block_Encrypt/presente
add wave -noupdate /SAEAES_Block_Encrypt/uAesKey/presente
add wave -noupdate /SAEAES_Block_Encrypt/uHash/presente
add wave -noupdate /SAEAES_Block_Encrypt/uAesEnc/presente
add wave -noupdate /SAEAES_Block_Encrypt/clk
add wave -noupdate /SAEAES_Block_Encrypt/uAesKey/En_out
add wave -noupdate /SAEAES_Block_Encrypt/uHash/En_out
add wave -noupdate /SAEAES_Block_Encrypt/uAesEnc/En_In
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Addr_Rd_eK
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Addr_Rd_S
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/Data_Out_eK
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/Data_Out_eK
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/Data_Out_S
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/Data_Out_eS

add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/witness_eSe
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/witness_eSe_0
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/witness_eSe_1
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/witness_eSe_2
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/witness_eSe_3
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/witness_eKe_0
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/witness_eKe_1
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/witness_eKe_2
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/witness_eKe_3
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/witness_eKe
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Block_Encrypt/uAesEnc/Addr_Rd_eK
run 7000
