onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns Saturnin_Tb
add wave -noupdate /saturnin_tb/Clk
add wave -noupdate /saturnin_tb/Addr_Rd
add wave -noupdate /saturnin_tb/Rd_En
add wave -noupdate /saturnin_tb/Data_Out_T
add wave -noupdate /saturnin_tb/presente
add wave -noupdate /saturnin_tb/u1/uDF/presente
add wave -noupdate /saturnin_tb/u1/uDF/Data_rIn_xK
add wave -noupdate /saturnin_tb/u1/uDF/Data_rIn_xB
add wave -noupdate /saturnin_tb/u1/uXorKey/presente
add wave -noupdate -radix hexadecimal /saturnin_tb/u1/uxB/r_memory
add wave -noupdate -radix hexadecimal /saturnin_tb/u1/uxK/r_memory
add wave -noupdate /saturnin_tb/SERIN
add wave -noupdate -radix hexadecimal /saturnin_tb/u1/uS2P/DOUT
add wave -noupdate /saturnin_tb/u1/uS2P/DRDY
add wave -noupdate /saturnin_tb/u1/Sel
add wave -noupdate /saturnin_tb/u1/En_DF
add wave -noupdate /saturnin_tb/u1/En_DG
add wave -noupdate /saturnin_tb/u1/uDS2P/En_Out
add wave -noupdate /saturnin_tb/u1/En_S2P
add wave -noupdate /saturnin_tb/u1/uDF/presente
add wave -noupdate /saturnin_tb/u1/uDF/En_In
add wave -noupdate -radix hexadecimal /saturnin_tb/u1/uDF/Data_rIn_xK
add wave -noupdate -radix hexadecimal /saturnin_tb/u1/UDS2P/Data_In
add wave -noupdate /saturnin_tb/u1/UDS2P/presente
add wave -noupdate /saturnin_tb/u1/UDS2P/En_In
add wave -noupdate -radix hexadecimal /saturnin_tb/u1/UDS2P/uReg_Data/r_memory
force -freeze sim:/saturnin_tb/Rd_En 0 0
force -freeze sim:/saturnin_tb/Addr_Rd 1111 0
run 8000
force -freeze sim:/saturnin_tb/Rd_En 0 0
force -freeze sim:/saturnin_tb/Addr_Rd 1110 0
run 700
force -freeze sim:/saturnin_tb/Rd_En 0 0
force -freeze sim:/saturnin_tb/Addr_Rd 1101 0
run 700
force -freeze sim:/saturnin_tb/Rd_En 0 0
force -freeze sim:/saturnin_tb/Addr_Rd 1100 0
run 700