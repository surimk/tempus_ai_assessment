#!/usr/bin/env python3

import pandas as pd
import argparse
import os

# Function to slice data by a chosen column
# Input: input_file (CSV file), slice_by (column to slice by), output_dir (directory to save sliced data)
def slice_data(input_file, slice_by, output_dir):
    
    df = pd.read_csv(input_file)
    os.makedirs(output_dir, exist_ok=True)
    
    for value in df[slice_by].unique():
        sliced_data = df[df[slice_by] == value]
        output_file = os.path.join(output_dir, f"{value}_data.csv")
        sliced_data.to_csv(output_file, index=False)
        print(f"Sliced data for {value} saved to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Slice data by a chosen column")
    parser.add_argument('--input', type=str, required=True, help="Input dataset CSV file")
    parser.add_argument('--slice_by', type=str, required=True, help="Column to slice by")
    parser.add_argument('--output', type=str, required=True, help="Directory to save sliced data")
    
    args = parser.parse_args()
    slice_data(args.input, args.slice_by, args.output)
