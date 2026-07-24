# Removing adapters with `trimmomatic`

## 🎯 Learning goals

By the end of this practical, you should be able to:

- use trimmomatic to trim your paired end Illumina reads


## Overview


## 1. Activate the Conda environment

Activate the Conda environment that contains `trimmomatics`.

```bash
conda activate trimmomatic
```

Check that `trimmomatic` is available.

```bash
trimmomatic --version
```

If the command prints a version number, the environment is ready.

## 2. Prepare the working directory

Move to the main workshop repository.

```bash
cd ~/2026-Workshop-Ghana
```

Create a working directory for this practical.

```bash
mkdir -p analysis/trimmomatic
cd analysis/trimmomatic
```

Create directories for input reads and output files.

```bash
mkdir -p input
mkdir -p output
```

Copy one FASTQ file into the `input` directory.

```bash
cp ~/2026-Workshop-Ghana/course_data/ ...
```

Check that the file was copied successfully.

```bash
ls -lh input/
```

> If your FASTQ file has a different name, adjust the commands below accordingly.

## 3. Basic `trimmomatic` syntax

The basic structure of a `trimmomatic` command is:

```bash
trimmomatic PE --help
```

Important options used in this practical:

| Option | Meaning |
|---|---|
| `--in` | Input FASTQ file |
| `--out` | Output FASTQ file after filtering/trimming |


## 4. Run `trimmomatic`

First, run `trimmomatic` using these settings.

```bash
trimmomatic PE -summary peter.summary.txt -trimlog output/peter.trim.log input/ERR10096087_1.fastq.gz input/ERR10096087_2.fastq.gz -baseout output/peter LEADING:30 TRAILING:30 SLIDINGWINDOW:4:20 MINLEN:35
```

```bash
cat output/peter.summary.txt
ls output/peter_* -halo
```


### 💬 Discussion

Look at the report and try to answer:

1. How many reads were present before filtering?
2. How many reads passed filtering?



## 5. change parameters



```bash
trimmomatic PE -summary output/peter40.summary.txt -trimlog output/peter40.trim.log input/ERR10096087_1.fastq.gz input/ERR10096087_2.fastq.gz -baseout output/peter40 LEADING:30 TRAILING:30 SLIDINGWINDOW:4:20 MINLEN:40
```

Look at the report and try to answer:

1. Did the percentage of dropped reads change? How?


### Extra

Try to find a parameter set where between 0% and 10% of reads survive.


## 📌 Summary

In this practical, you used `trimmomatic` to perform filtering of Illumina short reads.

| Analysis | Main option used | Output directory |
|---|---|---|
| Default QC | Default parameters | `filtered_reads/default_params/` |
| Length filtering | `--length_required 500` | `filtered_reads/by_length/` |
| Quality filtering | `--mean_qual 10` | `filtered_reads/by_quality/` |

---

[⬅ Back to Day 02 overview](README.md)

[⬅ Back to main page](../README.md)
