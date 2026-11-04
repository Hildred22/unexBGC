import pandas as pd

configfile: "config/config.yaml"

samples = pd.read_csv(config["samples"], sep="\t", comment="#")
SAMPLES = samples["sample"].tolist()

include: "workflow/rules/qc.smk"
include: "workflow/rules/assembly.smk"
include: "workflow/rules/quast.smk"
include: "workflow/rules/mapping.smk"
include: "workflow/rules/metabat2.smk"
include: "workflow/rules/maxbin2.smk"
include: "workflow/rules/concoct.smk"
include: "workflow/rules/dastool.smk"
include: "workflow/rules/checkm2.smk"
include: "workflow/rules/checkm2_combine.smk"
include: "workflow/rules/hq_mq.smk"
include: "workflow/rules/drep.smk"
include: "workflow/rules/gtdbtk.smk"
include: "workflow/rules/denovo.smk"
include: "workflow/rules/antismash.smk"
include: "workflow/rules/bgc_regions.smk"
include: "workflow/rules/bigscape.smk"


# Final outputs of the full workflow
rule all:
    input:
        # Read quality control
        "results/qc/multiqc_raw/multiqc_report.html",
        "results/qc/multiqc_trimmed/multiqc_report.html",
        # Assembly quality
        expand("results/assembly/quast/{sample}/report.html", sample=SAMPLES),
        # MAG quality, dereplication and taxonomy
        "results/binning/checkm2/CheckM2_all_samples.csv",
        "results/taxonomy/gtdbtk",
        "results/taxonomy/denovo/.complete",
        # Biosynthetic gene clusters
        "results/bgc/bgc_regions.tsv",
        "results/bgc/bigscape"
