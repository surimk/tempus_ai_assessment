SELECT 
    t.patient_id,
    egm.gene_symbol,
    LOG(SUM(t.transcript_tpm) + 1 ) / LOG(2) AS log2_tpm_plus_1
FROM 
    transcripts t
JOIN 
    transcript_gene_map tgm ON t.transcript_code = tgm.transcript_code
JOIN 
    ensembl_gene_map egm ON tgm.ensembl_gene_id = egm.ensembl_gene_id
WHERE
    t.transcript_tpm IS NOT NULL
GROUP BY 
    t.patient_id, 
    egm.gene_symbol
ORDER BY 
    t.patient_id, 
    egm.gene_symbol;
