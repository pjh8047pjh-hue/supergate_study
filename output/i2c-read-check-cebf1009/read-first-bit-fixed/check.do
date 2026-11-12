onerror {quit -code 1 -force}
onbreak {resume}
vsim -voptargs=+acc work.tb_rx
onfinish stop
run 1 ms
echo DEVICE_ADDRESS=[examine -radix hex sim:/tb_rx/dut/u_rx/u_ctrl/device_address]
echo MEMORY_0A=[examine -radix hex sim:/tb_rx/dut/u_rf/mem(10)]
quit -code 0 -force
