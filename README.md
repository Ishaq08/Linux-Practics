# Linux for DevOps Notes

Beginner notes on Linux: the filesystem and basic commands (Day 1), users, groups, permissions and ownership (Day 2), processes, signals, services and logs (Day 3), disk, memory, CPU and filesystems (Day 4), and networking, SSH and firewall basics (Day 5).

## Table of Contents

**Day 1: Filesystem and Basic Commands**
- [Core Concepts](#core-concepts)
- [Filesystem Basics](#filesystem-basics)
- [Directory Structure](#directory-structure)
- [Exploring Key Directories](#exploring-key-directories)
- [Interview-Style Questions (Day 1)](#interview-style-questions-day-1)
- [Practice Commands (Day 1)](#practice-commands-day-1)

**Day 2: Users, Groups and Permissions**
- [Users](#users)
- [Managing Users: All Commands](#managing-users-all-commands)
- [Groups](#groups)
- [Managing Groups: All Commands](#managing-groups-all-commands)
- [How to Add a User to a Group](#how-to-add-a-user-to-a-group)
- [File Permissions](#file-permissions)
- [chmod: Change Permissions](#chmod-change-permissions)
- [Ownership: chown and chgrp](#ownership-chown-and-chgrp)
- [sudo and su](#sudo-and-su)
- [Practice Lab (Day 2)](#practice-lab-day-2)
- [Interview-Style Questions (Day 2)](#interview-style-questions-day-2)
- [Quick Reference (Day 2)](#quick-reference-day-2)

**Day 3: Processes, Signals, Services and Logs**
- [Processes](#processes)
- [Jobs](#jobs)
- [Signals](#signals)
- [Services with systemctl](#services-with-systemctl)
- [Logs with journalctl](#logs-with-journalctl)
- [Troubleshooting Routine](#troubleshooting-routine)
- [Lab Exercises (Day 3)](#lab-exercises-day-3)
- [Self-Check Questions (Day 3)](#self-check-questions-day-3)
- [Pass Condition (Day 3)](#pass-condition-day-3)
- [Quick Reference (Day 3)](#quick-reference-day-3)

**Day 4: Disk, Memory, CPU and Filesystems**
- [Disk Space](#disk-space)
- [Block Devices and Filesystems](#block-devices-and-filesystems)
- [Memory](#memory)
- [CPU and Load](#cpu-and-load)
- [vmstat](#vmstat)
- [Troubleshooting Guide](#troubleshooting-guide)
- [Lab Exercises (Day 4)](#lab-exercises-day-4)
- [Self-Check Questions (Day 4)](#self-check-questions-day-4)
- [Pass Condition (Day 4)](#pass-condition-day-4)
- [Lessons Learned](#lessons-learned)
- [Quick Reference (Day 4)](#quick-reference-day-4)

**Day 5: Networking, SSH and Firewall Basics**
- [Network Basics](#network-basics)
- [Connectivity Testing](#connectivity-testing)
- [Ports and Sockets](#ports-and-sockets)
- [DNS](#dns)
- [HTTP with curl](#http-with-curl)
- [SSH](#ssh)
- [Firewall Basics](#firewall-basics)
- [Network Troubleshooting](#network-troubleshooting)
- [Lab Exercises (Day 5)](#lab-exercises-day-5)
- [Self-Check Questions (Day 5)](#self-check-questions-day-5)
- [Pass Condition (Day 5)](#pass-condition-day-5)
- [Quick Reference (Day 5)](#quick-reference-day-5)

---

# Day 1: Filesystem and Basic Commands

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

## Interview-Style Questions (Day 1)

**Q1. How can I tell if my machine has been attacked or hacked?**

All system activity is recorded in logs. Check `/var/log` for suspicious logins, failed authentication attempts and unusual activity.

**Q2. We host 4 web servers (2 in the UK, 1 in the USA, 1 in Pakistan). How do we find which users visited from Pakistan?**

Check the web server access logs and look up the client IP addresses. IPs that geolocate to Pakistan identify visitors from Pakistan.

**Q3. What is the difference between Windows and Linux?**

The main difference is the kernel. The Windows kernel is closed source. The Linux kernel is open source, so features can be added, removed or customized.

---

## Practice Commands (Day 1)

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

---

# Day 2: Users, Groups and Permissions

## Users

Every file and every running process in Linux belongs to a **user**. A user has a name and a number called the **UID**.

| Type | UID | Description |
|------|-----|-------------|
| **root** | 0 | Superuser with full control of the system |
| **System users** | 1-999 | Used by services (e.g. `www-data`, `sshd`); usually no login |
| **Regular users** | 1000+ | Normal human users |

### Important files

| File | Purpose |
|------|---------|
| `/etc/passwd` | User account details (name, UID, GID, home, shell) |
| `/etc/shadow` | Encrypted passwords (readable by root only) |
| `/etc/group` | Group details and members |

Format of a line in `/etc/passwd`:

```
username:x:UID:GID:comment:home_directory:shell
alice:x:1001:1001::/home/alice:/bin/bash
```

The `x` means the password hash is stored in `/etc/shadow`.

---

## Managing Users: All Commands

### Create a user

```bash
sudo adduser alice                          # Ubuntu/Debian: interactive, creates home dir
sudo useradd -m -s /bin/bash alice          # low-level tool
sudo useradd -m -s /bin/bash -G devs alice  # create and add to group devs at the same time
```

| Option | Meaning |
|--------|---------|
| `-m` | Create the home directory |
| `-s` | Set the login shell |
| `-G` | Supplementary groups |
| `-g` | Primary group |
| `-d` | Custom home directory |
| `-u` | Specific UID |
| `-c` | Comment (full name) |

### Set or change a password

```bash
sudo passwd alice          # set or change a password
sudo passwd -l alice       # lock the account
sudo passwd -u alice       # unlock the account
sudo passwd -e alice       # force password change at next login
```

### Modify a user

```bash
sudo usermod -aG devs alice        # add to a group (keeps existing groups)
sudo usermod -s /bin/zsh alice     # change login shell
sudo usermod -l newname alice      # rename the user
sudo usermod -d /new/home -m alice # move home directory
sudo usermod -L alice              # lock account
sudo usermod -U alice              # unlock account
```

### Delete a user

```bash
sudo userdel alice         # delete the account only
sudo userdel -r alice      # delete the account and home directory
sudo userdel -f -r alice   # force delete, even if logged in
```

If you get `user alice is currently used by process 1234`, stop the process first:

```bash
ps -u alice                # see the user's processes
sudo kill 1234             # stop one process
sudo pkill -u alice        # stop all of the user's processes
```

### Check users

```bash
whoami                 # current user
id                     # UID, GID and groups of the current user
id alice               # same, for another user
who                    # who is logged in
w                      # who is logged in and what they are doing
last                   # login history
cat /etc/passwd        # all accounts
getent passwd alice    # one account
```

---

## Groups

A **group** is a collection of users who share access to files. Instead of setting permissions for each person, you give access to the group.

Every user has:
- One **primary group**, used as the default group of files they create.
- Any number of **supplementary groups**.

---

## Managing Groups: All Commands

```bash
sudo groupadd devs             # create a group
sudo groupadd -g 2000 devs     # create with a specific GID
sudo groupmod -n developers devs   # rename a group
sudo groupdel devs             # delete a group

groups                         # groups of the current user
groups alice                   # groups of another user
id alice                       # UID, GID and all groups
getent group devs              # details of one group
cat /etc/group                 # all groups
```

The line in `/etc/group` looks like this:

```
devs:x:1002:alice,bob
```

(group name, password placeholder, GID, members)

---

## How to Add a User to a Group

```bash
# 1. Add an existing user to a group (most common)
sudo usermod -aG devs alice

# 2. Add using gpasswd
sudo gpasswd -a alice devs

# 3. Add using adduser (Ubuntu/Debian)
sudo adduser alice devs

# 4. Add when creating the user
sudo useradd -m -s /bin/bash -G devs alice
```

> **Always use `-a` with `-G`.** Without `-a`, `usermod -G` **replaces** all existing supplementary groups instead of adding one.

### Remove a user from a group

```bash
sudo gpasswd -d alice devs
sudo deluser alice devs         # Ubuntu/Debian
```

### Verify

```bash
id alice
groups alice
getent group devs
```

Example output:

```
uid=1001(alice) gid=1003(alice) groups=1003(alice),1002(devs)
```

A new group membership applies after the user logs out and back in, or runs `newgrp devs` in the current session.

---

## File Permissions

Run `ls -l` to see permissions:

```
-rwxr-xr--  1  alice  devs  4096  Oct 14 06:26  script.sh
```

| Part | Meaning |
|------|---------|
| `-` | File type: `-` file, `d` directory, `l` symbolic link |
| `rwx` | Owner (user) permissions |
| `r-x` | Group permissions |
| `r--` | Others (everyone else) permissions |
| `alice` | Owner |
| `devs` | Group |

### What r, w, x mean

| Permission | On a file | On a directory |
|------------|-----------|----------------|
| `r` (read) | View contents | List contents (`ls`) |
| `w` (write) | Modify contents | Create, delete, rename files inside |
| `x` (execute) | Run as a program | Enter the directory (`cd`) |

### Numeric (octal) values

| Permission | Value |
|------------|-------|
| `r` | 4 |
| `w` | 2 |
| `x` | 1 |
| none | 0 |

Add the values for each of owner, group and others. For example `rwxr-xr--` = 7, 5, 4 = **754**.

| Octal | Symbolic | Common use |
|-------|----------|------------|
| `755` | `rwxr-xr-x` | Programs, directories |
| `644` | `rw-r--r--` | Regular files |
| `770` | `rwxrwx---` | Shared folder for a group |
| `700` | `rwx------` | Private directories |
| `600` | `rw-------` | Private files (e.g. SSH keys) |
| `777` | `rwxrwxrwx` | Everyone can do everything (avoid) |

---

## chmod: Change Permissions

### Numeric mode

```bash
chmod 755 script.sh
chmod 644 notes.txt
chmod 770 /opt/project
chmod -R 755 mydir/        # apply to a folder and everything inside
```

### Symbolic mode

Who: `u` user (owner), `g` group, `o` others, `a` all.
Operators: `+` add, `-` remove, `=` set exactly.

```bash
chmod u+x script.sh        # add execute for the owner
chmod g+w file.txt         # add write for the group
chmod o-r file.txt         # remove read from others
chmod o= file.txt          # remove all permissions from others
chmod a+r file.txt         # add read for everyone
chmod u=rwx,g=rx,o=r file.txt   # set each exactly
```

### umask: default permissions for new files

```bash
umask          # show current mask (commonly 0022 or 0002)
```

With `022`, new files get `644` and new directories get `755`.

---

## Ownership: chown and chgrp

`chown` means **change owner**. It changes which user, and optionally which group, owns a file or directory. It usually needs `sudo`.

```bash
sudo chown alice file.txt            # change owner only
sudo chown alice:devs file.txt       # change owner and group
sudo chown :devs file.txt            # change group only
sudo chown -R alice:devs mydir/      # recursive: folder and all contents
sudo chgrp devs file.txt             # change group only (chgrp)
sudo chgrp -R devs mydir/            # recursive
```

> `chown` changes **who owns** the file. `chmod` changes **what they can do**. They are often used together.

### Give a group access to a file or folder

```bash
# 1. Set the group owner
sudo chown root:devs /opt/project

# 2. Give the group permissions
sudo chmod 770 /opt/project

# 3. Check
ls -ld /opt/project
```

Result: `drwxrwx--- root devs /opt/project`. Members of `devs` have full access, and others have none.

### Make new files inherit the folder's group (setgid)

```bash
sudo chmod g+s /opt/project
```

New files created inside now belong to the folder's group (`devs`) instead of the creator's primary group.

---

## sudo and su

| Command | Purpose |
|---------|---------|
| `sudo command` | Run one command as root |
| `sudo -i` | Open a root shell |
| `su - alice` | Switch to another user with their full environment |
| `su alice` | Switch user, keeping the current environment |
| `exit` | Return to the previous user |

Users in the `sudo` group (Ubuntu/Debian) or `wheel` group (RHEL/CentOS) can use `sudo`:

```bash
sudo usermod -aG sudo alice       # give alice sudo rights (Ubuntu/Debian)
sudo visudo                       # edit sudo rules safely
```

---

## Practice Lab (Day 2)

```bash
# 1. Create a group and two users
sudo groupadd devs
sudo useradd -m -s /bin/bash -G devs alice
sudo useradd -m -s /bin/bash bob
sudo passwd alice
sudo passwd bob

# 2. Verify
id alice
id bob
getent group devs

# 3. Create a shared folder for the group
sudo mkdir /opt/project
sudo chown root:devs /opt/project
sudo chmod 770 /opt/project
ls -ld /opt/project

# 4. Test as alice (member of devs): works
su - alice
touch /opt/project/alice.txt
ls -l /opt/project
exit

# 5. Test as bob (not in devs): permission denied
su - bob
touch /opt/project/bob.txt
exit

# 6. Add bob to the group, then test again
sudo usermod -aG devs bob
su - bob
touch /opt/project/bob.txt
exit

# 7. Practice chmod and chown
touch test.sh
ls -l test.sh
chmod 755 test.sh
ls -l test.sh
sudo chown alice:devs test.sh
ls -l test.sh

# 8. Clean up
sudo userdel -r alice
sudo userdel -r bob
sudo groupdel devs
sudo rm -r /opt/project
```

---

## Interview-Style Questions (Day 2)

**Q1. What is the difference between `chmod` and `chown`?**
`chmod` changes permissions (what can be done). `chown` changes ownership (who owns the file).

**Q2. What does `755` mean?**
Owner has read, write and execute (7). Group and others have read and execute (5).

**Q3. Why can a user not be deleted?**
Because they have a running process. Stop it with `kill` or `pkill -u user`, then run `userdel -r user`.

**Q4. What happens if you run `usermod -G devs alice` without `-a`?**
Alice's existing supplementary groups are replaced by only `devs`.

**Q5. Where are users, passwords and groups stored?**
`/etc/passwd`, `/etc/shadow` and `/etc/group`.

---

## Quick Reference (Day 2)

| Task | Command |
|------|---------|
| Who am I | `whoami`, `id` |
| Add user | `sudo adduser name` |
| Set password | `sudo passwd name` |
| Delete user | `sudo userdel -r name` |
| Create group | `sudo groupadd name` |
| Delete group | `sudo groupdel name` |
| Add user to group | `sudo usermod -aG group user` |
| Remove user from group | `sudo gpasswd -d user group` |
| Show user's groups | `groups user`, `id user` |
| Change permissions | `chmod 755 file` |
| Change owner and group | `sudo chown user:group file` |
| Change group only | `sudo chgrp group file` |
| Recursive change | `chmod -R` / `chown -R` |
| Switch user | `su - name` |
| Run as root | `sudo command` |

---

# Day 3: Processes, Signals, Services and Logs

Day 3 of the 7-day Linux and server administration plan. It covers how to inspect running processes, control them with signals, manage services with systemd, and read logs to diagnose failures.

## Topics Covered (Day 3)

- Processes: `ps`, `pgrep`, `pstree`, `top`
- Jobs: foreground, background, `nohup`
- Signals: `kill`, `pkill`, `killall`
- Services: `systemctl`
- Logs: `journalctl`

---

## Processes

```bash
ps aux                  # all processes
ps -ef --forest         # parent/child tree
pgrep -a nginx          # find PIDs by name
pstree -p               # tree view with PIDs
top                     # live view (q to quit)
```

### Key concepts

- Every process has a **PID** (process ID) and a **PPID** (parent's PID). On systemd systems, PID 1 is `systemd`.
- A **zombie** is a process that has already finished, but its parent has not yet read its exit status. It is already dead, so it **cannot be killed**. Fix or restart the parent, and the zombie is cleaned up.

| STAT | Meaning |
|------|---------|
| `R` | Running |
| `S` | Sleeping (waiting for an event) |
| `D` | Uninterruptible sleep, usually waiting on disk I/O |
| `T` | Stopped |
| `Z` | Zombie |

### top cheat sheet

| Key | Action |
|-----|--------|
| `P` / `M` | Sort by CPU / memory |
| `1` | Show each CPU core |
| `k` | Kill a process |
| `u` | Filter by user |
| `c` | Show full command line |
| `q` | Quit |

Scriptable snapshot:

```bash
top -b -n 1 | head -20
```

In the `top` header, compare the **load average** with the number of CPU cores. A high `wa` value means the system is waiting on disk I/O.

---

## Jobs

```bash
sleep 300 &          # run in background
jobs                 # list jobs
fg %1                # bring job 1 to the foreground
bg %1                # resume a paused job in the background
nohup ./script.sh &  # keep running after logout (output goes to nohup.out)
```

`Ctrl+Z` pauses the current foreground job. Then `bg %1` resumes it in the background.

---

## Signals

| Signal | Number | Meaning |
|--------|--------|---------|
| SIGHUP | 1 | Reload config / terminal closed |
| SIGINT | 2 | Interrupt (Ctrl+C) |
| SIGTERM | 15 | Polite terminate (default) |
| SIGKILL | 9 | Force kill, cannot be caught or ignored |

```bash
kill PID            # SIGTERM
kill -9 PID         # SIGKILL (last resort)
kill -HUP PID       # reload config
pkill nginx         # by name (pattern match)
pkill -x nginx      # exact name match only
pkill -u alice      # all processes of a user
killall nginx       # all processes with this exact name
kill -l             # list all signals
```

**`kill` vs `kill -9`:** `kill` sends SIGTERM, so the process can clean up (close files, remove locks, flush data). `kill -9` sends SIGKILL, which the kernel enforces immediately with no cleanup. Try SIGTERM first.

> Even `kill -9` cannot remove a process stuck in `D` state until its I/O finishes, and it cannot remove a zombie.

---

## Services with systemctl

```bash
systemctl status nginx
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl reload nginx          # reload config, no downtime
sudo systemctl enable --now nginx    # start at boot and start now
systemctl is-active nginx
systemctl is-enabled nginx
systemctl --failed                   # what is broken?
```

- **start** runs the service now. **enable** makes it start at boot. They are independent.
- **restart** stops and starts (new PID, brief downtime). **reload** re-reads the config (same PID, no downtime), but only if the service supports it. Use `reload-or-restart` if you are not sure.
- After editing a unit file, run `sudo systemctl daemon-reload`.

### Example custom service

Create the content folder first:

```bash
sudo mkdir -p /srv/hello
echo "hello" | sudo tee /srv/hello/index.html
```

`/etc/systemd/system/hello.service`

```ini
[Unit]
Description=Hello test service

[Service]
User=nobody
WorkingDirectory=/srv/hello
ExecStart=/usr/bin/python3 -m http.server 8080 --bind 127.0.0.1
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now hello
curl http://127.0.0.1:8080
```

> `WorkingDirectory` matters: without it, a service starts in `/`, so `http.server` would publish the whole filesystem. `User=nobody` and `--bind 127.0.0.1` keep this test service unprivileged and local only.

---

## Logs with journalctl

```bash
journalctl -u nginx                      # one service
journalctl -u nginx -n 50 --no-pager     # last 50 lines
journalctl -u nginx -f                   # follow live
journalctl -u nginx --since "10 min ago"
journalctl -p err -b                     # errors since boot
journalctl --disk-usage
```

**systemctl vs journalctl:** `systemctl` controls and inspects services. `journalctl` reads their logs.

---

## Troubleshooting Routine

When a service is `failed`:

1. `systemctl status SERVICE` shows the state, exit code and last log lines.
2. `journalctl -u SERVICE -n 50 --no-pager` shows the full reason.
3. Validate the config (for example `nginx -t`) and check ports with `ss -tlnp`.
4. Also check file permissions and free disk space (`df -h`).
5. Fix the problem, run `sudo systemctl restart SERVICE`, and verify with `systemctl is-active SERVICE`.

---

## Lab Exercises (Day 3)

- [ ] Start `sleep 1000 &`, find it with `ps` and `pgrep`, and kill it with SIGTERM.
- [ ] Start a process that ignores SIGTERM: `bash -c "trap '' TERM; while true; do sleep 1; done" &`. Confirm `kill PID` has no effect and `kill -9 PID` works.
- [ ] Create `hello.service`, kill its process with `kill -9`, and watch `Restart=on-failure` bring it back with a new PID.
- [ ] Install nginx (`sudo apt install nginx`), break its config, read the error in `journalctl`, fix it and restart.
- [ ] Run `systemctl --failed` and `journalctl -p err -b` to find other problems.
- [ ] Run `yes > /dev/null &`, spot it in `top`, and kill it.

## Self-Check Questions (Day 3)

1. What is the difference between `kill` and `kill -9`?
2. What is a zombie process, and can you kill it?
3. What is the difference between `restart` and `reload`?
4. A service shows `failed`. What are your next three commands?
5. What does `enable` do compared with `start`?

## Pass Condition (Day 3)

I can take a broken service, find the reason in the logs, fix it and restore it without following a tutorial.

---

## Quick Reference (Day 3)

| Task | Command |
|------|---------|
| List all processes | `ps aux` |
| Find a PID by name | `pgrep -a name` |
| Live process view | `top` |
| Run in background | `command &` |
| Stop a process politely | `kill PID` |
| Force kill | `kill -9 PID` |
| Kill by name | `pkill name`, `killall name` |
| Service status | `systemctl status name` |
| Start / stop / restart | `sudo systemctl start\|stop\|restart name` |
| Start at boot and now | `sudo systemctl enable --now name` |
| List failed services | `systemctl --failed` |
| Service logs | `journalctl -u name -n 50 --no-pager` |
| Follow logs live | `journalctl -u name -f` |
| Errors since boot | `journalctl -p err -b` |

---

**Previous:** Day 2: Users, Groups and Permissions
**Next:** Day 4: Disk, Memory, CPU and Filesystems (`df`, `du`, `free`, `uptime`, `vmstat`)

---

# Day 4: Disk, Memory, CPU and Filesystems

Day 4 of the 7-day Linux and server administration plan. It covers how to check disk space, memory, CPU load and I/O, and how to tell which resource is the bottleneck on a slow or full server.

## Topics Covered (Day 4)

- Disk space: `df`, `du`, `find`, `lsof`
- Block devices and mounts: `lsblk`, `mount`, `findmnt`, `/etc/fstab`
- Memory: `free`
- CPU and load: `uptime`, `nproc`, `lscpu`
- System activity: `vmstat`, `iostat`

---

## Disk Space

```bash
df -h                                   # space per filesystem
df -i                                   # inode usage
df -hT                                  # include filesystem type
du -sh /var/log                         # size of one directory
sudo du -xh / --max-depth=1 | sort -h   # biggest directories (-x = stay on one filesystem)
```

### Find large files

```bash
sudo find / -xdev -type f -size +500M 2>/dev/null
sudo find /var/log -type f -mtime +30
ls -lhS /var/log | head
```

### Key concepts

- `df` reports at the **filesystem** level. `du` adds up **files and directories**.
- If `df` shows far more used than `du`, a **deleted file is usually still held open** by a process. Find it with `sudo lsof +L1`, then restart that process.
- A disk can be full while space is free if **inodes** run out (`df -i` shows `IUse% 100%`).
- Ignore `tmpfs` and `udev` lines. They are RAM-backed.

---

## Block Devices and Filesystems

```bash
lsblk              # disks, partitions, mount points
lsblk -f           # plus filesystem type and UUID
findmnt            # tree of mounts
cat /etc/fstab     # mounts applied at boot
sudo blkid         # UUIDs
```

### Mount a new disk

```bash
lsblk                          # 1. identify the new disk and double-check its name
sudo mkfs.ext4 /dev/sdb1       # 2. create a filesystem (ERASES everything on it)
sudo mkdir /mnt/data           # 3. create a mount point
sudo mount /dev/sdb1 /mnt/data # 4. mount it
sudo umount /mnt/data          # unmount when finished
```

> `/dev/sdb1` assumes the disk already has a partition. A brand-new disk must be partitioned first (with `fdisk` or `parted`). Always confirm the device name with `lsblk` before `mkfs`, because formatting the wrong device destroys its data.

### Why UUIDs in `/etc/fstab`?

Device names like `/dev/sdb1` can change between boots (new disk, boot order, USB drive). A UUID is stored in the filesystem itself, so the correct disk is always mounted. Get yours from `sudo blkid` and replace the placeholder below:

```
UUID=3f2a1c9e-xxxx-xxxx-xxxx-9b7d4e6a1f20  /mnt/data  ext4  defaults,nofail  0  2
```

| Field | Example | Meaning |
|-------|---------|---------|
| Device | `UUID=...` | What to mount |
| Mount point | `/mnt/data` | Where to mount it |
| Type | `ext4` | Filesystem type |
| Options | `defaults,nofail` | Mount options |
| Dump | `0` | Backup flag (almost always 0) |
| Fsck order | `2` | Check order at boot: 1 for root, 2 for others, 0 to skip |

- Test with `sudo mount -a` before rebooting. A bad line can drop the machine into emergency mode.
- Add `nofail` for non-essential disks so a missing disk doesn't block boot.

---

## Memory

```bash
free -h
```

- **free** is completely unused RAM.
- **available** is what programs can actually use (free RAM plus cache that can be released). **Read this one.**
- Linux uses spare RAM as cache (`buff/cache`), so low "free" is normal.
- Swap in use is not automatically a problem. **Active swapping** (non-zero `si`/`so` in `vmstat`) means memory pressure.
- Top memory users: `ps aux --sort=-%mem | head`
- Check for the OOM killer (out-of-memory killer):

```bash
sudo journalctl -k | grep -i "out of memory"
sudo dmesg | grep -i oom
```

---

## CPU and Load

```bash
uptime            # load average: 1, 5, 15 minutes
nproc             # number of cores
lscpu             # CPU details
```

Compare load average with the core count:

| Load vs cores | Meaning |
|---------------|---------|
| Below core count | Fine |
| Equal | Fully busy |
| Well above (e.g. 8 on 4 cores) | Demand is double capacity, processes are queuing |

The three numbers are the 1, 5 and 15 minute averages, so check the trend: `8, 4, 2` is rising and `2, 4, 8` is recovering.

> On Linux, load average counts processes waiting on **disk I/O** (`D` state) as well as processes waiting for CPU. So high load with a mostly idle CPU often points to a disk problem.

**High load, then what?** Use `top` (press `P`, then `1`) and `vmstat 2`.

- High `us`/`sy`: CPU-bound. Find the process and fix or stop it.
- Low CPU but high `wa`: processes are stuck waiting on disk. Check `iostat -x` and `iotop`.

---

## vmstat

```bash
vmstat 2 5        # every 2 seconds, 5 samples
```

| Column | Meaning | Watch for |
|--------|---------|-----------|
| `r` | Runnable processes (running or waiting for CPU) | Consistently above core count |
| `b` | Processes blocked on I/O | Above 0 for long |
| `si` / `so` | Swap in / out | Non-zero means memory pressure |
| `bi` / `bo` | Blocks read / written | Heavy disk activity |
| `us` / `sy` | User / kernel CPU | High means CPU-bound |
| `id` | Idle | Near 0 means CPU-bound |
| `wa` | I/O wait | High means a disk bottleneck |

The first line is the average since boot, so ignore it.

**High `wa`** means the CPU is idle while waiting on disk I/O, so the disk is the bottleneck and adding CPU won't help. Use `iostat -x 2` (package `sysstat`) for per-disk stats and `sudo iotop` (package `iotop`) to find the process.

---

## Troubleshooting Guide

| Symptom | First checks |
|---------|--------------|
| "No space left on device" | `df -h`, `df -i`, `du` drill-down, `lsof +L1` |
| System slow | `uptime`, `top`, `vmstat 2` (CPU, memory or I/O?) |
| High `wa` | `iostat -x`, `iotop`, `df -h` |
| Process disappeared | `journalctl -k \| grep -i oom` |
| Swap growing | `free -h`, `ps aux --sort=-%mem` |

### Server at 100% disk: five commands

```bash
df -h                                    # which filesystem is full?
df -i                                    # or are inodes exhausted?
sudo du -xh / --max-depth=1 | sort -h    # biggest directory, repeat deeper
sudo find / -xdev -type f -size +500M    # large files
sudo lsof +L1                            # deleted files held open
```

Optional sixth: `journalctl --disk-usage` for bloated logs.

Fixes:

- Truncate a huge log instead of deleting it (a process may still hold it open): `sudo truncate -s 0 /var/log/big.log`
- Rotate logs, or vacuum the journal: `sudo journalctl --vacuum-size=200M`
- Clear package caches (for example `sudo apt clean`).
- Restart the process holding deleted files.
- Then add logrotate and monitoring to prevent a repeat.

---

## Lab Exercises (Day 4)

- [ ] Run `df -h` and `lsblk`. Identify the root filesystem and its type.
- [ ] Create a 1 GB file with `fallocate -l 1G /tmp/big.img`. Watch `df -h`, find it with `find`, delete it. (On systems where `/tmp` is `tmpfs`, this uses RAM, so use a disk-backed folder such as `/var/tmp`.)
- [ ] Fill a small loop-mounted filesystem and practise `df` → `du` → `find` → delete:

  ```bash
  truncate -s 100M /var/tmp/disk.img            # 100 MB image file
  mkfs.ext4 -F /var/tmp/disk.img                # filesystem inside the file
  sudo mkdir /mnt/small
  sudo mount -o loop /var/tmp/disk.img /mnt/small
  sudo fallocate -l 90M /mnt/small/fill.bin     # nearly fill it
  df -h /mnt/small
  # clean up
  sudo umount /mnt/small && rm /var/tmp/disk.img
  ```

- [ ] Hold a deleted file open (`sleep 1000 < /var/tmp/big.img &`, then `rm /var/tmp/big.img`). Confirm `df` still shows the space used, find it with `sudo lsof +L1`, and kill the process to free it.
- [ ] Run `yes > /dev/null &` and watch `uptime` and `vmstat 2`. Kill it.
- [ ] Explain `free` vs `available` in my own words.
- [ ] Check `df -i` and explain what causes a full disk with free space.

## Self-Check Questions (Day 4)

1. A server is at 100% disk. What are your first five commands?
2. `df` says the disk is full but `du` shows much less. Why?
3. What is the difference between `free` and `available` memory?
4. Load average is 8 on a 4-core machine. What does it mean?
5. What does a high `wa` tell you?
6. Why use UUIDs in `/etc/fstab`?

## Pass Condition (Day 4)

I can find what is filling a disk, tell whether a slow server is short of CPU, memory or disk I/O, and explain the numbers.

## Lessons Learned

- Read the question first, then pick commands for that resource (disk, CPU or memory).
- `df` and `du` can disagree. The usual cause is a deleted file still held open.
- Look at `available` memory, not `free`.

---

## Quick Reference (Day 4)

| Task | Command |
|------|---------|
| Space per filesystem | `df -h` |
| Inode usage | `df -i` |
| Size of a directory | `du -sh dir` |
| Biggest directories | `sudo du -xh / --max-depth=1 \| sort -h` |
| Find large files | `sudo find / -xdev -type f -size +500M` |
| Deleted files held open | `sudo lsof +L1` |
| List disks and mounts | `lsblk -f`, `findmnt` |
| Get UUIDs | `sudo blkid` |
| Test fstab | `sudo mount -a` |
| Memory | `free -h` (read `available`) |
| Load and cores | `uptime`, `nproc` |
| System activity | `vmstat 2 5` |
| Disk I/O per device | `iostat -x 2` |
| Journal size | `journalctl --disk-usage` |

---

**Previous:** Day 3: Processes, Signals, Services and Logs
**Next:** Day 5: Networking (ports, DNS, SSH, `curl`, `ip`, `ss`, firewall basics)

---

# Day 5: Networking, SSH and Firewall Basics

Day 5 of the 7-day Linux and server administration plan. It covers how to check a server's network configuration, test connectivity, inspect ports and DNS, make HTTP requests, log in remotely with SSH, and control traffic with a firewall.

## Topics Covered (Day 5)

- Addresses and routes: `ip`
- Connectivity: `ping`, `traceroute`
- Ports and sockets: `ss`, `nc`
- DNS: `dig`, `/etc/resolv.conf`, `/etc/hosts`
- HTTP: `curl`
- Remote access: SSH, keys, `scp`
- Firewall basics: `ufw`, `firewalld`

---

## Network Basics

```bash
ip addr                 # IP addresses (short form: ip a)
ip -br a                # brief, one line per interface
ip route                # routing table
ip route | grep default # default gateway
ip link                 # interfaces and their state
ip neigh                # ARP table (neighbours on the LAN)
hostname -I             # all IPs of this host
```

### Key concepts

- **IP address**: the address of a host (for example `192.168.1.10`).
- **Gateway**: the router that traffic leaves through to reach other networks. It is the `default via ...` line in `ip route`.
- **Loopback (`127.0.0.1`, `localhost`)**: the machine talking to itself.
- **Private ranges**: `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`. These are not routable on the internet.
- **CIDR**: `192.168.1.0/24` means the first 24 bits are the network, so 256 addresses.

---

## Connectivity Testing

```bash
ping -c 4 8.8.8.8          # 4 packets, by IP
ping -c 4 example.com      # by name (also tests DNS)
traceroute example.com     # path to the host (package traceroute)
tracepath example.com      # similar, usually preinstalled
```

### The ping ladder

Test from the inside out, and stop at the first failure:

| Step | Command | If it fails |
|------|---------|-------------|
| 1. Local stack | `ping -c 2 127.0.0.1` | Network stack is broken |
| 2. Gateway | `ping -c 2 <gateway IP>` | Local link or Wi-Fi/cable problem |
| 3. Internet by IP | `ping -c 2 8.8.8.8` | Routing or ISP problem |
| 4. Internet by name | `ping -c 2 example.com` | DNS problem |

> Some hosts block ICMP, so a failed `ping` does not always mean the host is down. Confirm with `curl` or `nc`.

---

## Ports and Sockets

A **port** identifies a service on a host. An address plus a port, such as `10.0.0.5:443`, is a **socket**.

| Port | Service |
|------|---------|
| 22 | SSH |
| 53 | DNS |
| 80 | HTTP |
| 443 | HTTPS |
| 3306 | MySQL |
| 5432 | PostgreSQL |

Ports below 1024 are privileged, so only root can listen on them.

```bash
sudo ss -tlnp                 # listening TCP ports with the process
sudo ss -tunap                # all TCP/UDP sockets with processes
ss -s                         # summary
ss -tn state established      # active connections
sudo ss -tlnp | grep :80      # who is on port 80?
sudo lsof -i :80              # alternative
```

| Flag | Meaning |
|------|---------|
| `-t` / `-u` | TCP / UDP |
| `-l` | Listening sockets only |
| `-n` | Numeric (no name lookups) |
| `-p` | Show the process (needs `sudo` for other users' processes) |
| `-a` | All sockets |

### Reading the listen address

| Local address | Meaning |
|---------------|---------|
| `127.0.0.1:5432` | Reachable **only from this machine** |
| `0.0.0.0:80` | All IPv4 interfaces |
| `[::]:80` | All IPv6 interfaces (often IPv4 too) |
| `192.168.1.10:80` | One specific interface |

A service listening only on `127.0.0.1` cannot be reached from another machine, however open the firewall is.

### Test a remote port

```bash
nc -zv example.com 443                                 # netcat: -z scan, -v verbose
timeout 3 bash -c '</dev/tcp/example.com/443' && echo open   # no extra tools
```

> `netstat` is the older tool (package `net-tools`). Prefer `ss`.

---

## DNS

DNS turns names into IP addresses.

```bash
dig example.com                # full answer
dig +short example.com         # just the IPs
dig example.com MX             # mail servers
dig @8.8.8.8 example.com       # ask a specific DNS server
nslookup example.com           # older alternative
getent hosts example.com       # what the system resolver returns
```

`dig` is in the package `dnsutils` (`bind-utils` on RHEL).

| Record | Purpose |
|--------|---------|
| A / AAAA | Name to IPv4 / IPv6 address |
| CNAME | Alias to another name |
| MX | Mail server |
| NS | Name servers of the domain |
| TXT | Free text (SPF, verification) |

### Where the system looks up names

| File | Purpose |
|------|---------|
| `/etc/hosts` | Manual name-to-IP entries, checked first |
| `/etc/resolv.conf` | Which DNS server to ask (on Ubuntu this is often `127.0.0.53`, the local resolver) |
| `/etc/nsswitch.conf` | The order: files (`/etc/hosts`) then DNS |

```bash
resolvectl status              # DNS servers in use (systemd-resolved)
cat /etc/hosts
```

> `dig` queries DNS directly and ignores `/etc/hosts`. Use `getent hosts name` to see what applications will actually get.

---

## HTTP with curl

```bash
curl https://example.com                   # fetch a page
curl -I https://example.com                # headers only
curl -v https://example.com                # verbose: DNS, TLS, request, response
curl -s -o /dev/null -w "%{http_code}\n" https://example.com   # just the status code
curl -L http://example.com                 # follow redirects
curl -o page.html https://example.com      # save to a file
curl -X POST -d "name=alice" https://example.com/api
curl -H "Authorization: Bearer TOKEN" https://example.com/api
curl --connect-timeout 5 https://example.com
curl -k https://self-signed.local          # skip TLS verification (testing only)
```

| Status | Meaning |
|--------|---------|
| 200 | OK |
| 301 / 302 | Redirect |
| 403 | Forbidden (permissions) |
| 404 | Not found |
| 500 | Server error |
| 502 / 503 | Bad gateway / unavailable (backend down or overloaded) |

### Refused vs timed out vs not resolved

| Error | Usual meaning |
|-------|---------------|
| `Could not resolve host` | DNS problem |
| `Connection refused` | Host reachable, but **nothing is listening** on that port (or a reject rule) |
| `Connection timed out` | Packets are being **dropped**: firewall, wrong IP or routing |

---

## SSH

**SSH (Secure Shell)** gives an encrypted remote terminal on port 22.

```bash
ssh alice@192.168.1.10                 # connect
ssh -p 2222 alice@192.168.1.10         # custom port
ssh -i ~/.ssh/mykey alice@host         # specific key
ssh alice@host 'df -h'                 # run one command remotely
ssh -v alice@host                      # verbose, for debugging
```

On the first connection SSH shows the server's fingerprint and stores it in `~/.ssh/known_hosts`. If a later connection warns that the host identification has changed, confirm the change is legitimate, then run `ssh-keygen -R host`.

### Key-based login (recommended)

- The **private key** (`~/.ssh/id_ed25519`) stays on your machine. Never share it.
- The **public key** (`~/.ssh/id_ed25519.pub`) goes on the server.

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"   # 1. create the key pair
ssh-copy-id alice@192.168.1.10                      # 2. install the public key
ssh alice@192.168.1.10                              # 3. log in without a password
```

The server keeps public keys in `~/.ssh/authorized_keys`. SSH refuses to work if the permissions are too open:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_ed25519
```

### Copy files with scp

```bash
scp file.txt alice@host:/home/alice/       # local to remote
scp alice@host:/home/alice/file.txt .      # remote to local
scp -r mydir/ alice@host:/home/alice/      # directory
```

### Config shortcut

`~/.ssh/config`

```
Host myserver
    HostName 192.168.1.10
    User alice
    Port 22
    IdentityFile ~/.ssh/id_ed25519
```

Then connect with `ssh myserver`.

### Hardening the server (`/etc/ssh/sshd_config`)

| Setting | Recommended | Why |
|---------|-------------|-----|
| `PermitRootLogin` | `no` | Block direct root login |
| `PasswordAuthentication` | `no` | Keys only (after confirming key login works) |

```bash
sudo sshd -t                    # check the config for errors first
sudo systemctl restart ssh      # service is "ssh" on Ubuntu/Debian, "sshd" on RHEL
```

> Keep your current session open and test a second login before closing it, so a mistake doesn't lock you out. On recent Ubuntu, SSH may be started by a socket (`ssh.socket`). If a port change doesn't take effect, check `systemctl status ssh.socket`.

### SSH logs

```bash
sudo journalctl -u ssh -n 50 --no-pager          # Ubuntu/Debian ("sshd" on RHEL)
sudo grep "Failed password" /var/log/auth.log    # failed logins (Ubuntu/Debian)
```

---

## Firewall Basics

A firewall decides which traffic is allowed in and out. Rules are matched per port, protocol and source.

### ufw (Ubuntu/Debian)

```bash
sudo ufw status verbose
sudo ufw allow OpenSSH              # or: sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo ufw status numbered
sudo ufw delete allow 80/tcp
sudo ufw limit ssh                  # rate-limit SSH attempts
```

> **Allow SSH before running `ufw enable`.** Otherwise you cut off your own remote session.

### firewalld (RHEL/CentOS)

```bash
sudo firewall-cmd --list-all
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

### Good to know

- `ufw` and `firewalld` are front-ends for `nftables`/`iptables`. See the raw rules with `sudo nft list ruleset` or `sudo iptables -L -n -v`.
- A **deny/drop** rule makes clients wait and **time out**. A **reject** rule makes them fail at once with **connection refused**.
- Cloud providers add their own firewall (security groups). Both the cloud firewall and the server firewall must allow the traffic.

---

## Network Troubleshooting

| Symptom | First checks |
|---------|--------------|
| `Could not resolve host` | `dig +short name`, `cat /etc/resolv.conf`, `resolvectl status` |
| Ping works by IP but not by name | DNS: check the resolver and `/etc/hosts` |
| `Connection refused` | On the server: `sudo ss -tlnp`, is the service up and on the right address and port? |
| `Connection timed out` | Firewall (`ufw status`, cloud security group), `ip route`, wrong IP |
| Website shows 502/503 | Backend service: `systemctl status`, `journalctl -u` |
| SSH `Permission denied (publickey)` | Key in `authorized_keys`? Permissions 700/600? Right user? `ssh -v` |
| SSH `Connection refused` | `systemctl status ssh`, `ss -tlnp \| grep :22` |

### Service unreachable from outside: my routine

```bash
systemctl is-active nginx          # 1. is the service running?
sudo ss -tlnp | grep :80           # 2. is it listening, and on which address?
curl -I http://localhost           # 3. does it work locally?
sudo ufw status                    # 4. does the firewall allow it?
curl -I http://SERVER_IP           # 5. from another machine
```

If step 5 still fails, check the cloud security group and any upstream firewall.

---

## Lab Exercises (Day 5)

- [ ] Run `ip -br a` and `ip route`. Identify your IP address and default gateway.
- [ ] Run the ping ladder (loopback, gateway, `8.8.8.8`, `example.com`) and note where it would break.
- [ ] Run `dig +short example.com`, then `dig @8.8.8.8 +short example.com`. Compare.
- [ ] Add a line to `/etc/hosts` (for example `127.0.0.1 myapp.local`) and confirm with `getent hosts myapp.local`. Notice that `dig` does not see it.
- [ ] Start `python3 -m http.server 8000 --bind 127.0.0.1 &`. Find it with `ss -tlnp`, test with `curl -I http://127.0.0.1:8000`, then stop it with `kill %1`.
- [ ] With the server stopped, run `curl -I http://127.0.0.1:8000` and read the **connection refused** error.
- [ ] Print only the status code: `curl -s -o /dev/null -w "%{http_code}\n" https://example.com`.
- [ ] Generate an SSH key with `ssh-keygen -t ed25519`, install it with `ssh-copy-id`, and log in without a password. Try `ssh -v` to read the handshake.
- [ ] On a test VM: `sudo ufw allow OpenSSH`, `sudo ufw enable`, add a rule for port 8000, check `ufw status numbered`, then delete the rule.

## Self-Check Questions (Day 5)

1. What is the difference between `Connection refused` and `Connection timed out`?
2. A service listens on `127.0.0.1:5432`. Why can't another server connect to it?
3. `ping 8.8.8.8` works but `ping example.com` fails. What is wrong?
4. What does `ss -tlnp` show, and what does each flag mean?
5. Why must you allow SSH before enabling `ufw`?
6. Why does `dig` return a different answer from what an application sees?
7. Which two files must have strict permissions for key-based SSH to work?

## Pass Condition (Day 5)

I can take a service that cannot be reached, work out whether the cause is DNS, the service, the listen address or a firewall, and fix it.

---

## Quick Reference (Day 5)

| Task | Command |
|------|---------|
| IP addresses | `ip -br a` |
| Default gateway | `ip route \| grep default` |
| Test connectivity | `ping -c 4 host` |
| Listening ports | `sudo ss -tlnp` |
| Who uses a port | `sudo lsof -i :PORT` |
| Test a remote port | `nc -zv host port` |
| DNS lookup | `dig +short name` |
| What the system resolves | `getent hosts name` |
| HTTP headers | `curl -I url` |
| HTTP status code only | `curl -s -o /dev/null -w "%{http_code}\n" url` |
| SSH login | `ssh user@host` |
| Create SSH key | `ssh-keygen -t ed25519` |
| Install SSH key | `ssh-copy-id user@host` |
| Copy a file | `scp file user@host:/path` |
| Firewall status | `sudo ufw status verbose` |
| Allow a port | `sudo ufw allow 80/tcp` |

---

**Previous:** Day 4: Disk, Memory, CPU and Filesystems
**Next:** Day 6
