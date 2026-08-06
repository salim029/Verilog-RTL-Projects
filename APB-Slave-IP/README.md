APB Slave IP (AMBA APB3/4 Compatible) – RTL Design in Verilog
Overview

This project implements a parameterizable AMBA APB (Advanced Peripheral Bus) Slave IP in Verilog HDL, designed to demonstrate an industry-style peripheral interface used in modern SoCs. The design follows the APB protocol transaction sequence (IDLE → SETUP → ACCESS) and supports configurable register space, programmable wait states, byte-level write operations, multiple register access types, and comprehensive protocol error handling.

The objective of this project was not only to build a functional APB slave but also to model features commonly found in real hardware peripherals, making it suitable as a Digital Design / RTL portfolio project.

Key Features
Parameterized RTL design
Configurable Address Width
Configurable Data Width
Configurable Number of Registers
Configurable Wait-State Cycles
APB Finite State Machine
IDLE
SETUP
ACCESS
Programmable Wait-State Generation
Configurable latency using WAIT_CYCLES
Proper PREADY generation
Register Access Types
Read/Write (RW)
Read-Only (RO)
Write-One-to-Clear (W1C)
Byte Write Support
Full implementation of PSTRB
Independent byte updates for partial register writes
Address Decoder
Register indexing from APB address
Parameterized register selection
Error Detection
Invalid address detection
Misaligned address detection
PSLVERR generation for protocol violations
Hardware Event Simulation
Internal hardware event updates status registers
Demonstrates interaction between hardware logic and software writes
Read/Write Enable Logic
Protocol-compliant transaction qualification
Separate write_en and read_en control signals
Verification

The design was verified using a self-checking Verilog testbench.

Test scenarios include:

Reset verification
Read/Write register operations
Read-Only register protection
Write-One-to-Clear behavior
Byte-enable (PSTRB) verification
Configurable wait-state operation
Invalid address access
Misaligned address access
PSLVERR verification
FSM state transitions
APB protocol timing validation

Simulation was performed using:

Icarus Verilog
GTKWave
Xilinx Vivado Simulator

Waveforms and RTL schematics were analyzed to verify correct protocol behavior and hardware implementation.

Tools Used
Verilog HDL
Icarus Verilog
GTKWave
Xilinx Vivado 2025.1
