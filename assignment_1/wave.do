onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb/dut/clk
add wave -noupdate -radix hexadecimal /tb/dut/rstb
add wave -noupdate -radix hexadecimal /tb/dut/ena
add wave -noupdate /tb/dut/cnt_done
add wave -noupdate /tb/dut/cnt_en
add wave -noupdate /tb/dut/done
add wave -noupdate -radix hexadecimal /tb/dut/rdy
add wave -noupdate -radix hexadecimal /tb/dut/din
add wave -noupdate -radix hexadecimal /tb/dut/dout
add wave -noupdate -radix hexadecimal /tb/dut/msg
add wave -noupdate -radix hexadecimal /tb/dut/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1585000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 246
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
WaveRestoreZoom {1554380 ps} {1807020 ps}
