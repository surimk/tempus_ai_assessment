nextflow.enable.dsl = 2

// publishDir set with publish_dir param and timestamp
params.out_dir = "${params.publish_dir}/${new Date().format('yyyyMMdd_HHmmss')}"

process SLICE {
    publishDir params.out_dir, mode: 'copy' 

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

workflow {
    // Slice the dataset based on slice_by parameter
    SLICE(params.dataset, params.slice_by)
}
