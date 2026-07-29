# Variant calling with `freebayes` 

## 🎯 Learning goals

By the end of this practical, you should be able to:

- run a nextflow pipeline


## Overview


## 1. Activate the first conda environment

Activate the Conda environment that contains `aligntrim`.

```bash
conda activate nextflow_25
```

Check that `nextflow` is available.

```bash
nextflow --version
```


## 2. Prepare the working directory

Move to the main workshop repository.

```bash
cd ~/2026-Workshop-Ghana
```

Create a working directory for this practical.

```bash
mkdir -p analysis/amplicon-nf
cd analysis/amplicon-nf
```

Create directories for input reads and output files.

```bash
mkdir -p input
mkdir -p output
```

Copy the bam and bai file into the `input` directory.

```bash
cp ~/2026-Workshop-Ghana/assets/samplesheet_ill.csv input
```

## 3. Run `amplicon-nf` with `nextflow`


```bash
nextflow run ~/amplicon-nf \
  -profile conda \
  --input input/samplesheet_ill.csv \
  --outdir output \
  --store_dir ~/2026-Workshop-Ghana/model_dir \
  -resume
```
