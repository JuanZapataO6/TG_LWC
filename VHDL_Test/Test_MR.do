onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns Saturnin_Block_EncryptV2
add wave -noupdate /saturnin_block_encryptv2/clk
add wave -noupdate /saturnin_block_encryptv2/Enable_Generate
add wave -noupdate /saturnin_block_encryptv2/Enable_DF
add wave -noupdate /saturnin_block_encryptv2/Enable_XK
add wave -noupdate /saturnin_block_encryptv2/Enable_XKR
add wave -noupdate /saturnin_block_encryptv2/Enable_SB
add wave -noupdate /saturnin_block_encryptv2/Enable_MDS
add wave -noupdate /saturnin_block_encryptv2/Load_MR

add wave -noupdate /saturnin_block_encryptv2/Data_F/presente
add wave -noupdate /saturnin_block_encryptv2/UXorKey/presente
add wave -noupdate /saturnin_block_encryptv2/UXorKey_Rotated/presente
add wave -noupdate /saturnin_block_encryptv2/UMDS/presente
add wave -noupdate /saturnin_block_encryptv2/USBox/presente
add wave -noupdate /saturnin_block_encryptv2/USR_Slice/presente
add wave -noupdate /saturnin_block_encryptv2/USR_Slice_Inv/presente
add wave -noupdate /saturnin_block_encryptv2/USR_Sheet/presente
add wave -noupdate /saturnin_block_encryptv2/USR_Sheet_Inv/presente
add wave -noupdate /saturnin_block_encryptv2/uMake_Rounds/presenteX0
add wave -noupdate /saturnin_block_encryptv2/uMake_Rounds/presenteX1
add wave -noupdate /saturnin_block_encryptv2/presente



add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/R_x0
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/x0
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/Wr_REn_0
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/Wr_En_0

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/R_x1
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/x1
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/Wr_REn_1
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/Wr_En_1

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/Rn_0
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/Addr_Wr_0

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/Rn_1
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uMake_Rounds/Addr_Wr_1

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Control

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/R_MR
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/D_MR
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Rd_MR0
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Rd_MR1
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/RC0
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/RC1

add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encryptv2/uKey/r_memory
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encryptv2/uBuff/r_memory
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
run 120000
