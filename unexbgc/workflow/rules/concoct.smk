# CONCOCT metagenomic binning rules for unexBGC


# Chop assembled contigs into 10 kb fragments

rule concoct_cut_up:
    input:
        contigs="results/assembly/megahit/{sample}/{sample}.fa"
    output:
        contigs="results/binning/concoct/{sample}/contigs_10K.fa",
        bed="results/binning/concoct/{sample}/contigs_10K.bed"
    conda:
        "../envs/concoct.yaml"
    shell:
        """
        cut_up_fasta.py \
            {input.contigs} \
            -c 10000 \
            -o 0 \
            --merge_last \
            -b {output.bed} \
            > {output.contigs}
        """


# Generate the CONCOCT coverage table

rule concoct_coverage:
    input:
        bed="results/binning/concoct/{sample}/contigs_10K.bed",
        bam="results/mapping/bam/{sample}.sorted.bam",
        bai="results/mapping/bam/{sample}.sorted.bam.bai"
    output:
        "results/binning/concoct/{sample}/coverage_table.tsv"
    conda:
        "../envs/concoct.yaml"
    shell:
        """
        concoct_coverage_table.py \
            {input.bed} \
            {input.bam} \
            > {output}
        """


# Run CONCOCT

rule concoct:
    input:
        contigs="results/binning/concoct/{sample}/contigs_10K.fa",
        coverage="results/binning/concoct/{sample}/coverage_table.tsv"
    output:
        clustering="results/binning/concoct/{sample}/clustering_gt1500.csv"
    threads:
        config["threads"]["concoct"]
    log:
        "logs/concoct/{sample}.log"
    conda:
        "../envs/concoct.yaml"
    shell:
        """
        concoct \
            --composition_file {input.contigs} \
            --coverage_file {input.coverage} \
            --length_threshold 1500 \
            -b results/binning/concoct/{wildcards.sample}/ \
            -t {threads} > {log} 2>&1
        """


# Merge fragment-level clustering back to original contigs

rule concoct_merge:
    input:
        clustering="results/binning/concoct/{sample}/clustering_gt1500.csv"
    output:
        "results/binning/concoct/{sample}/clustering_merged.csv"
    conda:
        "../envs/concoct.yaml"
    shell:
        """
        merge_cutup_clustering.py \
            {input.clustering} \
            > {output}
        """


# Extract individual CONCOCT bins as FASTA files

rule concoct_extract_bins:
    input:
        contigs="results/assembly/megahit/{sample}/{sample}.fa",
        clustering="results/binning/concoct/{sample}/clustering_merged.csv"
    output:
        directory("results/binning/concoct/{sample}/fasta_bins")
    conda:
        "../envs/concoct.yaml"
    shell:
        """
        mkdir -p {output}

        extract_fasta_bins.py \
            {input.contigs} \
            {input.clustering} \
            --output_path {output}
        """
