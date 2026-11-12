onerror {quit -code 1 -force}
onbreak {resume}
vsim -voptargs=+acc work.tb_rx
onfinish stop
run 1 ms
quit -code 0 -force
