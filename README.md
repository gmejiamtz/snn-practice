# snn-practice

Practice implementing an SNN on FPGA

## Requirements

This project requires several libraries, programs, and hardware to function:

### Python Libraries

This project requires several Python packages to function:

```
conda install h5py
pip install hdf5plugin matlibplot torch
```

### FPGA Software and Hardware

The board used for this project is the [Diligent Basys3](https://digilent.com/reference/programmable-logic/basys-3/reference-manual) and uses [Xilinx Vivado 2025.2](https://www.xilinx.com/support/download.html) for implementation.

## Usage

The following steps are required to correctly synthesize the SNN on the FPGA for inference.

1. Create the hexfiles required for weight storage on the FPGA

   - To do this run the following commands

   ```
   #To download the dataset
   make download-dataset
   #To process dataset and make packets
   make process-dataset
   #To train the weights
   make weight-train
   #To create the hexfiles required for FPGA synthesis
   make hexfiles
   ```

2. Synthesize and Implement the FPGA

   - To do this run the following commands:

   ```
   #To create the SNN IP required for the main project
   make create_ip
   #To create the Vivado project
   make project
   #To run the FPGA flow and generate a bitstream
   make run-pnr
   #To flash the bitstream onto the FPGA
   make board-flash
   ```

3. Send over the data into the FPGA
   ```
   make send-to-fpga
   ```
