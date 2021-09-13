onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /saturnin_tb/En_Ad
add wave -noupdate /saturnin_tb/Rd_En
add wave -noupdate /saturnin_tb/Addr_Rd
add wave -noupdate /saturnin_tb/Sel_O
add wave -noupdate /saturnin_tb/Data_Out_T
add wave -noupdate /saturnin_tb/Hex0
add wave -noupdate /saturnin_tb/Hex1
add wave -noupdate /saturnin_tb/Hex2
add wave -noupdate /saturnin_tb/Hex3
add wave -noupdate /saturnin_tb/Hex4
add wave -noupdate /saturnin_tb/Hex5
add wave -noupdate /saturnin_tb/Hex6
add wave -noupdate /saturnin_tb/Hex7
add wave -noupdate /saturnin_tb/En
add wave -noupdate /saturnin_tb/Addr_Rd_Ct
add wave -noupdate /saturnin_tb/Rd_En_Ct
add wave -noupdate /saturnin_tb/Data_Out_Ct
add wave -noupdate /saturnin_tb/presente
add wave -noupdate /saturnin_tb/RSTn
add wave -noupdate /saturnin_tb/SERIN
add wave -noupdate /saturnin_tb/Data_Out
add wave -noupdate /saturnin_tb/Clk
add wave -noupdate /saturnin_tb/u1/uxB/r_memory
add wave -noupdate /saturnin_tb/u1/uDS2P/En_Out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15507 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 206
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {36631 ns}
