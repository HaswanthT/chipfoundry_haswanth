#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
RTL_DIR="$PROJECT_ROOT/rtl"
TB_DIR="$PROJECT_ROOT/tb"
SIM_DIR="$SCRIPT_DIR"

echo "🧰 Running Verilator simulation (verilator + vvp)"
echo "Project root: $PROJECT_ROOT"

# cleanup
rm -f "$SIM_DIR"/aes_wave.vcd "$SIM_DIR"/verilator.log || true
rm -rf obj_dir || true

# Verilator compile (treat tb/aes_tb.v as top module)
echo "🔧 Verilator: compiling..."
verilator --cc --exe --build \
  --MMD --trace \
  -I"$RTL_DIR" \
  "$RTL_DIR/aes_sbox.v" \
  "$RTL_DIR/aes_mixcol.v" \
  "$RTL_DIR/aes_keyexp.v" \
  "$RTL_DIR/aes_core.v" \
  "$RTL_DIR/aes_fsm.v" \
  "$RTL_DIR/aes_apb_wrapper.v" \
  "$TB_DIR/aes_tb.v" \
  -o obj_dir/Vaes_tb 2>&1 | tee "$SIM_DIR/verilator.log"

# run
echo "▶️ Running simulation..."
./obj_dir/Vaes_tb

# waveform
if [ -f "$SIM_DIR"/aes_wave.vcd ]; then
  if command -v gtkwave >/dev/null 2>&1; then
    echo "📈 Opening waveform (aes_wave.vcd)..."
    gtkwave "$SIM_DIR/aes_wave.vcd" &
  else
    echo "🛈 GTKWave not found. Open $SIM_DIR/aes_wave.vcd with your viewer."
  fi
else
  echo "⚠️ aes_wave.vcd not found."
fi

echo "✅ Verilator simulation finished. See $SIM_DIR/verilator.log for details."
