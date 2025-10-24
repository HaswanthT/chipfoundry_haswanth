#!/bin/bash
# run_sim.sh - simple Icarus Verilog simulation script
# assumes rtl/ and tb/ directories at repo root

set -e

RTL_DIR=../rtl
TB_DIR=../tb

# change into sim directory
cd "$(dirname "$0")"

# build with iverilog
echo "Compiling..."
iverilog -g2012 -o aes_tb.vvp $RTL_DIR/aes_sbox.v $RTL_DIR/aes_mixcol.v $RTL_DIR/aes_keyexp.v $RTL_DIR/aes_core.v $RTL_DIR/aes_fsm.v $RTL_DIR/aes_apb_wrapper.v $TB_DIR/aes_tb.v

echo "Running simulation..."
vvp aes_tb.vvp

# show waveform (if GTKWave available)
if command -v gtkwave >/dev/null 2>&1; then
  echo "Opening waveform..."
  gtkwave aes_wave.vcd &
else
  echo "GTKWave not found - open aes_wave.vcd with your waveform viewer"
fi
