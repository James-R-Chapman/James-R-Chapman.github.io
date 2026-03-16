---
title:      "Linux Forensics Cheatsheet"
date:       2025-02-27T00:00:00-05:00
tags:       ["tryhackme"]
identifier: "20250227T000000"
  -  #tryhackme #Linux #Cheatsheet
hubs: "TryHackMe"
aliases:
  -
urls:
  -
id: 137c68bc-ed5d-47a0-a043-aa33286ead45
---

# Linux Forensics Cheatsheet

## Contents

### Table of contents

<!-- toc -->

# Linux Forensics Cheatsheet

## System and OS information

### OS release information:

Location: /etc/os-release
Can be read using cat, vim or any text editor or viewer

### User Accounts information:

Location: /etc/passwd
Can be read using cat, vim or any text editor or viewer

### User Group Information

Location: /etc/group
Can be read using cat, vim or any text editor or viewer

### Sudo'ers list

Location: /etc/sudoers
Can be read using cat, vim or any text editor or viewer
Needs sudo or root permissions to access

### Login Information

Location: /var/log/wtmp
Can be read using last utility

### Authentication Logs:

Location: /var/log/auth.log
Can be read using cat, vim or any text editor or viewer
Use grep for better filtering.
Might also have auth.log1, auth.log2 etc as log files that have been rotated.

## System Configuration

### Hostname:

Location: /etc/hostname
Can be read using cat, vim or any text editor or viewer

### Timezone Information:

Location: /etc/network/interfaces
Can be read using cat, vim or any text editor or viewer

### Network Interfaces:

Location: /etc/network/interfaces
Can be read using cat, vim or any text editor or viewer

Command: ip address show
The above command is suitable only for live Analysis

### Open network commmunications

Command: netstat -natp
The above command is suitable only for live Analysis

### Running processes:

Command: ps aux
The above command is suitable only for live Analysis

### DNS Information:

Location: /etc/hosts for hostname resolutions
Can be read using cat, vim or any text editor or viewer

Location: /etc/resolv.conf for information about DNS servers.
Can be read using cat, vim or any text editor or viewer

## Persistence mechanism

### Cron jobs:

Location: /etc/crontab
Can be read using cat, vim or any text editor or viewer

### Services:

Location: /etc/init.d/
Registered services are present in this directory

### Bash shell startup:

Location: /home/<user>/bashre for each user

Locations: /etc/bash.bashrc and /etc/profile for system wide settings. Can be read using cat, vim or any text editor or viewer

## Evidence of execution

### Authentication logs:

Location: /var/log/auth.log\* Igrep -i COMMAND;
the grep can be used to filter the results.
Can be read using cat, vim or any text editor or viewer

### Bash history:

Location: /home/<user>/.bash_history
Can be read using cat, vim or any text editor or viewer

### Vim history:

Location: /home/<user>/.viminfo
Can be read using cat, vim or any text editor or viewer

## Log files

### Syslogs:

Location: /var/log/syslog
Can be read using cat, vim or any text editor or viewer.
Use grep or similar utitity to filter results as per requirement

### Authentication logs:

Location: /var/log/auth.log Can be read using cat, vim or any text editor or viewer.
Use grep or similar utitity to filter results as per requirement

### Third-party logs:

Location: /var/log
Logs for each third-party application can be found in their specific directories in this location
