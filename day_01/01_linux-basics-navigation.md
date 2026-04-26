[⬅ Back to main page](../README.md)

# Linux Basics, Navigation, and File Management

## Learning goals

By the end of this lesson, you should be able to:

- open and use the terminal comfortably
- understand the current working directory
- move through the filesystem with `cd`
- understand `~`, `.`, `..`, absolute paths, and relative paths
- create, edit, copy, move, rename, and remove files and directories
- read built-in command documentation with `man` and `--help`

## Working assumption

This lesson assumes you cloned the repository into your **home** directory (`~`).
All examples below use paths relative to that location.

## Before you start

Open a terminal and move into the workshop repository:

```bash
cd ~/2026-Workshop-HSPA-Morocco/day_01
```

Create a safe practice area for this session:

```bash
mkdir -p scratch
```

Check where you are:

```bash
pwd
```

## 1. Your first commands

List the contents of the current directory:

```bash
ls
```

Try a few common variants:

```bash
ls .
ls ..
ls -l
ls -lh
ls -lt
```

### 💬 Discussion

- What is the difference between `ls`, `ls -l`, and `ls -lh`?
- What does `ls ..` show?
- Which option sorts by modification time, newest first?

## 2. Getting help

Most commands provide built-in documentation.

```bash
man ls
```

Or use the short help page:

```bash
ls --help
cp --help
mv --help
rm --help
mkdir --help
```

### 💬 Discussion

- Which `ls` option shows human-readable file sizes?
- Which `cp` option lets you copy directories recursively?

## 3. Useful terminal habits

Try these shortcuts:

- Press the `↑`**Up Arrow** to reuse previous commands.
- Type `cle` and press `Tab`.
- Start typing `cd ~/2026` and press `Tab` for autocompletion.

Linux is case-sensitive:

- `clear` works
- `CLEAR` does not

Avoid spaces in file names when possible.

## 4. Moving around the filesystem

Start in the repository root:

```bash
cd ~/2026-Workshop-HSPA-Morocco
pwd
```

Now try the following:

```bash
cd day_01
pwd

cd ..
pwd

cd ~
pwd

cd ~/2026-Workshop-HSPA-Morocco/day_01
pwd

cd -
pwd
```

### Key ideas

- `~` = your home directory
- `.` = the current directory
- `..` = the parent directory
- `cd -` = the directory you were in previously

## 5. Absolute and relative paths

An **absolute path** starts from the filesystem root `/`.

Example: `/home/username/2026-Workshop-HSPA-Morocco/day_01`

A **relative path** starts from where you are right now.

Example workflow:

```bash
cd ~/2026-Workshop-HSPA-Morocco
ls day_01

cd day_01
ls .
ls ..
```

### Practice

Run these commands and explain why they work:

```bash
cd ~/2026-Workshop-HSPA-Morocco
ls day_01

cd day_01
ls ../day_02

cd ..
cd ./day_01
```

## 6. Create files and directories

Return to your scratch directory:

```bash
cd ~/2026-Workshop-HSPA-Morocco/day_01/scratch
pwd
```

Create files and directories

Create a few files and folders:

```bash
touch notes.txt
touch copy_me.txt
mkdir drafts
mkdir results
ls -lh
```

Add text to a file:

```bash
echo "Hello Bioinformatics" > notes.txt
cat notes.txt
```

Append another line:

```bash
echo "Linux is powerful." >> notes.txt
cat notes.txt
```

### 💬 Discussion

- What is the difference between `>` and `>>`?
- Why is it useful to keep practice work in a separate directory?

Create a new file and open it in `nano`:

```bash
touch my_text_file.txt
nano my_text_file.txt
```

Inside `nano`, try the following:

- write two or three lines
- save with `Ctrl + O`
- exit with `Ctrl + X`

Show the result:

```bash
cat my_text_file.txt
```

### Useful nano shortcuts

- `Ctrl + O` — save
- `Ctrl + X` — exit
- `Ctrl + W` — search
- `Ctrl + K` — cut a line
- `Ctrl + U` — paste



## 7. Copy files and directories

Copy a file into another file:

```bash
cp copy_me.txt copy_me_backup.txt
ls
```

Copy a file into a directory:

```bash
cp notes.txt drafts/
ls drafts
```

Copy a directory recursively:

```bash
cp -r drafts drafts_copy
ls
```

### 💬 Discussion

- When do you need `-r` with `cp`?
- What is the difference between copying a file and copying a directory?


## 8. Move and rename files

Move a file into another directory:

```bash
mv copy_me_backup.txt results/
ls results
```

Rename a file:

```bash
mv copy_me.txt renamed_file.txt
ls
```

Move and rename at the same time:

```bash
mv renamed_file.txt drafts/final_notes.txt
ls drafts
```

## 9. Remove files and directories

Remove a file:

```bash
rm drafts/final_notes.txt
ls drafts
```

Remove an empty directory:

```bash
mkdir empty_dir
rmdir empty_dir
```

Remove a directory and everything inside it:

```bash
rm -r drafts_copy
```

> [!CAUTION]
> Be careful with `rm`, especially with `rm -r`. Deleted files do not go to a recycle bin.

### Question

- Why is `rm -r` more dangerous than `rm`?
- What is the difference between `rmdir` and `rm -r`?

## 10. View file contents

Use the file you already created:

```bash
cat notes.txt
```

Open it page by page:

```bash
less notes.txt
```

Show only the first lines:

```bash
head notes.txt
```

Show only the last lines:

```bash
tail notes.txt
```

### Useful `less` controls

- `q` — quit
- `/pattern` — search inside the file
- `n` — next match
- `p` — previous match
- `Space` — next page

### 💬 Discussion

- When is `less` better than `cat`?
- Which commands are more useful for large files?


## 11. Mini challenge

In `scratch` directory you created earlier, do the following:

1. create a directory called `project_demo`
2. create a file called `readme.txt` inside it
3. write one line into that file (e.g. "I love whales")
4. copy the file to `readme_backup.txt`
5. rename `readme_backup.txt` to `notes_backup.txt`
6. show the first lines of the original `readme.txt` file

One possible solution:

```bash
cd ~/2026-Workshop-HSPA-Morocco/day_01/scratch
mkdir project_demo
echo "I love whales" > project_demo/readme.txt
cp project_demo/readme.txt project_demo/readme_backup.txt
mv project_demo/readme_backup.txt project_demo/notes_backup.txt
head project_demo/readme.txt
```

## Quick reference

| Command | Purpose |
| --- | --- |
| `pwd` | Show current directory |
| `ls` | List files and folders |
| `cd` | Change directory |
| `man <command>` | Open the manual |
| `<command> --help` | Show short help |
| `touch` | Create an empty file |
| `nano` | Edit a text file in the terminal |
| `mkdir` | Create a directory |
| `cp` | Copy files or directories |
| `mv` | Move or rename files or directories |
| `rm` | Remove files |
| `rm -r` | Remove directories recursively |
| `rmdir` | Remove an empty directory |
| `cat` | Print a file |
| `less` | View a file page by page |
| `head` | Show first lines |
| `tail` | Show last lines |

---

[Next tutorial](./02_linux-view-edit-search.md)

[⬅ Back to main page](../README.md)
