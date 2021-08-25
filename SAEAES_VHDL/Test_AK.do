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
add wave -noupdate /SAEAES_Tb/u1/uAesKey/En_Out
add wave -noupdate  -color green -radix hexadecimal /SAEAES_Tb/u1/uAesKey/Data_in_K
add wave -noupdate  -color green -radix hexadecimal /SAEAES_Tb/u1/uAesKey/Addr_Rd_K
add wave -noupdate /SAEAES_Tb/u1/uAesKey/Rd_En_K
add wave -noupdate  -color blue -radix hexadecimal /SAEAES_Tb/u1/uAesKey/Data_In_eK
add wave -noupdate  -color blue -radix hexadecimal /SAEAES_Tb/u1/uAesKey/Addr_Wr_eK
add wave -noupdate /SAEAES_Tb/u1/uAesKey/Wr_En_eK

run 15000
