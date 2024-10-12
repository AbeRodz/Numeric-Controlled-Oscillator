# Numeric-Controlled-Oscillator

**This project is for the Programmable Logic Circuits class**

This project implements a **Numerically Controlled Oscillator (NCO)** using VHDL. An NCO is used to generate waveforms, often in digital signal processing, by leveraging a phase accumulator and a phase-to-amplitude conversion mechanism. This implementation supports multiple waveform types, including sine, square, triangle, and sawtooth waves, using a Look-Up Table (LUT)-based design.

## Key Features

- **Phase Accumulator**: A 32-bit accumulator that controls the frequency of the output waveform.
- **Waveform Generation**: Supports sine, square, triangle, and sawtooth waveforms.
- **LUT-based Sine Wave**: The sine wave is generated using a precomputed LUT with 1024 samples for high precision.
- **Multiple Wave Types**: Selectable output wave types based on input control signals.
- **VHDL Implementation**: Code is structured to be synthesizable and suitable for FPGA deployment.

## Project Structure

- **VHDL Modules**: Core components such as the phase accumulator and LUT are implemented in separate VHDL modules.
- **Python Script**: A Python script generates the sine wave LUT values.
- **Vivado Integration**: The project uses Vivado for synthesis, simulation, and resource utilization analysis.