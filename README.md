# Parameterized Verilog ALU for DE1-SoC

A parameterized combinational arithmetic logic unit (ALU) implemented in Verilog for the Terasic DE1-SoC FPGA board. Switches select the operands and operation, push-buttons select the operation set, six seven-segment displays show decimal values, and one LED indicates arithmetic errors.

Developed as part of a digital design laboratory course. This project documents my progress in FPGA development and technical English.

## Hardware and Tools

- **Board:** Terasic DE1-SoC
- **FPGA:** Intel/Altera Cyclone V SoC, `5CSEMA5F31C6`
- **FPGA tools:** Quartus Prime Lite Edition 18.1
- **Simulation:** ModelSim Intel FPGA Edition; additional RTL checks with Icarus Verilog 12.0
- **Language:** Verilog

The ALU and display converters are combinational: they do not require a clock or reset.

## Features

- Configurable operand, result, and alternative-selection widths
- Four main operations and four alternative operations
- Optional alternative-operation logic and arithmetic error indication
- Binary-to-BCD conversion using Double Dabble
- Decimal display of both operands and the result
- Random stimulus testbench for waveform inspection

## ALU Operations

Operands `a` and `b` are unsigned. Alternative operations are selected when `ALT_EN` is enabled and **every bit of `alt` is 1**, using the reduction AND expression `&alt`.

| `op` | Main operation | Alternative operation |
|------|----------------|-----------------------|
| `00` | `a % b` | `(2 * a) % b` |
| `01` | `a * b` | `a * b - 3` |
| `10` | `a ^ b` | `a ^ ~b` |
| `11` | `~(a & b)` | `~(~a & b)` |

`%` computes the remainder. `^`, `&`, and `~` are bitwise operators. The result is stored in the `RESULT_WIDTH`-bit output `s`.

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `DATA_WIDTH` | Operand width | `8` |
| `RESULT_WIDTH` | Result width | `DATA_WIDTH` |
| `ALT_WIDTH` | Alternative-selection input width | `4` |
| `ALT_EN` | Enable alternative operations | `1` |
| `OVERFLOW_EN` | Enable arithmetic error indication | `0` |

The `board_top` module uses `DATA_WIDTH = 4`, `RESULT_WIDTH = 6`, `ALT_WIDTH = 4`, `ALT_EN = 1`, and `OVERFLOW_EN = 1`.

On the board, each operand ranges from **0 to 15**, and the result bus holds unsigned values from **0 to 63**.

## Board Controls and Displays

The Verilog ports use lowercase names, such as `sw`, `key`, `hex0`, and `ledr0`. The table uses the board's printed signal labels.

| Board signal | Function |
|--------------|----------|
| `SW[7:4]` | Operand A |
| `SW[3:0]` | Operand B |
| `SW[9:8]` | Operation code |
| `KEY[3:0]` | Alternative-operation selection inputs |
| `HEX5`, `HEX4` | Operand A: tens and units |
| `HEX3`, `HEX2` | Operand B: tens and units |
| `HEX1`, `HEX0` | Result: tens and units |
| `LEDR0` | Arithmetic error flag |

All four push-buttons are **active-low**: a released button reads `1`, and a pressed button reads `0`.

- **All buttons released:** `alt = 4'b1111`, selecting alternative operations.
- **Any button pressed:** at least one `alt` bit is `0`, selecting main operations.

Only `LEDR0` is connected by this design; the other LEDs are not top-level outputs.

## Arithmetic Errors and Result Width

When `OVERFLOW_EN = 1`, the `overflow` output indicates:

- A zero divisor for either remainder operation.
- A multiplication result above the maximum value of `s`.
- An alternative multiplication result outside the unsigned result range, including a negative result from `a * b - 3`.

The result is **not saturated**. Excess high bits are discarded, and a negative arithmetic result wraps to the output width. The displays show the value stored in `s`.

Examples for the board's six-bit result:

| Operation | Mathematical result | Displayed result | Error flag |
|-----------|---------------------|------------------|------------|
| Main: `10 * 10` | `100` | `36` | `1` |
| Alternative: `10 * 10 - 3` | `97` | `33` | `1` |
| Alternative: `5 * 13 - 3` | `62` | `62` | `0` |
| Alternative: `1 * 2 - 3` | `-1` | `63` | `1` |

For a zero divisor, the result is undefined; the error LED should be used to identify this condition. Bitwise operations clear the error flag. When `OVERFLOW_EN = 0`, the flag is always `0`.

### Multiplication Width Fix

The overflow calculation uses `(a + 0) * b` to evaluate the product in a wider expression before comparing it with the result limit. The unsized literal `0` introduces a width of at least 32 bits; it does **not** simply add one extra result bit. This prevents premature truncation for the operand widths used in this lab.

For alternative multiplication, the upper-limit check uses the final expression `(a + 0) * b - 3`. Checking only the product would incorrectly flag `5 * 13 - 3 = 62` as an overflow for a six-bit output. A separate check detects products below `3`, which would produce an unsigned underflow after subtraction.

This width workaround is intended for the lab configurations. Wider parameter values require a review of intermediate arithmetic widths.

## Decimal Display

Three `bin2bcd` instances convert operand A, operand B, and the result into two BCD digits each. They use input widths of 4, 4, and 6 bits respectively.

Double Dabble processes the binary input from its most significant bit. Before each one-bit left shift, it adds `3` to each BCD digit that is at least `5`, then inserts the next input bit.

The eight-bit BCD output contains two four-bit decimal digits: tens in `[7:4]` and units in `[3:0]`. Six `bcd2sev` instances convert these digits into active-low seven-segment patterns. Each display output uses the bit order `{g, f, e, d, c, b, a}`.

Two BCD digits represent values from 0 to 99, which covers both operands and the six-bit result used here.

## Project Files

| File | Purpose |
|------|---------|
| `lab2.v` | Parameterized combinational ALU |
| `board_top.v` | Board integration and display connections; FPGA top-level module |
| `bin2bcd.v` | Binary-to-BCD converter |
| `bcd2sev.v` | BCD-to-seven-segment decoder |
| `test.v` | ALU stimulus testbench |
| `lab2.qpf` | Quartus project |
| `lab2.qsf` | Project settings and board pin assignments |
| `top.v` | Earlier laboratory wrapper; unused by `board_top` |

## Simulation

The `test` module instantiates the ALU with eight-bit operands and results, enables alternative operations and error indication, and generates five random operand pairs.

For each pair it tests all four main operations, followed by all four alternative operations. The operation interval is **2 ns**; each operand pair remains unchanged for **16 ns**. The complete stimulus sequence takes **80 ns**.

`test.v` provides stimulus for waveform inspection and does not contain automatic result assertions.

Run these commands in the ModelSim console from the project directory:

```tcl
vlib work
vlog lab2.v test.v
vsim work.test
add wave -r sim:/test/*
run -all
```

Alternatively, run the stimulus with Icarus Verilog:

```sh
iverilog -g2001 -s test -o test.vvp lab2.v test.v
vvp test.vvp
```

This Icarus command checks compilation and execution; the supplied testbench does not print results or write a waveform file.

### Final RTL Review

Separate automated checks of the updated RTL passed in Icarus Verilog:

- **16,384 board configurations:** all four-bit operand pairs, four operation codes, and all 16 button patterns. Checks covered the result, error flag, and six display outputs.
- **524,288 ALU configurations:** all eight-bit operand pairs, four operation codes, and both operation sets, with error indication enabled.

For zero divisors, these checks verified the error flag without requiring a defined remainder result. These review checks are separate from the random stimulus in `test.v`.

## Building and Programming

1. Open `lab2.qpf` in Quartus Prime.
2. Confirm the FPGA device is `5CSEMA5F31C6` and the top-level entity is `board_top`.
3. Include `lab2.v`, `board_top.v`, `bin2bcd.v`, and `bcd2sev.v` in the board build.
4. Check the pin assignments in `lab2.qsf`. Signal names are case-sensitive and must match the top-level ports.
5. Run a full compilation.
6. Connect the board by USB and open **Tools → Programmer**.
7. Select the USB-Blaster hardware and add the generated `output_files/lab2.sof` file to the FPGA device.
8. Enable **Program/Configure** and click **Start**.

Recompile after changing the RTL to ensure the programmed `.sof` corresponds to the current source files.

## Hardware Demonstration

The design has been run on a DE1-SoC board, and a demonstration video has been recorded. The video will be added separately.

## What I Learned

- Describing combinational logic and connecting Verilog modules
- Using parameters, bitwise operators, and reduction operators
- Handling result truncation, overflow, and unsigned underflow
- Writing simulation stimulus and inspecting waveforms
- Implementing Double Dabble and seven-segment decoding
- Assigning FPGA pins and programming the DE1-SoC board
- Comparing synthesized resource usage for different ALU configurations
