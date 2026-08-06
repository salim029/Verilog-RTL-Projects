# APB Slave IP (AMBA APB3/4 Compatible) – RTL Design in Verilog

## Overview

This project implements a **parameterizable AMBA APB (Advanced Peripheral Bus) Slave IP** completely in **Verilog HDL**, designed to emulate a realistic memory-mapped peripheral used in modern SoCs and microcontroller-based systems.

The design follows the **APB protocol timing** by implementing the complete **IDLE → SETUP → ACCESS** transaction flow using a Finite State Machine (FSM). Along with standard APB read and write operations, the slave supports **programmable wait-state insertion**, **multiple register access types**, **byte-enable writes**, and **robust error detection**, making it significantly closer to a practical hardware peripheral than a basic APB memory example.

Unlike a simple register bank, this implementation demonstrates how real hardware peripherals behave by incorporating **Read/Write (RW)**, **Read-Only (RO)**, and **Write-One-to-Clear (W1C)** registers, along with hardware-generated events that interact with software-controlled registers.

The design is fully parameterized, allowing the **address width**, **data width**, **number of registers**, and **wait-state latency** to be configured without modifying the RTL source, making the IP reusable for different applications.

---

## Features

- ✅ AMBA APB3/4 compatible slave interface
- ✅ Parameterizable Address Width (`ADDR_WIDTH`)
- ✅ Parameterizable Data Width (`DATA_WIDTH`)
- ✅ Configurable Register Count (`NUM_REG`)
- ✅ Programmable Wait-State Generator (`WAIT_CYCLES`)
- ✅ APB FSM (IDLE → SETUP → ACCESS)
- ✅ Memory-Mapped Register Bank
- ✅ Multiple Register Types
  - Read/Write (RW)
  - Read-Only (RO)
  - Write-One-to-Clear (W1C)
- ✅ Byte-wise Write Support using **PSTRB**
- ✅ Address Alignment Checking
- ✅ Invalid Address Detection
- ✅ PSLVERR Generation
- ✅ PREADY Handshake Logic
- ✅ Hardware Event Generation
- ✅ Self-checking Verilog Testbench

---

## Architecture

The APB Slave is divided into several functional blocks.

### 1. APB Protocol Controller

The protocol controller is implemented using a **three-state Finite State Machine (FSM)**.

| State | Function |
|--------|----------|
| **IDLE** | Waits for the master to assert `PSEL` |
| **SETUP** | Captures transaction information |
| **ACCESS** | Performs read/write operation and waits until `PREADY` becomes high |

This FSM accurately models APB protocol timing while supporting configurable wait states.

---

### 2. Configurable Register Bank

The slave implements a parameterized register bank whose size is controlled using:

```verilog
NUM_REG
```

Each register can have an independent access policy.

| Register | Type | Reset Value | Description |
|----------|------|-------------|-------------|
| REG0 | Read/Write | `0x00000000` | General purpose register |
| REG1 | Read-Only | `0xDEADBEEF` | Hardware-controlled register |
| REG2 | Write-One-to-Clear | `0x0000000F` | Interrupt / Status register |
| REG3 | Read/Write | `0xFFFFFFFF` | General purpose register |

This closely resembles register maps used inside commercial peripheral IPs.

---

### 3. Wait-State Generator

The slave supports programmable latency through

```verilog
WAIT_CYCLES
```

During the ACCESS phase, an internal wait counter delays the assertion of **PREADY** until the configured number of wait cycles has elapsed.

- `WAIT_CYCLES = 0` → Immediate response
- `WAIT_CYCLES > 0` → Delayed response with inserted wait states

This allows the IP to emulate slow peripherals that require multiple clock cycles before completing a transaction.

---

### 4. Address Decoder

Instead of decoding every address individually, the incoming APB address is converted into a register index.

```verilog
reg_index = PADDR[ADDR_WIDTH-1:2];
```

The decoder also determines the register type (RW, RO or W1C), allowing the write controller to process every register differently.

---

## Register Access Modes

### Read/Write (RW)

- Supports both read and write operations.
- Writes are performed according to the active **PSTRB** bits.
- Only the selected bytes are modified.

---

### Read-Only (RO)

- Software writes are ignored.
- Register contents are updated only by hardware.
- In this implementation:

```text
REG1 = 0xDEADBEEF
```

is continuously driven by internal hardware logic.

---

### Write-One-to-Clear (W1C)

This register behaves similarly to interrupt status registers found in real SoCs.

Writing a **logic '1'** clears the corresponding bit.

Writing **logic '0'** leaves the bit unchanged.

Example:

| Current Value | Write Data | Result |
|--------------|------------|--------|
| 00001111 | 00000101 | 00001010 |

A hardware event periodically sets the lower four bits, while software clears them through APB writes.

---

## Byte Write Support (PSTRB)

The slave supports APB byte strobes through **PSTRB**.

Each bit of `PSTRB` controls one byte of the 32-bit data bus.

This enables:

- Full-word writes
- Half-word writes
- Byte writes

without affecting the remaining bytes.

---

## Error Detection

The slave validates every APB transaction before executing it.

### Misaligned Address Detection

Addresses that are not 32-bit aligned generate

```text
PSLVERR = 1
```

Example:

```text
0x00000002
```

---

### Invalid Address Detection

Transactions outside the implemented register space also assert

```text
PSLVERR
```

Example:

```text
0x00000020
```

---

## Read & Write Control

Read and write operations are enabled only during a valid ACCESS phase.

```verilog
write_en = PSEL & PENABLE & PWRITE & PREADY & !PSLVERR;
```

```verilog
read_en = PSEL & PENABLE & !PWRITE & PREADY & !PSLVERR;
```

This guarantees that every transaction is executed only after:

- APB protocol timing is satisfied
- Wait states are completed
- Address validation succeeds

---

## Hardware Event Demonstration

To simulate real hardware behavior, the slave internally generates a hardware event.

Whenever the controller returns to the **IDLE** state, the hardware automatically sets

```text
REG2[3:0]
```

Software then clears these bits using the **Write-One-to-Clear** mechanism.

This demonstrates hardware/software interaction commonly seen in interrupt status registers.

---

## Verification

The APB Slave IP is verified using a dedicated Verilog testbench.

The verification covers:

- Reset functionality
- APB Read Transactions
- APB Write Transactions
- Wait-State Generation
- Read-Only Register Protection
- Write-One-to-Clear Operation
- Byte Enable (PSTRB) Verification
- Misaligned Address Detection
- Invalid Address Detection
- PSLVERR Verification
- PREADY Handshake Verification

Simulation outputs are displayed as **PASS/FAIL** messages to validate each feature.

---

## Tools Used

- **Verilog HDL**
- **Icarus Verilog** – Functional Simulation
- **GTKWave** – Waveform Analysis
- **Xilinx Vivado 2025.1** – RTL Elaboration & RTL Schematic Generation

---

## Project Outputs

The repository includes:

- RTL Source Code
- Self-checking Testbench
- Simulation Waveform (`apb_slave_waveform.png`)
- Vivado RTL Schematic (`apb_slave_rtl_schematic.png`)
- Documentation

The waveform demonstrates successful APB read/write transactions, wait-state insertion, PREADY handshaking, register operations, and PSLVERR generation. The RTL schematic generated in Vivado illustrates the synthesized register bank, FSM, address decoder, and protocol control logic implemented in hardware.
