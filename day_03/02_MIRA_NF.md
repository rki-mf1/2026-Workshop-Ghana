[⬅ Back to Day 03 overview](README.md)

# MIRA-NF

## 🎯 Learning goals

By the end of this practical, you should be able to:

- explain what `MIRA-NF` is used for
- launch a Nextflow pipeline
- run a Nextflow workflow with containers
- prepare a MIRA-NF samplesheet
- organize ONT FASTQ files in the barcode-based folder structure expected by MIRA-NF
- run `MIRA-NF` on Influenza A and SARS-CoV-2 ONT data

---

## Overview

In this practical, we will run [`CDCgov/MIRA-NF`](https://github.com/CDCgov/MIRA-NF) on Oxford Nanopore Technologies (ONT) sequencing data.

`MIRA-NF` can be used for reference-based genome reconstruction and variant calling for several respiratory viruses, including **Influenza A**, **SARS-CoV-2**, and **RSV**.

For ONT data, MIRA-NF expects a run directory containing:

1. a `samplesheet.csv` file
2. a `fastq_pass/` directory
3. barcode-specific subfolders such as `barcode01`, `barcode02`, `barcode03`

The expected structure looks like this:

```bash
fastq_pass/
├── barcode01/
│   └── sample_1.fastq.gz
├── barcode02/
│   └── sample_2.fastq.gz
└── barcode03/
    └── sample_3.fastq.gz
```

The samplesheet must contain the columns:

```
barcode,sample_id,sample_type
```

> [!NOTE]
> This folder structure is typical for ONT sequencing runs after basecalling and demultiplexing.
> In this tutorial, the FASTQ files were downloaded manually, so we will create the expected structure ourselves.

---

## 1. Create and activate a Nextflow environment

To run MIRA-NF, we need Nextflow.

Create and activate Conda environment containing Nextflow:

```bash
conda create -y -n nextflow -c bioconda nextflow=23.10.0
conda activate nextflow
```

> [!NOTE]
> This Conda environment installs Nextflow.
> It does not install Singularity, Apptainer, or Docker.
> One container engine must already be available on the system.

---

## 2. Prepare input directory structure for MIRA-NF

### for Influenza A

```bash
# Move to the directory containing the raw IAV H3N2 FASTQ files
cd ~/2026-Workshop-HSPA-Morocco/data/raw_data/iav_h3n2

# MIRA-NF expects ONT-like input organization:
# fastq_pass/barcodeXX/*.fastq.gz
#
# This structure is typically produced by ONT sequencing runs after basecalling
# and demultiplexing. Since these example files were downloaded manually,
# we create the expected folder structure ourselves.
mkdir -p fastq_pass

# Create the header line for the MIRA-NF samplesheet
printf "barcode,sample_id,sample_type\n" > samplesheet.csv

# Assign each FASTQ file to an artificial barcode folder and add it to the samplesheet.
#
# The barcode names used here, such as barcode01, barcode02, etc., are arbitrary.
# They do not represent real sequencing barcodes in this tutorial dataset.
# We use them only to reproduce the folder structure expected by MIRA-NF.
i=1
 
for f in *.fastq.gz
do
    # Create a barcode name with two digits, for example barcode01
    bn=$(printf "barcode%02d" "$i")

    # Use the FASTQ filename, without the .fastq.gz extension, as the sample ID
    sid=${f%.fastq.gz}

    # Create the barcode-specific folder inside fastq_pass
    mkdir -p "fastq_pass/$bn"

    # Move the FASTQ file into the corresponding barcode folder
    mv "$f" "fastq_pass/$bn/$f"

    # Add one line to samplesheet.csv:
    # barcode name, sample ID, and sample type
    printf "%s,%s,Test\n" "$bn" "$sid" >> samplesheet.csv

    # Increase the barcode counter
    i=$((i+1))
done
```

Check the resulting structure:

```bash
tree .
```

Check the samplesheet:

```bash
cat samplesheet.csv
```

> [!TIP]
> The barcode names used here, such as barcode01, barcode02, and barcode03, are artificial.
> They do not represent real sequencing barcodes in this tutorial dataset.
> We use them only to reproduce the folder structure expected from an ONT sequencing run.

### for SARS-CoV-2

```bash
# Move to the directory containing the raw SARS-CoV-2 FASTQ files
cd ~/2026-Workshop-HSPA-Morocco/data/raw_data/sc2

# MIRA-NF expects ONT-like input organization:
# fastq_pass/barcodeXX/*.fastq.gz
#
# This structure is typically produced by ONT sequencing runs after basecalling
# and demultiplexing. Since these example files were downloaded manually,
# we create the expected folder structure ourselves.
mkdir -p fastq_pass

# Create the header line for the MIRA-NF samplesheet
printf "barcode,sample_id,sample_type\n" > samplesheet.csv

# Assign each FASTQ file to an artificial barcode folder and add it to the samplesheet.
#
# The barcode names used here, such as barcode01, barcode02, etc., are arbitrary.
# They do not represent real sequencing barcodes in this tutorial dataset.
# We use them only to reproduce the folder structure expected by MIRA-NF.
i=1
 
for f in *.fastq.gz
do
    # Create a barcode name with two digits, for example barcode01
    bn=$(printf "barcode%02d" "$i")

    # Use the FASTQ filename, without the .fastq.gz extension, as the sample ID
    sid=${f%.fastq.gz}

    # Create the barcode-specific folder inside fastq_pass
    mkdir -p "fastq_pass/$bn"

    # Move the FASTQ file into the corresponding barcode folder
    mv "$f" "fastq_pass/$bn/$f"

    # Add one line to samplesheet.csv:
    # barcode name, sample ID, and sample type
    printf "%s,%s,Test\n" "$bn" "$sid" >> samplesheet.csv

    # Increase the barcode counter
    i=$((i+1))
done
```

Check the resulting structure:

```bash
tree .
```

Check the samplesheet:

```bash
cat samplesheet.csv
```

> [!WARNING]
> Run the folder-preparation command only **once** per dataset.
> The loop moves the FASTQ files from the current directory into `fastq_pass/barcodeXX/`.
> If you run it again, there may be no `*.fastq.gz` files left in the top-level directory, and the new samplesheet may be empty.

---

## 3. Run MIRA-NF


### for Influenza A

```bash
# Move back to the workshop repository
cd ~/2026-Workshop-HSPA-Morocco

# Create an output directory for the MIRA-NF IAV H3N2 run
mkdir -p analysis/mira-nf_iav_h3n2
```

```bash
nextflow run CDCgov/MIRA-NF -r v2.0.0 \
  -profile singularity,local \
  --input "$PWD/data/raw_data/iav_h3n2/samplesheet.csv" \
  --runpath "$PWD/data/raw_data/iav_h3n2" \
  --outdir "$PWD/analysis/mira-nf_iav_h3n2/results" \
  --e Flu-ONT \
  --check_version false
```

> [!NOTE]
> The option `--e Flu-ONT` tells MIRA-NF to run the Influenza ONT workflow.

### for SARS-CoV-2

```bash
# Move back to the workshop repository
cd ~/2026-Workshop-HSPA-Morocco

# Create an output directory for the MIRA-NF SARS-CoV-2 run
mkdir -p analysis/mira-nf_sc2
```

```bash
nextflow run CDCgov/MIRA-NF -r v2.0.0 \
  -profile singularity,local \
  --input "$PWD/data/raw_data/sc2/samplesheet.csv" \
  --runpath "$PWD/data/raw_data/sc2" \
  --outdir "$PWD/analysis/mira-nf_sc2/results" \
  --e SC2-Whole-Genome-ONT \
  --check_version false
```

> [!NOTE]
> The option `--e SC2-Whole-Genome-ONT` tells MIRA-NF to run the SARS-CoV-2 ONT workflow.

---

> [!IMPORTANT]
> When splitting long commands across multiple lines in Bash,
> the backslash `\` must be the final character on the line.
> **Do not add spaces after it**, otherwise the command will break.

---

> [!NOTE]
> - Use **absolute paths** for `--input`, `--runpath`, and `--outdir`. Relative paths can resolve incorrectly and cause missing-file errors.
> - `--check_version false` is useful on systems with restricted internet access.
> - Pinning the pipeline with `-r v2.0.0` improves reproducibility.
> - When running the pipeline on slurm you can set `-profile singularity,slurm`.
> - When running MIRA-NF with `--nextclade true`, Nextclade will be run for passing samples. For influenza, interpret this carefully: default Nextclade influenza support focuses on Influenza A/B HA datasets such as H3N2 and H1N1pdm, not every possible influenza segment or subtype.

---

## 📌 Summary

In this practical, you prepared ONT-style input folders and samplesheets for two datasets:

| Dataset | Workflow | Input directory | Output directory |
|---|---|---|---|
| Influenza A H3N2 | `Flu-ONT` | `data/raw_data/iav_h3n2` | `analyses/day_03/mira-nf/iav_h3n2/results` |
| SARS-CoV-2 | `SC2-Whole-Genome-ONT` | `data/raw_data/sc2` | `analyses/day_03/mira-nf/sc2/results` |

You used:

| Command / option | Purpose |
|---|---|
| `nextflow run` | Launch a Nextflow pipeline |
| `-profile singularity,local` | Run with Singularity on the local machine |
| `--input` | Path to the MIRA-NF samplesheet |
| `--runpath` | Path to the ONT run directory containing `fastq_pass/` |
| `--outdir` | Output directory for pipeline results |
| `--e` | MIRA-NF experiment/workflow type |
| `--check_version false` | Skip online version checking |

---

[⬅ Back to Day 03 overview](README.md)

[⬅ Back to main page](../README.md)
