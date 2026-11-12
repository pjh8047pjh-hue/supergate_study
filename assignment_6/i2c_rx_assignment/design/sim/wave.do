onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_rx/dut/clk_1
add wave -noupdate -radix hexadecimal /tb_rx/dut/clk_2
add wave -noupdate -radix hexadecimal /tb_rx/dut/rstb
add wave -noupdate -radix hexadecimal /tb_rx/dut/scl
add wave -noupdate -radix hexadecimal /tb_rx/dut/sda
add wave -noupdate -radix hexadecimal /tb_rx/dut/sda_oe
add wave -noupdate -radix hexadecimal /tb_rx/dut/start_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/stop_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/req
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_wen
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_full
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_wdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/tx_ren
add wave -noupdate -radix hexadecimal /tb_rx/dut/tx_empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/tx_rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/ack_out_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/ack_out_start
add wave -noupdate -radix hexadecimal /tb_rx/dut/ack_out_stop
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_ren
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/tx_wen
add wave -noupdate -radix hexadecimal /tb_rx/dut/tx_full
add wave -noupdate -radix hexadecimal /tb_rx/dut/tx_wdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/we
add wave -noupdate -radix hexadecimal /tb_rx/dut/addr
add wave -noupdate -radix hexadecimal /tb_rx/dut/rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/wdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/rstb
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/scl
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/sda
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/rx_full
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/tx_empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/tx_rdata_in
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/ack_out_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/ack_out_start
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/ack_out_stop
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/start_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/stop_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/rx_wen
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/rx_wdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/tx_ren
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/sda_oe
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/scl_rise
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/stop
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/scl_fall
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/sda_rise
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/sda_fall
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/sda_d2
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/scl_d2
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/start
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/rx_en
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/tx_rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/init_0
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/cnt_inc
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/cnt_max
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/cnt_scl
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/ack_req_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/ack_start_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/ack_stop_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_cdc/clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_cdc/rstb
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_cdc/ack_out_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_cdc/ack_out_start
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_cdc/ack_out_stop
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_cdc/ack_req_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_cdc/ack_start_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_cdc/ack_stop_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/rstb
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/start
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/stop
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/scl_rise
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/scl_fall
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/ack_bit
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/cnt_scl
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/rx_full
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/rx_wdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/tx_empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/tx_rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/ack_req_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/ack_start_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/ack_stop_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/init_0
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/cnt_inc
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/cnt_max
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/rx_en
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/rx_wen
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/tx_ren
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/start_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/stop_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/sda_oe
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/cstate
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/nstate
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/addr_match
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/mode
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/update_en
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/stop_nack
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/cnt_en
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/cnt_scl_bit
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/rd_clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/wr_clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/rst
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/din
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/we
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/dout
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/re
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/full
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/full_n
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/empty_n
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/re_r
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/we_r
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/rd_clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/wr_clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/rst
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/clr
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/din
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/we
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/dout
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/re
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/full
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/full_n
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/empty_n
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/re_r
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/we_r
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/rstb
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/start_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/ack_out_start
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/stop_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/ack_out_stop
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/ack_out_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/rx_empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/tx_full
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/rx_rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/ack_out_req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/ack_out_start
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/ack_out_stop
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/rx_ren
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/tx_wen
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/we
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/addr
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/tx_wdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/wdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/req_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/start_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/stop_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/addr_inc
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/waddr_en
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/rstb
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/start
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/stop_nack
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/rx_empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/tx_full
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/rx_ren
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/tx_wen
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/waddr_en
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/addr_inc
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/we
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/cstate
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/nstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {135285000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 406
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
WaveRestoreZoom {133760151 ps} {136577261 ps}
