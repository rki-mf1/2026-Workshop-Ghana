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
mkdir -p analysis/nextflow
cd analysis/nextflow
```

Create directories for input reads and output files.

```bash
mkdir -p input
mkdir -p output
```

Copy the samplesheet to the input folder

```bash
cp ~/2026-Workshop-Ghana/assets/samplesheet_illumina.csv input
```

Because each laptop is slightly different we could not easily prepare the samplesheet for you. You have to edit it yourself.


```bash
nano input/samplesheet_illumina.csv
```


## 3. Run `nextflow`

You will now about the power of nextflow. You can run the analysis that we have done manually on one sample and run it on many samples and more with one call. 

```bash
nextflow run ~/amplicon-nf -profile conda --input input/samplesheet_ill.csv outdir output --store_dir ~/2026-Workshop-Ghana/model_dir -resume
```

By default nextflow stores all its results in the `results` folder. 

```bash
cd results
```


### 💬 Discussion

- Have a look around and find results that we manually calculated before
- Also find the assembly and the html report that is calculated by this pipeline for each sample

[⬅ Back to Day 02 overview](README.md)

[⬅ Back to main page](../README.md)
