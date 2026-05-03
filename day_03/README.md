# Day 03 — Mapping, Reference-Based Assembly, and Variant Calling

## Overview

Day 03 focuses on reference-based genome reconstruction and variant calling. 

The practical session introduces `minimap2` for read mapping and `MIRA-NF` for reference-based assembly and variant calling. 
`minimap2` will be used to demonstrate the process of mapping which is necessary for understanding of reference-based assemblies. 
After that we will run `MIRA-NF` that can be used for assembly of multiple pathogens including influenza, sars-cov2 for both ONT and Illumina data.

## 🎯 Learning goals

By the end of Day 03, you should be able to:

- understand the difference between **de novo assembly** and **reference-based assembly**
- explain why choosing an appropriate reference genome is important
- map sequencing reads to a reference genome using `minimap2`
- understand the basic structure of **SAM/BAM** alignment files
- describe what a **VCF** file contains
- distinguish between reference bases, alternative bases, genotype calls, and variant quality information
- understand the main steps performed by `MIRA-NF`
- run or interpret a `MIRA-NF` variant calling workflow
- inspect and interpret basic variant calling outputs

## 💻 Practicals

1. [Mapping with minimap2](01_minimap2.md)
2. [MIRA-NF](02_MIRA_NF.md)

## 👩‍🏫 Slides

- [Reference-Based Assembly](https://docs.google.com/presentation/d/1v6zL6iEzGx5J7rtEcjGziaafWSFiwWpGT1CKWs94xfE)
- [MIRA-NF](https://docs.google.com/presentation/d/1fQEHHBpG6SRKNlKSIgZCDFn1uWXzjf9TxwdHP9aZ1LA)

## 📝 Evaluation

Please fill in this [daily feedback evaluation](https://survey.lamapoll.de/HSPA-Morocco-Bioinformatics-Workshop-Daily-Feedback) at the end of the day.

---

[⬅ Back to main page](../README.md)

---
