# Preprocessing of ONT data (fastplong)

## 1. Environment Setup

To begin, create a dedicated environment containing `fastplong`.
```bash
# Create the environment
conda create -n fastplong -c bioconda -c conda-forge fastplong -y
# Activate the environment
conda activate fastplong
```

## 2. Basic Usage

`fastplong` is an ultra-fast quality control and preprocessing tool specifically designed for Oxford Nanopore (ONT) long-read data. It performs quality filtering, length filtering, and generates comprehensive reports. Since ONT data is typically single-end, we only define one input and one output.
```bash
# Basic command for a single file
fastplong -i input.fastq.gz -o output.fastq.gz
```

### Parameters explained:
* `-i, --in1`: input file name
* `-o, --out1`: output file name
* `-h, --html`: the HTML report file name (default is fastp.html)
* `-j, --json`: the JSON report file name (default is fastp.json)
* `-w, --thread`: worker thread number (default is 4)

## 3. Workshop Exercise: Quality Filtering

In the context of this workshop, we will apply specific filters to handle the characteristics of long-read data, such as removing short fragments ("scraps") and low-quality reads.
```bash
# Create a directory for the output
mkdir -p 03_fastplong

# Run fastplong with specific long-read filters
fastplong -i 02_raw_data/sample.fastq.gz \
          -o 03_fastplong/sample_trimmed.fastq.gz \
          --html 03_fastplong/report.html \
          --length_required 200 \
          --mean_qual 7
```

### Advanced Filtering for ONT:
* `--length_required`: Discards reads shorter than the specified value (e.g., 200 bp). Useful for removing short, non-informative fragments.
* `--length_limit`: Discards reads longer than the specified value.
* `--mean_qual`: The minimum average quality score (Q-score) required for a read to pass.
* `--n_base_limit`: The maximum number of unknown bases (N) allowed in a read.

## 4. Automation for Multiple Samples

If you are working with multiple ONT runs, you can use a simple loop:
```bash
for file in 02_raw_data/*.fastq.gz; do
  NAME=$(basename "$file" .fastq.gz)
  fastplong -i "$file" \
            -o "03_fastplong/${NAME}_trimmed.fastq.gz" \
            -h "03_fastplong/${NAME}.html"
done
```

## 5. Report Interpretation

The `fastplong` HTML report provides several critical metrics for ONT data:
1. **Read Length Distribution:** Shows the N50 and length spread. A successful ONT library should show a peak reflecting your fragment selection.
2. **Quality Score Distribution:** Unlike Illumina, ONT quality scores might be lower (e.g., Q10-Q15), but they should remain consistent across the entire length of the long read.
3. **Base Content:** Monitors for adapter contamination or unexpected GC bias.
