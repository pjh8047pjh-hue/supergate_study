$ErrorActionPreference = 'Stop'
$taskDir = 'C:\Work\tmp\blake64-waveforms-fd064c47'
$sourceDir = 'C:\Work\assignment_3'
$caseDir = Join-Path $taskDir '63-extended'
New-Item -ItemType Directory -Path $caseDir -Force | Out-Null
$tbText = [System.IO.File]::ReadAllText((Join-Path $sourceDir 'tb_blake_64.v'))
[System.IO.File]::WriteAllText((Join-Path $caseDir 'tb_blake_64.v'), $tbText.Replace('repeat(63 )', 'repeat(62 )'))
$monitor = [System.IO.File]::ReadAllText((Join-Path $taskDir '63\waveform_check.v')).Replace('half <= 522', 'half <= 780')
[System.IO.File]::WriteAllText((Join-Path $caseDir 'waveform_check.v'), $monitor)
& 'C:\intelFPGA\20.1\modelsim_ase\win32aloem\vlib.exe' (Join-Path $caseDir 'work')
$sources = @(Get-ChildItem "$sourceDir\blake_64*.v") + @(Get-ChildItem "$sourceDir\blake_rbit*.v")
& 'C:\intelFPGA\20.1\modelsim_ase\win32aloem\vlog.exe' -work (Join-Path $caseDir 'work') @($sources.FullName) (Join-Path $caseDir 'tb_blake_64.v') (Join-Path $caseDir 'waveform_check.v') -l (Join-Path $caseDir 'compile.log')
if ($LASTEXITCODE -ne 0) { throw 'Compile failed' }
Push-Location $caseDir
try {
    & 'C:\intelFPGA\20.1\modelsim_ase\win32aloem\vsim.exe' -c -lib (Join-Path $caseDir 'work') waveform_check -wlf trace.wlf -l simulation.log -do 'run -all; quit -f'
    if ($LASTEXITCODE -ne 0) { throw 'Simulation failed' }
}
finally { Pop-Location }
$summary = Select-String -LiteralPath (Join-Path $caseDir 'simulation.log') -Pattern 'SUMMARY'
if ($summary.Line -notmatch 'errors=0') { throw 'Verification failed' }
$summary.Line
