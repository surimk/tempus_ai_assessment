nextflow.enable.dsl = 2

// publishDir set with publish_dir param and timestamp
params.out_dir = "${params.publish_dir}/${new Date().format('yyyyMMdd_HHmmss')}"

process SLICE {
    publishDir params.out_dir, mode: 'copy' 
    errorStrategy 'retry'
    maxRetries 3
    cpus 1
    memory { 2.GB * (task.attempt ?: 1) }  // Increase memory by 2GB for each retry (for larger datasets)

    input:
    path dataset
    val slice_by

    output:
    path "sliced_data/*"

    script:
    """
    slice.py --input ${dataset} --slice_by ${slice_by} --output sliced_data/
    """
}

process REGRESSION {
    publishDir params.out_dir, mode: 'copy'
    errorStrategy 'retry'
    maxRetries 3
    cpus 1
    memory { 2.GB * (task.attempt ?: 1) } 

    input:
    tuple path(sliced_data), val(features), val(target)
    
    output:
    path "regression_result/*"

    script:
    """
    regression.py --input ${sliced_data} --features ${features.join(',')} --target ${target} --output regression_result/
    """
}

process COMBINE {
    publishDir params.out_dir, mode: 'copy'
    errorStrategy 'retry'
    maxRetries 3
    cpus 1
    memory { 2.GB * (task.attempt ?: 1) } 

    input:
    path regression_results

    output:
    path 'combined_results.csv'

    script:
    """
    mkdir -p regression_results
    cp ${regression_results} regression_results/
    combine.py --input regression_results --output combined_results.csv
    """
}

workflow {
    // Slice the dataset based on slice_by parameter and store as channel
    sliced_ch = SLICE(params.dataset, params.slice_by)
    // Map output of sliced_ch into sliced_data path of the regression_input_ch tuple
    regression_input_ch = sliced_ch
                            .flatMap { it } 
                            .map { sliced_data -> tuple(sliced_data, params.features, params.target)}
    // Fit the regression models for each slice in parallel
    REGRESSION(regression_input_ch)
    // Collect regression process's output paths into a single list to be passed as a single COMBINE process
    COMBINE(REGRESSION.out.collect())
}
