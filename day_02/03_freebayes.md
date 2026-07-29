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
cp ~/2026-Workshop-Ghana/analysis/map/output/*bam* input
```

We also need the primer.bed file

```bash
cp ~/2026-Workshop-Ghana/assets/schemes/mpxv/primer.bed input
```

Check that the file was copied successfully.

```bash
ls -lh input/
```


## 3. Run `align_trim`

We can use _align_trim_ to trim the primers of our sequences and we get a report of the depth for earch of the primer regions. This helps us to easily assess the quality of our amplification.

```bash
align_trim --samfile input/peter.sorted.bam --output output/peter.primertrimmed.bam --report output/peter.align_trim_report.tsv --amp-depth-report output/peter.amp_depth_report.tsv --no-read-groups input/primer.bed
```

Have a look at the depth of each primer region.

```bash
nano output/peter.amp_depth_report.tsv
```

Which amplicons are well represented and which are not

### 💬 Discussion

- Which primer pair was sequenced deepest, what is the average depth in that region?

### Preparation for the next steps

In order to look at these files in detail and to also apply variant calling on them we need to sort and index the mapped and primer trimmed reads. You can stay in the same environment, it has the _samtools_ already installed. First we sort the bam file

```bash
samtools sort -o output/peter.primertrimmed.sorted.bam output/peter.primertrimmed.bam
```

Then we index that file

```bash
samtools index output/peter.primertrimmed.sorted.bam 
```


## 4. Look at the results in IGV

Load the bed file and the primertrimmed bam file



## 5. freebayes

We have seen that many regions of our reads are exactly the same as the reference genome. But we have also seen that a few variants with respect to our reference exist. We will now use the variant caller _freebayes_ to give us just those positions and to give a statistical measure to asses their certainty.

First we need to activate the right environment.

```bash
conda activate freebayes
```

Then we create the folders we will use in the exercise as we have done before


```bash
cd ~/2026-Workshop-Ghana
mkdir -p analysis/freebayes
cd analysis/freebayes
mkdir input 
mkdir output
```

And we put the files where we want to find them

```bash
cp ../aligntrim/output/peter.primertrimmed.sorted.bam input/
cp ../bwamem/index/reference.fasta input/
```

After this preparation we can now finally call the variant caller

```bash
freebayes -f input/reference.fasta input/peter.primertrimmed.sorted.bam > output/peter.vcf
```

Now have a look at the resulting `output/peter.vcf`

```bash
nano output/peter.vcf
```


### 💬 Discussion

- Get a rough understanding of the VCF file format
- We can see a few variants that are almost certainly real, e.g. at position 38684


Often the resulting vcf files are compressed with the _bgzip_ tool

```bash
bgzip output/peter.vcf
```

### IGV

Load the vcf file in IGV and look at the positions that we investigated before




---

[⬅ Back to Day 02 overview](README.md)

[⬅ Back to main page](../README.md)
