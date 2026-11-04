# Quality assessment and control rules for unexBGC


def raw_read(wildcards, column):
    """Return the path to a raw read file listed in config/samples.tsv."""
    filename = samples.loc[samples["sample"] == wildcards.sample, column].iloc[0]
    return f"{config['input_dir']}/{filename}"


# FastQC quality assessment of raw paired-end reads
# Raw files are linked to a standard name so FastQC reports are predictable.

rule fastqc:
    input:
        r1=lambda wildcards: raw_read(wildcards, "read1"),
        r2=lambda wildcards: raw_read(wildcards, "read2")
    output:
        html_r1="results/qc/fastqc/{sample}_R1_fastqc.html",
        zip_r1="results/qc/fastqc/{sample}_R1_fastqc.zip",
        html_r2="results/qc/fastqc/{sample}_R2_fastqc.html",
        zip_r2="results/qc/fastqc/{sample}_R2_fastqc.zip"
    params:
        tmpdir="results/qc/fastqc/tmp_{sample}"
    threads: 2
    log:
        "logs/fastqc/{sample}.log"
    conda:
        "../envs/qc.yaml"
    shell:
        """
        mkdir -p {params.tmpdir}
        ln -sf $(realpath {input.r1}) {params.tmpdir}/{wildcards.sample}_R1.fastq.gz
        ln -sf $(realpath {input.r2}) {params.tmpdir}/{wildcards.sample}_R2.fastq.gz

        fastqc \
            --threads {threads} \
            --outdir results/qc/fastqc \
            {params.tmpdir}/{wildcards.sample}_R1.fastq.gz \
            {params.tmpdir}/{wildcards.sample}_R2.fastq.gz > {log} 2>&1

        rm -rf {params.tmpdir}
        """


# MultiQC aggregation of FastQC results on raw reads

rule multiqc_raw:
    input:
        expand("results/qc/fastqc/{sample}_R{read}_fastqc.zip", sample=SAMPLES, read=[1, 2])
    output:
        "results/qc/multiqc_raw/multiqc_report.html"
    log:
        "logs/multiqc/raw.log"
    conda:
        "../envs/qc.yaml"
    shell:
        """
        multiqc --force \
            results/qc/fastqc \
            -o results/qc/multiqc_raw \
            -n multiqc_report.html > {log} 2>&1
        """


# FastP quality control of the raw paired-end reads

rule fastp:
    input:
        r1=lambda wildcards: raw_read(wildcards, "read1"),
        r2=lambda wildcards: raw_read(wildcards, "read2")
    output:
        r1="results/qc/trimmed/{sample}_trimmed.R1.fastq.gz",
        r2="results/qc/trimmed/{sample}_trimmed.R2.fastq.gz",
        json="results/qc/fastp/fastp-{sample}.json",
        html="results/qc/fastp/fastp-{sample}.html"
    threads:
        config["threads"]["fastp"]
    log:
        "logs/fastp/{sample}.log"
    conda:
        "../envs/qc.yaml"
    shell:
        """
        fastp \
            -i {input.r1} \
            -I {input.r2} \
            -o {output.r1} \
            -O {output.r2} \
            --thread {threads} \
            -q 15 \
            --cut_front \
            --cut_tail \
            --cut_mean_quality 15 \
            --length_required 15 \
            -j {output.json} \
            -h {output.html} > {log} 2>&1
        """


# FastQC quality assessment on trimmed and filtered reads obtained from FastP

rule fastqc_trimmed:
    input:
        r1="results/qc/trimmed/{sample}_trimmed.R1.fastq.gz",
        r2="results/qc/trimmed/{sample}_trimmed.R2.fastq.gz"
    output:
        html_r1="results/qc/fastqc_trimmed/{sample}_trimmed.R1_fastqc.html",
        zip_r1="results/qc/fastqc_trimmed/{sample}_trimmed.R1_fastqc.zip",
        html_r2="results/qc/fastqc_trimmed/{sample}_trimmed.R2_fastqc.html",
        zip_r2="results/qc/fastqc_trimmed/{sample}_trimmed.R2_fastqc.zip"
    threads: 2
    log:
        "logs/fastqc_trimmed/{sample}.log"
    conda:
        "../envs/qc.yaml"
    shell:
        """
        fastqc \
            --threads {threads} \
            --outdir results/qc/fastqc_trimmed \
            {input.r1} {input.r2} > {log} 2>&1
        """


# MultiQC aggregation of FastQC and fastp results on trimmed reads

rule multiqc_trimmed:
    input:
        expand("results/qc/fastqc_trimmed/{sample}_trimmed.R{read}_fastqc.zip", sample=SAMPLES, read=[1, 2]),
        expand("results/qc/fastp/fastp-{sample}.json", sample=SAMPLES)
    output:
        "results/qc/multiqc_trimmed/multiqc_report.html"
    log:
        "logs/multiqc/trimmed.log"
    conda:
        "../envs/qc.yaml"
    shell:
        """
        multiqc --force \
            results/qc/fastqc_trimmed results/qc/fastp \
            -o results/qc/multiqc_trimmed \
            -n multiqc_report.html > {log} 2>&1
        """
