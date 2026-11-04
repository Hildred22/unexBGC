# De novo phylogenetic tree rules for unexBGC (GTDB-Tk identify/align + FastTree)
# Bacterial (bac120) and archaeal (ar53) trees are built separately.

rule gtdbtk_identify_denovo:
    input:
        genomes="results/binning/drep/dereplicated"
    output:
        directory("results/taxonomy/denovo/identify")
    threads:
        config["threads"]["gtdbtk"]
    params:
        data=config["gtdbtk_db"]
    log:
        "logs/gtdbtk/identify.log"
    conda:
        "../envs/gtdbtk.yaml"
    shell:
        """
        export GTDBTK_DATA_PATH="{params.data}"

        gtdbtk identify \
            --genome_dir {input.genomes}/dereplicated_genomes \
            --out_dir {output} \
            --extension fa \
            --cpus {threads} > {log} 2>&1
        """


rule gtdbtk_align_denovo:
    input:
        "results/taxonomy/denovo/identify"
    output:
        directory("results/taxonomy/denovo/align")
    threads:
        config["threads"]["gtdbtk"]
    params:
        data=config["gtdbtk_db"]
    log:
        "logs/gtdbtk/align.log"
    conda:
        "../envs/gtdbtk.yaml"
    shell:
        """
        export GTDBTK_DATA_PATH="{params.data}"

        gtdbtk align \
            --identify_dir {input} \
            --out_dir {output} \
            --cpus {threads} > {log} 2>&1
        """


rule fasttree_bacteria:
    input:
        "results/taxonomy/denovo/align"
    output:
        "results/taxonomy/denovo/bacteria_denovo.nwk"
    conda:
        "../envs/gtdbtk.yaml"
    shell:
        """
        f=$(find {input} -name "gtdbtk.bac120.user_msa.fasta.gz" | head -1)

        if [ -n "$f" ]; then
            zcat $f | FastTree -wag -gamma > {output}
        else
            touch {output}
        fi
        """


rule fasttree_archaea:
    input:
        "results/taxonomy/denovo/align"
    output:
        "results/taxonomy/denovo/archaea_denovo.nwk"
    conda:
        "../envs/gtdbtk.yaml"
    shell:
        """
        f=$(find {input} -name "gtdbtk.ar53.user_msa.fasta.gz" | head -1)

        if [ -n "$f" ]; then
            zcat $f | FastTree -wag -gamma > {output}
        else
            touch {output}
        fi
        """


rule denovo_tree_complete:
    input:
        "results/taxonomy/denovo/bacteria_denovo.nwk",
        "results/taxonomy/denovo/archaea_denovo.nwk"
    output:
        touch("results/taxonomy/denovo/.complete")
