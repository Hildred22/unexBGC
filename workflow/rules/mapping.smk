# Read mapping rules for unexBGC

SAMPLES = samples["sample"].tolist()


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


# Map trimmed reads to the assembled contigs

rule bowtie2_map:
    input:
        r1="results/qc/trimmed/{sample}_trimmed.R1.fastq.gz",
        r2="results/qc/trimmed/{sample}_trimmed.R2.fastq.gz",
        index="results/mapping/bowtie2/{sample}/index.1.bt2"
    output:
        bam="results/mapping/bam/{sample}.sorted.bam"
    threads:
        config["threads"]["bowtie2"]
    shell:
        """
        mkdir -p results/mapping/bam

        bowtie2 \
            -x results/mapping/bowtie2/{wildcards.sample}/index \
            -1 {input.r1} \
            -2 {input.r2} \
            -p {threads} \
        | samtools view -bS - \
        | samtools sort -@ {threads} -o {output.bam}

        samtools index {output.bam}
        """
