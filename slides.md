---
author: Gary Mejia
title: Practice SNN on FPGA
subtitle: Basys3 - Artix7
date: December 5, 2025
---

## Structure of Presentation

1. Prequisites of Project
2. FPGA Design
3. Data Processing
4. Future Work
5. Conclusion

## Prequisites

---

### Software

This project involves several software stacks to run. Software is classified 
by what it is targetting: data processing, FPGA flow, website/documentation

---

### Data processing

The dataset is stored in `hdf5` files or `.h5` files. An hdf5 reader or
library is required extract data from these files. This project uses
the Python `h5py` and `hdf5plugin` modules. To install them use the 
following:

```
conda install h5py
pip install hdf5plugin matlibplot
```

---

### How to process data

Data processing is done through the central makefile commands:

```
#To download the dataset
make download-dataset

#To process dataset and make packets
make process-dataset

#To send packets to FPGA
make send-to-fpga
```

---

### FPGA Flow

This SNN is deployed on a Xilinx `Basys3` board with an Artix7 FPGA. The
Xlinix Vivado version used for this project is `2025.2`.

![Artix7 is equipped with 33k LUTs](img/Basys3-Rev.png)

---

### To run the FPGA Flow

The FPGA flow is ran through the central makefile commands:

```
#To create the Vivado project
make project

#To run simulations
make run-sim

#To run the FPGA flow and generate a bitstream
make run-pnr

#To flash the bitstream onto the FPGA
make board-flash
```

---

### Documentation Flow

To create this website, this repo uses `pandoc` along with `reveal.js` to
generate the HTML slide show. This project specifically uses `pandoc 3.8.2.1`
and thus is installed manually by doing the following:

```
wget https://github.com/jgm/pandoc/releases/download/3.8.2.1/pandoc-3.8.2.1-1-amd64.deb
sudo apt install ./pandoc-3.8.2.1-1-amd64.deb
```

---

### To create the website

To create this website, use the central makefile command:

```
make page
```

Deployment is handled via `Github Actions` and the `deploy.yml` workflow file.

## FPGA Design

---

### TBD

## Data Processing

---

### TBD

## Future Work

---

### TBD

## Conclusion

---

### TBD

## Thanks for watching

Contributions are welcome at [https://github.com/gmejiamtz/snn-practice](https://github.com/gmejiamtz/snn-practice)

