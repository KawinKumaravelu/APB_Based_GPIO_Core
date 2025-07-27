# **APB\_Based\_GPIO\_Core**

A Verilog-based GPIO IP core interfaced with the **AMBA 3 APB protocol**. This project includes RTL modules, testbenches, and waveform verification for register-level GPIO design and control.

## **📖 Overview**

This project implements a **General Purpose Input/Output (GPIO) core** using **Verilog HDL** and connects it to the system bus using the **AMBA 3 APB (Advanced Peripheral Bus)** protocol. It simulates a realistic digital peripheral, showcasing both RTL-level implementation and functional verification.

## **🔧 Features**

* ✅ Modular RTL design using Verilog
* ✅ APB 3.0 compliant slave interface
* ✅ Register-mapped I/O control
* ✅ External clock sampling and interrupt generation
* ✅ Aux signal routing to GPIO output
* ✅ Fully testbenched and simulated in ModelSim
* ✅ Synthesizable design using Quartus Prime

## **📁 Project Structure**
```
├── rtl/
│   ├── GPIO_top.v
│   ├── gpio_register.v
│   ├── aux_interface.v
│   ├── apb_slave_interface.v
│   └── io_interface.v

├── tb/
│   ├── tb_GPIO_top.v
│   ├── tb_gpio_register.v
│   ├── tb_aux_interface.v
│   ├── tb_apb_slave_interface.v
│   └── tb_io_interface.v

├── waveforms/
│   └── [Waveform screenshots]

├── reference/
│   └── [Block diagrams, synthesis images]

├── README.md
```

## **🛠 Tools Used**

* **ModelSim** – Simulation and waveform viewing
* **Quartus Prime** – RTL Synthesis
* **Verilog HDL** – Hardware description and testbench creation

## **✅ How to Run (Simulation)**

1. Open ModelSim or any Verilog simulator.
2. Compile all RTL and TB files.
3. Run `tb_GPIO_top.v` (or any individual block testbench).
4. View output waveforms and verify GPIO operation.
