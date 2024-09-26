#!/bin/bash
# Script to compile and run the Ethernet hub testbench

echo "Compiling Verilog files..."
iverilog -o hub_tb \
    src/hub.v \
    src/frame_parser.v \
    src/fifo_buffer.v \
    src/hub_logic.v \
    sim/testbench/hub_tb.v

echo "Running simulation..."
vvp hub_tb

echo "Generating waveform..."
gtkwave simulation.vcd &
