[⬅ Back to Day 04 overview](README.md)

# Phylogenetic Tree Inference with IQ-TREE

## 🎯 Learning goals

By the end of this practical, you should be able to:

- explain why multiple sequence alignment is needed before phylogenetic analysis
- prepare consensus genome sequences for tree inference
- align sequences with `mafft`
- infer a maximum-likelihood phylogenetic tree with `IQ-TREE`
- understand the most important IQ-TREE output files
- identify the tree file that can be opened in a tree viewer
- explain, in simple terms, what bootstrap support means

## Overview

Phylogenetic analysis allows us to compare reconstructed genomes and ask how closely related they are.

In this practical, we will use consensus sequences produced during the previous analysis steps. These sequences first need to be aligned so that the same genome positions are compared across samples.

The general workflow is:

```text
consensus FASTA files
  ↓
multiple sequence alignment
  ↓
IQ-TREE
  ↓
phylogenetic tree
```

> [!NOTE]
> The raw reads and reference genomes are downloaded in the Day 02 tutorial:
>
> [Downloading datasets](../day_02/02_downloading_datasets.md)
>
> This practical assumes that you already have reconstructed consensus sequences from the previous mapping / reference-based assembly practical.

---

## 1. Create and activate the Conda environment

First, move to the workshop repository.

```bash
cd ~/2026-Workshop-HSPA-Morocco
```

Create a Conda environment with `IQ-TREE` and `mafft`.

```bash
conda create -y -n iqtree -c conda-forge -c bioconda iqtree mafft
```

Activate the environment.

```bash
conda activate iqtree
```

Check that the tools are available.

```bash
iqtree2 --version
mafft --version
```

> [!TIP]
> Depending on the installation, the IQ-TREE command may be called `iqtree2` or `iqtree`.
> If `iqtree2 --version` does not work, try:
>
> ```bash
> iqtree --version
> ```

---

## 2. Create a working directory

Create a clean directory for this practical.

```bash
mkdir -p analyses/day_04/iqtree/input
mkdir -p analyses/day_04/iqtree/alignment
mkdir -p analyses/day_04/iqtree/results
```

Check the directory structure.

```bash
ls -R analyses/day_04/iqtree
```

---

## 3. Find consensus FASTA files

The exact location of your consensus FASTA files depends on the previous practical.

Use `find` to look for FASTA files in the analysis directories.

```bash
find analyses data -type f \( -name "*.fasta" -o -name "*.fa" -o -name "*.fna" \) 2>/dev/null | sort
```

Look for files that represent reconstructed consensus genomes, not reference genomes.

Consensus files often contain words such as:

```text
consensus
sample
assembly
```

Copy the consensus FASTA files into the input directory.

```bash
# Replace this example path with the path to your own consensus FASTA files
cp path/to/consensus/*.fasta analyses/day_04/iqtree/input/
```

Check how many sequences you have.

```bash
grep -c "^>" analyses/day_04/iqtree/input/*.fasta
```

> [!IMPORTANT]
> For phylogenetic analysis, do not mix unrelated data in the same tree.
>
> For example:
>
> - do not mix Influenza A segments with SARS-CoV-2 genomes
> - do not mix different Influenza genome segments in one alignment
> - do not mix very short partial sequences with full genomes unless there is a clear reason

---

## 4. Combine FASTA files into one file

IQ-TREE works on one alignment file. Before alignment, we first combine all input sequences into one FASTA file.

```bash
cat analyses/day_04/iqtree/input/*.fasta > analyses/day_04/iqtree/input/consensus_sequences.fasta
```

Check how many sequences are in the combined file.

```bash
grep -c "^>" analyses/day_04/iqtree/input/consensus_sequences.fasta
```

Inspect the sequence names.

```bash
grep "^>" analyses/day_04/iqtree/input/consensus_sequences.fasta
```

---

## 5. Clean sequence names

Some phylogenetic tools do not like spaces or special characters in sequence names.

Let’s create a cleaned FASTA file with safer names.

```bash
awk '
  /^>/ {
    name = substr($0, 2)
    gsub(/[^A-Za-z0-9_.-]/, "_", name)
    print ">" name
    next
  }
  {
    print
  }
' analyses/day_04/iqtree/input/consensus_sequences.fasta \
  > analyses/day_04/iqtree/input/consensus_sequences.clean.fasta
```

Check the cleaned names.

```bash
grep "^>" analyses/day_04/iqtree/input/consensus_sequences.clean.fasta
```

---

## 6. Create a multiple sequence alignment with MAFFT

Even if sequences were produced by reference-based assembly, we still prepare a multiple sequence alignment before phylogenetic analysis.

```bash
mafft --auto analyses/day_04/iqtree/input/consensus_sequences.clean.fasta \
  > analyses/day_04/iqtree/alignment/consensus_sequences.aligned.fasta
```

Check the alignment.

```bash
grep -c "^>" analyses/day_04/iqtree/alignment/consensus_sequences.aligned.fasta
head analyses/day_04/iqtree/alignment/consensus_sequences.aligned.fasta
```

> [!TIP]
> A multiple sequence alignment makes sure that each column represents homologous positions across samples.
> IQ-TREE then compares these alignment columns to infer the phylogenetic tree.

---

## 7. Run IQ-TREE

Now run IQ-TREE on the alignment.

```bash
iqtree2 \
  -s analyses/day_04/iqtree/alignment/consensus_sequences.aligned.fasta \
  -m MFP \
  -B 1000 \
  -T AUTO \
  --prefix analyses/day_04/iqtree/results/consensus_tree
```

Meaning of the most important options:

| Option | Meaning |
|---|---|
| `-s` | Input multiple sequence alignment |
| `-m MFP` | Use ModelFinder Plus to select a substitution model |
| `-B 1000` | Run 1000 ultrafast bootstrap replicates |
| `-T AUTO` | Automatically choose the number of CPU threads |
| `--prefix` | Prefix for all output files |

> [!TIP]
> If your installation uses `iqtree` instead of `iqtree2`, run the same command with `iqtree`.

---

## 8. Inspect IQ-TREE outputs

List the output files.

```bash
ls -lh analyses/day_04/iqtree/results/
```

Important files include:

| File | Purpose |
|---|---|
| `consensus_tree.iqtree` | Main IQ-TREE report |
| `consensus_tree.treefile` | Final maximum-likelihood tree in Newick format |
| `consensus_tree.log` | Log file from the run |
| `consensus_tree.contree` | Consensus tree with support values |
| `consensus_tree.ckp.gz` | Checkpoint file |

Inspect the main report.

```bash
less analyses/day_04/iqtree/results/consensus_tree.iqtree
```

Print the final tree.

```bash
cat analyses/day_04/iqtree/results/consensus_tree.treefile
```

The `.treefile` file can be opened in tree visualization tools such as FigTree, iTOL, or the tree viewer used by your instructor.

---

## 9. What are bootstrap values?

Bootstrap values are support values for branches in the tree.

A simple interpretation is:

| Bootstrap value | Interpretation |
|---|---|
| `95–100` | Strong support |
| `70–94` | Moderate support |
| `<70` | Weak support |

> [!CAUTION]
> Bootstrap values do not prove that a tree is correct.
> They only describe how consistently the data support a branch under the chosen model and analysis settings.

---

## 🧠 Mini exercise

Try to answer the following questions:

1. Why do we align sequences before running IQ-TREE?
2. Which IQ-TREE output file contains the final tree?
3. What does `-m MFP` do?
4. What does `-B 1000` mean?
5. Why should Influenza genome segments not be mixed in one phylogenetic alignment?

---

## 📌 Quick reference

| Command | Purpose |
|---|---|
| `conda activate iqtree` | Activate the IQ-TREE environment |
| `mafft --auto input.fasta > aligned.fasta` | Create a multiple sequence alignment |
| `iqtree2 -s aligned.fasta -m MFP -B 1000 -T AUTO` | Infer a maximum-likelihood tree |
| `less file.iqtree` | Inspect the IQ-TREE report |
| `cat file.treefile` | Print the Newick tree |
| `grep "^>" file.fasta` | Show sequence names |
| `grep -c "^>" file.fasta` | Count sequences |

---

[Next tutorial](./02_nextclade.md)

[⬅ Back to Day 04 overview](README.md)

[⬅ Back to main page](../README.md)
