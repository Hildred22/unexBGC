# BiG-SCAPE BGC clustering rules for unexBGC

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
    shell:
        """
        mkdir -p results/bgc/bigscape

        bigscape cluster \
            -i {params.antismash_dir} \
            -o {output} \
            -p {params.pfam} \
            -c {threads} \
            -m 4.0 \
            --gcf-cutoffs 0.3,0.7 \
            --mix
        """
