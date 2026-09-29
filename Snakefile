configfile: "config/config.yaml"

include: "workflow/rules/qc.smk"

rule all:
    input:
        "results/.pipeline_complete"
