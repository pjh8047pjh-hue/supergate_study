vlib work
vmap work work
set failed 0
if {[catch {vlog {module one_bit_cdc.v}} result]} {set failed 1}
if {[catch {vlog ass_i2c_slave_serdes.v} result]} {set failed 1}
quit -code $failed -force
