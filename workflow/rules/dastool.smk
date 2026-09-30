# DAS Tool bin refinement rules for unexBGC


# Prepare scaffolds-to-bin files for each binning method

rule dastool_prep:
    input:
        metabat2="results/binning/metabat2/{sample}",
        maxbin2="results/binning/maxbin2/{sample}",
        concoct="results/binning/concoct/{sample}/fasta_bins"
    output:
        metabat2="results/binning/dastool_helper/{sample}/{sample}_metabat2.scaffolds2bin.tsv",
        maxbin2="results/binning/dastool_helper/{sample}/{sample}_maxbin2.scaffolds2bin.tsv",
        concoct="results/binning/dastool_helper/{sample}/{sample}_concoct.scaffolds2bin.tsv"
    shell:
        """
        mkdir -p results/binning/dastool_helper/{wildcards.sample}

        Fasta_to_Scaffolds2Bin.sh \
            -i {input.metabat2} \
            -e fa \
            | awk '{{print $1 "\\t" $NF}}' \
            > {output.metabat2}

        Fasta_to_Scaffolds2Bin.sh \
            -i {input.maxbin2} \
            -e fasta \
            > {output.maxbin2}

        Fasta_to_Scaffolds2Bin.sh \
            -i {input.concoct} \
            -e fa \
            | awk '{{print $1 "\\t" $NF}}' \
            > {output.concoct}
        """


# Refine bins using DAS Tool

rule dastool:
    input:
        contigs="results/assembly/megahit/{sample}/final.contigs.fa",
        metabat2="results/binning/dastool_helper/{sample}/{sample}_metabat2.scaffolds2bin.tsv",
        maxbin2="results/binning/dastool_helper/{sample}/{sample}_maxbin2.scaffolds2bin.tsv",
        concoct="results/binning/dastool_helper/{sample}/{sample}_concoct.scaffolds2bin.tsv"
    output:
        directory("results/binning/dastool/{sample}")
    threads:
        config["threads"]["dastool"]
    shell:
        """
        mkdir -p results/binning/dastool/{wildcards.sample}

        DAS_Tool \
            -i {input.metabat2},{input.maxbin2},{input.concoct} \
            -l metabat2,maxbin2,concoct \
            -c {input.contigs} \
            -o results/binning/dastool/{wildcards.sample}/{wildcards.sample} \
            --search_engine diamond \
            --db_directory {config[dastool_db]} \
            --write_bins 1 \
            --debug \
            -t {threads}
        """
