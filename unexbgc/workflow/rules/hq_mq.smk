# High quality and medium quality MAG selection rules for unexBGC
# HQ: completeness >= 90% and contamination <= 5%
# MQ: completeness >= 50% and contamination <= 10%

rule select_hq_mq:
    input:
        checkm2="results/binning/checkm2/CheckM2_all_samples.csv",
        bins=expand("results/binning/dastool/{sample}", sample=SAMPLES)
    output:
        directory("results/binning/hq_mq")
    shell:
        """
        python workflow/scripts/select_hq_mq.py \
            --checkm2 {input.checkm2} \
            --bins results/binning/dastool \
            --output {output}
        """
