# Quality control with `fastplong`

## 🎯 Learning goals

By the end of this practical, you should be able to:

- understand why read quality control is important before downstream analysis
- run `fastplong` on FASTQ files
- create filtered FASTQ output files
- generate and open an HTML quality-control report
- filter reads by minimum length
- understand quality filtering specific to long-read data
- compare quality-control results generated with different parameters

## Overview

`fastplong` is a fast all-in-one preprocessing tool for FASTQ files, specifically optimized for Oxford Nanopore (ONT) and other long-read technologies. It can perform read quality control, quality filtering, length filtering, and report generation.

In this practical, we will use `fastplong` to inspect and filter sequencing reads. We will first run it with default parameters, then repeat the analysis with length-based and quality-based filtering.

`fastplong` automatically creates an HTML report that can be opened in a web browser. This report is very useful for checking read quality, read length distributions (N50), and filtering results.

## 1. Activate the Conda environment

First, create and activate the Conda environment that contains `fastplong`.

```bash
conda create -n fastplong -c bioconda -c conda-forge fastplong -y
conda activate fastplong
```

Check that `fastplong` is available.

```bash
fastplong --version
```

If the command prints a version number, the environment is ready.

## 2. Prepare the working directory

Move to the main workshop repository.

```bash
cd ~/2026-Workshop-HSPA-Morocco
```

Create a working directory for this practical.

```bash
mkdir -p analysis/fastplong
cd analysis/fastplong
```

Create directories for input reads and filtered output files.

```bash
mkdir -p input
mkdir -p filtered_reads/default_params
mkdir -p filtered_reads/by_length
mkdir -p filtered_reads/by_quality
```

Copy one FASTQ file into the `input` directory.

```bash
cp ~/2026-Workshop-HSPA-Morocco/data/raw_data/iav_h3n2/SRR32055876.fastq.gz input/
```

Check that the file was copied successfully.

```bash
ls -lh input/
```

> If your FASTQ file has a different name, adjust the commands below accordingly.

## 3. Basic `fastplong` syntax

The basic structure of a `fastplong` command is:

```bash
fastplong \
  --in input_reads.fastq.gz \
  --out filtered_reads.fastq.gz \
  --html fastplong.html \
  --json fastplong.json
```

Important options used in this practical:

| Option | Meaning |
|---|---|
| `--in` | Input FASTQ file |
| `--out` | Output FASTQ file after filtering/trimming |
| `--html` | Output HTML report |
| `--json` | Output JSON report |
| `--verbose` | Print more detailed information to the terminal |
| `--dont_overwrite` | Prevent existing output files from being overwritten |

For ONT reads, we use `--in` and `--out` (replacing the short-read `--in1`/`--out1` terminology).

## 4. Run `fastplong` with default parameters

First, run `fastplong` using its default settings.

```bash
fastplong \
  --verbose \
  --dont_overwrite \
  --in input/SRR32055876.fastq.gz \
  --out filtered_reads/default_params/SRR32055876_fastplong.fastq.gz \
  --html filtered_reads/default_params/SRR32055876_fastplong.html \
  --json filtered_reads/default_params/SRR32055876_fastplong.json
```

This command creates:

- a filtered FASTQ file
- an HTML report
- a JSON report

Check the output files.

```bash
ls -lh filtered_reads/default_params/
```

## 5. Open the HTML report

The HTML report can be opened with a web browser.

```bash
firefox filtered_reads/default_params/SRR32055876_fastplong.html
```

Look at the report and try to answer:

1. How many reads were present before filtering?
2. How many reads passed filtering?
3. What is the read length distribution (N50)?
4. Is there evidence of low-quality bases (Q-scores)?
5. Was the mean quality consistent across the long reads?

## 6. Filter reads by length

Length filtering removes reads shorter than a selected minimum length. This is crucial for ONT to remove short "scraps" that are often non-informative.

The option for minimum length filtering is:

```bash
--length_required <length>
```

The short option is:

```bash
-l <length>
```

Check the `fastplong` help page to find the default value.

```bash
fastplong --help | grep length_required
```

Now discard reads shorter than 500 bp.

```bash
fastplong \
  --verbose \
  --dont_overwrite \
  --length_required 500 \
  --in input/SRR32055876.fastq.gz \
  --out filtered_reads/by_length/SRR32055876_min500.fastq.gz \
  --html filtered_reads/by_length/SRR32055876_min500_fastplong.html \
  --json filtered_reads/by_length/SRR32055876_min500_fastplong.json
```

Check the output files.

```bash
ls -lh filtered_reads/by_length/
```

Open the report.

```bash
firefox filtered_reads/by_length/SRR32055876_min500_fastplong.html
```

### 💬 Discussion

Compare the reports from the default run and the length-filtered run.

Try to answer:

1. How many reads were removed by the 500 bp filter?
2. Did the N50 value change significantly?

## 7. Filter reads by quality

In long-read sequencing, we typically filter based on the average quality score of the entire read rather than sliding-window trimming, as long reads have different error profiles than Illumina.

Important options for quality filtering in `fastplong`:

| Option | Meaning |
|---|---|
| `--mean_qual` | The minimum average quality score (Q-score) required for a read to pass |
| `--n_base_limit` | Maximum number of unknown bases (N) allowed |

Run `fastplong` with a mean quality threshold of 10 (common for ONT).

```bash
fastplong \
  --verbose \
  --dont_overwrite \
  --mean_qual 10 \
  --in input/SRR32055876.fastq.gz \
  --out filtered_reads/by_quality/SRR32055876_q10.fastq.gz \
  --html filtered_reads/by_quality/SRR32055876_q10_fastplong.html \
  --json filtered_reads/by_quality/SRR32055876_q10_fastplong.json
```

## 8. Try different quality thresholds

Now try several different values for `--mean_qual`.

For example:

```bash
fastplong \
  --verbose \
  --dont_overwrite \
  --mean_qual 7 \
  --in input/SRR32055876.fastq.gz \
  --out filtered_reads/by_quality/SRR32055876_q7.fastq.gz \
  --html filtered_reads/by_quality/SRR32055876_q7_fastplong.html \
  --json filtered_reads/by_quality/SRR32055876_q7_fastplong.json
```

```bash
fastplong \
  --verbose \
  --dont_overwrite \
  --mean_qual 15 \
  --in input/SRR32055876.fastq.gz \
  --out filtered_reads/by_quality/SRR32055876_q15.fastq.gz \
  --html filtered_reads/by_quality/SRR32055876_q15_fastplong.html \
  --json filtered_reads/by_quality/SRR32055876_q15_fastplong.json
```

### 💬 Discussion

Compare quality thresholds between 7 and 15.

1. What happens to the "Passed filtering" percentage when using Q15 for ONT?
2. Which setting seems reasonable given the basecaller version used?

## 9. Check all generated reports

List all HTML reports created during this practical.

```bash
find filtered_reads -name "*.html"
```

## 📌 Summary

In this practical, you used `fastplong` to perform long-read quality control and filtering.

| Analysis | Main option used | Output directory |
|---|---|---|
| Default QC | Default parameters | `filtered_reads/default_params/` |
| Length filtering | `--length_required 500` | `filtered_reads/by_length/` |
| Quality filtering | `--mean_qual 10` | `filtered_reads/by_quality/` |

---

[⬅ Back to Day 02 overview](README.md)

[⬅ Back to main page](../README.md)
