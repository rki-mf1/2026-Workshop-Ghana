[⬅ Back to main page](../README.md)

# Conda

![conda_logo](https://upload.wikimedia.org/wikipedia/commons/e/ea/Conda_logo.svg)

## 🎯 Learning goals

By the end of this practical, you should be able to:

- understand why software environments are important in bioinformatics
- list available Conda environments
- create a new Conda environment from a YAML file
- activate and deactivate Conda environments
- check which software is available inside an environment
- understand why a tool may not be available before activating the correct environment

## Overview

Bioinformatics tools often depend on very specific software versions. Installing all tools into one large system environment can quickly become messy, difficult to reproduce, and sometimes impossible to maintain.

This is where **Conda environments** are useful.

A Conda environment is like a separate software box. Each environment can contain a specific set of tools and versions. For example, one environment may contain `bcftools`, another may contain `fastp`, and another may contain tools for genome assembly.

In this practical, we will create and use a Conda environment for `bcftools`.

---

### 1. List all available conda environments

First, let’s check which Conda environments are already available.

```bash
conda info --envs
```
You should see a list of environments. The **currently active environment** is marked with an asterisk (`*`).

Example output:

```bash
# conda environments:
#
base                  *  /home/user/miniconda3
```

---

### 2. Inspect the environment file

Conda environments can be described using a [YAML](https://en.wikipedia.org/wiki/YAML) file. This file acts like a recipe: it tells Conda which software should be installed.

We will first inspect the environment file for `bcftools`. This recipe tells Conda to create an environment containing `bcftools`.

```bash
cat /home/mf1/nambi24/flu-workflow/envs/bcftools.yaml
```

---

### 3. Create a Conda environment from the YAML file

Now we can create the environment.

```bash
conda env create -n bcftools -f /home/mf1/nambi24/flu-workflow/envs/bcftools.yaml
```

Here, we use two important options:

- `-n` bcftools` gives the new environment the name **bcftools**
- `-f` day_02/envs/bcftools.yaml` tells Conda which YAML recipe file to use

---

### 4. Check that the environment was created

Now list the available Conda environments again.

```bash
conda info --envs
```
You should now see an environment called **bcftools**.

🎉 Congratulations! You have created your first Conda environment in this workshop.

---

### 5. Try running bcftools before activating the environment

The `conda activate` command lets you switch to a specific environment. 
You can use any of the environments that were listed in the output of `conda info --envs` command. 
Once you activate a enviroment you will be able to use the software that is installed in that environment.

```bash
# try to use bcftools
bcftools
```

Before activating the environment, let’s try running bcftools.

```bash
bcftools
```

You may see an error message similar to this:

```bash
Command 'bcftools' not found
```
This is expected.

The software was installed inside the bcftools Conda environment, but that environment is not active yet.

---

### 6. Activate the Conda environment

To use software installed inside a Conda environment, we first need to activate it.

```bash
conda activate bcftools
```

Your terminal prompt may change and show the active environment name:

```bash
(bcftools) user@computer:~$
```

Now try running bcftools again.

```bash
bcftools
```

This time, you should see the bcftools help message instead of an error.

---

### 7. Check which version of bcftools is installed

It is good practice to check software versions, especially when working on reproducible analyses.

```bash
bcftools --version
```

---

### 8. List software installed in the active environment

You can inspect what is installed in the current Conda environment with:

```bash
conda list
```

---

### 9. Deactivate the environment

When you are finished using an environment, you can deactivate it.

```bash
conda deactivate
```

### 💬 Discussion

Try to answer the following questions:

- Which command lists all available Conda environments?
- Which command activates the `bcftools` environment?
- Why did `bcftools` not work before activating the environment?
- Which command shows the installed version of `bcftools`?

### 📌 Quick reference

In this practical, you used the following Conda commands:

| Command | Purpose |
|---|---|
| `conda info --envs` | List available Conda environments |
| `conda env create -n bcftools -f day_02/envs/bcftools.yaml` | Create a new environment from a YAML file |
| `conda activate bcftools` | Activate the `bcftools` environment |
| `conda list` | List installed packages in the active environment |
| `conda deactivate` | Leave the active environment |

---

[Next tutorial](./02_intermediate_commands.md)

[⬅ Back to main page](../README.md)
