onerror {abort}
if {![file isdirectory work]} {vlib work}
vmap work work

vlog ../tb/i2c_master/i2c_master_bit_ctrl.v
vlog ../tb/i2c_master/i2c_master_byte_ctrl.v
vlog ../tb/i2c_master/i2c_master_top.v
vlog ../rtl/edge_detecter.v
vlog ../rtl/ass_i2c_slave_serdes_fsm.v
vlog ../rtl/ass_i2c_slave_scl_counter.v
vlog ../rtl/ass_i2c_slave_serdes.v
vlog ../rtl/ass_i2c_slave_pkg_dec.v
vlog ../rtl/ass_i2c_slave_pkg_dec_fsm.v
vlog ../rtl/ass_i2c_slave_rf_v2.v
vlog ../rtl/ass_i2c_slave.v
vlog ../tb/hojunjung_tv_tb_rx.v
vlog ../rtl/generic_dpram.v
vlog ../rtl/generic_fifo_dc.v
vlog ../rtl/two_level_synchronizer.v

vsim -voptargs=+acc work.tb_rx

view wave
delete wave *
do wave.do

onfinish stop

run 1 ms
