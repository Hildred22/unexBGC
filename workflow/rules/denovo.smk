# De novo phylogenetic tree rules for unexBGC (GTDB-Tk identify/align + FastTree)

rule gtdbtk_identify_denovo:
    input:
        genomes="results/binning/drep/dereplicated"
    output:
        directory("results/taxonomy/denovo/identify")
    threads:
        24
    params:
        data=config["gtdbtk_db"]
    shell:
        """
        export GTDBTK_DATA_PATH="{params.data}"

        gtdbtk identify \
            --genome_dir {input.genomes} \
            --out_dir {output} \
            --extension fa \
            --cpus {threads}
        """
rule gtdbtk_align_denovo:
    input:
        "results/taxonomy/denovo/identify"
    output:
        directory("results/taxonomy/denovo/align")
    threads:
        24
    params:
        data=config["gtdbtk_db"]
    shell:
        """
        export GTDBTK_DATA_PATH="{params.data}"

        gtdbtk align \
            --identify_dir {input} \
            --out_dir {output} \
            --cpus {threads}
        """
rule fasttree_bacteria:
    input:
        "results/taxonomy/denovo/align"
    output:
        "results/taxonomy/denovo/bacteria_denovo.nwk"
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
    shell:
        """
        touch {output}
        """
