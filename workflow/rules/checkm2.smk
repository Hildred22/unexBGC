# CheckM2 genome quality assessment rules for unexBGC

rule checkm2:
    input:
        bins="results/binning/dastool/{sample}"
    output:
        directory("results/binning/checkm2/{sample}")
    threads:
        config["threads"]["checkm2"]
    shell:
        """
        mkdir -p results/binning/checkm2/{wildcards.sample}

        checkm2 predict \
            --threads {threads} \
            --input {input.bins} \
            --extension fa \
            --output-directory results/binning/checkm2/{wildcards.sample}
        """
