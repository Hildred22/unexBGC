configfile: "config/config.yaml"

include: "workflow/rules/qc.smk"

rule all:
    input:
        "results/qc/multiqc_trimmed/multiqc_report.html"
