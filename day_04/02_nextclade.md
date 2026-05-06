[⬅ Back to Day 04 overview](README.md)

# Genome QC and Clade Assignment with Nextclade Web

## 🎯 Learning goals

By the end of this practical, you should be able to:

- explain what Nextclade is used for
- open and use the interactive Nextclade Web interface
- inspect the interactive results table and phylogenetic tree view
- interpret basic genome QC results
- identify clade assignment, mutations, missing data, and QC warnings
- export Nextclade results for later reporting or downstream analysis

## Overview

`Nextclade` is a tool for rapid genome quality control, mutation calling, clade assignment, and phylogenetic placement.

In this practical, we will use **Nextclade Web** with influenza A and SARS-CoV-2 consensus sequences created by MIRA-NF. Nextclade Web runs in an interactive browser interface, so no command-line installation is needed for this exercise.


> [!NOTE]
> This practical assumes that you already have influenza A and/or SARS-CoV-2 consensus sequences from the previous MIRA-NF practical.

> [!TIP]
> Nextclade Web performs the analysis in your browser on your own computer. Internet access is still needed to load the web application and the required datasets.

---

## 1. Open Nextclade Web

Open the following website in a desktop browser:

<https://clades.nextstrain.org>

For this practical, use a recent version of **Firefox** or **Chrome** on a desktop computer or laptop.

> [!CAUTION]
> Avoid using Safari for this practical if possible, because Nextclade Web depends on browser technologies that are better supported in Firefox and Chrome.

After the page has loaded, take a moment to identify the main parts of the interface:

- the area for loading sequence data
- the dataset selector
- the button for starting the analysis
- the results table
- the phylogenetic tree view
- the export button

Do not upload your own files yet. We will first run a small example analysis.

---

## 2. Understand the required input format

Nextclade Web accepts **FASTA** sequence files.

For this practical, your input should be influenza A or SARS-CoV-2 consensus genome sequences in one of these formats:

- `.fasta`
- `.fa`
- `.fna`

Each sequence must have a FASTA header line beginning with `>` followed by the nucleotide sequence.

Example:

```text
>sample_001
NNNNATGTTTGTTTTTCTTGTTTTATTGCCACTAGTCTCTAGTCAGTGTGTTAATCTTACAAC...
>sample_002
NNNNATGTTTGTTTTTCTTGTTTTATTGCCACTAGTCTCTAGTCAGTGTGTTAATCTTACAAC...
```

Nextclade Web does **not** accept FASTQ files for this workflow. Use the consensus FASTA files generated in the previous assembly practical.

> [!CAUTION]
> Use uncompressed FASTA files. If your file ends in `.gz`, unzip it first using your file manager before using it in Nextclade Web.

---

## 3. Run Nextclade with example set of your own choice

Before uploading your own data, run the built-in example sequences.

1. In Nextclade Web, find the sequence input area.
2. Choose the **Examples** option.
3. Select an example dataset.
4. Start the analysis by clicking the run/start button.

After a few seconds, Nextclade should show an interactive results table and a tree view.

Questions to check:

1. How many example sequences were analyzed?
2. Which clades are assigned to the example sequences?
3. Do all example sequences pass QC?
4. Are there any sequences with warnings?

---

## 4. Selecting the dataset

Nextclade requires a **reference dataset**. The dataset contains the reference genome, genome annotation, pathogen configuration, reference tree, and other files needed for analysis.
The dataset selector can automatically suggest a compatible dataset after you provide sequences. You can also choose the dataset manually.

> [!TIP]
> Nextclade Web usually uses the latest compatible dataset available when the page is loaded. For reproducible surveillance work, record the dataset name, dataset version if shown, date of analysis, and Nextclade Web version if shown.

---

## 5. Prepare your own consensus sequences

Now prepare the consensus FASTA files from your own Day 03 analysis.

You can analyze either:

- one FASTA file containing multiple sequences, or
- multiple single-sample FASTA files selected together in the browser

> [!TIP]
> If you have many consensus FASTA files, you can select multiple files at once in the file picker. Depending on your browser, you may also be able to drag and drop a folder.

---

## 6. Upload your own sequences

Start a new analysis so that the example sequences are not mixed with your own samples.

1. Clear the example data or use the option to start a new analysis.
2. Drag and drop your consensus FASTA file or files into the input area.
3. Alternatively, click **Select files** and choose the FASTA files from your computer.
4. Wait until Nextclade has read the files.
5. Check whether a dataset is suggested automatically.
6. If necessary, manually select appropriate dataset.
7. Start the analysis.

---

## 7. Inspect the interactive results table

The results table contains one row per input sequence.

Useful columns to inspect include:

| Column / field | What it tells you |
|---|---|
| Sequence name | Which sample the row belongs to |
| Clade | Assigned Nextstrain clade |
| QC status | Overall quality control category |
| QC score | Numerical quality control score |
| Missing data | Regions or number of bases with missing sequence |
| Substitutions | Nucleotide changes compared with the reference |
| Deletions | Deleted positions compared with the reference |
| Non-ACGTN bases | Unexpected or ambiguous characters |
| Amino acid mutations | Changes in coding regions |

Tasks:

1. Find the sequence name column.
2. Sort or scan the table by QC status.
3. Identify any sequences with warnings or failed QC.
4. Compare the clade assignments between samples.
5. Find a sample with missing data and inspect where the missing regions occur.
6. Inspect one sample's nucleotide substitutions and amino acid mutations.

---

## 8. Inspect QC warnings and failed samples

Nextclade may report warnings or errors if sequences are incomplete, very short, contaminated, reversed, or contain too much missing data.

In the results table:

1. Look for the QC status column.
2. Click or expand a sequence with a warning or poor QC result.
3. Review the detailed QC information.
4. Note which QC rule triggered the warning.
5. Decide whether the sequence is suitable for reporting or should be reviewed.

Common warning categories include:

| Warning type | Interpretation |
|---|---|
| Many missing bases | Low coverage, incomplete assembly, or masked regions |
| Mixed or ambiguous bases | Possible mixed infection, sequencing noise, or unresolved bases |
| Private mutations | Unusual mutations relative to nearby sequences |
| Frame shifts or stop codons | Possible sequencing, assembly, or annotation issue |
| Short sequence | Consensus genome may be incomplete |
| Failed alignment | Input may be wrong pathogen, wrong orientation, or poor quality |

> [!NOTE]
> A warning does not always mean that a sample must be discarded. It means the sample should be inspected before interpretation or reporting.

---

## 9. Explore the phylogenetic tree view

Nextclade also places sequences on a reference tree.

Use the tree view to answer:

1. Where are your samples placed on the tree?
2. Do samples with the same clade cluster near each other?
3. Do any samples appear as outliers?
4. Do samples with poor QC appear in unusual positions?

Click individual samples in the table and observe whether the corresponding point or branch is highlighted in the tree view.

> [!CAUTION]
> The Nextclade tree view is useful for rapid orientation and QC. It does not replace a carefully designed phylogenetic analysis. For formal phylogenetic inference, use a dedicated workflow and tools such as IQ-TREE on an appropriate multiple sequence alignment.

---

## 10. Export the Nextclade results

After reviewing the results, export the analysis outputs.

1. Click the **Export** button in the top panel.
2. Download the **TSV** results file first.
3. Optionally download additional outputs, such as:
   - CSV results
   - JSON results
   - aligned FASTA sequences
   - tree file
   - error or warning files, if available
4. Save the files in a clearly named folder, for example:

```text
day_04_nextclade_results/
```

Recommended files to keep:

| Exported file | Purpose |
|---|---|
| `nextclade.tsv` | Main tabular results; recommended for most users |
| `nextclade.csv` | Same type of results in spreadsheet-compatible format |
| `nextclade.json` | Detailed structured results |
| aligned FASTA | Aligned nucleotide sequences |
| tree file | Tree output for further inspection |
| errors file | Fatal errors, if any occurred |

> [!TIP]
> Start with the TSV file. It is usually the safest format for checking results in a spreadsheet or importing into R or Python later.

---

## 11. Use the exported aligned FASTA output

The exported aligned FASTA file can be useful for inspection or downstream analyses.

Possible uses include:

- checking sequence lengths after alignment
- identifying large missing regions
- using the alignment as input for selected downstream tools
- comparing samples in an alignment viewer

> [!CAUTION]
> Do not treat the exported aligned FASTA as a complete phylogenetic workflow by itself. For phylogenetic analysis, check the alignment carefully and use an appropriate tree inference method.

---

## Mini exercise

Try to answer the following questions:

1. Why does Nextclade need a dataset?
2. Which browser action starts an analysis?
3. Which file should most users export first?
4. Which column or field reports the assigned clade?
5. What does missing data tell you about a genome?
6. Why might a sequence fail Nextclade QC?
7. Why is it important to record the dataset version or analysis date?
8. Why is Nextclade Web useful for small interactive analyses but not ideal for large automated pipelines?

---

[⬅ Previous tutorial](./01_iqtree.md)

[⬅ Back to Day 04 overview](README.md)

[⬅ Back to main page](../README.md)
