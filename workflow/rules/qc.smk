# Quality assessment and control rules for unexBGC

SAMPLES = samples["sample"].tolist()

# FastQC quality assessment of raw paired-end reads

rule fastqc:
    input:
        r1=lambda wildcards: "data/raw/" + samples.loc[samples["sample"] == wildcards.sample, "read1"].iloc[0],
        r2=lambda wildcards: "data/raw/" + samples.loc[samples["sample"] == wildcards.sample, "read2"].iloc[0]
    output:
        html_r1="results/qc/fastqc/{sample}_R1_fastqc.html",
        zip_r1="results/qc/fastqc/{sample}_R1_fastqc.zip",
        html_r2="results/qc/fastqc/{sample}_R2_fastqc.html",
        zip_r2="results/qc/fastqc/{sample}_R2_fastqc.zip"

    shell:
        """
        mkdir -p results/qc/fastqc

        fastqc \
            --threads 2 \
            --outdir results/qc/fastqc \
            {input.r1} {input.r2}
        """


# MultiQC aggregation of FastQC results on raw reads

rule multiqc_raw:
    input:
        directory("results/qc/fastqc")
    output:
        "results/qc/multiqc_raw/multiqc_report.html"

    shell:
        """
        mkdir -p results/qc/multiqc_raw

        multiqc \
            {input} \
            -o results/qc/multiqc_raw \
            -n multiqc_report.html
        """


# FastP quality control of the raw paired-end reads

    input:
        r1=lambda wildcards: "data/raw/" + samples.loc[samples["sample"] == wildcards.sample, "read1"].iloc[0],
        r2=lambda wildcards: "data/raw/" + samples.loc[samples["sample"] == wildcards.sample, "read2"].iloc[0],
        multiqc="results/qc/multiqc_raw/multiqc_report.html"
    output:
        r1="results/qc/trimmed/{sample}_trimmed.R1.fastq.gz",
        r2="results/qc/trimmed/{sample}_trimmed.R2.fastq.gz",
        json="results/qc/fastp/fastp-{sample}.json",
        html="results/qc/fastp/fastp-{sample}.html"

    shell:
        """
        mkdir -p results/qc/trimmed results/qc/fastp

        fastp \
            -i {input.r1} \
            -I {input.r2} \
            -o {output.r1} \
            -O {output.r2} \
            --thread 12 \
            -q 15 \
            --cut_front \
            --cut_tail \
            --cut_mean_quality 15 \
            --length_required 15 \
            -j {output.json} \
            -h {output.html}
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

    shell:
        """
        mkdir -p results/qc/fastqc_trimmed

        fastqc \
            --threads 2 \
            --outdir results/qc/fastqc_trimmed \
            {input.r1} {input.r2}
        """


# MultiQC aggregation of FastQC results on trimmed reads

rule multiqc_trimmed:
    input:
        directory("results/qc/fastqc_trimmed")
    output:
        "results/qc/multiqc_trimmed/multiqc_report.html"

    shell:
        """
        mkdir -p results/qc/multiqc_trimmed

        multiqc \
            {input} \
            -o results/qc/multiqc_trimmed \
            -n multiqc_report.html
        """
