onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns SAEAES_Tb

add wave -noupdate /SAEAES_Tb/RSTn
add wave -noupdate /SAEAES_Tb/clk
add wave -noupdate /SAEAES_Tb/presente
add wave -noupdate /SAEAES_Tb/SERIN
add wave -noupdate -color green -radix hexadecimal /SAEAES_Tb/u1/uDF/uReg_Data/r_memory
add wave -noupdate -color green -radix hexadecimal /SAEAES_Tb/u1/ueKey/r_memory

add wave -noupdate /SAEAES_Tb/u1/uAesKey/presente
add wave -noupdate /SAEAES_Tb/u1/uAesKey/En_In
add wave -noupdate /SAEAES_Tb/u1/En_DG

add wave -noupdate /SAEAES_Tb/u1/uHash/presente
add wave -noupdate /SAEAES_Tb/u1/uHash/Wr_En_S
add wave -noupdate /SAEAES_Tb/u1/uHash/Rst_S
add wave -noupdate /SAEAES_Tb/u1/uHash/En_In
add wave -noupdate /SAEAES_Tb/u1/uHash/En_Out
add wave -noupdate /SAEAES_Tb/u1/uHash/En_Out_1
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/eS_AddrWr_Hash
add wave -noupdate -format Literal -color brown -radix hexadecimal /SAEAES_Tb/u1/uHash/Addr_Wr_S
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/eS_AddrWr_Hash


add wave -noupdate -color yellow /SAEAES_Tb/u1/uHash/Rd_En_eS
add wave -noupdate -color blue /SAEAES_Tb/u1/es_Rd_Hash
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uHash/Addr_Rd_eS
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/eS_AddrRd_Hash
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uHash/Data_Out_eS
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/DataOut_eS_Hash

add wave -noupdate -color yellow /SAEAES_Tb/u1/uHash/Rd_En_Ad
add wave -noupdate -color blue /SAEAES_Tb/u1/Rd_En_Ad
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uHash/Addr_Rd_Ad
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/Addr_Rd_Ad
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uHash/Data_Out_Ad
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/Data_Out_Ad

add wave -noupdate -color yellow /SAEAES_Tb/u1/uHash/Wr_En_eS
add wave -noupdate -color blue /SAEAES_Tb/u1/Es_Wr_AE
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uHash/Addr_Wr_eS
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/eS_AddrWr_Ae
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uHash/Data_In_S
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/DataIn_eS_Hash

add wave -noupdate /SAEAES_Tb/u1/uAesEnc/presente
add wave -noupdate /SAEAES_Tb/u1/uAesEnc/En_In
add wave -noupdate /SAEAES_Tb/u1/uAesEnc/En_Out
add wave -noupdate -color yellow /SAEAES_Tb/u1/uAesEnc/Wr_En_eS
add wave -noupdate -color blue /SAEAES_Tb/u1/Es_Wr_AE
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/Addr_Wr_eS
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/eS_AddrWr_Ae
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/Data_In_eS
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/DataIn_eS_AE

add wave -noupdate -color yellow /SAEAES_Tb/u1/uAesEnc/Rd_En_eS
add wave -noupdate -color blue /SAEAES_Tb/u1/es_Rd_AE
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/Addr_Rd_eS
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/eS_AddrRd_Ae
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/Data_Out_eS
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/DataOut_eS_AE

add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/witness_eKe
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/witness_eKe_0
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/witness_eKe_1
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/witness_eKe_2
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/witness_eke_3

add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/witness_eSe
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/witness_eSe_0
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/witness_eSe_1
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/witness_eSe_2
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/witness_eSe_3

add wave -noupdate -color yellow /SAEAES_Tb/u1/uAesEnc/Rd_En_eK
add wave -noupdate -color blue /SAEAES_Tb/u1/Rd_En_eK
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/Addr_Rd_eK
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/Addr_Rd_eK
add wave -noupdate -format Literal -color yellow -radix hexadecimal /SAEAES_Tb/u1/uAesEnc/Data_Out_eK
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/Data_rOut_eK

add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/ueSe/r_memory
add wave -noupdate -format Literal -color blue -radix hexadecimal /SAEAES_Tb/u1/uCt/r_memory

run 50000
