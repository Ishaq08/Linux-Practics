# Linux for DevOps: Day 1 Notes

Beginner notes on the Linux filesystem, the directory layout, and basic commands.

## Table of Contents

- [Core Concepts](#core-concepts)
- [Filesystem Basics](#filesystem-basics)
- [Directory Structure](#directory-structure)
- [Exploring Key Directories](#exploring-key-directories)
- [Interview-Style Questions](#interview-style-questions)
- [Practice Commands](#practice-commands)

---

## Core Concepts

| Term | Description |
|------|-------------|
| **Kernel** | Manages hardware, memory, processes and other core resources. |
| **Shell** | Accepts your commands and runs programs. Bash is a common shell. |
| **Terminal** | The interface where you interact with the shell. |

### Special Paths

| Symbol | Meaning |
|--------|---------|
| `/` | Root directory: the top of the entire filesystem (also the parent of all directories) |
| `~` | Home directory of the current user |

> The **root user** is the administrator account. It is different from the `/` root directory and the `/root` home directory.

---

## Filesystem Basics

A **filesystem** organizes how data is stored and found on a disk.

Common types:

| Type | Notes |
|------|-------|
| **ext3 / ext4** | The Ext (Extended File System) family. ext4 is the default on many distributions. |
| **XFS** | High-performance journaling filesystem. |
| **Btrfs** | Modern filesystem with snapshots and checksums. |

Check filesystems and their types:

```bash
df -Th
```

### Listing files

```bash
ls -l      # detailed file information
ls -li     # detailed information plus inode number
```

### What is an inode?

An **inode** is a data structure that stores a file's metadata.

- It does **not** store the filename (the directory entry does).
- It stores information such as:
  - Size
  - Permissions
  - Location of the data on disk

---

## Directory Structure

| Directory | Main purpose |
|-----------|--------------|
| `/` | Root of the entire directory hierarchy |
| `/bin` | Essential user commands (e.g. `ls`, `cp`); often linked to `/usr/bin` |
| `/sbin` | System administration commands (e.g. `fdisk`, `shutdown`, `ip`); often linked to `/usr/sbin` |
| `/etc` | System-wide configuration files |
| `/home` | Regular users' home directories |
| `/root` | Home directory of the root user |
| `/var` | Variable data, including logs, caches and service data |
| `/boot` | Files needed to boot the OS (kernel, initial RAM disk, GRUB bootloader config) |
| `/dev` | Device files representing hardware (disks, sound devices, etc.) |
| `/lib`, `/lib64` | Shared libraries used by programs; often linked to `/usr/lib` and `/usr/lib64` |
| `/media` | Common mount point for removable media (USB, DVD) |
| `/mnt` | Conventional mount point for temporary or manual mounts (e.g. external disk for backups) |
| `/opt` | Optional application software, usually third-party and non-standard packages |
| `/proc` | Virtual filesystem exposing process and kernel information (exists only in memory) |
| `/run` | Runtime state such as PID files, lock files and sockets (cleared on every boot) |
| `/srv` | Data served by system services (e.g. web pages from a web server) |
| `/sys` | Virtual filesystem exposing devices and kernel features |
| `/usr` | Most user-space applications, libraries and shared resources (Unix System Resources) |

---

## Exploring Key Directories

### `/bin`: user commands (executable binaries)

```bash
ls /bin | grep cd
file /bin/ls          # shows that ls is an executable binary
```

### `/sbin`: admin commands

```bash
ls /sbin | grep fdisk
```

### `/etc`: configuration files

Holds configuration for users, networking, services and more.

```bash
cd /etc
less /etc/passwd          # user account details
less /etc/resolv.conf     # DNS server configuration
```

### `/var`: logs and variable data

Records system activity.

```bash
cd /var/log
ls
```

### `/proc`: live system information

```bash
cd /proc
ls
cat /proc/cpuinfo         # CPU details
```

### `/run`: runtime state

```bash
cd /run
ls
```

---

## Interview-Style Questions

**Q1. How can I tell if my machine has been attacked or hacked?**

All system activity is recorded in logs. Check `/var/log` for suspicious logins, failed authentication attempts and unusual activity.

**Q2. We host 4 web servers (2 in the UK, 1 in the USA, 1 in Pakistan). How do we find which users visited from Pakistan?**

Check the web server access logs and look up the client IP addresses. IPs that geolocate to Pakistan identify visitors from Pakistan.

**Q3. What is the difference between Windows and Linux?**

The main difference is the kernel. The Windows kernel is closed source. The Linux kernel is open source, so features can be added, removed or customized.

---

## Practice Commands

### Navigation

```bash
pwd          # print current directory
ls           # list files
ls -l        # detailed list
ls -la       # detailed list including hidden files
cd /         # go to root directory
pwd
ls
cd ~         # go to home directory
pwd
```

### Files and directories

```bash
mkdir -p ~/linux-devops-day1
cd ~/linux-devops-day1

touch notes.txt
echo "I am learning Linux for DevOps" > notes.txt

cat notes.txt
cp notes.txt backup.txt
mv backup.txt linux-notes.txt

ls -l
```

| Command | What it does |
|---------|--------------|
| `mkdir -p` | Create a directory (and parents if needed) |
| `touch` | Create an empty file |
| `echo "..." > file` | Write text into a file (overwrites existing content) |
| `cat` | Display file contents |
| `cp` | Copy a file |
| `mv` | Move or rename a file |
