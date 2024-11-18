#!/usr/bin/env python3

import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score
import argparse
import os

# Function to fit a regression model
# Input: input_file (CSV file), features (list of feature columns), target (target column), output_dir (directory to save results)
# Output: CSV file with regression results
def fit_regression(input_file, features, target, output_dir):
    
    df = pd.read_csv(input_file)
    # Drop rows with NaN values
    df = df.dropna()

    slice = os.path.splitext(os.path.basename(input_file))[0].replace('_data', '')

    # Split features by comma
    features = features.split(',')
    
    # Define the features (X) and target (y)
    X = df[features]
    y = df[target]

    # Split the data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Create and fit the regression model
    model = LinearRegression()
    model.fit(X_train, y_train)

    # Predict and calculate metrics
    y_pred = model.predict(X_test)
    mse = mean_squared_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)

    # Prepare the results
    results = {
        'Slice': slice,
        'Intercept': model.intercept_,
        'MSE': mse,
        'R2': r2
    }
    # Map feature names to coefficients with "Coef" suffix for headers
    for feature, coef in zip(features, model.coef_):
        results[f'{feature}_Coef'] = coef

    # Save the results
    os.makedirs(output_dir, exist_ok=True)
    result_file = os.path.join(output_dir, f"{slice}_regression_results.csv")
    pd.DataFrame([results]).to_csv(result_file, index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Fit regression model for a given slice")
    parser.add_argument('--input', type=str, required=True, help="Sliced data CSV file")
    parser.add_argument('--features', type=str, required=True, help="List of feature (x) columns")
    parser.add_argument('--target', type=str, required=True, help="Target (y) column for regression")
    parser.add_argument('--output', type=str, required=True, help="Directory to save regression results")
   
    args = parser.parse_args()
    fit_regression(args.input, args.features, args.target, args.output)
