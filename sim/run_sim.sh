#!/usr/bin/env bash
set -euo pipefail

# auto-detect locations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RTL_DIR="$PROJECT_ROOT/rtl"
TB_DIR="$PROJECT_ROOT/tb"
SIM_DIR="$SCRIPT_DIR"

echo "🧰 Running Icarus Verilog simulation (iverilog/vvp)"
echo "Project root: $PROJECT_ROOT"

# cleanup
rm -f "$SIM_DIR"/aes_wave.vcd "$SIM_DIR"/aes_tb.vvp || true
rm -rf obj_dir || true

# compile
echo "🔧 Compiling Verilog files..."
iverilog -g2012 -o "$SIM_DIR/aes_tb.vvp" \
  "$RTL_DIR/aes_sbox.v" \
  "$RTL_DIR/aes_mixcol.v" \
  "$RTL_DIR/aes_keyexp.v" \
  "$RTL_DIR/aes_core.v" \
  "$RTL_DIR/aes_fsm.v" \
  "$RTL_DIR/aes_apb_wrapper.v" \
  "$TB_DIR/aes_tb.v"

# run
echo "▶️ Running simulation..."
vvp "$SIM_DIR/aes_tb.vvp"

# show waveform if available
if command -v gtkwave >/dev/null 2>&1; then
  echo "📈 Opening waveform (aes_wave.vcd)..."
  gtkwave "$SIM_DIR/aes_wave.vcd" &
else
  echo "🛈 GTKWave not found. Open $SIM_DIR/aes_wave.vcd with your viewer."
fi

echo "✅ Simulation finished."
