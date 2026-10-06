# Metagenome assembly rules for unexBGC

SAMPLES = samples["sample"].tolist()


# MEGAHIT metagenome assembly

rule megahit:
    input:
        r1="results/qc/trimmed/{sample}_trimmed.R1.fastq.gz",
        r2="results/qc/trimmed/{sample}_trimmed.R2.fastq.gz"
    output:
        contigs="results/assembly/megahit/{sample}/final.contigs.fa"
    threads:
        config["threads"]["megahit"]
    shell:
        """
        mkdir -p results/assembly/megahit/{wildcards.sample}

        megahit \
            -1 {input.r1} \
            -2 {input.r2} \
            --presets meta-sensitive \
            --min-contig-len 1500 \
            --k-min 27 \
            --k-max 127 \
            --k-step 10 \
            -t {threads} \
            -o results/assembly/megahit/{wildcards.sample}
        """
#Rename assemblies to their specific sample identifiers
rule rename_megahit_contigs:
    input:
        "results/assembly/megahit/{sample}/final.contigs.fa"
    output:
        "results/assembly/megahit/{sample}/{sample}.fa"
    shell:
        """
        mv {input} {output}
        """
