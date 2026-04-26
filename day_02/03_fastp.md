# Quality control with `fastp`

## 🎯 Learning goals

By the end of this practical, you should be able to:

- understand why read quality control is important before downstream analysis
- run `fastp` on FASTQ files
- create filtered FASTQ output files
- generate and open an HTML quality-control report
- filter reads by minimum length
- trim low-quality regions using a sliding-window approach
- compare quality-control results generated with different parameters

## Overview

`fastp` is a fast all-in-one preprocessing tool for FASTQ files. It can perform read quality control, adapter trimming, quality filtering, length filtering, and report generation.

In this practical, we will use `fastp` to inspect and filter sequencing reads. We will first run it with default parameters, then repeat the analysis with length-based and quality-based filtering.

`fastp` automatically creates an HTML report that can be opened in a web browser. This report is very useful for checking read quality, read length distributions, adapter content, and filtering results.

## 1. Activate the Conda environment

First, activate the Conda environment that contains `fastp`.

```bash
conda activate fastp
```

Check that `fastp` is available.

```bash
fastp --version
```

If the command prints a version number, the environment is ready.

## 2. Prepare the working directory

Move to the main workshop repository.

```bash
cd ~/2026-Workshop-HSPA-Morocco
```

Create a working directory for this practical.

```bash
mkdir -p day_02/fastp_qc
cd day_02/fastp_qc
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
cp ../../data/raw_data/iav_h3n2/SRR32055876.fastq.gz input/
```

Check that the file was copied successfully.

```bash
ls -lh input/
```

> If your FASTQ file has a different name, adjust the commands below accordingly.

## 3. Basic `fastp` syntax

The basic structure of a `fastp` command is:

```bash
fastp \
  --in1 input_reads.fastq.gz \
  --out1 filtered_reads.fastq.gz \
  --html fastp.html \
  --json fastp.json
```

Important options used in this practical:

| Option | Meaning |
|---|---|
| `--in1` | Input FASTQ file |
| `--out1` | Output FASTQ file after filtering/trimming |
| `--html` | Output HTML report |
| `--json` | Output JSON report |
| `--verbose` | Print more detailed information to the terminal |
| `--dont_overwrite` | Prevent existing output files from being overwritten |

For single-end reads, we use `--in1` and `--out1`.

For paired-end reads, `fastp` can also use `--in2` and `--out2`, but we will not use those options in this practical.

## 4. Run `fastp` with default parameters

First, run `fastp` using its default settings.

```bash
fastp \
  --verbose \
  --dont_overwrite \
  --in1 input/SRR32055876.fastq.gz \
  --out1 filtered_reads/default_params/SRR32055876.fastp.fastq.gz \
  --html filtered_reads/default_params/SRR32055876.fastp.html \
  --json filtered_reads/default_params/SRR32055876.fastp.json
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
firefox filtered_reads/default_params/SRR32055876.fastp.html
```

If you are working on a system without a graphical browser, you can download the HTML file and open it on your own computer.

Look at the report and try to answer:

1. How many reads were present before filtering?
2. How many reads passed filtering?
3. What is the read length distribution?
4. Is there evidence of low-quality bases?
5. Was adapter content detected?

## 6. Filter reads by length

Length filtering removes reads shorter than a selected minimum length.

This is useful when very short reads are unlikely to be informative for downstream analysis.

The option for minimum length filtering is:

```bash
--length_required <length>
```

The short option is:

```bash
-l <length>
```

Check the `fastp` help page to find the default value.

```bash
fastp --help | grep length_required
```

Now discard reads shorter than 500 bp.

```bash
fastp \
  --verbose \
  --dont_overwrite \
  --length_required 500 \
  --in1 input/SRR32055876.fastq.gz \
  --out1 filtered_reads/by_length/SRR32055876.min500.fastq.gz \
  --html filtered_reads/by_length/SRR32055876.min500.fastp.html \
  --json filtered_reads/by_length/SRR32055876.min500.fastp.json
```

Check the output files.

```bash
ls -lh filtered_reads/by_length/
```

Open the report.

```bash
firefox filtered_reads/by_length/SRR32055876.min500.fastp.html
```

### 💬 Discussion

Compare the terminal output and the HTML reports from the default run and the length-filtered run.

Try to answer:

1. How many reads were present before filtering?
2. How many reads passed after filtering with `--length_required 500`?
3. How many reads were removed?
4. Did the read length distribution change?

## 7. Filter reads by quality

`fastp` can also trim low-quality regions using a sliding-window approach.

A sliding window moves along each read and calculates the mean quality score in that window. If the mean quality drops below the selected threshold, `fastp` can trim bases from the read.

In this practical, we will use front trimming.

Important options:

| Option | Meaning |
|---|---|
| `--cut_front` | Move a sliding window from the front of the read and trim low-quality bases |
| `--cut_mean_quality` | Mean quality threshold required in the sliding window |
| `--cut_window_size` | Sliding window size; default is 4 |

The short options are:

| Short option | Long option |
|---|---|
| `-5` | `--cut_front` |
| `-M` | `--cut_mean_quality` |
| `-W` | `--cut_window_size` |

Run `fastp` with front trimming and a mean quality threshold of 15.

```bash
fastp \
  --verbose \
  --dont_overwrite \
  --cut_front \
  --cut_mean_quality 15 \
  --in1 input/SRR32055876.fastq.gz \
  --out1 filtered_reads/by_quality/SRR32055876.q15.fastq.gz \
  --html filtered_reads/by_quality/SRR32055876.q15.fastp.html \
  --json filtered_reads/by_quality/SRR32055876.q15.fastp.json
```

Check the output files.

```bash
ls -lh filtered_reads/by_quality/
```

Open the report.

```bash
firefox filtered_reads/by_quality/SRR32055876.q15.fastp.html
```

## 8. Try different quality thresholds

Now try several different values for `--cut_mean_quality`.

For example:

```bash
fastp \
  --verbose \
  --dont_overwrite \
  --cut_front \
  --cut_mean_quality 5 \
  --in1 input/SRR32055876.fastq.gz \
  --out1 filtered_reads/by_quality/SRR32055876.q5.fastq.gz \
  --html filtered_reads/by_quality/SRR32055876.q5.fastp.html \
  --json filtered_reads/by_quality/SRR32055876.q5.fastp.json
```

```bash
fastp \
  --verbose \
  --dont_overwrite \
  --cut_front \
  --cut_mean_quality 30 \
  --in1 input/SRR32055876.fastq.gz \
  --out1 filtered_reads/by_quality/SRR32055876.q30.fastq.gz \
  --html filtered_reads/by_quality/SRR32055876.q30.fastp.html \
  --json filtered_reads/by_quality/SRR32055876.q30.fastp.json
```

⚠️ Make sure each run has a unique output file name and a unique HTML report name. Otherwise, previous reports may be overwritten.

### 💬 Discussion

Try quality thresholds between 5 and 30.

Compare the reports and answer:

1. What happens when the quality threshold is very low?
2. What happens when the quality threshold is very high?
3. How does the number of reads passing filtering change?
4. How does the read length distribution change?
5. Which setting seems reasonable for this dataset?

## 9. Check all generated reports

List all HTML reports created during this practical.

```bash
find filtered_reads -name "*.html"
```

You should see reports from the default, length-filtered, and quality-filtered runs.

## 📌 Summary

In this practical, you used `fastp` to perform read quality control and filtering.

You ran:

| Analysis | Main option used | Output directory |
|---|---|---|
| Default QC | Default parameters | `filtered_reads/default_params/` |
| Length filtering | `--length_required 500` | `filtered_reads/by_length/` |
| Quality trimming | `--cut_front --cut_mean_quality 15` | `filtered_reads/by_quality/` |

You also learned how to generate and compare HTML reports.

These QC reports help you decide whether your reads are suitable for downstream steps such as mapping, genome reconstruction, and variant calling.

---

[⬅ Back to Day 02 overview](README.md)

[⬅ Back to main page](../README.md)