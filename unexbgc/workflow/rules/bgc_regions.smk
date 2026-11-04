# BGC region extraction rules for unexBGC

rule export_bgc_regions:
    input:
        antismash="results/bgc/antismash/.complete"
    output:
        "results/bgc/bgc_regions.tsv"
    params:
        antismash_dir="results/bgc/antismash"
    shell:
        """
        python workflow/scripts/export_bgc_regions.py \
            --input {params.antismash_dir} \
            --output {output}
        """
