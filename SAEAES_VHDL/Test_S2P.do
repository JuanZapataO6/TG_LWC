onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns S2P_Tb

add wave -noupdate /S2P_Tb/RSTn
add wave -noupdate /S2P_Tb/clk
add wave -noupdate /S2P_Tb/presente
add wave -noupdate /S2P_Tb/u1/DOUT
add wave -noupdate /S2P_Tb/DOUT

add wave -noupdate /S2P_Tb/u1/RSTn
add wave -noupdate /S2P_Tb/u1/CLOCK
add wave -noupdate /S2P_Tb/u1/SERIN
add wave -noupdate /S2P_Tb/u1/PERRn
add wave -noupdate /S2P_Tb/u1/DRDY
add wave -noupdate /S2P_Tb/u1/DOUT
add wave -noupdate /S2P_Tb/DOUT
add wave -noupdate /S2P_Tb/u2/presente
add wave -noupdate /S2P_Tb/u2/en_rIn
add wave -noupdate /S2P_Tb/u2/Addr_Wr
add wave -noupdate /S2P_Tb/u2/Wr_En
add wave -noupdate /S2P_Tb/u2/rWr_En
add wave -noupdate /S2P_Tb/u2/En_Out
add wave -noupdate -color brown -radix hexadecimal /S2P_Tb/u2/Data_In
add wave -noupdate -color yellow -radix hexadecimal /S2P_Tb/u2/Data_rIn
add wave -noupdate -color yellow -radix hexadecimal /S2P_Tb/u2/uReg_Data/r_memory

run 9250
