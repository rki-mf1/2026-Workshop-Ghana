# Variant calling with `freebayes` 

## 🎯 Learning goals

By the end of this practical, you should be able to:

- align_trim
- use freebayes to call variants on a sample with respect to a reference genome


## Overview


## 1. Activate the first conda environment

Activate the Conda environment that contains `aligntrim`.

```bash
conda activate aligntrim
```

Check that `aligntrim` is available.

```bash
align_trim --version
```


## 2. Prepare the working directory

Move to the main workshop repository.

```bash
cd ~/2026-Workshop-Ghana
```

Create a working directory for this practical.

```bash
mkdir -p analysis/aligntrim
cd analysis/aligntrim
```

Create directories for input reads and output files.

```bash
mkdir -p input
mkdir -p output
```

Copy the bam and bai file into the `input` directory.

```bash
cp ~/2026-Workshop-Ghana/bwamem/output/*bam* input
```

We also need the primer.bed file

```bash
cp ~/2026-Workshop-Ghana/data/primer.bed input
```

Check that the file was copied successfully.

```bash
ls -lh input/
```


## 3. Run `align_trim`


```bash
align_trim --samfile input/peter.sorted.bam --output output/peter.primertrimmed.bam --report output/peter.align_trim_report.tsv --amp-depth-report output/peter.amp_depth_report.tsv --no-read-groups input/primer.bed
```

```bash
cat output/peter.amp_depth_report.tsv
```

Which amplicons are well represented and which are not


```bash
samtools sort -o output/peter.primertrimmed.sorted.bam output/peter.primertrimmed.bam
```

```bash
samtools index output/peter.primertrimmed.sorted.bam 
```


## 4. IGV

load the bed file



## 5. freebayes


```bash
conda activate freebayes
```


```bash
cd ~/2026-Workshop-Ghana
mkdir -p analysis/freebayes
cd analysis/freebayes
mkdir input 
mkdir output
```

```bash
cp ../aligntrim/output/peter.primertrimmed.sorted.bam input/
cp ../bwamem/index/reference.fasta input/
```

```bash
freebayes -f input/reference.fasta input/peter.primertrimmed.sorted.bam > output/peter.vcf
bgzip output/peter.vcf
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
