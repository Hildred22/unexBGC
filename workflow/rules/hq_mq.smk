# MAG quality filtering rules for unexBGC

rule select_hq_mq:
    input:
        results="results/binning/checkm2/{sample}/quality_report.tsv",
        bins="results/binning/dastool/{sample}"
    output:
        directory("results/binning/hq_mq/{sample}")
    shell:
        """
        mkdir -p results/binning/hq_mq/{wildcards.sample}

        python workflow/scripts/select_hq_mq.py \
            --checkm2 {input.results} \
            --bins {input.bins} \
            --output {output}
        """
