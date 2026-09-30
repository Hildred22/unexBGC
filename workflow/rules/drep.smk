# dRep genome dereplication rules for unexBGC

rule prepare_drep_checkm2:
    input:
        "results/binning/checkm2/CheckM2_all_samples.csv"
    output:
        "results/binning/drep/checkM2_for_dRep.csv"
    shell:
        """
        mkdir -p results/binning/drep

        awk -F',' 'BEGIN {{OFS=","}}
        NR==1 {{print "genome,completeness,contamination"}}
        NR>1 {{print $1"_"$2".fa",$3,$4}}
        ' {input} > {output}
        """


rule drep:
    input:
        checkm2="results/binning/drep/checkM2_for_dRep.csv",
        genomes=directory("results/binning/hq_mq")
    output:
        directory("results/binning/drep/dereplicated")
    threads:
        24
    shell:
        """
        mkdir -p results/binning/drep/dereplicated

        dRep dereplicate results/binning/drep/dereplicated \
            -g results/binning/hq_mq/*.fa \
            -p {threads} \
            -pa 0.9 \
            -sa 0.95 \
            --multiround_primary_clustering \
            --greedy_secondary_clustering \
            --genomeInfo {input.checkm2} \
            --S_algorithm fastANI
        """
