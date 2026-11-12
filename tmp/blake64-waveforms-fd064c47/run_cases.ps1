$ErrorActionPreference = 'Stop'
$taskDir = 'C:\Work\tmp\blake64-waveforms-fd064c47'
$sourceDir = 'C:\Work\assignment_3'
$tbText = [System.IO.File]::ReadAllText((Join-Path $sourceDir 'tb_blake_64.v'))
$monitorTemplate = @'
`timescale 1ns/10ps
module waveform_check;
    tb t();
    integer fd;
    integer half;
    integer results = 0;
    integer errors = 0;
    integer loads0 = 0;
    integer loads1 = 0;
    integer steps0 = 0;
    integer steps1 = 0;

    always @(posedge t.clk) begin
        if (!t.rstb) begin
            steps0 = 0;
            steps1 = 0;
        end
        else begin
            if (t.dut.init_g0) begin
                loads0 = loads0 + 1;
                steps0 = 0;
            end
            else if (t.dut.cnt_en_g0)
                steps0 = steps0 + 1;
            if (t.dut.init_g1) begin
                loads1 = loads1 + 1;
                steps1 = 0;
            end
            else if (t.dut.cnt_en_g1)
                steps1 = steps1 + 1;
        end
    end

    always @(posedge t.rdy) begin
        #1;
        if (results >= 3)
            errors = errors + 1;
        else if (t.dout !== t.ref[results]) begin
            errors = errors + 1;
            $display("VERIFY gap=__GAP__ hash=%0d FAIL", results);
        end
        else
            $display("VERIFY gap=__GAP__ hash=%0d PASS at %0t", results, $time);
        results = results + 1;
    end

    initial begin
        fd = $fopen("trace.csv", "w");
        $fdisplay(fd, "half,clk,rstb,ena,cstate,counter_g0,counter_g1,init_g0,init_g1,cnt_en_g0,cnt_en_g1,done_g0,done_g1,rdy,steps0,steps1,din,msg_g0,msg_g1,state_0,state_1,dout,v0");
        #(__FIRST__ - 10);
        for (half = -2; half <= 522; half = half + 1) begin
            #0.10;
            $fdisplay(fd, "%0d,%b,%b,%b,%0d,%0d,%0d,%b,%b,%b,%b,%b,%b,%b,%0d,%0d,%h,%h,%h,%h,%h,%h,%h",
                half, t.clk, t.rstb, t.ena, t.dut.u_blake_64_fsm.cstate,
                t.dut.counter_g0, t.dut.counter_g1, t.dut.init_g0, t.dut.init_g1,
                t.dut.cnt_en_g0, t.dut.cnt_en_g1, t.dut.done_g0, t.dut.done_g1,
                t.rdy, steps0, steps1, t.din, t.dut.msg_g0, t.dut.msg_g1,
                t.dut.state_0, t.dut.state_1, t.dout, t.dut.v0);
            #4.90;
        end
        $fclose(fd);
        if (results != __EXPECTED__ || loads0 != __LOADS0__ || loads1 != 1)
            errors = errors + 1;
        $display("SUMMARY gap=__GAP__ results=%0d loads_g0=%0d loads_g1=%0d errors=%0d",
                 results, loads0, loads1, errors);
        $finish;
    end
endmodule
'@

foreach ($gap in @(64, 65, 63)) {
    $caseDir = Join-Path $taskDir "$gap"
    New-Item -ItemType Directory -Path $caseDir | Out-Null
    $caseTb = $tbText.Replace('repeat(63 )', ('repeat(' + ($gap - 1) + ' )'))
    [System.IO.File]::WriteAllText((Join-Path $caseDir 'tb_blake_64.v'), $caseTb)
    $expected = if ($gap -ge 64) { 3 } else { 2 }
    $loads0 = if ($gap -ge 64) { 2 } else { 1 }
    $monitor = $monitorTemplate.Replace('__GAP__', "$gap").Replace('__FIRST__', "$(($gap - 1) * 10 + 5)").Replace('__EXPECTED__', "$expected").Replace('__LOADS0__', "$loads0")
    [System.IO.File]::WriteAllText((Join-Path $caseDir 'waveform_check.v'), $monitor)
    & 'C:\intelFPGA\20.1\modelsim_ase\win32aloem\vlib.exe' (Join-Path $caseDir 'work')
    $sources = @(Get-ChildItem "$sourceDir\blake_64*.v") + @(Get-ChildItem "$sourceDir\blake_rbit*.v")
    & vlog -work (Join-Path $caseDir 'work') @($sources.FullName) (Join-Path $caseDir 'tb_blake_64.v') (Join-Path $caseDir 'waveform_check.v') -l (Join-Path $caseDir 'compile.log')
    if ($LASTEXITCODE -ne 0) { throw "Compile failed for $gap" }
    Push-Location $caseDir
    try {
        & vsim -c -lib (Join-Path $caseDir 'work') waveform_check -wlf trace.wlf -l simulation.log -do 'run -all; quit -f'
        if ($LASTEXITCODE -ne 0) { throw "Simulation failed for $gap" }
    }
    finally { Pop-Location }
    $summary = Select-String -LiteralPath (Join-Path $caseDir 'simulation.log') -Pattern 'SUMMARY'
    if ($summary.Line -notmatch 'errors=0') { throw "Verification failed for $gap" }
}
