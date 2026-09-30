# Read mapping and depth calculation rules for unexBGC


# Build Bowtie2 index from the assembled contigs

rule bowtie2_build:
    input:
        contigs="results/assembly/megahit/{sample}/final.contigs.fa"
    output:
        index=multiext(
            "results/mapping/bowtie2/{sample}/index",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2"
        )
    shell:
        """
        mkdir -p results/mapping/bowtie2/{wildcards.sample}

        bowtie2-build \
            {input.contigs} \
            results/mapping/bowtie2/{wildcards.sample}/index
        """


# Map trimmed reads to the assembled contigs and generate depth files

rule bowtie2_map:
    input:
        r1="results/qc/trimmed/{sample}_trimmed.R1.fastq.gz",
        r2="results/qc/trimmed/{sample}_trimmed.R2.fastq.gz",
        index="results/mapping/bowtie2/{sample}/index.1.bt2"
    output:
        bam="results/mapping/bam/{sample}.sorted.bam",
        bai="results/mapping/bam/{sample}.sorted.bam.bai",
        depth="results/mapping/depth/{sample}_depth.txt",
        maxbin_abund="results/mapping/depth/{sample}_maxbin_abund.txt"
    threads:
        config["threads"]["bowtie2"]
    shell:
        """
        mkdir -p results/mapping/bam
        mkdir -p results/mapping/depth

        bowtie2 \
            -x results/mapping/bowtie2/{wildcards.sample}/index \
            -1 {input.r1} \
            -2 {input.r2} \
            -p {threads} \
            | samtools view -@ {threads} -bS - \
            | samtools sort -@ {threads} \
                -o {output.bam}

        samtools index {output.bam}

        jgi_summarize_bam_contig_depths \
            --outputDepth {output.depth} \
            {output.bam}

        tail -n +2 {output.depth} | \
            awk -F'\\t' '{{print $1"\\t"$3}}' \
            > {output.maxbin_abund}
        """
