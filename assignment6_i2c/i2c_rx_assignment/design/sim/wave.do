onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_rx/dut/clk_1
add wave -noupdate -radix hexadecimal /tb_rx/dut/clk_2
add wave -noupdate -radix hexadecimal /tb_rx/dut/rstb
add wave -noupdate -radix hexadecimal /tb_rx/dut/scl
add wave -noupdate -radix hexadecimal /tb_rx/dut/sda
add wave -noupdate -radix hexadecimal /tb_rx/dut/sda_oe
add wave -noupdate -radix hexadecimal /tb_rx/dut/start
add wave -noupdate -radix hexadecimal /tb_rx/dut/stop
add wave -noupdate -radix hexadecimal /tb_rx/dut/stop_nack
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_wen
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_full
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_wdata
add wave -noupdate -color Plum -radix hexadecimal /tb_rx/dut/tx_ren
add wave -noupdate -color Plum -radix hexadecimal /tb_rx/dut/tx_empty
add wave -noupdate -color Plum -radix hexadecimal /tb_rx/dut/tx_rdata
add wave -noupdate -color Plum -radix hexadecimal /tb_rx/dut/u_pkg_dec/tx_wdata
add wave -noupdate -color Plum -radix hexadecimal /tb_rx/dut/req
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_ren
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/rx_rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/tx_wen
add wave -noupdate -radix hexadecimal /tb_rx/dut/tx_full
add wave -noupdate -radix hexadecimal /tb_rx/dut/tx_wdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/we
add wave -noupdate -radix hexadecimal /tb_rx/dut/addr
add wave -noupdate -radix hexadecimal /tb_rx/dut/rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/rstb
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/scl
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/sda
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/rx_full
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/tx_empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/tx_wen
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/tx_ren
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/tx_rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/tx_rdata_in
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/start
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/stop
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/stop_nack
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/sda_oe
add wave -noupdate /tb_rx/dut/u_serdes/u_serdes_fsm/addr_match
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/u_serdes_fsm/cstate
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/scl_rise
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/scl_fall
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/sda_rise
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/sda_fall
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/sda_d2
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/scl_d2
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/rx_en
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/tx_rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/init_0
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/cnt_inc
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/cnt_max
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_serdes/cnt_scl
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/rstb
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/req
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/start
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/stop_nack
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/rx_empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/rx_rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/rdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/tx_wen
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/rx_ren
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/addr
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/tx_wdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/we
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/req_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/start_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/stop_sync
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/addr_inc
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/waddr_en
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/tx_full
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rf/clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rf/addr
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rf/wdata
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rf/we
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rf/rdata
add wave -noupdate -radix hexadecimal -childformat {{{/tb_rx/dut/u_rf/mem[0]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[1]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[2]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[3]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[4]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[5]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[6]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[7]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[8]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[9]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[10]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[11]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[12]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[13]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[14]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[15]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[16]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[17]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[18]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[19]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[20]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[21]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[22]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[23]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[24]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[25]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[26]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[27]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[28]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[29]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[30]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[31]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[32]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[33]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[34]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[35]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[36]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[37]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[38]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[39]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[40]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[41]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[42]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[43]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[44]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[45]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[46]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[47]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[48]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[49]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[50]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[51]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[52]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[53]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[54]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[55]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[56]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[57]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[58]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[59]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[60]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[61]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[62]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[63]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[64]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[65]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[66]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[67]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[68]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[69]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[70]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[71]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[72]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[73]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[74]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[75]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[76]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[77]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[78]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[79]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[80]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[81]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[82]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[83]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[84]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[85]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[86]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[87]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[88]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[89]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[90]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[91]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[92]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[93]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[94]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[95]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[96]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[97]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[98]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[99]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[100]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[101]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[102]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[103]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[104]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[105]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[106]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[107]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[108]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[109]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[110]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[111]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[112]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[113]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[114]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[115]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[116]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[117]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[118]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[119]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[120]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[121]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[122]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[123]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[124]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[125]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[126]} -radix hexadecimal} {{/tb_rx/dut/u_rf/mem[127]} -radix hexadecimal}} -subitemconfig {{/tb_rx/dut/u_rf/mem[0]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[1]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[2]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[3]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[4]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[5]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[6]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[7]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[8]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[9]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[10]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[11]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[12]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[13]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[14]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[15]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[16]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[17]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[18]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[19]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[20]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[21]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[22]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[23]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[24]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[25]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[26]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[27]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[28]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[29]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[30]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[31]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[32]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[33]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[34]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[35]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[36]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[37]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[38]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[39]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[40]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[41]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[42]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[43]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[44]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[45]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[46]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[47]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[48]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[49]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[50]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[51]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[52]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[53]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[54]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[55]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[56]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[57]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[58]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[59]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[60]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[61]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[62]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[63]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[64]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[65]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[66]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[67]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[68]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[69]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[70]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[71]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[72]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[73]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[74]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[75]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[76]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[77]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[78]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[79]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[80]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[81]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[82]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[83]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[84]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[85]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[86]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[87]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[88]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[89]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[90]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[91]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[92]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[93]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[94]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[95]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[96]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[97]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[98]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[99]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[100]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[101]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[102]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[103]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[104]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[105]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[106]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[107]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[108]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[109]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[110]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[111]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[112]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[113]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[114]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[115]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[116]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[117]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[118]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[119]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[120]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[121]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[122]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[123]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[124]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[125]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[126]} {-height 21 -radix hexadecimal} {/tb_rx/dut/u_rf/mem[127]} {-height 21 -radix hexadecimal}} /tb_rx/dut/u_rf/mem
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_pkg_dec/u_pkg_fsm/cstate
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/din
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/we
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/dout
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/re
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/full
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_rx_fifo/empty
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/wr_clk
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/din
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/we
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/dout
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/full
add wave -noupdate -radix hexadecimal /tb_rx/dut/u_tx_fifo/empty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {108575000 ps} 0}
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
WaveRestoreZoom {46767836 ps} {176543789 ps}
