[⬅ Back to main page](../README.md)

# Viewing, Editing, Compressing, and Searching Files

## 🎯 Learning goals

By the end of this lesson, you should be able to:

- unpack and inspect `.tar.gz` archives
- search text with `grep`
- combine commands using pipes (`|`)
- extract columns from tabular files
- write and run Bash scripts

## Before you start

Open a terminal and move into the workshop repository:

```bash
cd ~/2026-Workshop-Ghana
```

Create a safe practice area for this session:

```bash
mkdir -p scratch_2
cd scratch_2
```

Check where you are:

```bash
pwd
```

---

## 1. Working with `.tar.gz` archives

![tar.gz](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhkgOCjTC1nwiLFwYZjQ7IZzfxKGlMoU_AnHkawHGDeasDLthqgdNmQbE4lLePalNpEM12ooVLOWKPfY4IQ0F8UUkhAr8fkRVt-sO4R6KmDI-pM_ulAMIksmg71AVXcENnUNDKy-kUOocQ/s1600/tar-gzip.jpg)

*What is a `.tar.gz` file?*

In bioinformatics we often work with large datasets and collections of many related files. To make them easier to share and to reduce their size, these files are frequently packaged into `.tar.gz` archives.

- `.tar` → stands for [tape archive](https://en.wikipedia.org/wiki/Tar_(computing)). It combines multiple files and folders into a single archive (like putting them into a box), but does not compress them.

- `.gz` → stands for [gzip compression](https://en.wikipedia.org/wiki/Gzip). It shrinks the size of the file using compression.

When combined, `.tar.gz` means:
- Multiple files and/or directories are bundled together into one archive.
- That archive is then compressed to save space.


We prepared one archive in `data/tutorial_data`. First, copy it to your current working directory:

```bash
cp ~/2026-Workshop-Ghana/data/tutorial_data/references.tar.gz .
```

You can **extract** `.tar.gz` like this:

```bash
tar -xvzf references.tar.gz
```

### Meaning of the options

- `-x` — extract
- `-v` — [verbose](https://en.wikipedia.org/wiki/Verbose_mode) output
- `-z` — archive is gzip-compressed
- `-f` — file name follows

Check what was extracted:

```bash
ls -lh
```

Compare the sizes of compressed file vs uncompressed directory:

```bash
du -hs references.tar.gz
du -hs references
```

Try making your first `.tar.gz`:

```bash
tar -cvzf my_first_tar_file.tar.gz references
```

### 💬 Discussion

- Why are `.tar.gz` archives useful in bioinformatics?
- What is the difference between compressing and de-compressing `tar.gz` files?

---

## 2. Compression with `gzip`

Genomics files are often very large, frequently reaching several gigabytes. To reduce storage requirements, they are commonly compressed with `gzip`. Although these files contain binary data and cannot be read directly with standard text tools, you can still inspect them from the command line without decompressing them first.


Troughout the course we will work with data that is in `course_data`. This folder is not part of the git repository but was added by us manually. We will first copy one of those files to our working directory.

```bash
cp ~/2026-Workshop-Ghana/course_data/ERR10096087_1.fastq.gz .
```


First, let’s try seeing zipped file using `head` command.

```bash
head ERR10096087_1.fastq.gz
```

🎉 Congratulations! Instead of a readable FASTQ file, you have discovered mysterious alien 👽 symbols.

What actually happened is that head is showing you the raw compressed binary data of the `.gz` file — which looks like nonsense. To properly look inside compressed FASTQ files, you need to use tools that understand `gzip` compression, such as:

```bash
zcat ERR10096087_1.fastq.gz | head
```

Let's uncompress it:

```bash

# Uncompress but keep compressed file to compare sizes
gunzip -k ERR10096087_1.fastq.gz
ls -lh

# Remove gz file
rm ERR10096087_1.fastq.gz
ls -lh 
```

To compress file:

```bash
gzip ERR10096087_1.fastq
ls -lh
```

### 💬 Discussion

- What changed in the file size?
- Why is compression especially common for FASTA and FASTQ files?
- What is the difference between `gzip` and `gunzip`?

---

## 3. Work with tabular data from the command line

Create a small CSV file:

```bash
echo "Species,Serogroup,Continent" > data.csv
echo "Vibrio cholerae,O1,Essos" >> data.csv
echo "Vibrio cholerae,O139,Westeros" >> data.csv
echo "Vibrio cholerae,O139,Essos" >> data.csv
```

Display it:

```bash
cat data.csv
```

### Extract columns with `cut`

Get the `Serogroup` and `Continent` columns:

```bash
cut -d "," -f 2-3 data.csv
```

Get only countries for serogroup `O139`:

```bash
grep "O139" data.csv | cut -d "," -f 3
```

### Sort values with `sort`

```bash
cut -d "," -f 3 data.csv | tail -n +2 | sort
```

### Find unique values with `uniq`

```bash
cut -d "," -f 3 data.csv | tail -n +2 | sort | uniq
```

Count unique values:

```bash
cut -d "," -f 3 data.csv | tail -n +2 | sort | uniq -c
```

Save unique serogroups to a new file:

```bash
cut -d "," -f 2 data.csv | tail -n +2 | sort | uniq > unique_serogroup.txt
```

### Count lines with `wc`

```bash
wc data.csv
wc -l data.csv
wc -w data.csv
```

### 💬 Discussion

- Why is `sort` usually needed before `uniq`?
- What does `tail -n +2` do in the examples above?

---

## 4. Search text with `grep`


Let's copy the primer BED file to our current working directory to explore it:

```bash
cp ../assets/schemes/mpxv/primer.bed .
```

Search for one word:

```bash
grep "_4_" primer.bed
grep "_4" primer.bed
```

Count matching lines:

```bash
grep -c "_4" primer.bed
```

Search case-insensitively:

```bash
grep "Left" primer.bed
grep -i "Left" primer.bed
```

Search for lines that start with a pattern:

```bash
grep "^M" primer.bed
grep "^_4" primer.bed
```
#
#### 💬 Discussion
#
#- What does `-c` do?
#- What does `-i` do?
#- What does `^M` and `^_4` mean?

---

## 5. Pipes

A pipe sends the output of one command into the next command.

Examples:

```bash
cat primer.bed | wc -l
```

```bash
grep "_4" primer.bed | wc -l
```

```bash
grep "_4" primer.bed | less
```

```bash
grep "_4" primer.bed | head
```

### 💬 Discussion

- Why is `|` useful?
- Which part runs first in `grep "PASS" A_HA_H3.vcf | less`?


---

## 7. Write your first Bash script

Create a directory for scripts:

```bash
cd ~/2026-Workshop-Ghana/scratch_2
mkdir -p scripts
cd scripts
```

Create a small script called `create_project.sh`:

```bash
nano create_project.sh
```

Paste this content:

```bash
#!/bin/bash

TARGET_DIR=$1
PROJECT_NAME=$2

mkdir -p "$TARGET_DIR/$PROJECT_NAME"
mkdir -p "$TARGET_DIR/$PROJECT_NAME/data"
mkdir -p "$TARGET_DIR/$PROJECT_NAME/data/raw_data"
mkdir -p "$TARGET_DIR/$PROJECT_NAME/data/references"
mkdir -p "$TARGET_DIR/$PROJECT_NAME/analyses"
mkdir -p "$TARGET_DIR/$PROJECT_NAME/scripts"
mkdir -p "$TARGET_DIR/$PROJECT_NAME/docs"
```

Save and exit.

### What this script introduces

- `#!/bin/bash` — the shebang; tells the system to use Bash
- `$1` — first argument
- `$2` — second argument
- `mkdir -p` — create directories, including parent directories if needed

---

## 8. Make the script executable and run it

Give the script execute permission:

```bash
ls -lh
chmod +x create_project.sh
ls -lh
```

Run it explicitly with Bash:

```bash
bash create_project.sh ~/2026-Workshop-Ghana/scratch_2/scripts demo_project
```

Run it directly:

```bash
./create_project.sh ~/2026-Workshop-Ghana/scratch_2/scripts demo_project_2

# or

./create_project.sh . demo_project_3
```

Check the results:

```bash
tree demo_project
```

If `tree` is not installed:

```bash
ls -R demo_project
```

### 💬 Discussion

- What is the difference between `bash create_project.sh ...` and `./create_project.sh ...`?
- What happens if the script is not executable?

---

## 9. A simple loop script

Create another script:

```bash
nano creating_files.sh
```

Paste this content:

```bash
#!/bin/bash

for number in {1..4}; do
  touch "file_${number}.txt"
done
```

Make it executable and run it:

```bash
chmod +x creating_files.sh
./creating_files.sh
ls
```

### 💬 Discussion

- What is brace expansion in `{1..4}`?
- Why is it good practice to write variables as `${number}` instead of `$number` in scripts?

---

## 10. Optional | Script with if-else conditions

Create one more script:

```bash
nano if_else.sh
```

Paste this content:

```bash
#!/bin/bash

echo "Please enter a number:"
read number

if [ "$number" -gt 10 ]; then
  echo "The number is greater than 10."
elif [ "$number" -lt 10 ]; then
  echo "The number is less than 10."
else
  echo "The number is equal to 10."
fi
```

Run it:

```bash
chmod +x if_else.sh
./if_else.sh
```

### 💬 Discussion

- What happens if you enter `10`?
- What happens if you enter a letter instead of a number?
- Which operators compare numbers in Bash?

---


## 📌 Quick reference

| Command | Purpose |
| --- | --- |
| `tar -xvzf` | Extract a `.tar.gz` archive |
| `gzip` | Compress a file |
| `gunzip` | Uncompress a `.gz` file |
| `zcat` | Print contents of a `.gz` file |
| `zless` | View a `.gz` file page by page |
| `grep` | Search text |
| `grep -c` | Count matching lines |
| `cut` | Extract selected columns |
| `sort` | Sort lines |
| `uniq` | Remove consecutive duplicates |
| `wc` | Count lines, words, or characters |
| `chmod +x` | Make a file executable |
| `bash script.sh` | Run a script with Bash |
| `./script.sh` | Run an executable script directly |

---

[⬅ Back to main page](../README.md)
