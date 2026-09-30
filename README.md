# unexBGC

An integrated Snakemake pipeline for identifying and characterising biosynthetic gene clusters from environmental metagenomic data.

## Overview

unexBGC is a reproducible and modular bioinformatics pipeline designed to process environmental metagenomic sequencing data and investigate their biosynthetic potential.

The pipeline integrates quality control, metagenome assembly, genome binning, bin refinement and quality assessment, dereplication, taxonomic classification, and biosynthetic gene cluster analysis into a single workflow.

The pipeline is designed to support researchers who may not have extensive bioinformatics expertise by providing an integrated and reproducible workflow from raw sequencing reads to interpretable biosynthetic gene cluster information.

## Workflow

###Add flow diagram of workflow here

## Input data

The pipeline requires paired-end metagenomic sequencing reads.

Input samples are specified by the user in: config/samples.tsv

Raw sequencing data should be placed in: data/raw/

Raw sequencing data are not included in this repository.

## Sample sheet format

The sample sheet should contain three columns:

sample    read1    read2

For example:

sample    read1              read2
sample1   sample1_R1.fastq.gz    sample1_R2.fastq.gz

Users should replace the example entries with their own sample information.

## Reproducibility

The workflow is implemented using Snakemake, allowing individual pipeline steps to be executed according to their dependencies and enabling the workflow to be reproduced across datasets and computational environments.

Computational resources and pipeline settings can be configured through: config/config.yaml
