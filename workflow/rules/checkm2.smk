# CheckM2 genome quality assessment rules for unexBGC

rule checkm2:
    input:
        bins="results/binning/dastool/{sample}"
    output:
        report="results/binning/checkm2/{sample}/quality_report.tsv"
    params:
        outdir="results/binning/checkm2/{sample}",
        db=f"--database_path {config['checkm2_db']}" if config.get("checkm2_db") else ""
    threads:
        config["threads"]["checkm2"]
    log:
        "logs/checkm2/{sample}.log"
    conda:
        "../envs/checkm2.yaml"
    shell:
        """
        checkm2 predict \
            --threads {threads} \
            --input {input.bins}/{wildcards.sample}_DASTool_bins \
            --extension fa \
            {params.db} \
            --force \
            --output-directory {params.outdir} > {log} 2>&1
        """
