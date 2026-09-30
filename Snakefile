import pandas as pd

configfile: "config/config.yaml"

samples = pd.read_csv(config["samples"], sep="\t")

include: "workflow/rules/qc.smk"
include: "workflow/rules/assembly.smk"
include: "workflow/rules/quast.smk"

rule all:
    input:
        "results/qc/multiqc_trimmed/multiqc_report.html"
