# Combine CheckM2 quality reports across samples
# Output columns: Sample, Name, Completeness, Contamination, ... (comma-separated)

rule combine_checkm2:
    input:
        expand(
            "results/binning/checkm2/{sample}/quality_report.tsv",
            sample=SAMPLES
        )
    output:
        "results/binning/checkm2/CheckM2_all_samples.csv"
    shell:
        """
        first=1

        for report in {input}; do
            sample=$(basename $(dirname "$report"))

            if [ "$first" -eq 1 ]; then
                head -n 1 "$report" | tr '\\t' ',' | sed 's/^/Sample,/' > {output}
                first=0
            fi

            tail -n +2 "$report" | tr '\\t' ',' | \
                awk -v sample="$sample" '{{print sample "," $0}}' \
                >> {output}
        done
        """
