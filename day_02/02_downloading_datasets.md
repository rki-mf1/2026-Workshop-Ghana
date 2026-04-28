# Downloading datasets

To download the small datasets used in this workshop, we first need to install a few tools.

We will use **NCBI SRA Toolkit**. The reads are downloaded with `prefetch`, converted to FASTQ with `fasterq-dump`, and compressed with `pigz`.

```bash
# install SRA Toolkit and pigz
conda create -y -n sra-tools -c conda-forge -c bioconda sra-tools pigz

# install ncbi-datasets
conda create -y -n ncbi-datasets-cli conda-forge::ncbi-datasets-cli
```

We will continue working in the same directory as before.

```bash
cd ~/2026-Workshop-HSPA-Morocco
```

## Influenza A

```bash
# activate conda environment
conda activate sra-tools

# create directory for raw Influenza A data
mkdir -p data/raw_data/iav_h3n2
cd data/raw_data/iav_h3n2

# download reads from SRA
for acc in \
  SRR32055876 \
  SRR32055888 \
  SRR32055875 \
  SRR32055882 \
  SRR32055884 \
  SRR32055883
do
  echo "Downloading ${acc}"

  # download the SRA file
  prefetch "$acc" --output-directory .

  # convert SRA to FASTQ
  fasterq-dump "${acc}/${acc}.sra" \
    --split-files \
    --threads 4 \
    --outdir . \
    --temp .

  # compress FASTQ files
  pigz -p 4 "${acc}"*.fastq

  # remove downloaded SRA directory after successful conversion
  rm -r "$acc"
done

cd ../../..
```

## SARS-CoV-2

```bash
# create directory for raw SARS-CoV-2 data
mkdir -p data/raw_data/sc2
cd data/raw_data/sc2

# download reads from SRA
for acc in \
  SRR18858570 \
  SRR23056640 \
  SRR27995776 \
  SRR21357556
do
  echo "Downloading ${acc}"

  # download the SRA file
  prefetch "$acc" --output-directory .

  # convert SRA to FASTQ
  fasterq-dump "${acc}/${acc}.sra" \
    --split-files \
    --threads 4 \
    --outdir . \
    --temp .

  # compress FASTQ files
  pigz -p 4 "${acc}"*.fastq

  # remove downloaded SRA directory after successful conversion
  rm -r "$acc"
done

cd ../../..

# deactivate conda environment
conda deactivate
```

---

# Downloading references

## Influenza A

```bash
# activate conda environment
conda activate ncbi-datasets-cli

# create directory for Influenza A reference genome
mkdir -p data/references/iav_h3n2
cd data/references/iav_h3n2

# download genome using ncbi-datasets-cli
datasets download genome accession GCA_039415675.1 --include genome

# unzip downloaded archive
unzip ncbi_dataset.zip

# move FASTA file into the current directory
mv ncbi_dataset/data/GCA_039415675.1/*.fna .

# rename FASTA file
mv GCA_039415675.1_ASM3941567v1_genomic.fna A_DistrictOfColumbia_27_2023_H3N2_ASM3941567v1.fasta

# cleanup
rm -r md5sum.txt ncbi_dataset* README.md

cd ../../..
```

## SARS-CoV-2

```bash
# create directory for SARS-CoV-2 reference genome
mkdir -p data/references/sc2
cd data/references/sc2

# download genome using ncbi-datasets-cli
datasets download genome accession GCF_009858895.2 --include genome

# unzip downloaded archive
unzip ncbi_dataset.zip

# move FASTA file into the current directory
mv ncbi_dataset/data/*/*.fna .

# rename FASTA file
mv GCF_009858895.2_ASM985889v3_genomic.fna Wuhan-Hu-1_ASM985889v3.fasta

# cleanup
rm -r md5sum.txt ncbi_dataset* README.md

cd ../../..

# deactivate conda environment
conda deactivate
```
