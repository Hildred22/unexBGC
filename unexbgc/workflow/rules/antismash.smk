# antiSMASH biosynthetic gene cluster identification rules for unexBGC
# antiSMASH is run per sample on the assembled contigs (contigs >= 1500 bp).

rule antismash:
    input:
        contigs="results/assembly/megahit/{sample}/{sample}.fa"
    output:
        directory("results/bgc/antismash/{sample}")
    threads:
        config["threads"]["antismash"]
    log:
        "logs/antismash/{sample}.log"
    conda:
        "../envs/antismash.yaml"
    shell:
        """
        antismash \
            {input.contigs} \
            --output-dir {output} \
            --cpus {threads} \
            --minlength 1500 \
            --genefinding-tool prodigal \
            --cc-mibig > {log} 2>&1
        """


rule antismash_complete:
    input:
        expand("results/bgc/antismash/{sample}", sample=SAMPLES)
    output:
        touch("results/bgc/antismash/.complete")
