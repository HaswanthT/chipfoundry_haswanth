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
               ┌───────────────────┐
         │   Microwatt CPU   │
         │ (POWER ISA Core)  │
         └─────────┬─────────┘
                   │
          ┌────────▼─────────┐
          │  System Bus       │
          │ (Wishbone/AXI-lite)│
          └───────┬──────────┘
                  │
     ┌────────────▼────────────┐
     │   Crypto Accelerator    │
     │       (AES-128)         │
     │ ┌─────────────────────┐ │
     │ │ Key Expansion       │ │
     │ │ AES Rounds (10x)    │ │
     │ │ FSM Controller      │ │
     │ │ Regs: CTRL, KEY,    │ │
     │ │       DATA_IN/OUT   │ │
     │ └─────────────────────┘ │
     └────────────┬────────────┘
                  │
         Encrypted/Decrypted Data


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

