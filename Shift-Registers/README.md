# Shift Registers in Verilog HDL

## Overview

This project implements the four basic types of shift registers using Verilog HDL. Each design is verified with an independent testbench and simulated using Icarus Verilog and GTKWave.

## Shift Registers Included

1. SISO (Serial-In Serial-Out)
2. SIPO (Serial-In Parallel-Out)
3. PISO (Parallel-In Serial-Out)
4. PIPO (Parallel-In Parallel-Out)

## How It Works

This project demonstrates the four fundamental types of shift registers implemented in Verilog HDL.

### SISO (Serial-In Serial-Out)
- Accepts one bit of input at a time.
- Shifts the data by one position on every rising clock edge.
- Produces the data serially at the output.

### SIPO (Serial-In Parallel-Out)
- Accepts serial input data.
- Shifts data into the register on each clock cycle.
- Makes all stored bits available simultaneously as parallel outputs.

### PISO (Parallel-In Serial-Out)
- Loads multiple bits simultaneously using the load signal.
- After loading, the data is shifted out one bit at a time.

### PIPO (Parallel-In Parallel-Out)
- Loads all input bits simultaneously.
- Updates all outputs together on the rising edge of the clock.

## Applications

- Data storage
- Serial-to-parallel conversion
- Parallel-to-serial conversion
- Digital communication systems
- Data transfer between devices

## Tools Used

- Verilog HDL
- VS Code
- Icarus Verilog
- GTKWave

## Project Structure

- SISO.v
- SIPO.v
- PISO.v
- PIPO.v
- Testbenches for each design
- Simulation waveforms

## Learning Outcomes

- Shift Register Design
- Sequential Logic
- Register Operations
- Verilog RTL Coding
- Testbench Development
- Functional Simulation

## Simulation Results

### SISO Register
![SISO Waveform](siso_waveform.png)

### SIPO Register
![SIPO Waveform](sipo_waveform.png)

### PISO Register
![PISO Waveform](piso_waveform.png)

### PIPO Register
![PIPO Waveform](pipo_waveform.png)
