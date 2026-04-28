[⬅ Back to Day 03 overview](README.md)

# Mapping with minimap2

## 🎯 Learning goals

By the end of this practical, you should be able to:

- explain what read mapping means
- understand the difference between reads, references, SAM files, and BAM files
- map Oxford Nanopore reads to a reference genome using `minimap2`
- convert mapping output into sorted and indexed BAM files
- inspect basic mapping statistics with `samtools`
- compare mapping results for SARS-CoV-2 and Influenza A
- understand why reference choice matters for reference-based genome reconstruction

## Overview

Reference-based assembly starts by mapping sequencing reads to a known reference genome.

In this practical, we will use `minimap2` to map Oxford Nanopore reads to two viral reference genomes:

1. SARS-CoV-2 reads mapped to the Wuhan-Hu-1 reference genome
2. Influenza A H3N2 reads mapped to an Influenza A reference genome

The general workflow is:

```text
FASTQ reads
  ↓
reference genome
  ↓
minimap2 mapping
  ↓
SAM/BAM alignment file
  ↓
mapping statistics and inspection
```

> [!NOTE]
> This practical assumes that you already downloaded the datasets and references during Day 02:
>
> [Downloading datasets](../day_02/02_downloading_datasets.md)

---

## 1. Move to the workshop repository

Start from the main workshop directory.

```bash
cd ~/2026-Workshop-HSPA-Morocco
```

Check that you are in the correct location.

```bash
pwd
```

You should see something similar to:

```text
/home/your_username/2026-Workshop-HSPA-Morocco
```

---

## 2. Check that the input files are available

First, check the raw read files.

```bash
ls -lh data/raw_data/sc2
ls -lh data/raw_data/iav_h3n2
```

You should see SARS-CoV-2 FASTQ files in:

```text
data/raw_data/sc2
```

and Influenza A FASTQ files in:

```text
data/raw_data/iav_h3n2
```

Now check the reference genomes.

```bash
ls -lh data/references/sc2
ls -lh data/references/iav_h3n2
```

For this tutorial, we will use:

| Virus | Reads | Reference |
|---|---|---|
| SARS-CoV-2 | `data/raw_data/sc2/SRR18858561.fastq.gz` | `data/references/sc2/Wuhan-Hu-1_ASM985889v3.fasta` |
| Influenza A H3N2 | `data/raw_data/iav_h3n2/SRR32055876.fastq.gz` | `data/references/iav_h3n2/A_DistrictOfColumbia_27_2023_H3N2_ASM3941567v1.fasta` |

> [!TIP]
> If the FASTQ file names are slightly different on your computer, use `ls` to check the exact names and adjust the commands below.

---

## 3. Create and activate a Conda environment

Create a Conda environment containing `minimap2` and `samtools`.

```bash
conda create -y -n minimap2 -c conda-forge -c bioconda minimap2 samtools
```

Activate the environment.

```bash
conda activate minimap2
```

Check that both tools are available.

```bash
minimap2 --version
samtools --version
```

---

## 4. Create a working directory

Create a clean working directory for the mapping results.

```bash
mkdir -p analyses/day_03/minimap2/sc2
mkdir -p analyses/day_03/minimap2/iav_h3n2
```

Check the directory structure.

```bash
ls -R analyses/day_03/minimap2
```

---

# Example 1: SARS-CoV-2 mapping

## 5. Define input files for SARS-CoV-2

To make the commands easier to read, we will store file paths in variables.

```bash
SC2_REF="data/references/sc2/Wuhan-Hu-1_ASM985889v3.fasta"
SC2_READS="data/raw_data/sc2/SRR18858561.fastq.gz"
SC2_OUT="analyses/day_03/minimap2/sc2/SRR18858561"
```

Check that the files exist.

```bash
ls -lh "$SC2_REF"
ls -lh "$SC2_READS"
```

---

## 6. Inspect the SARS-CoV-2 reference genome

Check the sequence names in the reference genome.

```bash
grep "^>" "$SC2_REF"
```

Check the size of the reference genome.

```bash
samtools faidx "$SC2_REF"
cat "${SC2_REF}.fai"
```

> [!NOTE]
> `samtools faidx` creates a FASTA index file ending in `.fai`.
> This index allows tools to quickly access specific reference sequences.

---

## 7. Map SARS-CoV-2 reads with minimap2

Now map the reads to the reference genome.

```bash
minimap2 -ax map-ont "$SC2_REF" "$SC2_READS" > "${SC2_OUT}.sam"
```

Meaning of the options:

| Option | Meaning |
|---|---|
| `-a` | Output SAM format |
| `-x map-ont` | Use settings suitable for Oxford Nanopore reads |
| `"$SC2_REF"` | Reference genome |
| `"$SC2_READS"` | Input FASTQ reads |
| `> "${SC2_OUT}.sam"` | Save output to a SAM file |

Check the output file.

```bash
ls -lh "${SC2_OUT}.sam"
```

> [!TIP]
> SAM files are text files, but they can be very large.
> For most downstream analysis, we convert SAM to BAM.

---

## 8. Convert SAM to sorted BAM

Convert the SAM file into a sorted BAM file.

```bash
samtools sort -o "${SC2_OUT}.sorted.bam" "${SC2_OUT}.sam"
```

Index the sorted BAM file.

```bash
samtools index "${SC2_OUT}.sorted.bam"
```

Check the files.

```bash
ls -lh analyses/day_03/minimap2/sc2
```

You should now have:

```text
SRR18858561.sam
SRR18858561.sorted.bam
SRR18858561.sorted.bam.bai
```

> [!NOTE]
> BAM is a compressed binary version of SAM.
> A BAM index file (`.bai`) allows fast access to specific genome positions.

---

## 9. Inspect SARS-CoV-2 mapping statistics

Use `samtools flagstat` to summarize the mapping result.

```bash
samtools flagstat "${SC2_OUT}.sorted.bam"
```

Create a text file with the mapping statistics.

```bash
samtools flagstat "${SC2_OUT}.sorted.bam" > "${SC2_OUT}.flagstat.txt"
```

Check the first few covered positions.

```bash
samtools depth "${SC2_OUT}.sorted.bam" | head
```

---

# Example 2: Influenza A H3N2 mapping

## 10. Define input files for Influenza A

Now we will repeat the same process for Influenza A H3N2.

```bash
IAV_REF="data/references/iav_h3n2/A_DistrictOfColumbia_27_2023_H3N2_ASM3941567v1.fasta"
IAV_READS="data/raw_data/iav_h3n2/SRR32055876.fastq.gz"
IAV_OUT="analyses/day_03/minimap2/iav_h3n2/SRR32055876"
```

Check that the files exist.

```bash
ls -lh "$IAV_REF"
ls -lh "$IAV_READS"
```

---

## 11. Inspect the Influenza A reference genome

Check the reference sequence names.

```bash
grep "^>" "$IAV_REF"
```

Index the reference and inspect the FASTA index.

```bash
samtools faidx "$IAV_REF"
cat "${IAV_REF}.fai"
```

> [!IMPORTANT]
> Influenza A has a segmented genome.
> The reference FASTA may contain multiple sequences, one for each genome segment.
>
> This means that reads can map to different reference segments such as PB2, PB1, PA, HA, NP, NA, MP, and NS.

---

## 12. Map Influenza A reads with minimap2

Map the Influenza A reads to the Influenza A reference genome.

```bash
minimap2 -ax map-ont "$IAV_REF" "$IAV_READS" > "${IAV_OUT}.sam"
```

Check the output file.

```bash
ls -lh "${IAV_OUT}.sam"
```

---

## 13. Convert SAM to sorted BAM

Convert the SAM file into a sorted BAM file.

```bash
samtools sort -o "${IAV_OUT}.sorted.bam" "${IAV_OUT}.sam"
```

Index the sorted BAM file.

```bash
samtools index "${IAV_OUT}.sorted.bam"
```

Check the output files.

```bash
ls -lh analyses/day_03/minimap2/iav_h3n2
```

---

## 14. Inspect Influenza A mapping statistics

Generate mapping statistics.

```bash
samtools flagstat "${IAV_OUT}.sorted.bam"
```

Save the mapping statistics to a text file.

```bash
samtools flagstat "${IAV_OUT}.sorted.bam" > "${IAV_OUT}.flagstat.txt"
```

Check coverage depth.

```bash
samtools depth "${IAV_OUT}.sorted.bam" | head
```

Check how many positions are covered per reference segment.

```bash
samtools depth "${IAV_OUT}.sorted.bam" | cut -f 1 | sort | uniq -c
```

> [!TIP]
> For Influenza A, this command helps you see whether all genome segments have read coverage.

---

# Comparing both examples

## 15. Compare SARS-CoV-2 and Influenza A outputs

List both result directories.

```bash
ls -lh analyses/day_03/minimap2/sc2
ls -lh analyses/day_03/minimap2/iav_h3n2
```

Compare the mapping statistics.

```bash
cat analyses/day_03/minimap2/sc2/SRR18858561.flagstat.txt
cat analyses/day_03/minimap2/iav_h3n2/SRR32055876.flagstat.txt
```

Think about the following questions:

1. Which sample had more reads?
2. Which sample had a higher mapping percentage?
3. Which sample had higher coverage?
4. Did the Influenza A reads cover all genome segments?
5. Why might some reads fail to map?

---

## 16. Optional: Create smaller BAM files for easier viewing

For large files, you may want to remove the SAM file after creating the sorted BAM.

```bash
rm "${SC2_OUT}.sam"
rm "${IAV_OUT}.sam"
```

> [!CAUTION]
> Only remove SAM files after confirming that the sorted BAM and BAM index files were created successfully.

Check that the BAM files are still present.

```bash
ls -lh analyses/day_03/minimap2/sc2
ls -lh analyses/day_03/minimap2/iav_h3n2
```

---

## 17. Optional: View alignments in the terminal

You can inspect alignments directly with `samtools view`.

Show the first few alignments for SARS-CoV-2.

```bash
samtools view "${SC2_OUT}.sorted.bam" | head
```

Show the first few alignments for Influenza A.

```bash
samtools view "${IAV_OUT}.sorted.bam" | head
```

Show only the BAM header.

```bash
samtools view -H "${SC2_OUT}.sorted.bam"
samtools view -H "${IAV_OUT}.sorted.bam"
```

The header contains information about the reference sequences and the command used to create the alignment.

---

## 🧠 Mini exercise

Try to answer the following questions:

1. What is the difference between FASTQ, FASTA, SAM, and BAM files?
2. Why do we use `-x map-ont` with Oxford Nanopore reads?
3. Why do we sort and index BAM files?
4. Why is Influenza A mapping different from SARS-CoV-2 mapping?
5. What does `samtools flagstat` tell you?
6. What does `samtools depth` tell you?

---

## 📌 Summary

In this practical, you mapped two Oxford Nanopore read datasets to reference genomes:

| Example | Reads | Reference | Output |
|---|---|---|---|
| SARS-CoV-2 | `SRR18858561.fastq.gz` | Wuhan-Hu-1 | Sorted BAM |
| Influenza A H3N2 | `SRR32055876.fastq.gz` | A/District of Columbia/27/2023 H3N2 | Sorted BAM |

You used:

| Command | Purpose |
|---|---|
| `minimap2 -ax map-ont reference.fasta reads.fastq.gz` | Map ONT reads to a reference genome |
| `samtools sort` | Convert and sort alignments into BAM format |
| `samtools index` | Create a BAM index |
| `samtools flagstat` | Summarize mapping statistics |
| `samtools depth` | Inspect coverage depth |
| `samtools faidx` | Index a FASTA reference genome |

Mapping is the first major step in reference-based genome reconstruction. The sorted BAM files produced here can be used for downstream inspection, coverage analysis, consensus generation, and variant calling.

---

[Next tutorial](./02_MIRA_NF.md)

[⬅ Back to Day 03 overview](README.md)

[⬅ Back to main page](../README.md)
