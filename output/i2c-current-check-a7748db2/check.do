onerror {quit -code 1 -force}
onbreak {resume}
vsim -voptargs=+acc work.tb_rx
onfinish stop
run 1 ms
foreach {address expected} {10 f5 11 fb 12 77 13 88 2 55 3 aa 5 66 6 bb} {
    set actual [examine -radix hex sim:/tb_rx/dut/u_rf/mem($address)]
    if {![string equal -nocase $actual $expected]} {
        echo MEMORY_FAIL:$address:$actual
        quit -code 1 -force
    }
}
echo MEMORY_PASS
echo WRITE_HOLD_CHECKS=[examine -radix unsigned sim:/tb_rx/write_hold_checks]
quit -code 0 -force
