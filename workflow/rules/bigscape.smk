# BiG-SCAPE BGC clustering rules for unexBGC

rule bigscape:
    input:
        antismash="results/bgc/antismash"
    output:
        directory("results/bgc/bigscape")
    threads:
        24
    params:
        pfam=config["bigscape_pfam"]
    shell:
        """
        mkdir -p results/bgc/bigscape

        bigscape cluster \
            -i {input.antismash} \
            -o {output} \
            -p {params.pfam} \
            -c {threads} \
            -m 4.0 \
            --gcf-cutoffs 0.3,0.7 \
            --mix
        """
