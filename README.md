# VLSI-System-Design-picoComputer-on-FPGA

## Overview

This project implements the picoComputer architecture on an FPGA platform. The system includes a processor core, a structured memory hierarchy, and controllers for external peripherals such as VGA and PS/2, with rigorous verification using the industrial UVM standard.


## Modules

### CPU

Supports a custom ISA (Instruction Set Architecture) with 1-word and 2-word instructions.

Features both direct (value 0) and indirect (value 1) addressing.

Includes a 6-bit Program Counter (PC), 6-bit Stack Pointer (SP), 32-bit Instruction Register (IR), and a 16-bit Accumulator (A).


### Memory Hierarchy

A 64-word memory space divided into a General Purpose Register (GPR) zone and a flexible zone for program code, data, and the stack.


### BCD & SSD

A Binary Coded Decimal (BCD) converter for two-digit numbers and a Seven Segment Display (SSD) module for real-time monitoring.

### Helper Modules

Includes a Debouncer for input stabilization, a Rising Edge Detector (RED) for signal edge detection, and a Clock Divider to adjust the operating frequency.

### Parameterized ALU

Arithmetic Operations: ADD, SUB, MUL, and DIV

Logical Operations: NOT, XOR, OR, and AND

### VGA Interface

An RGB controller managing horizontal and vertical synchronization (hsync, vsync) to display dual-color data on a monitor.

### PS/2 Keyboard

A controller for PS/2 protocol communication, including a scan-code translator for numerical input.


### Verification

A SystemVerilog verification environment was developed using the Universal Verification Methodology (UVM), including code coverage.



## Technologies & Hardware

Languages: Verilog, SystemVerilog (UVM)

Tools: Quartus, ModelSim / QuestaSim

Target Hardware: Cyclone III and Cyclone V FPGA development systems
