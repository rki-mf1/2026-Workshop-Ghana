# Pipeline: `amplicon-nf`

In this practical, we run the `amplicon-nf` pipeline with Nextflow and inspect the output files produced for mpox amplicon sequencing data.

The focus is on understanding where variant calling fits in the analysis and how to inspect sample-level results, including files produced from read mapping, variant calling, and consensus genome reconstruction.

## Overview

Amplicon sequencing produces short reads that cover selected regions of a viral genome.

To reconstruct a genome and identify differences from a reference, a typical workflow includes:

1. **Input reads:** raw sequencing reads for each sample.
2. **Read trimming and filtering:** remove low-quality sequence and adapter/primer artifacts.
3. **Reference mapping:** align reads to a reference genome.
4. **Variant calling:** identify positions where reads differ from the reference.
5. **Consensus reconstruction:** build a final genome sequence for each sample.
6. **Quality control:** summarize coverage, missing data, and possible problems.

In this workflow, **FreeBayes** is used for variant calling. It examines mapped reads and reports candidate variants in a VCF file.

## 1. Activate the Nextflow Environment

Activate the Conda environment that contains Nextflow.

```bash
conda activate nextflow_25
```

Check that Nextflow is available.

```bash
nextflow -version
```

You should see a Nextflow version printed in the terminal.

## 2. Prepare the Working Directory

Move to the main workshop repository.

```bash
cd ~/2026-Workshop-Ghana
```

Create a working directory for this practical.

```bash
mkdir -p analysis/amplicon-nf
cd analysis/amplicon-nf
```

Create directories for input files and output files.

```bash
mkdir -p input
```

Copy the prepared samplesheet into the `input` directory.

```bash
cp ~/2026-Workshop-Ghana/assets/samplesheet_ill.csv input/
```

Check that the samplesheet is present.

```bash
ls -lh input
```

Inspect the samplesheet.

```bash
cat input/samplesheet_ill.csv
```

Discuss:

- How many samples are listed?
- Which columns are present?
- Where are the input read files located?
- Do the sample names look consistent?

## 3. Run `amplicon-nf` with Nextflow

Run the pipeline.

```bash
nextflow run ~/amplicon-nf \
  -profile conda \
  --input input/samplesheet_ill.csv \
  --outdir output \
  --store_dir ~/2026-Workshop-Ghana/model_dir \
  -resume
```

### What the Options Mean

| Option | Meaning |
|---|---|
| `nextflow run ~/amplicon-nf` | Run the pipeline located at `~/amplicon-nf` |
| `-profile conda` | Use Conda environments defined by the pipeline |
| `--input input/samplesheet_ill.csv` | Use the prepared samplesheet |
| `--outdir output` | Write results to the `output` directory |
| `--store_dir ~/2026-Workshop-Ghana/model_dir` | Use the workshop model/reference directory |
| `-resume` | Reuse completed Nextflow steps if the run is repeated |

### Checkpoint

When the run finishes successfully, Nextflow should report that the workflow completed.

If the command fails, do not delete files immediately. Read the error message and check:

- Did you activate the correct Conda environment?
- Are you in `~/2026-Workshop-Ghana/analysis/amplicon-nf`?
- Does `input/samplesheet_ill.csv` exist?
- Is the path `~/amplicon-nf` correct?
- Is the model directory available?

## 4. Inspect the Main Output Directory

Move into the output directory.

```bash
cd output
ls -lah
```

You should see a mixture of:

- run reports
- logs
- sample-specific output directories
- summary files

Open the pipeline report.

```bash
firefox mpvx_amplicon-nf_run-report.html
```

### Small Exercise 1: Overall Run Quality

Inspect the report and answer:

1. Did all samples complete successfully?
2. Are any samples flagged as lower quality?
3. Which sample would you inspect first?
4. Is there evidence of uneven performance across samples?

Write down one sentence:

``
Overall, the run looks ...
```

## 5. Inspect One Sample in Detail

Move into the directory for one sample.

The example below uses `alva`.

```bash
cd alva
ls -la
```

## 6. Recognize Common Output Files

The exact filenames may differ depending on the pipeline version, but you may see files with extensions such as:

| File type | Example extension | What it usually contains |
|---|---|---|
| Alignment file | `.bam` | Reads mapped to the reference genome |
| Alignment index | `.bai` | Index that allows fast access to the BAM file |
| Variant calls | `.vcf` or `.vcf.gz` | Variants called from mapped reads |
| Consensus genome | `.fa`, `.fasta`, or `.consensus.fasta` | Final reconstructed genome sequence |
| Coverage summary | `.bed`, `.tsv`, `.txt`, `.html` | Information about read depth across the genome |
| Log file | `.log`, `.txt` | Messages from tools run by the pipeline |
| QC report | `.html`, `.tsv`, `.json` | Quality metrics and summaries |

Use `ls` to look for these files:

```bash
ls -lh
```

1. Which file is most likely the mapped read alignment?
2. Which file is most likely the variant call file?
3. Which file is most likely the final consensus genome?
4. Which files are reports or summaries rather than primary analysis files?
5. Which files would you share with someone who wants to inspect variants?
