onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /data_generate/Rd_En_K
add wave -noupdate /data_generate/Rd_En_B
add wave -noupdate /data_generate/Ena_Out
add wave -noupdate /data_generate/Addr_Out_K
add wave -noupdate /data_generate/Addr_Out_B
add wave -noupdate /data_generate/Data_Out_K
add wave -noupdate /data_generate/Data_Out_B
add wave -noupdate /data_generate/presente
add wave -noupdate /data_generate/Data_In
add wave -noupdate /data_generate/Addr_In
add wave -noupdate /data_generate/Load
add wave -noupdate /data_generate/RSt
add wave -noupdate /data_generate/Wr_en_K
add wave -noupdate /data_generate/Wr_en_B
add wave -noupdate /data_generate/clk
add wave -noupdate -radix hexadecimal /data_generate/uKey/r_memory
add wave -noupdate -radix hexadecimal /data_generate/uBuf/r_memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {1 us}
