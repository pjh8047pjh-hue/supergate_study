

vlib work
vmap work work

vlog -incr -novopt +incdir+../tb \
../rtl/ass_uart_slave.v \
../tb/uart_master.v \
../tb/uart_packet.v \
../tb/tb_ass_uart_slave.v

vsim -voptargs=+acc work.tb

vsim -novopt work.tb