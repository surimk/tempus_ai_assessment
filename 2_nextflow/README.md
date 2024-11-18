### 2. Write a Dockerized pipeline in Nextflow with DSL2 syntax that takes a stock data set (e.g. iris, mtcars, palmer penguins), slices it by some relevant variable, fits a simple regression model on each slice, and then combines these models into a single table. The slicing, fitting, and combining should be distinct Nextflow processes, and fitting the regression should be done on each slice in parallel. We are primarily interested in seeing how you approach building a pipeline that could scale beyond a toy data set.

This workflow has been tested on Nextflow Version 24.10.0 

First, `cd` into `2_nextflow` directory, as this will be the project directory.

Then, build the Docker image by running this command:
```
docker build . -t tempus_nextflow_reg:0.1.0
```

Run nextflow pipeline with `local` profile:
```
nextflow run . -profile local
```
There are other profiles in `nextflow.config` to test out (`slice_test1`,`slice_test2`, and `feat_test`)

Check outputs in `output` directory (marked by timestamp)

Palmer Penguins dataset has been chosen as the sample dataset
`penguin.csv` is downloaded from: https://gist.githubusercontent.com/slopp/ce3b90b9168f2f921784de84fa445651/raw/4ecf3041f0ed4913e7c230758733948bc561f434/penguins.csv