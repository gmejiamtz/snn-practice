import glob
import h5py
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim

# -------------------------------
# 1. Parameters
# -------------------------------
data_folder = 'extracted_data/sr_dataset_gt/sr_dataset_h5/'
input_size = 6    # Euler + Position axes: x,y,z
hidden_size = 32
output_size = 3   # vel_imu x,y,z
epochs = 200
learning_rate = 1e-3
q_fixed = 16      # Q16.16 fixed-point

# -------------------------------
# 2. Load & preprocess HDF5 files
# -------------------------------
file_list = glob.glob(f'{data_folder}/*.h5')
inputs_list = []
targets_list = []

for file_path in file_list:
    with h5py.File(file_path, 'r') as f:
        # Input: Euler IMU
        euler_x = f['Euler_imu/x'][:]
        euler_y = f['Euler_imu/y'][:]
        euler_z = f['Euler_imu/z'][:]
        # Input: Position
        pos_x = f['position_OT/x'][:]
        pos_y = f['position_OT/y'][:]
        pos_z = f['position_OT/z'][:]

        # Output: vel_imu
        vel_x = f['vel_imu/x'][:]
        vel_y = f['vel_imu/y'][:]
        vel_z = f['vel_imu/z'][:]

        # Encode 6 input neurons (signed values)
        inputs = np.stack([
            euler_x, euler_y, euler_z,
            pos_x, pos_y, pos_z
        ], axis=1)

        # Encode 3 output neurons (signed values)
        targets = np.stack([
            vel_x, vel_y, vel_z
        ], axis=1)

        inputs_list.append(inputs)
        targets_list.append(targets)

# Concatenate all files
X_np = np.vstack(inputs_list)
Y_np = np.vstack(targets_list)

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
# 3. Define a simple feedforward SNN-like network
# -------------------------------
class SNNLikeNet(nn.Module):
    def __init__(self, input_size=6, hidden_size=32, output_size=3):
        super().__init__()
        self.fc1 = nn.Linear(input_size, hidden_size, bias=False)  # Input -> Hidden
        self.fc2 = nn.Linear(hidden_size, output_size, bias=False) # Hidden -> Output

    def forward(self, x):
        h = torch.relu(self.fc1(x))   # hidden layer (ReLU approximates spiking behavior)
        out = self.fc2(h)             # output layer
        return out

model = SNNLikeNet(input_size, hidden_size, output_size)

# -------------------------------
# 4. Train network
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
        print(f"Epoch {epoch}, Loss: {loss.item()}")

# -------------------------------
# 5. Convert weights to Q16.16 fixed-point
# -------------------------------
def float_to_fixed(arr, q=16):
    return np.round(arr * (2**q)).astype(np.int32)

# fc1: input -> hidden
w_in_hidden = model.fc1.weight.detach().numpy()       # shape (32,6)
# fc2: hidden -> output
w_hidden_out = model.fc2.weight.detach().numpy()      # shape (3,32)

w_in_hidden_fixed = float_to_fixed(w_in_hidden, q_fixed)
w_hidden_out_fixed = float_to_fixed(w_hidden_out, q_fixed)

# Flatten for FPGA BRAM loading
w_in_hidden_flat = w_in_hidden_fixed.flatten()
w_hidden_out_flat = w_hidden_out_fixed.flatten()

print("Input->Hidden weights shape:", w_in_hidden_fixed.shape)
print("Hidden->Output weights shape:", w_hidden_out_fixed.shape)
print("Flattened sizes:", len(w_in_hidden_flat), len(w_hidden_out_flat))

# Save weights for FPGA
np.save('weights_in_hidden.npy', w_in_hidden_flat)
np.save('weights_hidden_out.npy', w_hidden_out_flat)
print("Weights saved for FPGA transfer.")
