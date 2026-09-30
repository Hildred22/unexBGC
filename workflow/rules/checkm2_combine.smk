# Combine CheckM2 quality reports across samples

rule combine_checkm2:
    input:
        expand(
            "results/binning/checkm2/{sample}/quality_report.tsv",
            sample=samples["sample"].tolist()
        )
    output:
        "results/binning/checkm2/CheckM2_all_samples.tsv"
    shell:
        """
        first=1

        for report in {input}; do
            sample=$(basename $(dirname "$report"))

            if [ "$first" -eq 1 ]; then
                echo -e "Sample\\t$(head -n 1 "$report")" > {output}
                first=0
            fi

            tail -n +2 "$report" | \
                awk -v sample="$sample" '{{print sample "\\t" $0}}' \
                >> {output}
        done
        """
