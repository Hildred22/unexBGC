# MaxBin2 metagenomic binning rules for unexBGC

rule maxbin2:
    input:
        contigs="results/assembly/megahit/{sample}/final.contigs.fa",
        abund="results/mapping/depth/{sample}_maxbin_abund.txt"
    output:
        directory("results/binning/maxbin2/{sample}")
    threads:
        config["threads"]["maxbin2"]
    shell:
        """
        mkdir -p results/binning/maxbin2/{wildcards.sample}

        run_MaxBin.pl \
            -contig {input.contigs} \
            -abund {input.abund} \
            -out results/binning/maxbin2/{wildcards.sample}/bin \
            -min_contig_length 1500 \
            -thread {threads}
        """
