# antiSMASH biosynthetic gene cluster identification rules for unexBGC

rule antismash:
    input:
        contigs="results/assembly/megahit/{sample}/final.contigs.fa"
    output:
        directory("results/bgc/antismash/{sample}")
    threads:
        config["threads"]["antismash"]
    shell:
        """
        mkdir -p results/bgc/antismash/{wildcards.sample}

        antismash \
            {input.contigs} \
            --output-dir results/bgc/antismash/{wildcards.sample} \
            --cpus {threads} \
            --genefinding-tool prodigal \
            --cc-mibig
        """
