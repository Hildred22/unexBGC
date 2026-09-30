# GTDB-Tk taxonomic classification rules for unexBGC

rule gtdbtk:
    input:
        genomes=directory("results/binning/drep/dereplicated")
    output:
        directory("results/taxonomy/gtdbtk")
    threads:
        24
    params:
        data="/path/to/gtdbtk/database"
    shell:
        """
        mkdir -p results/taxonomy/gtdbtk

        gtdbtk classify_wf \
            --genome_dir {input.genomes} \
            --out_dir {output} \
            --extension fa \
            --cpus {threads} \
            --pplacer_cpus {threads}
        """
