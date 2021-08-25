onerror {resume}
quietly WaveActivateNextPane {} 0
vsim -t ns SAEAES_Tb

add wave -noupdate /SAEAES_Tb/u1/presente
add wave -noupdate /SAEAES_Tb/u1/uAesKey/presente
add wave -noupdate /SAEAES_Tb/u1/uHash/presente
add wave -noupdate /SAEAES_Tb/u1/uAesEnc/presente
add wave -noupdate /SAEAES_Tb/u1/clk
add wave -noupdate -color yellow -radix hexadecimal /SAEAES_Tb/u1/Addr_Control
add wave -noupdate -color yellow -radix hexadecimal /SAEAES_Tb/u1/ueSe/r_memory
add wave -noupdate /SAEAES_Tb/u1/uAesKey/En_In
add wave -noupdate /SAEAES_Tb/u1/uAesKey/En_out
add wave -noupdate /SAEAES_Tb/u1/uHash/En_In
add wave -noupdate /SAEAES_Tb/u1/uHash/En_out
add wave -noupdate /SAEAES_Tb/u1/uAesEnc/En_In
add wave -noupdate /SAEAES_Tb/u1/uAesEnc/En_out



run 35000
