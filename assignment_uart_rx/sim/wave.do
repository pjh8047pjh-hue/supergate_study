onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/clk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/rstb
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/ser_in
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/rx_full
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/tx_empty
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/tx_rdata
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/baud_freq
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/baud_limit
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/ser_out
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/tx_ren
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/rx_wen
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/rx_wdata
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/ser_fall
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/ser_rise
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/ser_sync
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/rx_sampling
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/rx_start
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/rx_busy
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/rx_bclk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/rx_data_en
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/tx_start
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/tx_busy
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/tx_bclk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/tx_cnt_bit
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/tx_update
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/tx_data_en
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_rx/clk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_rx/rstb
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_rx/ser_rise
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_rx/ser_fall
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_rx/rx_full
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_rx/data_en
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_rx/start
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_rx/rx_busy
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_rx/cstate
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_rx/nstate
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_rx/clk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_rx/rstb
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_rx/start
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_rx/bclk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_rx/data_en
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_rx/tx_update
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_rx/sampling
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_rx/cnt_bit
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_rx/cnt_bclk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_rx/sample_tick
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_s2p/clk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_s2p/rstb
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_s2p/sampling
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_s2p/serial_in
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_s2p/data_en
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_s2p/parallel_out
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_s2p/shift_reg
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_tx/clk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_tx/rstb
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_tx/data_en
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_tx/tx_empty
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_tx/start
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_tx/tx_busy
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_tx/cstate
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_fsm_tx/nstate
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_tx/clk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_tx/rstb
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_tx/start
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_tx/bclk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_tx/data_en
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_tx/tx_update
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_tx/sampling
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_tx/cnt_bit
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_tx/cnt_bclk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_couter_tx/sample_tick
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_p2s/clk
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_p2s/rstb
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_p2s/start
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_p2s/parallel_in
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_p2s/cnt_bit
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_p2s/data_en
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_p2s/tx_update
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_p2s/serial_out
add wave -noupdate -radix hexadecimal /tb/dut/u_serdes/u_shift_reg_p2s/output_reg
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/clk
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/rstb
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/rx_empty
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/tx_full
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/mode
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/addr_match
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/length
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/we
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/addr_inc
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/rx_ren
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/rx_ren_d
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/tx_wen
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/init_cmd
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/init_addr
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/init_length
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/nstate
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/cstate
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/cnt_rx
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/tx_wen_pre
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_fsm/tx_wen_d
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/clk
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/rstb
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/rx_rdata
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/addr_inc
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/rx_ren_d
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/rdata
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/we
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/init_cmd
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/init_addr
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/init_length
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/mode
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/addr
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/length
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/wdata
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/tx_wdata
add wave -noupdate -radix hexadecimal /tb/dut/u_pkg_dec/u_pkg_dec_reg/cmd
add wave -noupdate -radix hexadecimal /tb/dut/u_rf/clk
add wave -noupdate -radix hexadecimal /tb/dut/u_rf/addr
add wave -noupdate -radix hexadecimal /tb/dut/u_rf/wdata
add wave -noupdate -radix hexadecimal /tb/dut/u_rf/we
add wave -noupdate -radix hexadecimal /tb/dut/u_rf/rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4313893016 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 393
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
WaveRestoreZoom {0 ps} {5250 us}
