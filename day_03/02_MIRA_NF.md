# MIRA-NF Flu-ONT

This is a tutorial for running [`CDCgov/MIRA-NF`](https://github.com/CDCgov/MIRA-NF) with `Flu-ONT` data.

In this tutorial you will learn how to:
- launch Nextflow pipeline
- use containers in Nextflow
- prepare samplesheet for MIRA-NF
- prepare expected barcode folder structure for MIRA-NF for ONT data  


MIRA-NF supports `Flu-ONT` and expects ONT input in a samplesheet with columns `barcode,sample_id,sample_type`, plus a run directory containing the samplesheet and the FASTQ folder structure. The project docs also state that `--input`, `--outdir`, `--runpath`, and `--e` are required runtime parameters.

---

## 1. Requirements

Install:
- Nextflow
- Singularity/Apptainer **or** Docker 
- `fastq-dl` (or `fasterq-dump` / ENA download tools)

Example with Conda / Mamba:

```bash
mamba create -n mira-nf -c conda-forge -c bioconda nextflow fastq-dl seqtk
conda activate mira-nf
```

--------------------------------------------------------------------------------

## 2. Download a small public influenza ONT dataset

A simple way is to use `fastq-dl`, which can download public FASTQ files from ENA/SRA using an accession. 
`fastq-dl` supports SRA/ENA Study, Sample, Experiment, or Run accessions.

Example accessions for a public influenza A Oxford Nanopore experiment:
- `PRJNA1294791`
  - Study: "Alphainfluenzavirus influenzae Genome sequencing and assembly"
  - Number of SRA Experiments: 1
  - Instrument: MinION (Oxford Nanopore)
  - *Complete Genome Sequence of Avian Influenza A (H5N1) Virus Isolated from Chicken During a Recent Outbreak in Bangladesh* 
- `PRJNA1420411`
  - Study: "Environmental Surveillance for Assessing Pathogen Emergence (ESCAPE)"
  - Number of SRA Experiments: 9
  - Instrument: MinION (Oxford Nanopore)
  - *Nanopore sequencing of Influenza A virus (H5): avian cloacal and oropharyngeal swabs*

Download:

```bash
mkdir -p 1_data/sra_download
cd 1_data/sra_download
fastq-dl -a PRJNA1294791 --provider SRA --prefix PRJNA1294791
fastq-dl -a PRJNA1420411 --provider SRA --prefix PRJNA1420411
cd ..
```

--------------------------------------------------------------------------------

## 3. Prepare input directory structure for MIRA-NF

```bash
mkdir -p fastq_pass; 
printf "barcode,sample_id,sample_type\n" > samplesheet.csv; 
i=1; 
for f in *.fastq.gz; 
  do bn=$(printf "barcode%02d" "$i"); 
    sid=${f%.fastq.gz}; 
    mkdir -p "fastq_pass/$bn"; 
    mv "$f" "fastq_pass/$bn/$f"; 
    printf "%s,%s,Test\n" "$bn" "$sid" >> samplesheet.csv; 
    i=$((i+1)); 
done
```

--------------------------------------------------------------------------------

## 5. Run MIRA-NF

```bash
cd ..
mkdir -p 2_analysis/1_mira-nf
```

```bash
nextflow run CDCgov/MIRA-NF -r v2.0.0 \
  -profile singularity,slurm \
  --input "$PWD/1_data/sra_download/samplesheet.csv" \
  --runpath "$PWD/1_data/sra_download" \
  --outdir "$PWD/2_analysis/1_mira-nf/results" \
  --e Flu-ONT \
  --check_version false
```


Notes:
- Use **absolute paths** for `--input`, `--runpath`, and `--outdir`. Relative paths can resolve incorrectly and cause missing-file errors.
- `--check_version false` is useful on systems with restricted internet access.
- Pinning `-r v2.0.0` improves reproducibility.
- When running the pipeline on slurm you can set `-profile singularity,slurm`.
- When running MIRA-NF with `--nextclade true` it will automatically run nextclade for passing samples. However, for influenza, Nextclade only supports seasonal human H1N1 and H3N2 at this time.

--------------------------------------------------------------------------------
