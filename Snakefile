import pandas as pd

configfile: "config/config.yaml"

samples = pd.read_csv(config["samples"], sep="\t")

include: "workflow/rules/qc.smk"
include: "workflow/rules/assembly.smk"
include: "workflow/rules/quast.smk"
include: "workflow/rules/mapping.smk"
include: "workflow/rules/metabat2.smk"
include: "workflow/rules/maxbin2.smk"
include: "workflow/rules/dastool.smk"

rule all:
    input:
        "results/qc/multiqc_trimmed/multiqc_report.html"
