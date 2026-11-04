# GTDB-Tk taxonomic classification rules for unexBGC

rule gtdbtk:
    input:
        genomes="results/binning/drep/dereplicated"
    output:
        directory("results/taxonomy/gtdbtk")
    threads:
        config["threads"]["gtdbtk"]
    params:
        data=config["gtdbtk_db"]
    log:
        "logs/gtdbtk/classify_wf.log"
    conda:
        "../envs/gtdbtk.yaml"
    shell:
        """
        export GTDBTK_DATA_PATH="{params.data}"

        gtdbtk classify_wf \
            --genome_dir {input.genomes}/dereplicated_genomes \
            --out_dir {output} \
            --extension fa \
            --skip_ani_screen \
            --cpus {threads} \
            --pplacer_cpus {threads} > {log} 2>&1
        """
