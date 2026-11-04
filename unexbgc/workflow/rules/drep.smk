# dRep genome dereplication rules for unexBGC
# Dereplicated MAGs are written to results/binning/drep/dereplicated/dereplicated_genomes/

rule prepare_drep_checkm2:
    input:
        "results/binning/checkm2/CheckM2_all_samples.csv"
    output:
        "results/binning/drep/checkM2_for_dRep.csv"
    shell:
        """
        awk -F',' 'BEGIN {{OFS=","}}
        NR==1 {{print "genome,completeness,contamination"}}
        NR>1 {{print $1"_"$2".fa",$3,$4}}
        ' {input} > {output}
        """


rule drep:
    input:
        checkm2="results/binning/drep/checkM2_for_dRep.csv",
        genomes="results/binning/hq_mq"
    output:
        directory("results/binning/drep/dereplicated")
    threads:
        config["threads"]["drep"]
    log:
        "logs/drep/drep.log"
    conda:
        "../envs/drep.yaml"
    shell:
        """
        dRep dereplicate {output} \
            -g {input.genomes}/*.fa \
            -p {threads} \
            -comp 50 \
            -con 10 \
            -pa 0.9 \
            -sa 0.95 \
            --multiround_primary_clustering \
            --greedy_secondary_clustering \
            --genomeInfo {input.checkm2} \
            --S_algorithm fastANI > {log} 2>&1
        """
