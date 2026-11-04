# MaxBin2 metagenomic binning rules for unexBGC

rule maxbin2:
    input:
        contigs="results/assembly/megahit/{sample}/{sample}.fa",
        abund="results/mapping/depth/{sample}_maxbin_abund.txt"
    output:
        directory("results/binning/maxbin2/{sample}")
    threads:
        config["threads"]["maxbin2"]
    log:
        "logs/maxbin2/{sample}.log"
    conda:
        "../envs/binning.yaml"
    shell:
        """
        mkdir -p {output}

        run_MaxBin.pl \
            -contig {input.contigs} \
            -abund {input.abund} \
            -out {output}/bin \
            -min_contig_length 1500 \
            -thread {threads} > {log} 2>&1
        """
