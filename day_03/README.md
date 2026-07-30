# Day 03 — From genomes to clades and trees

## Overview

Day 03 focuses on QC of genomes, clade assignment and phylogenetic analysis. 

The practical session introduces `Nextclade` for QC of genomes, mutation calling, clade assignment and phylogenetic placement.
We will use the pipeline `omnifluss_downstream` that finds the best matching Nextclade dataset and runs Nextclade.
Then, `omnifluss_downstream` aligns the translated amino acid sequences with `mafft`, builds a tree with `IQ-TREE` and reconstructs the ancestral sequence with `TreeTime`.

## 🎯 Learning goals

By the end of Day 03, you should be able to:

- understand the advantage of workflow managers
- understand QC of genomes
- basic steps of Nextclade
- understand the output of Nextclade
- inspect a tree on auspice.us or peartree
- understand basic principles of phylogenetics 

## 💻 Practicals

1. [Genome reconstruction pipeline](01_pipeline.md)
2. [QC, mutation calling, clade assignment](02_downstream.md)

## 👩‍🏫 Slides

- [Introduction to Research Software Engineering](../slides/Introduction_RSE.pdf)
- [Introduction to Nextclade](../slides/Introduction_Nextclade.pdf)
- [From sequences to trees](../slides/Introduction_Phylo.pdf)

## Further reading

### Trees

- https://www.cdc.gov/advanced-molecular-detection/php/training/module-3-4.html
- https://nextstrain.org/narratives/trees-background
- https://training.galaxyproject.org/training-material/topics/evolution/tutorials/abc_intro_phylo/tutorial.html#phylogenetics-back-to-basics
- https://alliblk.github.io/genepi-book/index.html

### Nextclade

- [Nextclade's quality control](https://docs.nextstrain.org/projects/nextclade/en/stable/user/algorithm/06-quality-control.html#)

### Pipeline Paper

- [for Illumina SARS-CoV-2 reads (CovPipe2)](https://doi.org/10.12688/f1000research.136683.2)
- [for ONT SARS-CoV2 reads (poreCov)](https://doi.org/10.3389/fgene.2021.711437)

### Further Trainings

- [ONT Influenza Workshop](https://github.com/rki-mf1/2024-Workshop-Namibia)
- [Nextflow & nf-core](https://training.nextflow.io/latest/hello_nf-core/)

---

[⬅ Back to main page](../README.md)

---
