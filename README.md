<h1 align="center">unexBGC</h1>

<p align="center">
  <b>From raw metagenomic reads to biosynthetic gene clusters, in one reproducible workflow</b>
</p>

<p align="center">
  <a href="https://snakemake.github.io"><img src="https://img.shields.io/badge/snakemake-%E2%89%A58.0-039475" alt="Snakemake ≥8.0"></a>
  <img src="https://img.shields.io/badge/package%20manager-conda-44A833" alt="conda">
  <img src="https://img.shields.io/badge/platform-Linux%20%7C%20HPC-1f6feb" alt="Linux | HPC">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT licence"></a>
</p>

<p align="center">
  <a href="#workflow">Workflow</a> •
  <a href="#quick-start">Quick start</a> •
  <a href="#input-data">Input</a> •
  <a href="#main-outputs">Outputs</a> •
  <a href="#citation">Citation</a>
</p>

---

**unexBGC** finds the genes microbes use to make natural products (BGCs) in **marine metagenomes**. Starting from paired-end sequencing reads, it reconstructs metagenome-assembled genomes (MAGs), identifies taxonomy, detects biosynthetic gene clusters (BGCs) and identifies potentially novel BGCs.

It was built for microbiologists without extensive bioinformatics experience: you edit **one sample sheet** and **one settings file**, and Snakemake runs every step in the right order, locally or on an HPC cluster.

### The pipeline provides

**Quality-checked genomes**: HQ and MQ MAGs, dereplicated, with completeness and contamination for each

**Taxonomy and phylogeny**: GTDB classification plus separate bacterial and archaeal trees ready for iTOL

**BGC catalogue**: one table listing every cluster with its product class, location and closest known relative

**Novelty assessment**: gene cluster families compared against the MIBiG database of characterised clusters



## Workflow

<img width="749" height="297" alt="Copy of LabUpdate (1)" src="https://github.com/user-attachments/assets/d90a0185-3ab3-4a38-8e35-20c8f4c7d4fa" />


## Input data

The pipeline requires paired-end metagenomic sequencing reads.

Input samples are specified by the user in:

`config/samples.tsv`

Raw sequencing data should be placed in:

`data/raw/`

Raw sequencing data are not included in this repository.

## Sample sheet format

The sample sheet should contain three columns:

```text
sample    read1    read2
```

For example:

```text
sample    read1                  read2
sample1   sample1_R1.fastq.gz    sample1_R2.fastq.gz
```

Users should replace the example entries with their own sample information.


## Reproducibility

The workflow is implemented using Snakemake, allowing individual pipeline steps to be executed according to their dependencies and enabling the workflow to be reproduced across datasets and computational environments.

Computational resources and pipeline settings can be configured through: config/config.yaml
