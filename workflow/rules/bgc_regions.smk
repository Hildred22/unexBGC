# BGC region extraction rules for unexBGC

rule export_bgc_regions:
    input:
        antismash="results/bgc/antismash"
    output:
        "results/bgc/bgc_regions.tsv"
    shell:
        """
        python workflow/scripts/export_bgc_regions.py \
            --input {input.antismash} \
            --output {output}
        """
