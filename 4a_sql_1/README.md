## 4A. SQL/GBQ Challenge 1: Analyzing Genomic Data for Disease Association
### Background:
#### You are working on a bioinformatics platform that analyzes genomic data to find associations between genetic variants and diseases. You have access to a dataset containing information about genetic variants, patients, and their disease status.
### Dataset:
#### You have two tables in your BigQuery dataset: 
##### ● variants:
######  ○ variant_id (STRING): Unique identifier for the genetic variant.
######  ○ chromosome (STRING): Chromosome where the variant is located.
######  ○ position (INTEGER): Position on the chromosome.
######  ○ reference_allele (STRING): Reference allele.
######  ○ alternate_allele (STRING): Alternate allele.
##### ● patients:
######  ○ patient_id (STRING): Unique identifier for the patient.
######  ○ variant_id (STRING): Identifier for the genetic variant (foreign key to variants.variant_id).
######  ○ disease_status (STRING): Disease status of the patient ('diseased' or 'healthy').
#### Task:
#### Write a SQL query to identify the top 5 genetic variants that are most strongly associated with the disease. The association is measured by the difference in the frequency of the variant between diseased and healthy patients.
### Steps:
#### ● Calculate the frequency of each variant in diseased patients.
    ```
    WITH diseased_frequencies AS (
        SELECT
            variant_id,
            COUNT(*) * 1.0 / (SELECT COUNT(*) FROM patients WHERE disease_status = 'diseased') AS   diseased_frequency
        FROM
            patients
        WHERE
            disease_status = 'diseased'
        GROUP BY
            variant_id
    ),
    ```

#### ● Calculate the frequency of each variant in healthy patients.
    ```
    healthy_frequencies AS (
        SELECT
            variant_id,
            COUNT(*) * 1.0 / (SELECT COUNT(*) FROM patients WHERE disease_status = 'healthy') AS    healthy_frequency
        FROM
            patients
        WHERE
            disease_status = 'healthy'
        GROUP BY
            variant_id
    )
    ```
#### ● Compute the absolute difference in frequencies for each variant.
    ```
    SELECT
        df.variant_id,
        df.diseased_frequency,
        hf.healthy_frequency,
        ABS(
            df.diseased_frequency - hf.healthy_frequency
        ) AS frequency_difference
    FROM
        diseased_frequencies df
    JOIN
        healthy_frequencies hf
    ON
        df.variant_id = hf.variant_id
    ```
#### ● Return the top 5 variants with the highest absolute difference in frequencies.
    ```
    ORDER BY
        frequency_difference DESC
    LIMIT 5
    ```
### Expected Output:
#### The query should return the following columns:
##### ● variant_id: The unique identifier for the genetic variant.
##### ● diseased_frequency: The frequency of the variant in diseased patients.
##### ● healthy_frequency: The frequency of the variant in healthy patients.
##### ● frequency_difference: The absolute difference in frequencies between diseased and
##### healthy patients.
### Notes:
#### ● Ensure that your query handles cases where a variant might be present in only diseased or only healthy patients.
#### ● Consider edge cases where the number of patients is very small or where variants are extremely rare.