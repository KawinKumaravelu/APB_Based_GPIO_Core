APB-Based GPIO Core
This project implements a General Purpose Input/Output (GPIO) core designed using Verilog HDL and interfaced via the AMBA 3 APB (Advanced Peripheral Bus) protocol. The project includes RTL modules, structured testbenches, and waveform verification, simulating a typical embedded hardware peripheral.

🔧 Features
    -Modular RTL design using Verilog
    -APB 3.0 compliant slave interface
    -Register-mapped I/O control
    -External clock and interrupt support
    -Aux signal routing and pad-level logic 
    -Fully testbenched and simulated using ModelSim
    -Synthesizable in Quartus Prime

📁 Project Structure

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
|   └── [Referance images]
├── README.md

🛠 Tools Used
ModelSim – Simulation and waveform analysis
Quartus Prime – RTL synthesis
Verilog HDL – Design and testbench development

✅ How to Run (Simulation)
Compile all Verilog files in ModelSim
Run tb_GPIO_top.v or any desired testbench
Observe waveform results and verify register behavior