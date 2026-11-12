onerror {quit -code 1 -force}
onbreak {quit -code 0 -force}
vlib work
vmap work work
vlog i2c_master_bit_ctrl.v i2c_master_byte_ctrl.v i2c_master_top.v edge_detecter.v ass_i2c_slave_serdes_fsm.v ass_i2c_slave_scl_counter.v ass_i2c_slave_serdes.v ass_i2c_slave_pkg_dec.v ass_i2c_slave_pkg_dec_fsm.v ass_i2c_slave_rf_v2.v ass_i2c_slave.v tb_rx.v generic_dpram.v generic_fifo_dc.v two_level_synchronizer.v trace_x.v
vsim -voptargs=+acc work.tb_rx work.trace_x
run 1 ms
quit -code 0 -force
