# Assembly quality assessment rules for unexBGC

SAMPLES = samples["sample"].tolist()


# QUAST assessment of MEGAHIT assemblies

rule quast:
    input:
        contigs="results/assembly/megahit/{sample}/{sample}.fa"
    output:
        report="results/assembly/quast/{sample}/report.html"
    threads:
        config["threads"]["quast"]
    shell:
        """
        mkdir -p results/assembly/quast/{wildcards.sample}

        quast.py \
            {input.contigs} \
            -o results/assembly/quast/{wildcards.sample} \
            -t {threads}
        """
