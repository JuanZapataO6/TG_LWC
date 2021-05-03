onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns Saturnin_Block_EncryptV2
add wave -noupdate /saturnin_block_encryptv2/clk
add wave -noupdate /saturnin_block_encryptv2/presente
add wave -noupdate /saturnin_block_encryptv2/Enable_Generate
add wave -noupdate /saturnin_block_encryptv2/Enable_DF
add wave -noupdate /saturnin_block_encryptv2/Enable_XK
add wave -noupdate /saturnin_block_encryptv2/Enable_SB
add wave -noupdate /saturnin_block_encryptv2/Enable_MDS
add wave -noupdate /saturnin_block_encryptv2/Data_F/presente
add wave -noupdate /saturnin_block_encryptv2/UXorKey/presente
add wave -noupdate /saturnin_block_encryptv2/USBox/presente
add wave -noupdate /saturnin_block_encryptv2/UMDS/presente
add wave -noupdate /saturnin_block_encryptv2/USR_Slice/presente
add wave -noupdate /saturnin_block_encryptv2/uMake_Rounds/presenteX0
add wave -noupdate /saturnin_block_encryptv2/uMake_Rounds/presenteX1

add wave -noupdate /saturnin_block_encryptv2/uMake_Rounds/X0
add wave -noupdate /saturnin_block_encryptv2/uMake_Rounds/x1

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/n_0
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/n_1
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Control

add wave -noupdate /saturnin_block_encryptv2/Rd_En_SRSB
add wave -noupdate /saturnin_block_encryptv2/Load
add wave -noupdate /saturnin_block_encryptv2/R
add wave -noupdate /saturnin_block_encryptv2/D

add wave -noupdate /saturnin_block_encryptv2/UMDS/En_In
add wave -noupdate /saturnin_block_encryptv2/USBox/En_In

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_Out_SB
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_Out_Sk
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_Out_SRSB
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_Out_MDSB

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Rd_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_RRd_B
add wave -noupdate /saturnin_block_encryptv2/Rd_En_B
add wave -noupdate /saturnin_block_encryptv2/Rd_REn_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_RWr_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Wr_B
add wave -noupdate /saturnin_block_encryptv2/Wr_REn_B
add wave -noupdate /saturnin_block_encryptv2/Wr_En_B

add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/Data_Out_SBB
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/USBox/Data_RIn_B

add wave -noupdate -format Literal -color brown -radix hexadecimal /saturnin_block_encryptv2/USBox/Addr_Rd_B

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_RIn_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_In_B

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uBuff/r_memory
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/u_R0/r_memory
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/u_R1/r_memory
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
run 12000
