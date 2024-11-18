#!/usr/bin/env python3

import os
import pandas as pd
import argparse

# Function to combine regression results into a single file
# Input: input_dir (directory containing regression results), output_file (output combined CSV file)
# Output: CSV file with combined regression results
def combine_results(input_dir, output_file):
    result_files = []
    for f in os.listdir(input_dir):
        if f.endswith("_regression_results.csv"):
            result_files.append(f)
    all_results = []
    for file in result_files:
        result_file = os.path.join(input_dir, file)
        df = pd.read_csv(result_file)
        all_results.append(df)

    combined_df = pd.concat(all_results, ignore_index=True)
    combined_df.to_csv(output_file, index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Combine regression results into a single file")
    parser.add_argument('--input', type=str, required=True, help="Directory containing regression results")
    parser.add_argument('--output', type=str, required=True, help="Output combined CSV file")
    
    args = parser.parse_args()
    combine_results(args.input, args.output)
    