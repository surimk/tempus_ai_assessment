WITH diseased_frequencies AS (
    SELECT
        variant_id,
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM patients WHERE disease_status = 'diseased') AS diseased_frequency
    FROM
        patients
    WHERE
        disease_status = 'diseased'
    GROUP BY
        variant_id
),
healthy_frequencies AS (
    SELECT
        variant_id,
        COUNT(*) * 1.0 / (SELECT COUNT(*) FROM patients WHERE disease_status = 'healthy') AS healthy_frequency
    FROM
        patients
    WHERE
        disease_status = 'healthy'
    GROUP BY
        variant_id
)
SELECT
    df.variant_id,
    df.diseased_frequency,
    hf.healthy_frequency,
    ABS(
        (CASE WHEN df.diseased_frequency IS NOT NULL THEN df.diseased_frequency ELSE 0 END) -
        (CASE WHEN hf.healthy_frequency IS NOT NULL THEN hf.healthy_frequency ELSE 0 END)
    ) AS frequency_difference
FROM
    diseased_frequencies df
FULL OUTER JOIN
    healthy_frequencies hf
ON
    df.variant_id = hf.variant_id
ORDER BY
    frequency_difference DESC
LIMIT 5
