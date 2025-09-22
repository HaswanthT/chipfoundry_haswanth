# 🔐 Crypto Accelerator for Microwatt  

## 📖 Project Overview  
This project proposes a **hardware cryptographic accelerator** integrated with the open-source **Microwatt POWER CPU core**.  
The accelerator will implement **AES-128 encryption/decryption** in Verilog, providing a **secure and high-performance solution** for open computing systems.  

By offloading cryptographic operations to hardware, this design demonstrates **significant performance improvements** compared to software-only implementations, while showcasing the flexibility of Microwatt as a foundation for custom extensions.  

---

## 🎯 Objectives  
- Design and implement an **AES-128 crypto core in Verilog**.  
- Provide a **Wishbone/AXI-lite memory-mapped interface** for Microwatt integration.  
- Demonstrate secure and fast data encryption/decryption on Microwatt.  
- Ensure the design is **open-source, reproducible, and SKY130-compatible**.  

---

## 🔲 System Architecture  
       <?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="600" viewBox="0 0 1000 600">
  <style>
    .box { fill:#ffffff; stroke:#0b3d91; stroke-width:2; rx:8; }
    .small { font: 14px sans-serif; fill:#0b3d91; }
    .title { font: 18px sans-serif; font-weight:700; fill:#092a6f; }
    .label { font: 13px sans-serif; fill:#092a6f; }
    .arrow { stroke:#0b3d91; stroke-width:2; marker-end:url(#arrowhead); }
  </style>

  <defs>
    <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="10" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#0b3d91" />
    </marker>
  </defs>

  <!-- Title -->
  <text x="30" y="34" class="title">Microwatt Crypto Accelerator — System Architecture</text>

  <!-- Microwatt CPU box -->
  <rect x="40" y="70" width="220" height="120" class="box" />
  <text x="150" y="100" text-anchor="middle" class="label">Microwatt CPU</text>
  <text x="150" y="122" text-anchor="middle" class="small">(POWER ISA core)</text>
  <text x="150" y="142" text-anchor="middle" class="small">GCC/GDB toolchain</text>

  <!-- Bus box -->
  <rect x="300" y="60" width="380" height="140" class="box" />
  <text x="490" y="80" text-anchor="middle" class="label">System Interconnect</text>
  <text x="490" y="102" text-anchor="middle" class="small">Wishbone / AXI-lite</text>

  <!-- Arrow Microwatt -> Bus -->
  <line x1="260" y1="130" x2="300" y2="130" class="arrow" />

  <!-- Crypto Accelerator box -->
  <rect x="720" y="90" width="240" height="260" class="box" />
  <text x="840" y="118" text-anchor="middle" class="label">Crypto Accelerator</text>
  <text x="840" y="138" text-anchor="middle" class="small">(AES-128)</text>

  <!-- Internal blocks inside Crypto Accelerator -->
  <rect x="740" y="160" width="200" height="48" rx="6" fill="#f7fbff" stroke="#08407a" stroke-width="1.5" />
  <text x="840" y="192" text-anchor="middle" class="small">Key Expansion</text>

  <rect x="740" y="216" width="200" height="48" rx="6" fill="#f7fbff" stroke="#08407a" stroke-width="1.5" />
  <text x="840" y="248" text-anchor="middle" class="small">AES Round (SubBytes, ShiftRows, MixColumns)</text>

  <rect x="740" y="272" width="200" height="48" rx="6" fill="#f7fbff" stroke="#08407a" stroke-width="1.5" />
  <text x="840" y="304" text-anchor="middle" class="small">FSM Controller (round sequencing)</text>

  <rect x="740" y="330" width="200" height="36" rx="6" fill="#f7fbff" stroke="#08407a" stroke-width="1.5" />
  <text x="840" y="354" text-anchor="middle" class="small">Reg File & Status (CTRL, KEY, DATA_IN, DATA_OUT)</text>

  <!-- Arrow Bus -> Crypto -->
  <line x1="680" y1="130" x2="720" y2="130" class="arrow" />
  <text x="680" y="112" class="small">MMIO Access</text>

  <!-- External Memory/Peripherals -->
  <rect x="300" y="220" width="260" height="120" class="box" />
  <text x="430" y="250" text-anchor="middle" class="label">External Memory</text>
  <text x="430" y="272" text-anchor="middle" class="small">(SDRAM/Flash)</text>

  <rect x="300" y="360" width="260" height="120" class="box" />
  <text x="430" y="390" text-anchor="middle" class="label">Peripherals / IO</text>
  <text x="430" y="412" text-anchor="middle" class="small">(SPI, I2C, UART, Sensors)</text>

  <!-- Arrows from Bus to Memory/Peripherals -->
  <line x1="490" y1="150" x2="490" y2="220" class="arrow" />
  <line x1="490" y1="340" x2="490" y2="360" class="arrow" />

  <!-- Optional DMA block -->
  <rect x="720" y="380" width="240" height="84" class="box" />
  <text x="840" y="412" text-anchor="middle" class="label">Optional DMA Engine</text>
  <text x="840" y="436" text-anchor="middle" class="small">(streaming data to/from Crypto)</text>

  <!-- Arrows DMA <-> Crypto Accelerator -->
  <line x1="840" y1="380" x2="840" y2="350" class="arrow" />

  <!-- FPGA / SKY130 boundary -->
  <rect x="20" y="460" width="960" height="120" fill="none" stroke="#aaaaaa" stroke-dasharray="6,4" />
  <text x="40" y="480" class="small">Implementation Target: FPGA (simulation) / SKY130 (OpenLane)</text>

  <!-- Legend -->
  <rect x="760" y="470" width="200" height="64" rx="6" fill="#ffffff" stroke="#0b3d91" />
  <text x="770" y="492" class="small">Legend:</text>
  <text x="770" y="512" class="small">• MMIO = Memory-Mapped I/O</text>
  <text x="770" y="530" class="small">• FSM = Finite State Machine</text>

</svg>

## 🛠️ Key Features  
- **AES-128 Core in Verilog** (combinational + FSM-based design).  
- **Memory-mapped registers** for key, input data, output data, and control.  
- **NIST AES test vectors** used for functional verification.  
- **FPGA + OpenLane flow compatibility** for reproducibility.  
- Open-source under the **Apache 2.0 license**.  

---

## 🧪 Verification & Testing  
- **RTL Testbenches** using NIST official test vectors.  
- **Integration with Microwatt** for CPU-controlled encryption/decryption.  
- **Performance benchmarks** comparing hardware vs. software AES on Microwatt.  

---

## 📅 Timeline  
- **Phase 1 (Sep 22 – Sep 30):** AES core design in Verilog.  
- **Phase 2 (Oct 1 – Oct 14):** FSM + memory-mapped interface integration.  
- **Phase 3 (Oct 15 – Oct 28):** RTL testbench + functional verification.  
- **Phase 4 (Oct 29 – Nov 3):** Microwatt integration + demo + documentation.  

---

## 📂 Deliverables  
- Verilog RTL source code for AES-128 core and bus interface.  
- Testbenches and verification results.  
- Documentation (design flow, block diagrams, usage guide).  
- Final demo video and reproducible GitHub repo.  

---

## 📜 License  
This project will be released under the **Apache 2.0 License**, ensuring open-source availability and reuse.  

