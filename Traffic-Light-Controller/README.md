# Traffic Light Controller

FSM-based Traffic Light Controller implemented in Verilog HDL.
## Overview

This project implements a Finite State Machine (FSM) based Traffic Light Controller using Verilog HDL.

The controller continuously cycles through three traffic light states:

- 🔴 RED
- 🟢 GREEN
- 🟡 YELLOW

On every positive edge of the clock, the FSM transitions to the next state in the sequence:

RED → GREEN → YELLOW → RED

The traffic light outputs are encoded as:

| Light | Output |
|--------|--------|
| RED | 100 |
| GREEN | 010 |
| YELLOW | 001 |

### State Encoding

| State | Binary |
|--------|--------|
| RED | 10 |
| GREEN | 01 |
| YELLOW | 11 |

### How it Works

- The FSM starts in the **RED** state after reset.
- On each rising edge of the clock, it moves to the next state.
- A combinational logic block determines the next state.
- Another combinational block generates the corresponding traffic light output.
- The design is verified using a Verilog testbench and simulated in GTKWave.

### Tools Used

- Verilog HDL
- VS Code
- Icarus Verilog
- GTKWave

## Project Files

- `TrafficLight_controller.v` – RTL design
- `tb_TrafficLight_controller.v` – Testbench
- `TrafficLight controller waveform.png` – Simulation waveform

## Learning Outcomes

- Finite State Machine (FSM) Design
- Sequential Logic Design
- State Transition Logic
- Verilog RTL Coding
- Testbench Development
- Functional Simulation using Icarus Verilog and GTKWave
