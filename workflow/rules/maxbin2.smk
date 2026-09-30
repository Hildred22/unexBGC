# MaxBin2 metagenomic binning rules for unexBGC

rule maxbin2:
    input:
        contigs="results/assembly/megahit/{sample}/final.contigs.fa",
        bam="results/mapping/bam/{sample}.sorted.bam"
    output:
        directory("results/binning/maxbin2/{sample}")
    threads:
        config["threads"]["maxbin2"]
    shell:
        """
        mkdir -p results/binning/maxbin2/{wildcards.sample}

        samtools sort \
            -n \
            -@ {threads} \
            -o results/binning/maxbin2/{wildcards.sample}/reads.namesorted.bam \
            {input.bam}

        jgi_summarize_bam_contig_depths \
            --outputDepth results/binning/maxbin2/{wildcards.sample}/depth.txt \
            {input.bam}

        run_MaxBin.pl \
            -contig {input.contigs} \
            -out results/binning/maxbin2/{wildcards.sample}/maxbin \
            -abund results/binning/maxbin2/{wildcards.sample}/depth.txt \
            -thread {threads}
        """
