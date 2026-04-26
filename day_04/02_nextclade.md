[⬅ Back to Day 04 overview](README.md)

# Genome QC and Clade Assignment with Nextclade

## 🎯 Learning goals

By the end of this practical, you should be able to:

- explain what Nextclade is used for
- download a Nextclade dataset
- run Nextclade on example sequences
- run Nextclade on your own consensus sequences
- inspect the main Nextclade output files
- interpret basic genome QC results
- identify clade assignment, mutations, missing data, and QC warnings

## Overview

`Nextclade` is a tool for rapid genome quality control, mutation calling, clade assignment, and phylogenetic placement.

In this practical, we will use Nextclade with SARS-CoV-2 consensus sequences.

The general workflow is:

```text
consensus FASTA files
  ↓
Nextclade dataset
  ↓
Nextclade run
  ↓
QC report, clade assignment, mutations, aligned sequences
```

> [!NOTE]
> The raw reads and reference genomes are downloaded in the Day 02 tutorial:
>
> [Downloading datasets](../day_02/02_downloading_datasets.md)
>
> This practical assumes that you already have SARS-CoV-2 consensus sequences from the previous mapping / reference-based assembly practical.

---

## 1. Create and activate the Conda environment

Move to the workshop repository.

```bash
cd ~/2026-Workshop-HSPA-Morocco
```

Create a Conda environment with Nextclade.

```bash
conda create -y -n nextclade -c conda-forge -c bioconda nextclade
```

Activate the environment.

```bash
conda activate nextclade
```

Check that Nextclade is available.

```bash
nextclade --version
```

You can also open the help page.

```bash
nextclade --help
nextclade run --help
```

---

## 2. Create a working directory

Create a clean directory for this practical.

```bash
mkdir -p analyses/day_04/nextclade/input
mkdir -p analyses/day_04/nextclade/datasets
mkdir -p analyses/day_04/nextclade/results
```

Check the directory structure.

```bash
ls -R analyses/day_04/nextclade
```

---

## 3. Download the SARS-CoV-2 Nextclade dataset

Nextclade requires a dataset. The dataset contains the reference genome, annotation, pathogen configuration, and other files needed for the analysis.

Download the SARS-CoV-2 dataset.

```bash
nextclade dataset get \
  --name 'nextstrain/sars-cov-2/wuhan-hu-1/orfs' \
  --output-dir analyses/day_04/nextclade/datasets/sars-cov-2
```

Check what was downloaded.

```bash
ls -lh analyses/day_04/nextclade/datasets/sars-cov-2
```

> [!TIP]
> Nextclade datasets are updated over time.
> For real surveillance work, make sure you know which dataset version was used.

---

## 4. Run Nextclade on example sequences

The downloaded dataset usually includes example sequences.

Run Nextclade on the example FASTA file.

```bash
nextclade run \
  --input-dataset analyses/day_04/nextclade/datasets/sars-cov-2 \
  --output-all analyses/day_04/nextclade/results/example_run \
  analyses/day_04/nextclade/datasets/sars-cov-2/sequences.fasta
```

List the output files.

```bash
ls -lh analyses/day_04/nextclade/results/example_run
```

Important outputs include:

| File | Purpose |
|---|---|
| `nextclade.tsv` | Main tabular results |
| `nextclade.csv` | Same results in CSV format |
| `nextclade.json` | Detailed results in JSON format |
| `nextclade.aligned.fasta` | Aligned nucleotide sequences |
| `nextclade.tree.nwk` | Tree output in Newick format |
| `nextclade.errors.csv` | Errors, if any occurred |

---

## 5. Inspect the Nextclade results table

Open the main TSV result file.

```bash
less -S analyses/day_04/nextclade/results/example_run/nextclade.tsv
```

Show the column names.

```bash
head -n 1 analyses/day_04/nextclade/results/example_run/nextclade.tsv | tr '\t' '\n' | nl
```

Show the first few result lines.

```bash
head analyses/day_04/nextclade/results/example_run/nextclade.tsv
```

> [!TIP]
> Use `less -S` for wide tables.
> Press `q` to exit.

---

## 6. Prepare your own SARS-CoV-2 consensus sequences

Now we will prepare input FASTA files from your own Day 03 outputs.

First, look for FASTA files.

```bash
find analyses data -type f \( -name "*.fasta" -o -name "*.fa" -o -name "*.fna" \) 2>/dev/null | sort
```

Copy your SARS-CoV-2 consensus FASTA files into the Nextclade input directory.

```bash
# Replace this example path with the path to your own SARS-CoV-2 consensus FASTA files
cp path/to/sars-cov-2/consensus/*.fasta analyses/day_04/nextclade/input/
```

Combine the consensus FASTA files.

```bash
cat analyses/day_04/nextclade/input/*.fasta > analyses/day_04/nextclade/input/sc2_consensus_sequences.fasta
```

Check how many sequences are present.

```bash
grep -c "^>" analyses/day_04/nextclade/input/sc2_consensus_sequences.fasta
```

Inspect the sequence names.

```bash
grep "^>" analyses/day_04/nextclade/input/sc2_consensus_sequences.fasta
```

---

## 7. Run Nextclade on your own sequences

Run Nextclade on your SARS-CoV-2 consensus sequences.

```bash
nextclade run \
  --input-dataset analyses/day_04/nextclade/datasets/sars-cov-2 \
  --output-all analyses/day_04/nextclade/results/sc2_consensus_run \
  analyses/day_04/nextclade/input/sc2_consensus_sequences.fasta
```

List the output files.

```bash
ls -lh analyses/day_04/nextclade/results/sc2_consensus_run
```

Open the main result table.

```bash
less -S analyses/day_04/nextclade/results/sc2_consensus_run/nextclade.tsv
```

---

## 8. Interpret key Nextclade outputs

Nextclade reports many columns. Some useful columns to look for include:

| Column type | What it tells you |
|---|---|
| Sequence name | Which sample the row belongs to |
| Clade | Assigned Nextstrain clade |
| QC status | Whether the genome passed quality checks |
| Substitutions | Nucleotide changes compared with the reference |
| Deletions | Deleted positions compared with the reference |
| Missing data | Regions with missing bases |
| Non-ACGTN bases | Unexpected characters in the sequence |
| Amino acid mutations | Changes in coding regions |

Use the header line to find exact column names in your Nextclade version.

```bash
head -n 1 analyses/day_04/nextclade/results/sc2_consensus_run/nextclade.tsv | tr '\t' '\n' | nl
```

Print only the first few columns.

```bash
cut -f 1-10 analyses/day_04/nextclade/results/sc2_consensus_run/nextclade.tsv | column -t -s $'\t' | less -S
```

---

## 9. Check for warnings and failed samples

Nextclade may report warnings or errors if sequences are incomplete, very short, contaminated, reversed, or contain too much missing data.

Check whether an error file was produced.

```bash
ls -lh analyses/day_04/nextclade/results/sc2_consensus_run/*error*
```

Open it if present.

```bash
cat analyses/day_04/nextclade/results/sc2_consensus_run/nextclade.errors.csv
```

> [!NOTE]
> If no error file is present, or if the file is empty, this usually means that Nextclade did not encounter fatal errors.

---

## 10. Use the aligned FASTA output

Nextclade also writes aligned sequences.

```bash
ls -lh analyses/day_04/nextclade/results/sc2_consensus_run/*aligned*
```

This aligned FASTA can be useful for inspection or downstream analysis.

```bash
grep -c "^>" analyses/day_04/nextclade/results/sc2_consensus_run/nextclade.aligned.fasta
```

> [!CAUTION]
> Nextclade is excellent for genome QC and clade assignment, but it does not replace a carefully designed phylogenetic analysis.
> For phylogenetic tree inference, use a tool such as IQ-TREE on an appropriate multiple sequence alignment.

---

## 🧠 Mini exercise

Try to answer the following questions:

1. Why does Nextclade need a dataset?
2. Which file contains the main tabular results?
3. Which column reports the assigned clade?
4. What does missing data tell you about a genome?
5. Why might a sequence fail Nextclade QC?

---

## Quick reference

| Command | Purpose |
|---|---|
| `conda activate nextclade` | Activate the Nextclade environment |
| `nextclade --help` | Show Nextclade help |
| `nextclade dataset get` | Download a Nextclade dataset |
| `nextclade run` | Run Nextclade analysis |
| `--input-dataset` | Use a downloaded local dataset |
| `--output-all` | Write all standard output files |
| `less -S file.tsv` | View a wide table |
| `head -n 1 file.tsv \| tr '\t' '\n' \| nl` | Show numbered TSV columns |
| `cut -f 1-10 file.tsv` | Extract selected columns |

---

[⬅ Previous tutorial](./01_iqtree.md)

[⬅ Back to Day 04 overview](README.md)

[⬅ Back to main page](../README.md)
