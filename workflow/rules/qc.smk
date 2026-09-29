# Quality control rules for unexBGC

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
