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
    
    with h5py.File(file_path, 'r') as f:
        group = f[group_name]
        for dataset_name, dataset in group.items():
            data_array = dataset[:]
            save_path = os.path.join(save_dir, f"{group_name}_{dataset_name}.npy")
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
    file_path = "extracted_data/sr_dataset_gt/sr_dataset_h5/1.h5"
    print_hdf5_tree(file_path)
    plot_hdf5_timeseries(file_path, "Euler_imu", "ts", ["x", "y", "z"])
    plot_hdf5_timeseries(file_path, "angular_rate_imu", "ts", ["x", "y", "z"])
    plot_hdf5_timeseries(file_path, "gyro_static_unbiased", "ts", ["x", "y", "z"])
    plot_hdf5_timeseries(file_path, "position_OT", "ts", ["x", "y", "z"])
    plot_hdf5_timeseries(file_path, "vel_imu", "ts", ["x", "y", "z"])
    plot_hdf5_timeseries(file_path, "vel_over_height_imu", "ts", ["x", "y", "z"])
    save_hdf5_group_arrays(file_path, "events", save_dir="saved_arrays")
    save_hdf5_group_arrays(file_path, "Euler_imu", save_dir="saved_arrays")
    save_hdf5_group_arrays(file_path, "angular_rate_imu", save_dir="saved_arrays")
    save_hdf5_group_arrays(file_path, "gyro_static_unbiased", save_dir="saved_arrays")
    save_hdf5_group_arrays(file_path, "position_OT", save_dir="saved_arrays")
    save_hdf5_group_arrays(file_path, "vel_imu", save_dir="saved_arrays")
    save_hdf5_group_arrays(file_path, "vel_over_height_imu", save_dir="saved_arrays")
    ps = np.load("saved_arrays/events_ps.npy")
    xs = np.load("saved_arrays/events_xs.npy")
    ys = np.load("saved_arrays/events_ys.npy")
    ts = np.load("saved_arrays/events_ts.npy")
    true_count = count_true_in_array(ps)
    print("True events:", true_count)
    # Show first 1000 spikes as an image
    #plt.scatter(xs[:1000], ys[:1000], c=ps[:1000], cmap='gray')
    #plt.gca().invert_yaxis()
    #plt.show()
    dt = np.diff(ts)
    # Find first non-zero time difference
    #first_valid_index = np.where(dt > 0)[0][0] + 1
    #print("First valid time increment occurs at index:", first_valid_index)
    #print("Time difference at that point:", dt[first_valid_index-1])
    first_spike_ts = ts[3]
    print("events_ps",ps[:10])
    print("events_ts",ts[:10])
    print("events_xs",xs[:10])
    print("events_ys",ys[:10])
    ts = np.load("saved_arrays/vel_imu_ts.npy")
    xs = np.load("saved_arrays/vel_imu_x.npy")
    ys = np.load("saved_arrays/vel_imu_y.npy")
    zs = np.load("saved_arrays/vel_imu_z.npy")
    print("vel_imu_ts",ts[:10])
    print("vel_imu_x",xs[:10])
    print("vel_imu_y",ys[:10])
    print("vel_imu_z",zs[:10])
    print(first_spike_ts == ts[0])