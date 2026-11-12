vlog ./blake_rtl_input.v ./blake_rtl_output_comb.v ./blake_rtl_fsm.v ./blake_rtl_counter.v ./blake_rtl_msg_mux.v ./blake_rtl_state_mux.v ./blake_rtl_g_function.v ./blake_rtl.v ./blake_rtl_filpflop.v

vlog ./tb.v

vsim work.tb

do wave.do
run 10us	
