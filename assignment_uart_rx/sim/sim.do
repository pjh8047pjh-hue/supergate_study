onerror {abort}

if {![file isdirectory work]} {vlib work}
vmap work work

# Run from sim/ and compile the current rtl_2 sources only.
vlog -incr +incdir+../tb \
    ../rtl_2/generic_dpram.v \
    ../rtl_2/generic_fifo_dc.v \
    ../rtl_2/uart_edge_detecter.v \
    ../rtl_2/ass_uart_serdes_baud_gen.v \
    ../rtl_2/ass_uart_serdes_counter.v \
    ../rtl_2/ass_uart_serdes_fsm_rx.v \
    ../rtl_2/ass_uart_serdes_fsm_tx.v \
    ../rtl_2/ass_uart_serdes_shift_reg_s2p.v \
    ../rtl_2/ass_uart_serdes_shift_reg_p2s.v \
    ../rtl_2/ass_uart_serdes.v \
    ../rtl_2/ass_uart_pkg_dec_fsm.v \
    ../rtl_2/ass_uart_pkg_dec_reg.v \
    ../rtl_2/ass_uart_pkg_dec.v \
    ../rtl_2/ass_uart_slave_rf_v2.v \
    ../rtl_2/ass_uart_slave.v \
    ../tb/uart_master.v \
    ../tb/uart_packet.v \
    ../tb/tb_ass_uart_slave.v

vsim -voptargs=+acc work.tb

do wave.do

run 5 ms
