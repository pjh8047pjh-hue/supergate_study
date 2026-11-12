onerror {abort}
if {![file isdirectory work]} {vlib work}
vmap work work

vlog ../tb/i2c_master/i2c_master_bit_ctrl.v
vlog ../tb/i2c_master/i2c_master_byte_ctrl.v
vlog ../tb/i2c_master/i2c_master_top.v
vlog ../rtl/edge_detecter.v
vlog ../rtl/cdc_handshake_sync.v
vlog ../rtl/ass_i2c_slave_serdes_cdc.v
vlog ../rtl/ass_i2c_slave_serdes_fsm.v
vlog ../rtl/ass_i2c_slave_scl_counter.v
vlog ../rtl/ass_i2c_slave_serdes.v
vlog ../rtl/ass_i2c_slave_pkg_dec.v
vlog ../rtl/ass_i2c_slave_pkg_dec_fsm.v
vlog ../rtl/ass_i2c_slave_rf_v2.v
vlog ../rtl/ass_i2c_slave.v
vlog ../rtl/cdc_handshake_sync.v
vlog ../tb/tb_rx.v
vlog ../rtl/generic_dpram.v
vlog ../rtl/generic_fifo_dc.v

vsim -voptargs=+acc work.tb_rx

view wave
delete wave *
do wave.do

onfinish stop

run 1 ms
