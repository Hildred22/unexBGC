# Assembly quality assessment rules for unexBGC


# QUAST assessment of MEGAHIT assemblies

rule quast:
    input:
        contigs="results/assembly/megahit/{sample}/{sample}.fa"
    output:
        report="results/assembly/quast/{sample}/report.html"
    threads:
        config["threads"]["quast"]
    log:
        "logs/quast/{sample}.log"
    conda:
        "../envs/assembly.yaml"
    shell:
        """
        quast.py \
            {input.contigs} \
            -o results/assembly/quast/{wildcards.sample} \
            -t {threads} > {log} 2>&1
        """
