import os
import glob
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
import pdb
# -------------------------------
# Configuration
# -------------------------------
SAVED_DIR = "saved_arrays"       # directory holding group folders
BRAM_DIR = "bram_weights"        # directory to save FPGA weights
input_size = 6                    # Euler + Position axes (x,y,z)
hidden_size = 32
output_size = 3                   # vel_imu x,y,z
epochs = 200
learning_rate = 1e-3
q_fixed = 16                      # Q16.16 fixed-point

os.makedirs(BRAM_DIR, exist_ok=True)

# -------------------------------
# Helper to load .npy files from a directory
# -------------------------------
def load_group_data(group_dir, axes=["x", "y", "z"]):
    arrays = []
    for axis in axes:
        # Find npy files matching the axis
        files = glob.glob(os.path.join(group_dir, f"*_{axis}_*.npy"))
        files.sort()  # Ensure consistent order
        # Load and concatenate all files along time axis
        data_list = [np.load(f) for f in files]
        data = np.concatenate(data_list, axis=0)
        arrays.append(data)
    return np.stack(arrays, axis=1)  # shape: [timesteps, num_axes]

# -------------------------------
# Load input and target datasets
# -------------------------------
# Input layers: Euler_imu + position_OT
euler_data = load_group_data(os.path.join(SAVED_DIR, "Euler_imu"))
pos_data = load_group_data(os.path.join(SAVED_DIR, "position_OT"))
X_np = np.concatenate([euler_data, pos_data], axis=1)  # shape: [timesteps, 6]

# Target layer: vel_imu
Y_np = load_group_data(os.path.join(SAVED_DIR, "vel_imu"))  # shape: [timesteps, 3]

# Shuffle dataset
perm = np.random.permutation(X_np.shape[0])
X_np = X_np[perm]
Y_np = Y_np[perm]

# Convert to PyTorch tensors
X = torch.tensor(X_np, dtype=torch.float32)
Y = torch.tensor(Y_np, dtype=torch.float32)

print(f"Training samples: {X.shape[0]}")
print(f"Input shape: {X.shape}, Target shape: {Y.shape}")

# -------------------------------
# Define SNN-like feedforward network
# -------------------------------
class SNNLikeNet(nn.Module):
    def __init__(self, input_size=6, hidden_size=32, output_size=3):
        super().__init__()
        self.fc1 = nn.Linear(input_size, hidden_size, bias=False)
        self.fc2 = nn.Linear(hidden_size, output_size, bias=False)

    def forward(self, x):
        h = torch.relu(self.fc1(x))
        out = self.fc2(h)
        return out

model = SNNLikeNet(input_size, hidden_size, output_size)

# -------------------------------
# Train network
# -------------------------------
optimizer = optim.Adam(model.parameters(), lr=learning_rate)
loss_fn = nn.MSELoss()

for epoch in range(epochs):
    optimizer.zero_grad()
    y_pred = model(X)
    loss = loss_fn(y_pred, Y)
    loss.backward()
    optimizer.step()
    if epoch % 20 == 0:
        print(f"Epoch {epoch}, Loss: {loss.item():.6f}")

# -------------------------------
# Convert weights to Q16.16 fixed-point
# -------------------------------
def float_to_fixed(arr, q=16):
    return np.round(arr * (2**q)).astype(np.int32)

w_in_hidden = model.fc1.weight.detach().numpy()       # (hidden_size, input_size)
w_hidden_out = model.fc2.weight.detach().numpy()      # (output_size, hidden_size)

w_in_hidden_fixed = float_to_fixed(w_in_hidden, q_fixed)
w_hidden_out_fixed = float_to_fixed(w_hidden_out, q_fixed)

# Flatten for FPGA BRAM loading
w_in_hidden_flat = w_in_hidden_fixed.flatten()
w_hidden_out_flat = w_hidden_out_fixed.flatten()

# -------------------------------
# Save weights to BRAM_DIR
# -------------------------------
np.save(os.path.join(BRAM_DIR, "weights_in_hidden.npy"), w_in_hidden_flat)
np.save(os.path.join(BRAM_DIR, "weights_hidden_out.npy"), w_hidden_out_flat)
print("Weights saved to 'bram_weights' directory")
