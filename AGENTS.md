# Repository Guidelines

## Project Structure & Module Organization

This repository contains independent digital-design exercises:

- `assignment_0/`: Visual Studio C++ BLAKE reference project (`blake_Test.sln`).
- `assignment_1/` and `assignment_3/`: BLAKE RTL, testbenches, simulation scripts, and diagrams; `assignment_3/answer/` contains an alternative implementation.
- `assignment_uart_rx/`: UART RTL in `rtl_2/`, stimulus and testbenches in `tb/`, and ModelSim setup in `sim/`.
- `assignment_6/` and `assignment6_i2c/`: separate I2C variants with `i2c_rx_assignment/design/{rtl,tb,sim}/` layouts.
- `CDC/` and `fifo_code/`: clock-domain-crossing exercises and reusable FIFO/RAM modules.
- `Lecture/`: teaching materials, examples, and submissions. PDFs, HTML guides, and waveform diagrams provide reference assets.

Confirm which variant you are changing. Do not compile alternative implementations together when they define the same modules. Treat `tmp/`, `.tmp/`, and `output/` as scratch or captured results rather than canonical RTL.

## Build, Test, and Development Commands

Use ModelSim/Questa with `vlib`, `vmap`, `vlog`, and `vsim` on `PATH`. Run scripts from their containing directory because paths are relative. From the repository root, PowerShell examples are:

```powershell
Set-Location C:\Work\CDC
vsim -do sim.do
```

This creates the work library, compiles CDC modules, opens waveforms, and runs 100 microseconds.

```powershell
Set-Location C:\Work\assignment_3
vlib work
vsim -do sim.do
```

This compiles the BLAKE exercise and runs 10 microseconds. There is no repository-wide build or test command. Before using the UART script, reconcile its `../rtl/` paths and testbench ports with the current `rtl_2/` sources.

## Coding Style & Naming Conventions

Match surrounding indentation; use four spaces for new blocks. Use descriptive snake_case module/signal names, uppercase state constants, explicit widths, and named port connections. Preserve existing reset polarity (`rstb` commonly denotes active-low reset). Use nonblocking assignments in clocked logic and blocking assignments with complete defaults in combinational logic. No shared formatter or lint configuration is provided.

## Testing Guidelines

Tests are Verilog simulations, commonly named `tb.v`, `tb_<module>.v`, or `<module>_tb.v`. Extend the relevant testbench for reset, boundary conditions, and changed protocol timing. Check expected data and handshake behavior; compilation alone is insufficient. Record the simulation duration and results. No coverage threshold is configured.

## Commit & Pull Request Guidelines

History uses short, imperative subjects such as `Add BLAKE testbench`; follow that style and identify the affected exercise. Keep commits focused. PRs should describe behavior changes, affected variant, simulator/version, commands, and results. Link relevant issues and include annotated waveforms for timing changes. Exclude newly generated work libraries, transcripts, and waveform databases from commits.
