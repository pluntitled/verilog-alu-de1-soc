# Parameterized Verilog ALU for DE1-SoC

A parameterized combinational arithmetic logic unit (ALU)
implemented in Verilog for the Terasic DE1-SoC FPGA board.

The project includes operation selection, optional alternative
operations, overflow and calculation error indication, and
decimal output on six seven-segment displays.

Developed as part of a digital design laboratory course.
This repository also documents my progress in FPGA development
and technical English.

## Target Hardware

- Board: Terasic DE1-SoC
- FPGA: Intel/Altera Cyclone V SoC, 5CSEMA5F31C6
- Design software: Quartus II / Quartus Prime
- Simulation software: ModelSim

## Features

- Combinational ALU with unsigned input operands
- Four operation codes selected by a two-bit input
- Main and alternative operation sets
- Alternative operation selection using a reduction operator
- Configurable operand, result, and alternative-input widths
- Optional overflow and calculation error indication
- Binary-to-BCD conversion using Double Dabble
- BCD-to-seven-segment decoding
- Simulation testbench with random operands
- Board-level integration with switches, buttons, displays, and an LED

The ALU does not require a clock signal.

## ALU Interface

| Port | Direction | Description |
|------|-----------|-------------|
| a | Input | First unsigned operand |
| b | Input | Second unsigned operand |
| op | Input | Two-bit operation code |
| alt | Input | Alternative operation selection inputs |
| s | Output | Operation result |
| overflow | Output | Overflow or calculation error flag |

The operation set and the alternative-selection condition
follow the assigned laboratory variant.

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| DATA_WIDTH | Operand width | 8 |
| RESULT_WIDTH | Result width | DATA_WIDTH |
| ALT_WIDTH | Alternative-selection input width | 4 |
| ALT_EN | Enable alternative operation logic | 0 |
| OVERFLOW_EN | Enable overflow/error indication | 0 |

When ALT_EN is 0, alternative operation logic is excluded
from the synthesized design.

## Board Configuration

The board-level module uses the following parameter values:

| Parameter | Value |
|-----------|-------|
| DATA_WIDTH | 4 |
| RESULT_WIDTH | 6 |
| ALT_WIDTH | 4 |
| ALT_EN | 1 |
| OVERFLOW_EN | 1 |

The operands range from 0 to 15.
The six-bit result bus represents unsigned values from 0 to 63.

The displays show the value carried by the result bus.
The overflow LED indicates when an operation produces
an overflow or a calculation error.

## Board Controls

| Board signal | Function |
|--------------|----------|
| SW[7:4] | Operand A |
| SW[3:0] | Operand B |
| SW[9:8] | Operation code |
| KEY[3:0] | Alternative operation selection inputs |
| HEX5, HEX4 | Operand A: tens and units |
| HEX3, HEX2 | Operand B: tens and units |
| HEX1, HEX0 | Result: tens and units |
| LEDR0 | Overflow or calculation error indication |

## Decimal Display

Three binary-to-BCD converters process operand A,
operand B, and the ALU result.

Each converter produces two decimal digits:
tens and units. Six BCD-to-seven-segment decoders
drive the corresponding displays.

The Double Dabble algorithm converts binary values into BCD
using conditional addition of 3 and one-bit left shifts.

## Simulation

The testbench generates random values for operands A and B
and cycles through operation codes 00, 01, 10, and 11.

Operands change once every four operation intervals,
allowing all four operations to be observed for each operand pair.

The simulation configuration enables both alternative operations
and overflow/error indication. Other ALU parameters use their defaults.

Waveforms are used to inspect all inputs and outputs.
This testbench provides stimulus for waveform inspection;
it should not be described as self-checking unless automatic
result comparisons are added.

## FPGA Resource Comparison

The laboratory includes a comparison of FPGA resource usage
for operand widths of 4, 8, and 16 bits.

Each width is evaluated using three configurations:

| ALT_EN | OVERFLOW_EN |
|--------|-------------|
| 0 | 0 |
| 1 | 0 |
| 1 | 1 |

The comparison records:

- Total pins
- Logic utilization in ALMs
- Total registers
- Total DSP blocks

Measured results can be added to the docs directory.

## Building and Programming

1. Open the Quartus project file.
2. Select the 5CSEMA5F31C6 FPGA device.
3. Set board_top as the top-level entity.
4. Check that all Verilog source files are included.
5. Check the DE1-SoC pin assignments.
6. Run a full compilation.
7. Connect the board and open Quartus Programmer.
8. Select the generated .sof file and program the FPGA.

Pin assignments must match the exact top-level port names,
including capitalization.

## Hardware Verification

Hardware verification is pending.

The laboratory requires at least 15 input combinations,
recording:

- Operand A
- Operand B
- Operation code
- Alternative operation selection
- Displayed result
- Overflow/error flag

## Documentation

Supporting materials may include:

- ALU operation table
- RTL diagrams with optional features disabled and enabled
- Top-level RTL diagram
- Simulation waveforms
- FPGA resource comparison
- Hardware test results (in the process)
- A photo or short video of the running design (in the process)

## What I Learned

- Describing combinational logic in Verilog
- Using parameters and reduction operators
- Handling arithmetic widths and calculation errors
- Writing a simulation testbench
- Implementing Double Dabble conversion
- Connecting modules through ports and internal wires
- Assigning FPGA pins
- Comparing synthesized hardware resources
