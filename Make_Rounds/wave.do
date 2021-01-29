onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /saturnin_block_encrypt/presente
add wave -noupdate /saturnin_block_encrypt/presente_XOR
add wave -noupdate /saturnin_block_encrypt/clk
add wave -noupdate /saturnin_block_encrypt/Rd_En_DGK
add wave -noupdate /saturnin_block_encrypt/Rd_En_DGB
add wave -noupdate /saturnin_block_encrypt/Enable_Generate
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_In_DGK
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_In_DGB
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Addr_Rd_DGK
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Addr_Rd_DGB
add wave -noupdate /saturnin_block_encrypt/Wr_En_k
add wave -noupdate /saturnin_block_encrypt/Rd_En_k
add wave -noupdate /saturnin_block_encrypt/Rst_k
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Addr_Rd_k
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Addr_Wr_k
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_In_k
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_Out_Sk
add wave -noupdate /saturnin_block_encrypt/Wr_En_B
add wave -noupdate /saturnin_block_encrypt/Rd_En_B
add wave -noupdate /saturnin_block_encrypt/Rst_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Addr_Rd_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Addr_Wr_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_In_B
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/Data_Out_SB
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/state_Out
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/uKey/r_memory
add wave -noupdate -radix hexadecimal /saturnin_block_encrypt/uBuff/r_memory
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
configure wave -timelineunits ps
update
WaveRestoreZoom {1259 ns} {3027 ns}
