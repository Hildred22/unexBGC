# Quality assessment and control rules for unexBGC

# FastQC quality assessment of raw paired end reads
rule fastqc:
    input:
        r1="data/raw/{sample}_R1_001.fastq.gz",
        r2="data/raw/{sample}_R2_001.fastq.gz"
    output:
        html_r1="results/qc/fastqc/{sample}_R1_001_fastqc.html",
        zip_r1="results/qc/fastqc/{sample}_R1_001_fastqc.zip",
        html_r2="results/qc/fastqc/{sample}_R2_001_fastqc.html",
        zip_r2="results/qc/fastqc/{sample}_R2_001_fastqc.zip"
    
    shell:
        """
        mkdir -p results/qc/fastqc
        fastqc \
            --threads 2 \
            --outdir results/qc/fastqc \
            {input.r1} {input.r2}
        """


# FastP quality control of the raw paired end reads
rule fastp:
    input:
        r1="data/raw/{sample}_R1_001.fastq.gz",
        r2="data/raw/{sample}_R2_001.fastq.gz"
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
