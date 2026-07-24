# Mapping with `bwa mem` 

## 🎯 Learning goals

By the end of this practical, you should be able to:

- use bwa to index a reference genome
- use bwa mem to map fastq sequence data to a reference genome


## Overview


## 1. Activate the Conda environment

Activate the Conda environment that contains `bwa2mem`.

```bash
conda activate bwa2mem 
```

Check that `bwa` is available.

```bash
bwa --version
```

If the command prints a version number, the environment is ready.

## 2. Prepare the working directory

Move to the main workshop repository.

```bash
cd ~/2026-Workshop-Ghana
```

Create a working directory for this practical.

```bash
mkdir -p analysis/map
cd analysis/map
```

Create directories for input reads and output files.

```bash
mkdir -p input
mkdir -p output
mkdir -p index
```


## 3. Index the reference genome utilizing `bwa index`

```bash
cp ~/2026-Workshop-Ghana/data/references.tar.gz .
tar -xvzf references.tar.gz
mv references/reference.fasta index
rm -r references
```


```bash
bwa index index/reference.fasta
```


## 4. Map with `bwa mem`

The basic structure of a `bwa mem` command is:

```bash
bwa mem index/reference.fasta input/peter_1P input/peter_2P > output/peter.sam
```

```bash
samtools sort output/peter.sam > output/peter.sorted.bam
```

```bash
samtools index output/peter.sorted.bam
```

## 5. Look at the results with IGV




## 📌 Summary

In this practical, you used `bwa mem` to perform short read mapping and you used `samtools` to sort and index the result. Furthermore you looked at the results with IGV.


---

[⬅ Back to Day 02 overview](README.md)

[⬅ Back to main page](../README.md)
