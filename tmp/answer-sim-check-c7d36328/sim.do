
if {![file isdirectory work]} {
    vlib work
}
vlog blake_64.v
vlog blake_64_1.v
vlog blake_64_1_msg_mux.v
vlog blake_64_1_state_mux.v
vlog blake_64_2.v
vlog blake_64_2_msg_mux.v
vlog blake_64_2_state_mux.v
vlog blake_64_g_func.v
vlog blake_rbit_0.v
vlog blake_rbit_2.v
vlog tb_blake_64.v

vsim -voptargs=+acc work.tb

add wave sim:/tb/clk sim:/tb/rstb sim:/tb/ena sim:/tb/rdy
add wave -radix hexadecimal sim:/tb/din sim:/tb/dout
run 10 us
wave zoom full
