# Linux for DevOps Notes

Beginner notes on Linux: the filesystem and basic commands (Day 1), users, groups, permissions and ownership (Day 2), and processes, signals, services and logs (Day 3).

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
- [Pass Condition](#pass-condition)
- [Quick Reference (Day 3)](#quick-reference-day-3)

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

## Topics Covered

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

## Pass Condition

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
