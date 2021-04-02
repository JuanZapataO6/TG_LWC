onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns Saturnin_Block_EncryptV2
add wave -noupdate /saturnin_block_encryptv2/clk
add wave -noupdate /saturnin_block_encryptv2/Enable_Generate
add wave -noupdate /saturnin_block_encryptv2/Data_F/presente
add wave -noupdate /saturnin_block_encryptv2/Data_F/Wr_En_B
add wave -noupdate /saturnin_block_encryptv2/Data_F/Wr_En_k
add wave -noupdate /saturnin_block_encryptv2/presente
add wave -noupdate /saturnin_block_encryptv2/Wr_En_B
add wave -noupdate /saturnin_block_encryptv2/Wr_REn_B
add wave -noupdate /saturnin_block_encryptv2/Wr_En_k
add wave -noupdate /saturnin_block_encryptv2/Wr_REn_k
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_F/Data_RIn_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_F/Data_RIn_K
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_RIn_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_RIn_K
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_In_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_In_K
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uBuff/r_memory
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uKey/r_memory
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Control
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2145 ns} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ps
update
WaveRestoreZoom {1510 ns} {2356 ns}
run 5000
