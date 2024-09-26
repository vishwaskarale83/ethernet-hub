
# Ethernet Hub - Verilog Implementation

## Overview

This project implements a **Full-Duplex Ethernet Hub** using Verilog, capable of handling Ethernet frames according to standard protocols. The hub processes Ethernet frames across multiple ports, forwarding data frames to appropriate destinations or broadcasting them when needed. The project includes support for:

- **Modular Design**: Different modules for parsing Ethernet frames, managing frame forwarding, and handling errors.
- **Protocol Support**: Real-world Ethernet protocol features, including destination MAC address parsing and CRC checks.
- **Simulation**: A complete testbench is provided to simulate and verify the functionality of the hub.

## Features

- **Full-Duplex Support**: Transmit and receive on all ports simultaneously.
- **MAC Address Forwarding**: Forward Ethernet frames to specific ports based on destination MAC address.
- **Broadcast Handling**: Broadcasts frames to all ports when the destination MAC is `FF:FF:FF:FF:FF:FF`.
- **Frame Parsing and CRC**: Implements frame parsing with CRC error checking and payload extraction.
- **Modular Design**: The hub is implemented with a high degree of modularity to facilitate easy maintenance and extensions.

## File Structure

```
ethernet-hub/
│
├── README.md                   # Documentation for the project
├── LICENSE                     # License for the project (MIT, GPL, etc.)
├── docs/                       # Additional project documentation (optional)
│   └── specification.pdf       # Technical specifications of the hub (optional)
├── src/                        # Source Verilog code
│   ├── hub.v                   # Top-level Ethernet hub module
│   ├── frame_parser.v          # Ethernet frame parsing module
│   ├── fifo_buffer.v           # FIFO buffer module
│   └── hub_logic.v             # Core hub logic module
│
├── sim/                        # Simulation files
│   └── testbench/              # Testbench files for verification
│       ├── hub_tb.v            # Main testbench for the Ethernet hub
│       └── frame_gen.v         # Helper module for generating Ethernet frames
│
├── scripts/                    # Automation scripts
│   └── run_simulation.sh       # Shell script to compile and run simulation
│
│
└── .gitignore                  # Ignored files for Git (e.g., logs, temp files)
```

## Getting Started

### Prerequisites

Ensure you have the following installed on your system:

- **Verilog Compiler** (e.g., Icarus Verilog, ModelSim, Vivado)
- **GTKWave** (for waveform viewing)
- **Shell (bash)** for running the simulation script

### Cloning the Repository

To get started, clone the repository using Git:

```bash
git clone https://github.com/vishwaskarale83/ethernet-hub.git
cd ethernet-hub
```

### Running the Simulation

A testbench is provided to simulate the Ethernet hub and verify its functionality. You can run the simulation using the provided script.

1. Navigate to the root directory of the project:

   ```bash
   cd ethernet-hub
   ```

2. Run the simulation using the shell script:

   ```bash
   ./scripts/run_simulation.sh
   ```

   This will:
   - Compile all source files and the testbench.
   - Run the simulation.
   - Generate waveform files (`.vcd`) and logs.

3. Open the waveform in **GTKWave** to inspect the output:

   ```bash
   gtkwave results/waveforms/simulation.vcd
   ```

### Simulation Results

- The Ethernet hub is expected to correctly forward Ethernet frames to the appropriate ports based on the destination MAC address.
- Broadcast frames (`FF:FF:FF:FF:FF:FF`) should be forwarded to all other ports.
- Frames with incorrect CRC should be discarded and not forwarded.

### Testbench

The testbench (`hub_tb.v`) is designed to verify different scenarios:
- Sending Ethernet frames from different ports.
- Handling valid and invalid CRCs.
- Verifying broadcast behavior and unicast MAC forwarding.

## Customization

- **MAC Address Table**: You can expand the project to support a MAC address table for dynamic learning and filtering.
- **Additional Ports**: Modify the design to support more Ethernet ports by extending the Verilog modules.

## Contributing

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Create a new Pull Request.

## Acknowledgements

Special thanks to the developers of the open-source Verilog tools and simulators used in this project.
