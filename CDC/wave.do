onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/rstb
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/clk1
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/clk2
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/req
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/ack
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/rdy
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/dout
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/data
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/u_cdc_tx/inc
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/u_cdc_tx/state
add wave -noupdate /tb_cdc_top/dut/u_cdc_tx/ena
add wave -noupdate /tb_cdc_top/dut/u_cdc_rx/rdy
add wave -noupdate /tb_cdc_top/dut/u_cdc_rx/req_d2
add wave -noupdate /tb_cdc_top/dut/u_cdc_rx/rdy_d2
add wave -noupdate -radix hexadecimal /tb_cdc_top/dut/u_cdc_tx/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95447830 ps} 0} {{Cursor 2} {5825000 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 284
configure wave -valuecolwidth 40
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
WaveRestoreZoom {5417510 ps} {5878870 ps}
