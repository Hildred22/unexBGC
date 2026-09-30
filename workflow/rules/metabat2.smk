# MetaBAT2 metagenomic binning rules for unexBGC

rule metabat2:
    input:
        contigs="results/assembly/megahit/{sample}/final.contigs.fa",
        bam="results/mapping/bam/{sample}.sorted.bam"
    output:
        directory("results/binning/metabat2/{sample}")
    threads:
        config["threads"]["metabat2"]
    shell:
        """
        mkdir -p results/binning/metabat2/{wildcards.sample}

        jgi_summarize_bam_contig_depths \
            --outputDepth results/binning/metabat2/{wildcards.sample}/depth.txt \
            {input.bam}

        metabat \
            -i {input.contigs} \
            -a results/binning/metabat2/{wildcards.sample}/depth.txt \
            -o results/binning/metabat2/{wildcards.sample}/bin \
            -t {threads}
        """
