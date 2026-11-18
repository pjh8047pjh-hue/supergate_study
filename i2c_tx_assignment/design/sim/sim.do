
vlib work
vmap work work
vlog ../rtl/i2c_master_top.v
vlog ../tb/i2c_slave_model.v
vlog ../tb/tb_tx.v
vsim -novopt work.tb_tx

add wave -position insertpoint sim:/tb_tx/*
run 1 ms
