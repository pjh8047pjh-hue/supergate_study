vlog -work work ./blake_64*.v ./blake_rbit*.v ./tb_blake_64.v

vlog ./tb_blake_64.v

vsim work.tb

do wave.do
run 10us