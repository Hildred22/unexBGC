# Metagenome assembly rules for unexBGC


# MEGAHIT metagenome assembly
# MEGAHIT refuses to write into an existing directory, so it assembles into a
# temporary folder and the final contigs are renamed to {sample}.fa.

rule megahit:
    input:
        r1="results/qc/trimmed/{sample}_trimmed.R1.fastq.gz",
        r2="results/qc/trimmed/{sample}_trimmed.R2.fastq.gz"
    output:
        contigs="results/assembly/megahit/{sample}/{sample}.fa"
    params:
        tmpdir="results/assembly/megahit/{sample}/megahit_tmp"
    threads:
        config["threads"]["megahit"]
    log:
        "logs/megahit/{sample}.log"
    conda:
        "../envs/assembly.yaml"
    shell:
        """
        rm -rf {params.tmpdir}

        megahit \
            -1 {input.r1} \
            -2 {input.r2} \
            --presets meta-sensitive \
            --min-contig-len 1500 \
            --k-min 27 \
            --k-max 127 \
            --k-step 10 \
            -t {threads} \
            -o {params.tmpdir} > {log} 2>&1

        mv {params.tmpdir}/final.contigs.fa {output.contigs}
        mv {params.tmpdir}/log results/assembly/megahit/{wildcards.sample}/megahit.log
        rm -rf {params.tmpdir}
        """
