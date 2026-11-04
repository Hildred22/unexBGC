# DAS Tool bin refinement rules for unexBGC (written for DAS Tool v1.1.x)


# Prepare contigs-to-bin tables for each binning method

rule dastool_prep:
    input:
        metabat2="results/binning/metabat2/{sample}",
        maxbin2="results/binning/maxbin2/{sample}",
        concoct="results/binning/concoct/{sample}/fasta_bins"
    output:
        metabat2="results/binning/dastool_helper/{sample}/{sample}_metabat2.contigs2bin.tsv",
        maxbin2="results/binning/dastool_helper/{sample}/{sample}_maxbin2.contigs2bin.tsv",
        concoct="results/binning/dastool_helper/{sample}/{sample}_concoct.contigs2bin.tsv"
    conda:
        "../envs/dastool.yaml"
    shell:
        """
        Fasta_to_Contig2Bin.sh -i {input.metabat2} -e fa > {output.metabat2}
        Fasta_to_Contig2Bin.sh -i {input.maxbin2} -e fasta > {output.maxbin2}
        Fasta_to_Contig2Bin.sh -i {input.concoct} -e fa > {output.concoct}
        """


# Refine bins using DAS Tool
# Refined bins are written to results/binning/dastool/{sample}/{sample}_DASTool_bins/

rule dastool:
    input:
        contigs="results/assembly/megahit/{sample}/{sample}.fa",
        metabat2="results/binning/dastool_helper/{sample}/{sample}_metabat2.contigs2bin.tsv",
        maxbin2="results/binning/dastool_helper/{sample}/{sample}_maxbin2.contigs2bin.tsv",
        concoct="results/binning/dastool_helper/{sample}/{sample}_concoct.contigs2bin.tsv"
    output:
        directory("results/binning/dastool/{sample}")
    params:
        db=f"--dbDirectory {config['dastool_db']}" if config.get("dastool_db") else ""
    threads:
        config["threads"]["dastool"]
    log:
        "logs/dastool/{sample}.log"
    conda:
        "../envs/dastool.yaml"
    shell:
        """
        mkdir -p {output}

        DAS_Tool \
            -i {input.metabat2},{input.maxbin2},{input.concoct} \
            -l metabat2,maxbin2,concoct \
            -c {input.contigs} \
            -o {output}/{wildcards.sample} \
            --search_engine diamond \
            {params.db} \
            --write_bins \
            -t {threads} > {log} 2>&1
        """
