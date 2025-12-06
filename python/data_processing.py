#!/usr/bin/env python3
import os
import zipfile
import h5py
import hdf5plugin
import matplotlib.pyplot as plt
import numpy as np
import pdb

ZIP_DIR = "downloaded_data"
EXTRACT_DIR = "extracted_data"
SAVED_DIR = "saved_arrays"
GROUPS_TO_SAVE = ["Euler_imu", "position_OT", "vel_imu"]

def unzip_all(zip_dir, extract_dir):
    os.makedirs(extract_dir, exist_ok=True)

    for filename in os.listdir(zip_dir):
        if filename.lower().endswith(".zip"):
            zip_path = os.path.join(zip_dir, filename)
            # Use a subfolder named after the zip file
            subfolder = os.path.join(extract_dir, os.path.splitext(filename)[0])
            
            if os.path.exists(subfolder):
                print(f"Skipping {filename}: {subfolder} already exists.")
                continue

            print(f"Extracting {filename} to {subfolder}...")
            os.makedirs(subfolder, exist_ok=True)
            with zipfile.ZipFile(zip_path, 'r') as zip_ref:
                zip_ref.extractall(subfolder)
            print(f"Finished extracting {filename}\n")

def print_hdf5_tree(file_path):
    """
    Prints the hierarchy (groups and datasets) of an HDF5 file.
    
    Args:
        file_path (str): Path to the HDF5 file
    """
    def print_item(name, obj):
        if isinstance(obj, h5py.Dataset):
            print(f"Dataset: {name} | shape: {obj.shape} | dtype: {obj.dtype}")
        elif isinstance(obj, h5py.Group):
            print(f"Group: {name}")
    
    with h5py.File(file_path, 'r') as f:
        print(f"HDF5 file: {file_path}")
        f.visititems(print_item)

def plot_hdf5_timeseries(file_path, group_name, dataset_x, dataset_y):
    """
    Plot a timeseries dataset from an HDF5 file.

    Args:
        file_path (str): path to HDF5 file
        group_name (str): name of group, e.g. 'Euler_imu'
        dataset_x (str): name of dataset for x-axis (usually time)
        dataset_y (str or list of str): dataset(s) to plot on y-axis
    """
    if isinstance(dataset_y, str):
        dataset_y = [dataset_y]

    with h5py.File(file_path, 'r') as f:
        x = f[f"{group_name}/{dataset_x}"][:]
        plt.figure(figsize=(10, 6))
        for y_name in dataset_y:
            y = f[f"{group_name}/{y_name}"][:]
            plt.plot(x, y, label=y_name)
        plt.xlabel(dataset_x)
        plt.ylabel("Value")
        plt.title(f"{group_name}: {', '.join(dataset_y)} vs {dataset_x}")
        plt.legend()
        plt.grid(True)
        plt.show()

def save_hdf5_group_arrays(file_path, group_name, save_dir="saved_arrays"):
    """
    Save all datasets in a given HDF5 group to separate .npy files.
    
    Args:
        file_path (str): Path to the HDF5 file
        group_name (str): Name of the group to save, e.g. 'events'
        save_dir (str): Directory where .npy files will be saved
    """
    import os
    os.makedirs(save_dir, exist_ok=True)
    file_base = os.path.splitext(os.path.basename(file_path))[0]
    with h5py.File(file_path, 'r') as f:
        group = f[group_name]
        for dataset_name, dataset in group.items():
            data_array = dataset[:]
            save_path = os.path.join(save_dir, f"{group_name}_{dataset_name}_{file_base}.npy")
            np.save(save_path, data_array)
            print(f"Saved {group_name}/{dataset_name} -> {save_path}")

def count_true_in_array(arr: np.ndarray) -> int:
    """
    Count how many True values are in a numpy boolean array.

    Args:
        arr (np.ndarray): Input array (expected dtype=bool)

    Returns:
        int: Number of True entries
    """
    if arr.dtype != np.bool_:
        print("Warning: array is not boolean, converting to bool.")
        arr = arr.astype(bool)
    
    return np.count_nonzero(arr)

if __name__ == "__main__":
    unzip_all(ZIP_DIR, EXTRACT_DIR)
    train_data_path = f"{EXTRACT_DIR}/sr_dataset_gt/sr_dataset_train"
    for filename in os.listdir(train_data_path):
        if filename.endswith(".h5"):
            save_hdf5_group_arrays(f"{train_data_path}/{filename}", GROUPS_TO_SAVE[0],save_dir=f"{SAVED_DIR}/{GROUPS_TO_SAVE[0]}")
            save_hdf5_group_arrays(f"{train_data_path}/{filename}", GROUPS_TO_SAVE[1],save_dir=f"{SAVED_DIR}/{GROUPS_TO_SAVE[1]}")
            save_hdf5_group_arrays(f"{train_data_path}/{filename}", GROUPS_TO_SAVE[2],save_dir=f"{SAVED_DIR}/{GROUPS_TO_SAVE[2]}")