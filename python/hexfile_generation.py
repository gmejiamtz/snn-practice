#!/usr/bin/env python3
import os
import numpy as np

BRAM_WEIGHTS_DIR = "bram_weights"
HEX_OUTPUT_DIR = os.path.join(BRAM_WEIGHTS_DIR, "hexfiles")
os.makedirs(HEX_OUTPUT_DIR, exist_ok=True)

# Load the flattened weight arrays
w_in_hidden = np.load(os.path.join(BRAM_WEIGHTS_DIR, "weights_in_hidden.npy")).astype(np.int32)
w_hidden_out = np.load(os.path.join(BRAM_WEIGHTS_DIR, "weights_hidden_out.npy")).astype(np.int32)

# -----------------------------
# Hidden layer hex files (32 neurons)
# Each neuron has 6 weights (input_size)
input_size = 6
hidden_size = 32

for i in range(hidden_size):
    start_idx = i * input_size
    end_idx = start_idx + input_size
    neuron_weights = w_in_hidden[start_idx:end_idx]

    hex_file = os.path.join(HEX_OUTPUT_DIR, f"hidden_neuron_{i+1}.hex")
    with open(hex_file, "w") as f:
        for w in neuron_weights:
            hex_str = format(np.uint32(w) & 0xFFFFFFFF, '08X')
            f.write(hex_str + "\n")
    print(f"Created {hex_file} with {len(neuron_weights)} weights.")

# -----------------------------
# Output layer hex files (3 neurons)
# Each neuron has 32 weights (hidden_size)
output_size = 3

for i in range(output_size):
    start_idx = i * hidden_size
    end_idx = start_idx + hidden_size
    neuron_weights = w_hidden_out[start_idx:end_idx]

    hex_file = os.path.join(HEX_OUTPUT_DIR, f"output_neuron_{i+1}.hex")
    with open(hex_file, "w") as f:
        for w in neuron_weights:
            hex_str = format(np.uint32(w) & 0xFFFFFFFF, '08X')
            f.write(hex_str + "\n")
    print(f"Created {hex_file} with {len(neuron_weights)} weights.")

print(f"Total hex files created: {hidden_size + output_size}")
