# MetaBAT2 metagenomic binning rules for unexBGC

rule metabat2:
    input:
        contigs="results/assembly/megahit/{sample}/{sample}.fa",
        depth="results/mapping/depth/{sample}_depth.txt"
    output:
        directory("results/binning/metabat2/{sample}")
    threads:
        config["threads"]["metabat2"]
    log:
        "logs/metabat2/{sample}.log"
    conda:
        "../envs/binning.yaml"
    shell:
        """
        mkdir -p {output}

        metabat2 \
            -i {input.contigs} \
            -a {input.depth} \
            -o {output}/bin \
            -t {threads} \
            -m 1500 > {log} 2>&1
        """
