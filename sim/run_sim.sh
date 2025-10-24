#!/usr/bin/env bash
set -euo pipefail

# resolve script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RTL_DIR="$PROJECT_ROOT/rtl"
TB_DIR="$PROJECT_ROOT/tb"
SIM_DIR="$SCRIPT_DIR"

echo "🔧 Cleaning old builds..."
rm -rf "$SIM_DIR"/aes_wave.vcd obj_dir || true

echo "🚀 Compiling Verilog files..."
# Use iverilog for pure Verilog tb
iverilog -g2012 -o "$SIM_DIR/aes_tb.vvp" \
  "$RTL_DIR/aes_sbox.v" \
  "$RTL_DIR/aes_mixcol.v" \
  "$RTL_DIR/aes_keyexp.v" \
  "$RTL_DIR/aes_core.v" \
  "$RTL_DIR/aes_fsm.v" \
  "$RTL_DIR/aes_apb_wrapper.v" \
  "$TB_DIR/aes_tb.v"

echo "▶️ Running simulation..."
vvp "$SIM_DIR/aes_tb.vvp"

# open waveform if gtkwave exists
if command -v gtkwave >/dev/null 2>&1; then
  echo "📈 Opening waveform aes_wave.vcd..."
  gtkwave "$SIM_DIR/aes_wave.vcd" &
else
  echo "🛈 GTKWave not found. Open $SIM_DIR/aes_wave.vcd with your waveform viewer."
fi

echo "✅ Simulation finished."
