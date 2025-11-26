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

if __name__ == "__main__":
    unzip_all(ZIP_DIR, EXTRACT_DIR)
    file_path = "extracted_data/sr_dataset_gt/sr_dataset_h5/1.h5"
    print_hdf5_tree(file_path)
    plot_hdf5_timeseries(file_path, "Euler_imu", "ts", ["x", "y", "z"])
    plot_hdf5_timeseries(file_path, "angular_rate_imu", "ts", ["x", "y", "z"])

