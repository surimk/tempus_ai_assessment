## 4B. SQL/GBQ Challenge 2: Analyzing Genomic Data for Gene Expression
### Background:
#### You are working on a bioinformatics platform that analyzes genomic data and you wish to find gene-level expression values in log2(TPM+1) from transcript-level count data (TPM), where TPM = Transcript per Million.
### Dataset:
#### You have three target tables in your BigQuery dataset:
##### ● transcripts:
##### ○ patient_id (STRING): Unique identifier for the patient.
##### ○ transcript_code (STRING): Unique Ensembl identifier for a given transcript (of
##### type ENST00000505931).
##### ○ transcript_tpm (NUMERIC/FLOAT/DECIMAL): Transcript per million (TPM) value
##### for a given transcript.
##### ● transcript_gene_map:
##### ○ ensembl_gene_id (STRING): Unique Ensembl identifier for a given transcript (of type ENSG00000205765).
##### ○ trasnscript_code (STRING): Unique Ensembl identifier for a given transcript (of type ENST00000505931).
##### ● ensembl_gene_map:
##### ○ gene_symbol (STRING): Unique identifier for HUGO gene name (of type RIMOC1)
##### ○ chromosome (VCHAR): Chromosome location of gene (of type 5p13.1)
##### ○ ensembl_gene_id (STRING): Unique Ensembl identifier for a given transcript (of type ENSG00000205765).
### Task:
#### Write a SQL query to aggregate all transcript TPM values to a gene-level log2(TPM+1) output for every unique gene in every unique patient.
#### The query should return the following columns:
##### ● patient_id: The unique identifier for each patient.
##### ● gene_symbol: The Hugo symbol for each gene.
##### ● log2(TPM+1): The log2(TPM+1) expression level for each gene.
#### Notes:
##### ● Ensure that your query handles cases where there may be a single transcript for a given gene.
##### ● Ensure that your query handles cases where there may be a null value(s) for transcript_tpm.
