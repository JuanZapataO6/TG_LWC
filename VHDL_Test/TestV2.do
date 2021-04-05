onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns Saturnin_Block_EncryptV2
add wave -noupdate /saturnin_block_encryptv2/clk
add wave -noupdate /saturnin_block_encryptv2/Enable_Generate
add wave -noupdate /saturnin_block_encryptv2/Enable_DF
add wave -noupdate /saturnin_block_encryptv2/Enable_XK
add wave -noupdate /saturnin_block_encryptv2/Enable_SB
add wave -noupdate /saturnin_block_encryptv2/Data_F/presente
add wave -noupdate /saturnin_block_encryptv2/UXorKey/presente
add wave -noupdate /saturnin_block_encryptv2/USBox/presente


add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Rd_XKK
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_RRd_K
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Rd_K
add wave -noupdate /saturnin_block_encryptv2/Rd_REn_K
add wave -noupdate /saturnin_block_encryptv2/Rd_En_K

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Rd_XKB
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_RRd_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Rd_B
add wave -noupdate /saturnin_block_encryptv2/Rd_REn_B
add wave -noupdate /saturnin_block_encryptv2/Rd_En_B

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_Out_SB
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_Out_Sk

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_Out_XKB
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_Out_XKK

add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/Data_Out_SBB
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/USBox/Data_RIn_B
add wave -noupdate -format Literal -color blue -radix hexadecimal /saturnin_block_encryptv2/USBox/Data_Out_B
add wave -noupdate -format Literal -color brown -radix hexadecimal /saturnin_block_encryptv2/USBox/Establish
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/USBox/A0
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/USBox/B0
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/USBox/C0
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/USBox/D0
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/USBox/A1
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/USBox/B1
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/USBox/C1
add wave -noupdate -format Literal -color yellow -radix hexadecimal /saturnin_block_encryptv2/USBox/D1
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_RIn_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_In_B

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Data_In_XKB
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Wr_XKB
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_RWr_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Addr_Wr_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Wr_REn_B
add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/Wr_En_B

add wave -noupdate -radix hexadecimal /saturnin_block_encryptv2/uBuff/r_memory

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
run 10000
