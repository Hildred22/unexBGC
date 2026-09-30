# CONCOCT metagenomic binning rules for unexBGC

rule concoct_cut_up:
    input:
        contigs="results/assembly/megahit/{sample}/final.contigs.fa"
    output:
        contigs="results/binning/concoct/{sample}/contigs_10K.fa",
        bed="results/binning/concoct/{sample}/contigs_10K.bed"
    shell:
        """
        mkdir -p results/binning/concoct/{wildcards.sample}

        cut_up_fasta.py \
            {input.contigs} \
            -c 10000 \
            -o 0 \
            --merge_last \
            -b {output.bed} \
            > {output.contigs}
        """


rule concoct_coverage:
    input:
        bed="results/binning/concoct/{sample}/contigs_10K.bed",
        bam="results/mapping/bam/{sample}.sorted.bam"
    output:
        "results/binning/concoct/{sample}/coverage_table.tsv"
    shell:
        """
        concoct_coverage_table.py \
            {input.bed} \
            {input.bam} \
            > {output}
        """


rule concoct:
    input:
        contigs="results/binning/concoct/{sample}/contigs_10K.fa",
        coverage="results/binning/concoct/{sample}/coverage_table.tsv"
    output:
        bins=directory("results/binning/concoct/{sample}/bins")
    threads:
        config["threads"]["concoct"]
    shell:
        """
        mkdir -p {output.bins}

        concoct \
            --composition_file {input.contigs} \
            --coverage_file {input.coverage} \
            --threads {threads} \
            --basename {wildcards.sample}_concoct \
            --output_path {output.bins}
        """
