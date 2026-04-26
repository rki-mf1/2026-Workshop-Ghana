# Bioinformatics for Influenza Genome Reconstruction: A Hands-On Workshop
# Day 02: Quality control with `fastp`

## Lesson Objectives

Fastp is a tool for fast all-in-one preprocessing for `fastq` files. It provides functions for quality control, adapter trimming, and filtering. Fastp is designed to be faster than other similar tools, hence the name. It employs multithreading and optimization techniques to achieve high processing speeds.

## Key Features
Here are some (!) key features of fastp:

1. Quality Control: `fastp` evaluates the quality of sequencing reads and performs quality filtering to remove low-quality reads. The filtering can be performed globally

2. Length Filtering: Users can specify a minimum length threshold for reads, and `fastp` will discard reads shorter than this threshold.

3. HTML Report: `fastp` generates a comprehensive HTML report summarizing the preprocessing results, including quality metrics, adapter content, and read length distributions.

`fastp` has the following syntax:
```bash
fastp \
# read input file name
-in1 < path/to/input_fastq.gz > \
# read output file name
-out1 < path/to/filtered_fastq > \

# additional useful options
# output verbose (detailed) log information
--verbose \
# protect existing files not to be overwritten by fastp
--dont_overwrite

# one liner
fastp -v --dont_overwrite -in1 <path/to/input_fastq.gz> -out1 <path/to/filtered_fastq>
```

Run the following commands. You can also use the one-letter options, check the documentation for more information on them.

```bash
# Activate the fastp conda environment

# Create a new folder, name it day02 and cd to it

# Copy one of the fastq.gz files to here

# Create a new folder, name it filtered_reads

# Create another folder, name it default_params 

# Run fastp with all default parameteres
# Use filtered_reads/default_params as output directory

```
`fastp` creates an output report that you can open with your browser. We will have a look on this report later.


## Filtering by Length
The length filtering approach in `fastp` is used to filter out sequencing reads based on their length. This approach ensures that only reads meeting a specified length criterion are retained.

Length filtering is enabled by default. The length filtering options are

```bash
# Create a second subdirectory in filtered_reads and name it by_length

# Reads shorter than length l are discarded
fastp -v --dont_overwrite -l <l> -in1 <path/to/input_fastq.gz> -out1 <path/to/filtered_fastq>
```
* _What is the default of `l`_? Check the documentation

```bash
# Discard all lengths which are shorter than 500 bp
# Use filtered_reads/by_length as output directory

```

* _What is the number of reads before and after the filtering? Check the output of `fastp` that is printed to the terminal._


## Filtering by Quality
The sliding window approach is a quality control technique used by `fastp` to assess the quality of sequencing reads. This approach involves moving a window of fixed size (defined by the user) across each read, calculating the average quality score within each window. By examining the quality scores in successive windows along the read, Fastp can identify regions of low-quality sequence data.

Here's how the sliding window approach works:

* Window Size: The user specifies the size of the sliding window using a parameter in the `fastp` command.

* Quality Calculation: `fastp` calculates the average quality score within each window as it moves along the read.

* Thresholding: `fastp` applies a quality threshold to the average quality scores within each window. If the average quality score falls below the specified threshold, the corresponding region of the read is considered low-quality.

* Trimming or Filtering: Depending on user preferences, `fastp` can trim or filter out low-quality regions identified by the sliding window approach. Trimming involves removing low-quality bases from the ends of reads, while filtering involves discarding entire reads containing low-quality regions.

The following parameters will be used:
* `-5`, `--cut_front`: Move a sliding windoe from front (5') to tail, drop the bases in the window if its mean quality < threshold, stop otherwise
* `-M`, `--cut_mean_quality`: The mean quality requirement in the sliding window

The following parameter will be kept to default:
* `-W`, `--cut_window_size`: The sliding window size, default: 4


```bash
# Create a third subdirectory in filtered_reads, name it by_quality

# Run fastp with a mean quality of 15, cutting from the front
# Use filtered_reads/by_quality as output

# Go to the by_quality directory

# Use firefox to view the report
firefox fastp.html

```

* _Play with the parameter `-M`, trying values from 5 to 30. Please use the `-h` parameter to give your output reports unique names, otherwise `fastp.html` will be overwritten for each run. What do you observe?_
