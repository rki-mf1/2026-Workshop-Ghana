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
cp ~/2026-Workshop-Ghana/course_data/ERR10096087_1.fastq.gz input
cp ~/2026-Workshop-Ghana/course_data/ERR10096087_2.fastq.gz input
```

Check that the file was copied successfully.

```bash
ls -lh input/
```

### 💬 Discussion

- Which file is bigger ? (You should be able to see this information from the last ouput)
- How many reads are in each file ? (Use `grep -c` or `wc` to find out)

## 3. Basic `trimmomatic` syntax
We will call the chosen sample _peter_, just to things easier down the line for us. We will run a few different tools on peter. The riste one will be _trimmomatic_. The basic structure of a `trimmomatic` command is:

```bash
trimmomatic PE --help
```

Important options used in this practical:

| Option | Meaning |
|---|---|
| `[-basein <inputBase> \| <inputFile1> <inputFile2>]` | You have the option to either provide a prefix or two fastq files explicitly |
| `[-baseout <outputBase> \| <outputFile1P> <outputFile1U> <outputFile2P> <outputFile2U>]` | same as above |


## 4. Run `trimmomatic`

 Firstly, run `trimmomatic` using these settings.

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



## 5. Change parameters

Now we will be more strict and demand that reads are at least 40 nucleotides long. Otherwise they get filtered out.


```bash
trimmomatic PE -summary output/peter40.summary.txt -trimlog output/peter40.trim.log input/ERR10096087_1.fastq.gz input/ERR10096087_2.fastq.gz -baseout output/peter40 LEADING:30 TRAILING:30 SLIDINGWINDOW:4:20 MINLEN:40
```

Look at the report and try to answer:

1. Did the percentage of dropped reads change? How?


### Extra

Try to find a parameter set where between 0% and 10% of reads survive.


## 📌 Summary

In this practical, you used `trimmomatic` to perform filtering of Illumina short reads.


---

[⬅ Back to Day 02 overview](README.md)

[⬅ Back to main page](../README.md)
