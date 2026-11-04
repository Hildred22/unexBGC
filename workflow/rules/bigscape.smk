# BiG-SCAPE BGC clustering rules for unexBGC (written for BiG-SCAPE 2.0)
# Regions are compared with MIBiG 4.0 references at GCF cutoffs 0.3 and 0.7.

rule bigscape:
    input:
        antismash="results/bgc/antismash/.complete"
    output:
        directory("results/bgc/bigscape")
    threads:
        config["threads"]["bigscape"]
    params:
        pfam=config["bigscape_pfam"],
        antismash_dir="results/bgc/antismash"
    log:
        "logs/bigscape/bigscape.log"
    conda:
        "../envs/bigscape.yaml"
    shell:
        """
        bigscape cluster \
            -i {params.antismash_dir} \
            -o {output} \
            -p {params.pfam} \
            -c {threads} \
            --mibig-version 4.0 \
            --gcf-cutoffs 0.3,0.7 \
            --mix > {log} 2>&1
        """
