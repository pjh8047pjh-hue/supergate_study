onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/dut/clk
add wave -noupdate /tb/dut/rstb
add wave -noupdate /tb/dut/ena
add wave -noupdate -radix hexadecimal /tb/dut/din
add wave -noupdate /tb/dut/rdy
add wave -noupdate -radix symbolic /tb/dut/u_blake_64_fsm/cstate
add wave -noupdate -radix symbolic /tb/dut/u_blake_64_fsm/nstate
add wave -noupdate -radix hexadecimal /tb/dut/dout
add wave -noupdate -radix unsigned /tb/dut/counter_g0
add wave -noupdate -radix unsigned /tb/dut/counter_g1
add wave -noupdate /tb/dut/init_g0
add wave -noupdate /tb/dut/init_g1
add wave -noupdate /tb/dut/cnt_en_g0
add wave -noupdate /tb/dut/cnt_en_g1
add wave -noupdate /tb/dut/done_g0
add wave -noupdate /tb/dut/done_g1
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_64_output_comb/dout
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_rbit_2_state_1/dout
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_rbit_2_state_0/dout
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_rbit_1_msg_0/dout
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_rbit_1_msg_1/dout
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_64_g_function_0/m0
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_64_g_function_0/m1
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_64_g_function_0/c0
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_64_g_function_0/c1
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_64_g_function_0/a
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_64_g_function_0/b
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_64_g_function_0/c
add wave -noupdate -radix hexadecimal /tb/dut/u_blake_64_g_function_0/d
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1294950 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 396
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
WaveRestoreZoom {9925390 ps} {10003930 ps}
