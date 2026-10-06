# MetaBAT2 metagenomic binning rules for unexBGC

rule metabat2:
    input:
        contigs="results/assembly/megahit/{sample}/{sample}.fa",
        depth="results/mapping/depth/{sample}_depth.txt"
    output:
        directory("results/binning/metabat2/{sample}")
    threads:
        config["threads"]["metabat2"]
    shell:
        """
        mkdir -p results/binning/metabat2/{wildcards.sample}

        metabat2 \
            -i {input.contigs} \
            -a {input.depth} \
            -o results/binning/metabat2/{wildcards.sample}/bin \
            -t {threads} \
            -m 1500 \
            --unbinned
        """
