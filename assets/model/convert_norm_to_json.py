import numpy as np
import json
import os

# Update these paths to where your .npy files are located
x_mean_path = 'norm_mean.npy' # Assuming this is [5] shape for the 5 features
x_std_path = 'norm_std.npy'   # Assuming this is [5] shape for the 5 features

# Assuming you also have y_mean and y_std. If they are in the same or separate files, update accordingly.
# For example purposes, we assume they are scalars or arrays of shape [1].
y_mean_path = 'y_mean.npy'
y_std_path = 'y_std.npy'

def convert_to_json():
    # Load X norm
    if os.path.exists(x_mean_path) and os.path.exists(x_std_path):
        x_mean = np.load(x_mean_path).flatten().tolist()
        x_std = np.load(x_std_path).flatten().tolist()
    else:
        print("X norm files not found, using dummy data")
        x_mean = [0.0] * 5
        x_std = [1.0] * 5

    # Load Y norm
    if os.path.exists(y_mean_path) and os.path.exists(y_std_path):
        y_mean = float(np.load(y_mean_path).flatten()[0])
        y_std = float(np.load(y_std_path).flatten()[0])
    else:
        print("Y norm files not found, using dummy data")
        y_mean = 0.0
        y_std = 1.0

    data = {
        'x_mean': x_mean,
        'x_std': x_std,
        'y_mean': y_mean,
        'y_std': y_std
    }

    output_path = 'norm.json'
    with open(output_path, 'w') as f:
        json.dump(data, f, indent=2)
    
    print(f"Saved normalization config to {output_path}")
    print("Move this file to assets/model/norm.json in your Flutter project.")

if __name__ == '__main__':
    convert_to_json()
