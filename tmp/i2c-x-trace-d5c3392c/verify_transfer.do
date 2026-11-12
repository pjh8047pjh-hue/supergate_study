onerror {quit -code 1 -force}
onbreak {quit -code 0 -force}
vlog ass_i2c_slave_serdes_fsm.v ass_i2c_slave_serdes.v trace_transfer.v
vsim -voptargs=+acc work.tb_rx work.trace_transfer
run 250 us
quit -code 0 -force
