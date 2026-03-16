---
layout: post
title: "TryHackMe  - Linux Logs Investigations"
date: 2025-09-03
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Advanced Endpoint Investigations/Linux Endpoint Investigation"
source_id: "005048eb-47ae-43c0-8985-8adf07d11a7d"
source_urls: "(https://tryhackme.com/room/linuxlogsinvestigations)"
source_path: "Advanced Endpoint Investigations/Linux Endpoint Investigation/TryHackMe  - Linux Logs Investigations.md"
---


# TryHackMe | Linux Logs Investigations

## Task 1 | Introduction

Start Machine

 Just like a map guides explorers, logs can be used to navigate system administrators and security analysts through the intricate world of Linux. This room equips you with essential skills to decipher these logs, focusing on core areas like logging levels, kernel whispers via `/var/log/kern.log`, user interactions, the watchful eye of auditd, the versatile syslog, and the modern journal. By the end, you'll be able to unearth hidden clues and safeguard your systems.

 Objectives 
- Learn about the different types of logs recorded on Linux systems.
- Learn how to perform forensic analysis through logs on Linux systems, focused on determining malicious processes, services, and scripts.
- Hunt malicious processes, services, and configurations to mitigate further compromise in a hands-on IR scenario.

 Prerequisites To understand how to work with Linux logs for forensic investigations, you should have a solid grasp of the Linux operating system basics and system hardening concepts.

 
- [Log Analysis](https://tryhackme.com/module/log-analysis)
- Linux Fundamentals: [Part 1](https://tryhackme.com/room/linuxfundamentalspart1), [Part 2](https://tryhackme.com/room/linuxfundamentalspart2), and [Part 3](https://tryhackme.com/room/linuxfundamentalspart3)
- [Linux File System Analysis](https://tryhackme.com/room/linuxfilesystemanalysis)
- [Linux System Hardening](https://tryhackme.com/room/linuxsystemhardening)

 Connecting to the machine To start the VM, press the green `Start Machine` button attached to this task. The machine will start in split view. In case it is not showing up, you can press the blue Show `Split View` button at the top of the page.

### **Answer the questions below**

**Question:** I'm ready to learn about Linux logs!

*Answer:* 

     No answer needed

---

## Task 2 | Logging Levels and Kernel Logs

In the world of Linux systems administration, understanding logs is akin to deciphering the language of your server's soul. Logs provide a breadcrumb trail of system activities, errors, and events crucial for troubleshooting, auditing, and security analysis. Knowing how to locate, parse, and analyse log files is worth mastering.

 The initial point is to understand the two primary types of logging mechanisms: kernel and user.

 
- **Kernel** logs provide a backstage pass into your system's inner workings. They include messages related to hardware events, driver operations, and system errors.
- **User** logs capture user interactions between users, applications, and the operating system. They include login attempts, command executions, and app-specific activities.

 Logging Levels The Linux logs have different levels of importance, which help categorise messages based on severity and allow administrators and analysts to prioritise their actions. The levels used by Linux include:

    Level Name Description     EMERGENCY The highest level is adopted by messages when the system is unusable or crashes.   ALERT Provides information where user attention is immediately required.   CRITICAL Provides information about critical errors, whether hardware or software-related.   ERROR Notifies the user about non-critical errors, such as failed device recognition or driver-related issues.   WARNING The default log level to display warnings about non-imminent errors.   NOTICE Notifies about events which are worth having a look at.   INFO Provides informational messages about system actions and operations.   DEBUG Detailed information used for debugging, mostly relevant during development or troubleshooting.
    
 Kernel Logging The kernel is the operating system's core, orchestrating hardware interactions, process management, and resource allocation. Kernel logs, often referred to as kernel messages, provide a backstage pass into the inner workings of your system. From hardware initialisation to driver crashes, kernel logs chronicle everything. These logs are critical for diagnosing hardware failures, identifying problematic drivers, and troubleshooting system crashes.

 The console outputs information about the system startup during a Linux host's boot process. Logging is done via the **kernel ring buffer to avoid data loss** , which handles messages from the kernel and kernel modules. The kernel ring buffer only exists in memory and is of a fixed size, which means that once full, older entries are overwritten with every new log encountered.

 We can view the current contents of the ring buffer by running the command `dmesg` as root or privileged user on the host.

    Reading the kernel ring buffer  
```Reading the kernel ring buffer 
ubuntu@tryhackme:~$ sudo dmesg
[    0.000000] Linux version 5.15.0-1063-aws (buildd@lcy02-amd64-003) (gcc (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #69~20.04.1-Ubuntu SMP Fri May 10 19:20:12 UTC 2024 (Ubuntu 5.15.0-1063.69~20.04.1-aws 5.15.152)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-5.15.0-1063-aws root=PARTUUID=da63a61e-01 ro console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295 panic=-1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Hygon HygonGenuine
[    0.000000]   Centaur CentaurHauls
[    0.000000]   zhaoxin   Shanghai  
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009e000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000efffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000010fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Xen HVM domU, BIOS 4.11.amazon 08/24/2006
[    0.000000] Hypervisor detected: Xen HVM
[    0.000000] Xen version 4.11.
[    0.000000] platform_pci_unplug: Netfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated NICs.
[    0.000000] platform_pci_unplug: Blkfront and the Xen platform PCI driver have been compiled for this kernel: unplug emulated disks.
```

  
 Additionally, it is essential to know that kernel logs are stored in the `/var/log/kern.log` file, which is managed by the **rsyslog**  or **syslog**  service. We can view the kern.log file using common file-viewing commands such as **cat** , **less,**  or **tail** .

### **Answer the questions below**

**Question:** Which type of logs provide messages related to hardware events and system errors?

*Answer:* 

     Kernel

**Question:** What is the memory space used to store system messages?

*Answer:* 

     Kernel ring buffer

**Question:** What is the default log level used to inform about non-imminent errors?

*Answer:* 

     WARNING

---

## Task 3 | Exploring the /var/log Directory

The `/var/log` directory in Linux systems is a critical repository of log files that provide insights into system activities and events. These logs are indispensable in forensic investigations, as they contain records of system processes, user activities, network connections, and much more. We will delve into major log files in the `/var/log` directory, explaining their purposes and how to analyse them effectively during a DFIR investigation.

 **kern.log and dmesg**  Continuing on the kernel logs covered in the previous task, the `/var/log/kern.log` file is dedicated to recording kernel messages. This log is essential for diagnosing hardware failures and understanding deeper system issues that attackers could exploit.

 By running the commands shown below, we can simulate a custom kernel rootkit installation and investigate the logs generated. Note that the kernel module file used here has already been generated in the VM.

    Kernel rootkit installation simulation with kern.log  
```Kernel rootkit installation simulation with kern.log 
ubuntu@tryhackme:~$ sudo insmod /home/ubuntu/exploit/custom_kernel.ko 
ubuntu@tryhackme:~$ sudo tail -f /var/log/kern.log
Jun 27 10:54:13 tryhackme kernel: raid6: sse2x1   gen()  4131 MB/s
Jun 27 10:54:13 tryhackme kernel: raid6: sse2x1   xor()  3083 MB/s
Jun 27 10:54:13 tryhackme kernel: raid6: using algorithm avx2x1 gen() 9658 MB/s
Jun 27 10:54:13 tryhackme kernel: raid6: .... xor() 4742 MB/s, rmw enabled
Jun 27 10:54:13 tryhackme kernel: raid6: using avx2x2 recovery algorithm
Jun 27 10:54:13 tryhackme kernel: xor: automatically using best checksumming function   avx       
Jun 27 10:54:13 tryhackme kernel: Btrfs loaded, crc32c=crc32c-intel, zoned=yes, fsverity=yes
Jun 27 12:11:02 tryhackme kernel: custom_kernel: loading out-of-tree module taints kernel.
Jun 27 12:11:02 tryhackme kernel: custom_kernel: module verification failed: signature and/or required key missing - tainting kernel
Jun 27 12:11:02 tryhackme kernel: Custom Kernel Module Loaded: Simulating Kernel Exploit
```

  
 Another location to look for kernel logs is the `/var/log/dmesg` file. Examining this log can help you detect unusual messages during system startup, which might indicate tampering or hardware issues. However, what you would notice is that it is quite difficult to follow this format of the logs.

    Investigating kernel logs with dmesg  
```Investigating kernel logs with dmesg 
ubuntu@tryhackme:~$ sudo tail /var/log/dmesg
[   30.719880] kernel: audit: type=1400 audit(1719484416.292:4): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=352 comm="apparmor_parser"
[   30.719886] kernel: audit: type=1400 audit(1719484416.292:5): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/NetworkManager/nm-dhcp-helper" pid=352 comm="apparmor_parser"
[   30.719888] kernel: audit: type=1400 audit(1719484416.292:6): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/connman/scripts/dhclient-script" pid=352 comm="apparmor_parser"
[   30.719891] kernel: audit: type=1400 audit(1719484416.292:7): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/{,usr/}sbin/dhclient" pid=352 comm="apparmor_parser"
[   30.829947] kernel: audit: type=1400 audit(1719484416.400:8): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/lib/cups/backend/cups-pdf" pid=360 comm="apparmor_parser"
[   30.829954] kernel: audit: type=1400 audit(1719484416.400:9): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/cupsd" pid=360 comm="apparmor_parser"
[   30.829957] kernel: audit: type=1400 audit(1719484416.400:10): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/sbin/cupsd//third_party" pid=360 comm="apparmor_parser"
[   30.836788] kernel: audit: type=1400 audit(1719484416.408:11): apparmor="STATUS" operation="profile_load" profile="unconfined" name="/usr/bin/man" pid=364 comm="apparmor_parser"
[   49.317142] kernel: EXT4-fs (xvda1): resizing filesystem from 10485499 to 15728379 blocks
[   49.568767] kernel: EXT4-fs (xvda1): resized filesystem to 15728379
```

  
 Let's investigate our rootkit simulation by running the command `sudo dmesg -T | grep 'exploit'`. The **-T**  option is used to convert the timestamps recorded into a human-readable format.

    Rootkit investigation with dmesg  
```Rootkit investigation with dmesg 
ubuntu@tryhackme:~$ sudo dmesg -T | grep 'custom_kernel'
[Thu Jun 27 12:11:03 2024] custom_kernel: loading out-of-tree module taints kernel.
[Thu Jun 27 12:11:03 2024] custom_kernel: module verification failed: signature and/or required key missing - tainting kernel.
```

  
 **auth.log**  The `/var/log/auth.log` file is your go-to for all authentication-related events on your Linux system. It records every login attempt, whether successful or failed, along with commands executed using elevated privileges and SSH logins. This makes it an invaluable resource for tracking potential security breaches.

 For example, we can simulate an attacker who may be attempting to gain unauthorised access to the system through SSH brute-force attacks by generating SSH authentication logs by running:

    Unauthorised login attempts in auth.log  
```Unauthorised login attempts in auth.log 
ubuntu@tryhackme:~$ ssh root@localhost -p 22
The authenticity of host 'localhost (127.0.0.1)' can't be established.
ECDSA key fingerprint is ------
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'localhost' (ECDSA) to the list of known hosts.
root@localhost: Permission denied (publickey).
```

  
 Then, investigate the authentication logs for any output from the command:

    Unauthorised login attempts in auth.log  
```Unauthorised login attempts in auth.log 
ubuntu@tryhackme:~$ sudo tail -f /var/log/auth.log
Jun 27 08:55:45 tryhackme sshd[70808]: Connection closed by authenticating user root 127.0.0.1 port 43086 [preauth]
Jun 27 08:56:10 tryhackme sudo:   ubuntu : TTY=pts/0 ; PWD=/home/ubuntu ; USER=root ; COMMAND=/usr/bin/tail -f /var/log/auth.log
Jun 27 08:56:10 tryhackme sudo: pam_unix(sudo:session): session opened for user root by ubuntu(uid=0)
```

  
 It is also important to monitor successful login attempts, especially those occurring outside normal business hours or from unusual IP addresses, by running `grep 'Accepted password' /var/log/auth.log` to filter these entries.

    Successful login attempts in auth.log  
```Successful login attempts in auth.log 
ubuntu@tryhackme:~$ grep 'Accepted password' /var/log/auth.log
May 31 11:17:00 server sshd[2009]: Accepted password for root from 192.168.1.50 port 22 ssh2
```

  
 Additionally, tracking commands executed with elevated privileges can provide insights into potential malicious activities. By running `grep 'sudo' /var/log/auth.log`, you can review all commands run with **sudo** , giving you a clear view of who has performed critical system operations.

    Sudo commands in auth.log  
```Sudo commands in auth.log 
ubuntu@tryhackme:~$ grep 'sudo' /var/log/auth.log
Jun 18 07:51:00 tryhackme sudo:   ubuntu : TTY=pts/0 ; PWD=/home/ubuntu ; USER=root ; COMMAND=/usr/bin/dmesg
Jun 18 07:51:00 tryhackme sudo: pam_unix(sudo:session): session opened for user root by ubuntu(uid=0)
Jun 18 07:51:00 tryhackme sudo: pam_unix(sudo:session): session closed for user root
Jun 18 07:54:53 tryhackme sudo:   ubuntu : TTY=pts/0 ; PWD=/home/ubuntu ; USER=root ; COMMAND=/usr/bin/nano /var/log/auth.log
Jun 18 07:54:53 tryhackme sudo: pam_unix(sudo:session): session opened for user root by ubuntu(uid=0)
Jun 18 07:55:23 tryhackme sudo: pam_unix(sudo:session): session closed for user root
```

  
 **syslog**  The `/var/log/syslog` file serves as a catch-all for various system messages, making it a central point for understanding system-wide events. This log captures everything from cron job executions to kernel activities, providing a comprehensive view of your system's health and activities.

 For instance, we can look at cron job executions in syslog by searching for entries containing '**CRON** '. This can help you verify that scheduled tasks are running as expected and identify any suspicious or unauthorised cron jobs.

    Cron job executions in syslog  
```Cron job executions in syslog 
ubuntu@tryhackme:~$ grep 'CRON' /var/log/syslog
Jun 18 00:09:01 tryhackme CRON[18304]: (root) CMD (  [ -x /usr/lib/php/sessionclean ] && if [ ! -d /run/systemd/system ]; then /usr/lib/php/sessionclean; fi)
Jun 18 00:09:01 tryhackme CRON[18305]: (root) CMD (   test -x /etc/cron.daily/popularity-contest && /etc/cron.daily/popularity-contest --crond)
Jun 18 00:17:01 tryhackme CRON[18358]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Jun 18 00:39:01 tryhackme CRON[18367]: (root) CMD (  [ -x /usr/lib/php/sessionclean ] && if [ ! -d /run/systemd/system ]; then /usr/lib/php/sessionclean; fi)
Jun 18 01:09:01 tryhackme CRON[18424]: (root) CMD (  [ -x /usr/lib/php/sessionclean ] && if [ ! -d /run/systemd/system ]; then /usr/lib/php/sessionclean; fi)
Jun 18 01:17:01 tryhackme CRON[18476]: (root) CMD (   cd / && run-parts --report /etc/cron.hourly)
Jun 18 01:39:01 tryhackme CRON[18486]: (root) CMD (  [ -x /usr/lib/php/sessionclean ] && if [ ! -d /run/systemd/system ]; then /usr/lib/php/sessionclean; fi)
```

  
 Kernel-related messages can also be viewed via syslog. These entries can indicate hardware issues or potential attacks targeting the kernel. By running `grep 'kernel' /var/log/syslog`, you can sift through these messages and pinpoint problems that might otherwise go unnoticed.

    Kernel messages in syslog  
```Kernel messages in syslog 
ubuntu@tryhackme:~$ grep 'kernel' /var/log/syslog
May 31 12:00:10 server kernel: [10000.123456] EXT4-fs error (device sda1): ext4_find_entry:1446: inode #524289: comm apache2: reading directory lblock 0
```

  
 **btmp and wtmp**  The `/var/log/btmp` file logs failed login attempts, while the `/var/log/wtmp` records every login and logout activity. We can be assured that these files are critical in identifying potential brute-force attacks and tracking unauthorised access, similar to the `/var/log/auth.log` file.

    Assessing login attempts in wtmp  
```Assessing login attempts in wtmp 
ubuntu@tryhackme:~$ sudo last -f /var/log/wtmp
ubuntu   pts/3        10.110.7.185      Thu Jun 27 11:50 - 15:04  (03:13)
ubuntu   pts/2        10.110.7.185      Thu Jun 27 11:50 - 15:05  (03:15)
ubuntu   pts/1        10.110.7.185      Thu Jun 27 10:36 - 13:28  (02:52)
ubuntu   pts/0        10.110.7.185      Thu Jun 27 10:34 - 13:28  (02:53)
reboot   system boot  5.15.0-1053-aws  Thu Jun 27 10:33   still running
reboot   system boot  5.15.0-1053-aws  Sun Jun 23 16:34   still running
```

### **Answer the questions below**

**Question:** Which log file can be used to record failed login attempts only?

*Answer:* 

     btmp

---

## Task 4 | User Logging With Syslog

User space logging involves capturing and analysing log messages generated by applications, services, and user activities. The syslog system is a standard for message logging on Linux systems, facilitating the centralised collection and management of log messages from various sources. This guide will cover syslog’s components, its configuration, and a step-by-step process for analysing syslog entries to identify system events and anomalies.

 Overview of Syslog Syslog has evolved over time, with different daemon versions being used:

 
1. **syslogd:**  The original daemon with basic logging capabilities.
2. **syslog-ng:**  An enhanced version that provided more features such as content-based filtering, TCP transport, and complex configuration options.
3. **rsyslog:**  The most recent syslog daemon with high performance, modularity and support for TLS encryption, database storage, and message modification.

 Syslog consists of three main components:

 
1. **Syslog daemon** : The `rsyslogd` daemon (or `syslogd` in older systems) handles logging and routing messages.
2. **Configuration file** : The `/etc/rsyslog.conf` file (or `/etc/syslog.conf`) defines rules for logging, including log file locations, filtering, and message forwarding.
3. **Log files** : The actual logs are stored in the `/var/log` directory.

 Syslog Configuration The syslog default configuration file, `/etc/rsyslog.d/50-default.conf`, controls how messages are logged. Here’s an example configuration snippet:

    Syslog configuration snippet  
```Syslog configuration snippet 
# Default rules for rsyslog.
#
#         For more information see rsyslog.conf(5) and /etc/rsyslog.conf

#
# First some standard log files.  Log by facility.
#
#Save authentication logs
auth,authpriv.*                 /var/log/auth.log

*.*;auth,authpriv.none          -/var/log/syslog

# Log cron jobs separately
cron.*                         /var/log/cron.log

#daemon.*                       -/var/log/daemon.log
# Log all kernel messages to /var/log/kern.log

kern.*                          -/var/log/kern.log
#lpr.*                          -/var/log/lpr.log
mail.*                          -/var/log/mail.log
#user.*                         -/var/log/user.log
```

 
 Additionally, it is important to understand the architecture used for logging systems. The main components of the architecture are:

 
- **Originator** : This is also known as the *syslog client*  and is responsible for sending the syslog messages over the network or to the required application.
- **Relay** : This is used to forward messages over the network. A relay can modify the messages to enrich them, such as when used in Logstash.
- **Collector** : This is also known as the *syslog server*  and is used to store, visualise, and retrieve logs from different applications.

 Furthermore, according to [RFC 5424](https://www.rfc-editor.org/info/rfc5424), the syslog message format comprises three parts:

 
1. **PRI:**  This part details the message priority value, a combination of facility and severity levels. It appears at the beginning of the message.
2. **Header:**  Composed of several fields, including:
3. - **TIMESTAMP:**  The time the message was generated.
- **HOSTNAME:**  The name of the machine that generated the log.
- **APP-NAME:**  The name of the application responsible for the message.
- **PROCID:**  The process ID.
- **MSGID:**  A unique identifier for the message.
4. **MSG:**  This part details the actual information about the event recorded.

 
 Syslog Severity and Facilities Levels Syslog messages have associated severity levels and facilities that determine the program or part of the host that produced the logs. As you may notice, the severity levels used within a Linux system are the same whether on kernel or user logging:

 **Severity levels** : Indicate the severity of the message.

   Value Severity Keyword Description     0 Emergency emerg System is unusable   1 Alert alert Immediate action needed   2 Critical crit Critical conditions   3 Error err Error conditions   4 Warning warning Warning conditions   5 Notice notice Normal but significant   6 Informational info Informational messages   7 Debug debug Debug-level messages    **Facilities** : Indicate the source of the message. There are 24 different syslog facilities that can be described below:

    Numerical Code Keyword Facility Name     0 kern Kernel messages   1 user User-level messages   2 mail Mail system   3 daemon System daemons   4 auth Security/authentication messages   5 syslog Internal syslog messages   6 lpr Line printer subsystem   7 news Network news subsystem   8 uucp UUCP subsystem   9 cron Cron subsystems   10 authpriv Security messages   11 ftp FTP daemon   12 ntp NTP subsystem   13 security Security log audit   14 console Console log alerts   15 solaris-cron Scheduling logs   16-23 local0 to local7 Locally used facilities    The local facilities are used if a third party wants to issue a log.

### **Answer the questions below**

**Question:** What severity level keyword is used to indicate immediate action is needed in a syslog message?

*Answer:* 

     alert

**Question:** What facility code is used for cron jobs?

*Answer:* 

     9

---

## Task 5 | Journalctl

The `journal` and `journalctl` tools provide a powerful logging system for modern Linux distributions, capturing log messages from the kernel, system services, and user applications. This guide will explain how to use these tools to monitor system activities, identify potential security incidents, and investigate anomalies.

 Understanding the Journal The `journal` is a binary logging system used by systemd-based distributions. Unlike traditional text-based log files, the journal provides structured, indexed logs, allowing for efficient querying and filtering. This makes it easier to search and analyse logs, especially for security investigations.

 Typically, journal logs are volatile and would be erased on the next system restart. This can be changed within its configuration file `/etc/systemd/journald.conf` by setting the **Storage**  parameter to **persistent**  and restarting the systemd journal daemon for the setting to take effect.

 Using Journalctl `journalctl` is the command-line tool used to interact with the systemd journal. It allows you to view, filter, and analyse log messages efficiently.

 To view logs, simply type the following command. It will reveal all logs in reverse chronological order.

    Running journalctl  
```Running journalctl 
ubuntu@tryhackme:~$ sudo journalctl
-- Logs begin at Wed 2023-09-06 07:57:36 UTC, end at Tue 2024-06-11 08:17:01 UTC. --
Sep 06 07:57:36 ubuntu kernel: Linux version 5.4.0-1029-aws (buildd@lcy01-amd64-022) (gcc version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04)) #30-Ubuntu SMP Tue Oct 20 10:06:38 UTC 2020 (Ub>
Sep 06 07:57:36 ubuntu kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-5.4.0-1029-aws root=PARTUUID=da63a61e-01 ro console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295 panic=-1
Sep 06 07:57:36 ubuntu kernel: KERNEL supported cpus:
Sep 06 07:57:36 ubuntu kernel:   Intel GenuineIntel
Sep 06 07:57:36 ubuntu kernel:   AMD AuthenticAMD
Sep 06 07:57:36 ubuntu kernel:   Hygon HygonGenuine
Sep 06 07:57:36 ubuntu kernel:   Centaur CentaurHauls
Sep 06 07:57:36 ubuntu kernel:   zhaoxin   Shanghai  
Sep 06 07:57:36 ubuntu kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
Sep 06 07:57:36 ubuntu kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
Sep 06 07:57:36 ubuntu kernel: x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
Sep 06 07:57:36 ubuntu kernel: x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
Sep 06 07:57:36 ubuntu kernel: x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
```

  
 The command supports a plethora of options that filter and format the logs. The common flags worth knowing are listed in the table below:

    Argument Description Example     `-f` Follow the journal and show new entries as they are added. `journalctl -f`   `-k` Show only kernel messages. `journalctl -k`   `-b` Show messages from a specific boot. `journalctl -b -1`   `-u` Filter messages by a specific unit. `journalctl -u apache.service`   `-p` Filter messages by priority. `journalctl -p err`   `-S` Show messages since a specific time. `journalctl -S "2021-05-24 14:08:01"`   `-U` Show messages until a specific time. `journalctl -U "2021-05-24 15:46:01"`   `-r` Reverse the output, showing the newest entries first. `journalctl -r`   `-n` Limit the number of shown lines. `journalctl -n 20`   `--no-pager` Do not pipe the output into a pager. `journalctl --no-pager`    We can now use these arguments to conduct an advanced analysis of our logs.

 **Filtering Logs by Date and Time**  We may need to focus our investigations on specific periods, especially when working with servers with significant uptime. From the options we have seen before, we can filter by arbitrary time limits using `--since or -S` and `--until or -U`. Time values can come in various formats, and if we need to filter by absolute time values, we should use the format `YYYY-MM-DD HH:MM:SS`. To view the logs from Feb 6th, 2024, at 15:30 hrs to Feb 17th, 2024, at 15:30 hrs, the command will look as follows:

    Filter by absolute date and time  
```Filter by absolute date and time 
ubuntu@tryhackme:~$ sudo journalctl -S "2024-02-06 15:30:00" -U "2024-02-17 15:29:59"
-- Logs begin at Sun 2022-02-27 13:52:14 UTC, end at Wed 2024-07-03 14:00:50 UTC. --
Feb 16 10:40:52 tryhackme kernel: Linux version 5.4.0-1029-aws (buildd@lcy01-amd64-022) (gcc version 9.3.0 (Ubuntu 9.3.0-17ubuntu1~20.04)) #30-Ubuntu SMP Tue Oct 20 10:06:38 UTC 2020 >
Feb 16 10:40:52 tryhackme kernel: Command line: BOOT_IMAGE=/boot/vmlinuz-5.4.0-1029-aws root=PARTUUID=da63a61e-01 ro console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295 panic=-1
Feb 16 10:40:52 tryhackme kernel: KERNEL supported cpus:
Feb 16 10:40:52 tryhackme kernel:   Intel GenuineIntel
Feb 16 10:40:52 tryhackme kernel:   AMD AuthenticAMD
Feb 16 10:40:52 tryhackme kernel:   Hygon HygonGenuine
Feb 16 10:40:52 tryhackme kernel:   Centaur CentaurHauls
Feb 16 10:40:52 tryhackme kernel:   zhaoxin   Shanghai  
Feb 16 10:40:52 tryhackme kernel: x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
Feb 16 10:40:52 tryhackme kernel: x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
Feb 16 10:40:52 tryhackme kernel: x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
Feb 16 10:40:52 tryhackme kernel: x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
Feb 16 10:40:52 tryhackme kernel: x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
Feb 16 10:40:52 tryhackme kernel: BIOS-provided physical RAM map:
Feb 16 10:40:52 tryhackme kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
Feb 16 10:40:52 tryhackme kernel: BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
Feb 16 10:40:52 tryhackme kernel: BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
Feb 16 10:40:52 tryhackme kernel: BIOS-e820: [mem 0x0000000000100000-0x000000007dfe9fff] usable
Feb 16 10:40:52 tryhackme kernel: BIOS-e820: [mem 0x000000007dfea000-0x000000007fffffff] reserved
Feb 16 10:40:52 tryhackme kernel: BIOS-e820: [mem 0x00000000e0000000-0x00000000e03fffff] reserved
```

  
 It is worth noting that defaults will be applied if any of the format’s components are omitted. For example, if no date is provided, the current date will be used, and if the time component is not specified, *00:00:00*  as midnight will be used.

 Accompanying absolute values, the journal can understand relative values and shortcuts. We can use terms such as *“**today** ”, “**yesterday** ”, “**now** ”* , or “**2 hours ago** ” to retrieve a set of logs.

 If we want to check logs from 2 hours ago, we will run:

    Relative time filtering  
```Relative time filtering 
ubuntu@tryhackme:~$ sudo journalctl -S "2 hours ago"
-- Logs begin at Sun 2022-02-27 13:52:14 UTC, end at Tue 2024-06-18 08:13:29 UTC. --
Jun 18 06:17:01 tryhackme audit[19095]: USER_ACCT pid=19095 uid=0 auid=4294967295 ses=4294967295 subj=unconfined msg='op=PAM:accounting grantors=pam_permit acct="root" exe="/usr/sbin/>
Jun 18 06:17:01 tryhackme audit[19095]: CRED_ACQ pid=19095 uid=0 auid=4294967295 ses=4294967295 subj=unconfined msg='op=PAM:setcred grantors=pam_permit,pam_cap acct="root" exe="/usr/s>
Jun 18 06:17:01 tryhackme audit[19095]: SYSCALL arch=c000003e syscall=1 success=yes exit=1 a0=7 a1=7ffdc3f7da20 a2=1 a3=7f99a2b10371 items=0 ppid=785 pid=19095 auid=0 uid=0 gid=0 euid>
Jun 18 06:17:01 tryhackme audit: PROCTITLE proctitle=2F7573722F7362696E2F43524F4E002D66
Jun 18 06:17:01 tryhackme audit[19095]: USER_START pid=19095 uid=0 auid=0 ses=350 subj=unconfined msg='op=PAM:session_open grantors=pam_loginuid,pam_env,pam_env,pam_permit,pam_umask,p>
Jun 18 06:17:01 tryhackme audit[19095]: CRED_DISP pid=19095 uid=0 auid=0 ses=350 subj=unconfined msg='op=PAM:setcred grantors=pam_permit acct="root" exe="/usr/sbin/cron" hostname=? ad>
Jun 18 06:17:01 tryhackme audit[19095]: USER_END pid=19095 uid=0 auid=0 ses=350 subj=unconfined msg='op=PAM:session_close grantors=pam_loginuid,pam_env,pam_env,pam_permit,pam_umask,pa>
```

  
 **Filtering Logs by Service**  In addition to filtering by time, `journalctl` can filter logs by the services and units running on the host machine. To do so, we use the `-u` option and specify the service needed.

    Service filtering  
```Service filtering 
ubuntu@tryhackme:~$ sudo journalctl -u nginx.service
```

  
 **Filtering Logs by Priority**  Another vital information discussed in previous tasks is the log message priority. With `journalctl`, we can display messages of a specific priority or above using the `-p` option.

 To show entries logged at a critical level or above on the host, that is, *critical, alert, and emergency*  levels, we will run the command:

    Priority filtering  
```Priority filtering 
ubuntu@tryhackme:~$ sudo journalctl -p crit 
	-- Logs begin at Sun 2022-02-27 13:52:14 UTC, end at Tue 2024-06-18 08:16:30 UTC. --
Feb 27 15:14:15 ip-10-10-238-44 gnome-session-binary[38253]: CRITICAL: We failed, but the fail whale is dead. Sorry....
-- Reboot --
Jun 11 19:20:37 tryhackme sudo[77760]: pam_unix(sudo:auth): auth could not identify password for [www-data]
Jun 11 19:20:37 tryhackme sudo[77760]: www-data : command not allowed ; TTY=unknown ; PWD=/var/www/html ; USER=root ; COMMAND=list
Jun 11 19:33:44 tryhackme sudo[77794]: pam_unix(sudo:auth): auth could not identify password for [www-data]
```

### **Answer the questions below**

**Question:** To configure the persistence of journal logs, which parameter has to be modified within the journald configuration file?

*Answer:* 

     Storage

---

## Task 6 | Leveraging Auditd for Security

Auditd is a powerful tool that can be used to enhance the security posture of a Linux system. Auditd is the user-space component of the Linux Auditing System. The Linux Audit Daemon (or auditd for short) collects and writes log files to disk. These logs can include information about file access, user logins, process execution, and more. Auditd provides a flexible and customizable framework for monitoring and analysing security incidents with a granular level of detail. In this task, we will learn about some of the tools and telemetry that auditd provides us.

 Defining Audit Rules We need to define audit rules to set up what activities need to be logged. These rules can be specified in the `/etc/audit/audit.rules` file or added using the `auditctl` utility. Adding the rules to the `/etc/audit/audit.rules` file makes them persistent, while adding using `auditctl` is temporary. For details on the `auditctl` utility, we can read its man page. However, we will explain the relevant functionalities of this utility in this task.

 From a security point of view, we would like to see rules that help us identify potential security events. We discuss some of these events below:

 **Example 1: Tracking Users Using /etc/passwd**  From a security point of view, user activity is one of the most important types of events. Attackers often try to leverage the `/etc/passwd` file to identify users, their permissions, groups, etc. Therefore, tracking any changes to this file is important from a security standpoint. We can do this by creating the following rules:

 `sudo auditctl -w /etc/passwd -p wra -k users`

 This command leverages the auditctl utility to watch (`-w` option) the `/etc/passwd` file for write, read, and change attributes (`-p wra` option), and tag it as 'users' (`-k` or key option). Later in this task, we will discuss and search relevant events using this key. Once we have this rule created for audits, we will have an event added to auditd whenever someone reads, writes, or changes an attribute on the `/etc/passwd` file, providing important telemetry.

 **Example 2: Monitoring Execve Syscalls**  The execve utility is used to execute a program from the caller. Sometimes, this might be helpful to monitor. To use the auditctl utility to monitor execve syscalls, we can create the following rule:

 `sudo auditctl -a always,exit -F arch=b64 -S execve -k execve_syscalls`

 This rule logs every program execution through the execve system call on a 64-bit architecture (arch=b64) and tags these events with the key execve_syscall. The `-a always,exit` flag tells auditctl to always allocate an audit context at the start of the syscall, and fill it with the details of an audit event at the exit of the syscall.

 Reviewing Audit Logs So far, we have learned how to set up rules to create auditd events. Now, we will learn how we can query and parse them. Audit logs are stored in the `/var/log/audit/audit.log` file. We can query these logs using the `ausearch` utility. We can check its man page to learn about the `ausearch` utility. However, we will explain the relevant usage of this utility in this task.

 Using `ausearch` to query audit logs is simple. Following the example we mentioned earlier, we can query audit logs by matching the key we assigned while creating the rule. Therefore, to search for the `users` key, which we created to track changes to `/etc/passwd` file, we can use:

 `sudo ausearch -k users`

 Similarly, to view events matching the `execve_syscalls` key, we can use:

 `sudo ausearch -k execve_syscalls`

 The below terminal window shows an example output of `ausearch` for a rule named tests-changes, which monitors changes to a file named `tests.sh`:

    Auditd report  
```Auditd report 
ubuntu@tryhackme:~$ sudo ausearch -k tests-changes
----
time->Wed Jun 12 22:23:12 2024
type=PROCTITLE msg=audit(1718230992.098:90): proctitle=617564697463746C002D77002F7661722F7777772F68746D6C2F74657374732E7368002D70007761002D6B0074657374732D6368616E676573
type=SYSCALL msg=audit(1718230992.098:90): arch=c000003e syscall=44 success=yes exit=1092 a0=4 a1=7ffd779c1470 a2=444 a3=0 items=0 ppid=6050 pid=6051 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=2 comm="auditctl" exe="/usr/sbin/auditctl" subj=unconfined key=(null)
type=CONFIG_CHANGE msg=audit(1718230992.098:90): auid=1000 ses=2 subj=unconfined op=add_rule key="tests-changes" list=4 res=1
----
time->Wed Jun 12 22:33:22 2024
type=PROCTITLE msg=audit(1718231602.640:256): proctitle=76696D002F7661722F7777772F68746D6C2F74657374732E7368
type=PATH msg=audit(1718231602.640:256): item=0 name="/var/www/html/tests.sh" inode=1024384 dev=ca:01 mode=0100755 ouid=33 ogid=33 rdev=00:00 nametype=NORMAL cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
type=CWD msg=audit(1718231602.640:256): cwd="/home/ubuntu"
type=SYSCALL msg=audit(1718231602.640:256): arch=c000003e syscall=188 success=yes exit=0 a0=5615097f1e30 a1=7f75a4bca0b3 a2=561509a1f3c0 a3=1c items=1 ppid=6401 pid=6402 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=2 comm="vim" exe="/usr/bin/vim.basic" subj=unconfined key="tests-changes"
```

   
 Here, we can see two events where the rule has been triggered. The first is related to the creation of the rule, whereas the second is about the time when the file `/var/www/html/tests.sh` has been accessed. The event also provides us with other information, such as the program used to access the file (vim), the current working directory (`/home/ubuntu`), as well as the date and time.

One thing we might note here is that the `proctitle` information here is in hex. We can use the same `ausearch` utility to decode this information as well. We can use the `-i` option for decoding the `proctitle` from hex to ASCII, this time on the serverdir-changes rule, as shown below.

    Auditd search directory changes  
```Auditd search directory changes 
ubuntu@tryhackme:~$ sudo ausearch -i -k serverdir-changes
----
time->Sun Jun 23 21:28:50 2024
type=PROCTITLE msg=audit(1719178130.725:305): proctitle=auditctl -w /var/www/html -p wax -k serverdir-changes
type=SYSCALL msg=audit(1719178130.725:305): arch=c000003e syscall=44 success=yes exit=1088 a0=4 a1=7ffda2ec3d70 a2=440 a3=0 items=0 ppid=15948 pid=15949 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=2 comm="auditctl" exe="/usr/sbin/auditctl" subj=unconfined key=(null)
type=CONFIG_CHANGE msg=audit(1719178130.725:305): auid=1000 ses=2 subj=unconfined op=add_rule key="serverdir-changes" list=4 res=1
----
```

   
 Generating Reports The `aureport` utility provides a summary of audit events. This can be useful for displaying information to third parties and providing information in an easy-to-view manner. We can pipe the output of `ausearch` to the `aureport` utility to generate a report.

 `sudo ausearch -k users | aureport -f user-logs`

 Real-Time Monitoring For real-time monitoring of audit events, `audispd` (Audit Dispatch Daemon) utility can be configured to send audit logs to other systems or to trigger specific actions when certain events occur. An example action can be sending the logs to a SIEM, where we can trigger further rules or playbooks as soon as these logs are generated. Overall, auditd can be a really helpful tool that can help us in real-time monitoring as well as post-incident response activity.

### **Answer the questions below**

**Question:** Which utility is used to search for auditd logs?

*Answer:* 

     ausearch

---

## Task 7 | Examining Auth Logs

Auth logs or authentication logs are crucial for monitoring and analysing user authentication events on a Linux system. These logs provide detailed records of login attempts, both successful and unsuccessful, and can be instrumental in identifying potential security incidents, unauthorized access attempts, and suspicious activities.

 Location and Structure Auth logs are normally stored in the `/var/log/auth.log` file on most Linux distributions. This log file records all authentication-related events, such as SSH logins, sudo attempts, etc. Each record consists of a timestamp, the service generating the log, the relevant user, and a short description of the event.

 Analysing Auth Logs Auth logs can be analysed using standard command-line tools like grep, awk, and tail. Understanding and interpreting these logs can help system administrators and security professionals detect and respond to unauthorized access attempts and other security incidents.

 As already discussed, auth logs are present in the `/var/log` directory in a file named `auth.log`. The auth.log file is a standard text log file and can be viewed using any of the text file parsers present in Linux, like `cat`, `less`, `tail`, etc. For instance, to see the most recent entries in the auth log, we might use the tail utility:

 `sudo tail /var/log/auth.log`

 This command displays the last ten lines of the auth log, giving us a quick overview of recent authentication events. We will see an output similar to the following as a result of running this command.

   Auth log
 
```Auth log 
ubuntu@tryhackme:~$ tail /var/log/auth.log
Jun 19 19:07:12 tryhackme sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Jun 19 19:07:12 tryhackme su: (to root) ubuntu on pts/0
Jun 19 19:07:12 tryhackme su: pam_unix(su:session): session opened for user root by (uid=0)
Jun 19 19:07:23 tryhackme su: pam_unix(su:session): session closed for user root
Jun 19 19:07:23 tryhackme sudo: pam_unix(sudo:session): session closed for user root
Jun 19 19:07:33 tryhackme sudo:   ubuntu : TTY=pts/0 ; PWD=/home/ubuntu ; USER=root ; COMMAND=/usr/bin/vim /etc/hosts
Jun 19 19:07:33 tryhackme sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
Jun 19 19:07:39 tryhackme sudo: pam_unix(sudo:session): session closed for user root
Jun 19 19:07:48 tryhackme sudo:   ubuntu : TTY=pts/0 ; PWD=/home/ubuntu ; USER=root ; COMMAND=/usr/bin/tail /var/log/auth.log
Jun 19 19:07:48 tryhackme sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
```

   
 Logs are rolled over after a set size is reached, and only the latest logs are present in the auth.log file. In such cases, the historical logs are stored in archived formats in files such as auth.log.1, auth.log.2.gz and so on. To search among such historical logs, we can use auth.log* instead of auth.log to use grep or other text parsers for more accurate historical results.

 Filtering Auth Logs Since auth logs can be parsed using any of the text parsing utilities in Linux, we can use simple text filtering techniques to filter the auth logs as well. Filtering auth logs can help narrow down specific events of interest, such as failed login attempts or sudo command executions. Let's go through some common scenarios and practice how to filter them:

 Failure or Success of Login Attempts To find all failed login attempts, we can use `grep` to search for "failure":

 `sudo grep -i "failure" /var/log/auth.log`

 As is evident, this command returns all entries where a login attempt was unsuccessful, providing details about the user and the source of the attempt.

 Similarly, to filter for sessions opened for a user, search for "session opened":

 `sudo grep -i "session opened" /var/log/auth.log`

 As an example, this is how the result for searching for failed logins will look like:

   Failed logins
 
```Failed logins 
ubuntu@tryhackme:~$ /var/log$ sudo grep -i "failure" /var/log/auth.log*
/var/log/auth.log.1:Jun  9 14:01:54 tryhackme polkit-agent-helper-1[51951]: pam_unix(polkit-1:auth): authentication failure; logname= uid=1000 euid=0 tty= ruser=ubuntu rhost=  user=ubuntu
/var/log/auth.log.1:Jun 10 10:54:26 tryhackme polkit-agent-helper-1[65186]: pam_unix(polkit-1:auth): authentication failure; logname= uid=1000 euid=0 tty= ruser=ubuntu rhost=  user=ubuntu
/var/log/auth.log.1:Jun 10 10:54:35 tryhackme polkit-agent-helper-1[65191]: pam_unix(polkit-1:auth): authentication failure; logname= uid=1000 euid=0 tty= ruser=ubuntu rhost=  user=ubuntu
/var/log/auth.log.1:Jun 11 19:33:33 tryhackme su: pam_unix(su-l:auth): authentication failure; logname= uid=33 euid=0 tty= ruser=www-data rhost=  user=root
/var/log/auth.log.1:Jun 11 19:34:01 tryhackme su: pam_unix(su-l:auth): authentication failure; logname= uid=33 euid=0 tty= ruser=www-data rhost=  user=root
```

   
 To further tweak the results, we can change the logging levels to provide us with more or less information, as discussed previously in this room.

 **Sudo Command Executions**  To track the use of the sudo command, we can again use `grep` to search for "sudo":

 `sudo grep "sudo" /var/log/auth.log`

 This filter shows when users invoked sudo, which commands were executed, and whether the attempts were successful or failed.

 An example execution of the above search will look like the following:

    Sudo usage
 
```Sudo usage 
ubuntu@tryhackme:~$ grep "sudo" /var/log/auth.log*
/var/log/auth.log.1:Jun 12 22:51:08 tryhackme sudo:   ubuntu : TTY=pts/0 ; PWD=/home/ubuntu ; USER=root ; COMMAND=/usr/bin/systemctl disable tests.timer
/var/log/auth.log.1:Jun 12 22:51:08 tryhackme sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
/var/log/auth.log.1:Jun 12 22:51:09 tryhackme sudo: pam_unix(sudo:session): session closed for user root
/var/log/auth.log.1:Jun 12 22:51:18 tryhackme sudo:   ubuntu : TTY=pts/0 ; PWD=/home/ubuntu ; USER=root ; COMMAND=/usr/bin/systemctl daemon-reload
/var/log/auth.log.1:Jun 12 22:51:18 tryhackme sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
/var/log/auth.log.1:Jun 12 22:51:18 tryhackme sudo: pam_unix(sudo:session): session closed for user root
/var/log/auth.log.1:Jun 12 22:51:29 tryhackme sudo:   ubuntu : TTY=pts/0 ; PWD=/home/ubuntu ; USER=root ; COMMAND=/usr/bin/journalctl -u tests.service -f
/var/log/auth.log.1:Jun 12 22:51:29 tryhackme sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
/var/log/auth.log.1:Jun 12 22:51:39 tryhackme sudo: pam_unix(sudo:session): session closed for user root
/var/log/auth.log.1:Jun 19 18:36:05 tryhackme sudo:   ubuntu : TTY=unknown ; PWD=/home/ubuntu ; USER=root ; COMMAND=/usr/bin/python3 -m websockify 80 localhost:5901 -D
/var/log/auth.log.1:Jun 19 18:36:05 tryhackme sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
/var/log/auth.log.1:Jun 19 18:36:06 tryhackme sudo:   ubuntu : TTY=unknown ; PWD=/home/ubuntu ; USER=root ; COMMAND=/usr/sbin/runuser -l ubuntu -c vncserver :1 -depth 24 -geometry 1900x1200
/var/log/auth.log.1:Jun 19 18:36:06 tryhackme sudo: pam_unix(sudo:session): session opened for user root by (uid=0)
```

   
 As we can see, the results also show us the log file from which the logs have been sourced, the date, time, and the command that was run.

 **Time-Based Filters**  Filtering by date and time can be particularly useful for more focused investigations. It allows us to isolate events within a specific timeframe, which can be particularly helpful when investigating an incident that occurred in a specific time period.

 **Filter by Date and Time**  To filter auth logs by a specific date and time range, we can use awk:

 `sudo awk '/2024-06-04 15:30:00/,/2024-06-05 15:29:59/' /var/log/auth.log`

 This command displays log entries between June 4, 2024, 15:30:00 and June 5, 2024, 15:29:59.

 **Relative Time Filtering**  To filter entries from the last few hours, we can use tail in combination with grep and date:

 `sudo grep "$(date --date='2 hours ago' '+%b %e %H:')" /var/log/auth.log`

 This command filters log entries from the past two hours. We are actually using the Linux `date` utility to identify the current date and time and then extract the time in the format of the abbreviated month (`%b`), day of the month (`%e`), and hour (`%H`). An example execution of this command will look as follows:

    Logs from the last two hours  
```Logs from the last two hours 
ubuntu@tryhackme:~$ grep "$(date --date='2 hours ago' '+%b %e %H:')" /var/log/auth.log*
/var/log/auth.log:Jun 19 18:36:06 tryhackme runuser: pam_unix(runuser-l:session): session opened for user ubuntu by (uid=0)
/var/log/auth.log:Jun 19 18:36:07 tryhackme sudo: pam_unix(sudo:session): session closed for user root
/var/log/auth.log:Jun 19 18:36:07 tryhackme CRON[811]: pam_unix(cron:session): session closed for user ubuntu
/var/log/auth.log:Jun 19 18:36:10 tryhackme runuser: pam_unix(runuser-l:session): session closed for user ubuntu
/var/log/auth.log:Jun 19 18:36:10 tryhackme sudo: pam_unix(sudo:session): session closed for user root
/var/log/auth.log:Jun 19 18:36:10 tryhackme CRON[812]: pam_unix(cron:session): session closed for user ubuntu
/var/log/auth.log:Jun 19 18:36:10 tryhackme sshd[1106]: Server listening on 0.0.0.0 port 22.
/var/log/auth.log:Jun 19 18:36:10 tryhackme sshd[1106]: Server listening on :: port 22.
/var/log/auth.log:Jun 19 18:36:13 tryhackme lightdm: pam_unix(lightdm-greeter:session): session opened for user lightdm by (uid=0)
/var/log/auth.log:Jun 19 18:36:13 tryhackme systemd-logind[612]: New session c1 of user lightdm.
/var/log/auth.log:Jun 19 18:36:13 tryhackme systemd: pam_unix(systemd-user:session): session opened for user lightdm by (uid=0)
/var/log/auth.log:Jun 19 18:36:13 tryhackme lightdm: gkr-pam: gnome-keyring-daemon started properly
/var/log/auth.log:Jun 19 18:36:14 tryhackme gnome-keyring-daemon[1339]: couldn't connect to control socket at: /home/ubuntu/.cache/xdg/keyring/control: Connection refused
```

   
 Auth logs are necessary resources for monitoring user authentication events and identifying potential security breaches. By analysing these logs using tools like awk, grep, and tail, administrators can streamline the process of extracting meaningful information from them and ensure the security of their environment.

### **Answer the questions below**

**Question:** What command can be used to search logs related to a session opened for a user?

*Answer:* 

     sudo grep -i "session opened" /var/log/auth.log

---

## Task 8 | Analysing Application Logs

Application logs are essential for monitoring and troubleshooting Linux applications. These logs are often stored in the `/var/log` directory and contain information about the application, details about their execution, and provide useful information regarding errors.

 Application logs provide information about client requests and server responses for web servers like Apache2. For databases, application logs will include information about database queries and responses. In this task, we'll explore how to manage and analyse application logs using Apache2 as an example.

 Understanding Apache2 Logs Apache2 is a commonly used web server. It produces two types of logs: access logs and error logs.

 
- **Access logs** : Record all requests made to the server, including client IP addresses, request methods, requested URLs, response statuses, and more.
- **Error logs** : Capture error messages generated by the server, such as configuration errors, script errors, and server crashes.

 Logs for Apache2 are generally placed in the `/var/log/apache2` directory. Generally, the `/var/log/apache2` directory contains two files, `/var/log/apache2/access.log` and `/var/log/apache2/error.log`, each containing the respective logs.

 Apache2 logs are typically configured in the main configuration file (`/etc/apache2/apache2.conf`) or in the virtual host configuration files (e.g., `/etc/apache2/sites-available/000-default.conf`).

Viewing Apache2 Logs Apache2 logs are stored in the `/var/log/apache2/` directory by default. To view and analyse these logs, we can use common command-line utilities such as `cat`, `less`, or `tail`.

 We can view the access log by using the tail utility:

 `tail -f /var/log/apache2/access.log*`

 Here is what the access log looks like:

    Apache2 access log  
```Apache2 access log 
ubuntu@tryhackme:~$ tail -f /var/log/apache2/access.log*
10.11.86.7 - - [12/Jun/2024:15:59:15 +0000] "GET /favicon.ico HTTP/1.1" 404 493 "http://10.10.104.189:8080/cmd.php?ip=10.10.225.142&port=5000" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0"
10.11.86.7 - - [12/Jun/2024:16:35:25 +0000] "GET /cmd.php?ip=10.10.225.142&port=5000 HTTP/1.1" 200 205 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0"
10.11.86.7 - - [12/Jun/2024:16:35:15 +0000] "GET /cmd.php?ip=10.10.146.99&port=5000 HTTP/1.1" 200 205 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0"
10.10.24.106 - - [12/Jun/2024:19:28:04 +0000] "GET / HTTP/1.1" 200 484 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.24.106 - - [12/Jun/2024:19:28:04 +0000] "GET /favicon.ico HTTP/1.1" 404 493 "http://10.10.104.189:8080/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.24.106 - - [12/Jun/2024:19:28:28 +0000] "GET /?cmd.php?ip=10.10.24.106&port=5000 HTTP/1.1" 200 484 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.24.106 - - [12/Jun/2024:19:28:34 +0000] "GET /?cmd.php?ip=10.10.24.106&port=5000 HTTP/1.1" 200 484 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.24.106 - - [12/Jun/2024:19:28:40 +0000] "GET /cmd.php?ip=10.10.24.106&port=5000 HTTP/1.1" 200 205 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.110.234 - - [12/Jun/2024:22:05:14 +0000] "GET /cmd.php?ip=10.10.110.234&port=5000 HTTP/1.1" 200 205 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.110.234 - - [12/Jun/2024:22:05:14 +0000] "GET /favicon.ico HTTP/1.1" 404 493 "http://10.10.104.189:8080/cmd.php?ip=10.10.110.234&port=5000" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
```

   
 As can be seen, the access log contains the source IP address, date, time, request information, response code, and the user agent.

 We can also use the tail utility to view the error log:

 `tail -f /var/log/apache2/error.log*`

 Here is what the output will look like:

    Apache error log  
```Apache error log 
ubuntu@tryhackme:~$ tail -f /var/log/apache2/error.log*
[Wed Jun 12 00:00:27.334620 2024] [mpm_prefork:notice] [pid 65787] AH00163: Apache/2.4.41 (Ubuntu) configured -- resuming normal operations
[Wed Jun 12 00:00:27.334650 2024] [core:notice] [pid 65787] AH00094: Command line: '/usr/sbin/apache2'
[Wed Jun 12 16:35:33.419815 2024] [php7:warn] [pid 78542] [client 10.11.86.7:59153] PHP Warning:  fsockopen(): unable to connect to 10.10.146.99:5000 (No route to host) in /var/www/html/cmd.php on line 10
[Wed Jun 12 16:35:33.419915 2024] [php7:warn] [pid 78542] [client 10.11.86.7:59153] PHP Warning:  proc_open(): Descriptor item must be either an array or a File-Handle in /var/www/html/cmd.php on line 11
[Wed Jun 12 19:09:37.359208 2024] [mpm_prefork:notice] [pid 65787] AH00169: caught SIGTERM, shutting down
[Wed Jun 12 19:24:51.225795 2024] [mpm_prefork:notice] [pid 817] AH00163: Apache/2.4.41 (Ubuntu) configured -- resuming normal operations
[Wed Jun 12 19:24:51.227391 2024] [core:notice] [pid 817] AH00094: Command line: '/usr/sbin/apache2'
```

   
 Filtering and Analysing Logs When responding to incidents or analysing logs for any other purpose, we often need to find relevant information. This might feel like finding a needle in a haystack unless we know how to filter information. Below, we will follow through with some examples of filtering information from the Apache logs.

 Filtering Using the Grep Utility We can use the grep utility to filter out results from a specific IP address with the following command:

 `grep "10.10.24.106" /var/log/apache2/access.log*`

 The result is shown in the below terminal window.

    Logs from specific IP  
```Logs from specific IP 
ubuntu@tryhackme:~$ grep 10.10.24.106 /var/log/apache2/access.log*
10.10.24.106 - - [12/Jun/2024:19:28:04 +0000] "GET / HTTP/1.1" 200 484 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.24.106 - - [12/Jun/2024:19:28:04 +0000] "GET /favicon.ico HTTP/1.1" 404 493 "http://10.10.104.189:8080/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.24.106 - - [12/Jun/2024:19:28:28 +0000] "GET /?cmd.php?ip=10.10.24.106&port=5000 HTTP/1.1" 200 484 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.24.106 - - [12/Jun/2024:19:28:34 +0000] "GET /?cmd.php?ip=10.10.24.106&port=5000 HTTP/1.1" 200 484 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.24.106 - - [12/Jun/2024:19:28:40 +0000] "GET /cmd.php?ip=10.10.24.106&port=5000 HTTP/1.1" 200 205 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
```

 Similarly, we can use the grep utility to filter out HTTP status codes as well.

 `grep "404" /var/log/apache2/access.log*`

 The output will look something like this:

    Logs for specific response code  
```Logs for specific response code 
ubuntu@tryhackme:~$ grep "404" /var/log/apache2/access.log* 
10.11.86.7 - - [12/Jun/2024:15:59:15 +0000] "GET /favicon.ico HTTP/1.1" 404 493 "http://10.10.104.189:8080/cmd.php?ip=10.10.225.142&port=5000" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:126.0) Gecko/20100101 Firefox/126.0"
10.10.24.106 - - [12/Jun/2024:19:28:04 +0000] "GET /favicon.ico HTTP/1.1" 404 493 "http://10.10.104.189:8080/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
10.10.110.234 - - [12/Jun/2024:22:05:14 +0000] "GET /favicon.ico HTTP/1.1" 404 493 "http://10.10.104.189:8080/cmd.php?ip=10.10.110.234&port=5000" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
```

 The grep utility can also be used to find specific error codes in the error logs.

 `grep "error" /var/log/apache2/error.log*`

 Filtering Using the Awk Utility Using the awk utility, we can do advanced filtering, such as counting the number of requests from a specific IP address. The following command can be used to perform this task.

 `awk '{print $1}' /var/log/apache2/access.log* | sort | uniq -c | sort -nr`

 The output will show us the number of requests each IP address made.

    Requests per IP address  
```Requests per IP address 
ubuntu@tryhackme:~$ awk '{print $1}' /var/log/apache2/access.log* | sort | uniq -c | sort -nr
      5 10.10.24.106
      4 10.11.86.7
      2 10.10.110.234
```

 Similarly, we can use the following command to summarise the HTTP status codes from the access logs.

 `awk '{print $9}' /var/log/apache2/access.log* | sort | uniq -c | sort -nr`

 The output will contain the number of times each HTTP status code was returned by the server.

    Status codes summary  
```Status codes summary 
ubuntu@tryhackme:~$ awk '{print $9}' /var/log/apache2/access.log* | sort | uniq -c | sort -nr
      8 200
      3 404
```

 Similarly, other types of application logs may also be leveraged to provide useful information in a Linux system. Application logs are essential when performing incident response as public-facing applications often prove to be the entry points for attackers. Therefore, application logs can provide us with crucial information related to initial access gained by a threat actor.

### **Answer the questions below**

**Question:** Which folder contains Apache2 logs?

*Answer:* 

     /var/log/apache2

---

## Task 9 | Linux Logs Capstone

Anna is the IR lead for Deer Inc., an organisation that protects wildlife. Various notorious actors have recently attacked the organisation, aiming to disrupt its goals. Although Anna had tried her best to secure the organisation's assets, she discovered a staging development server had been accessible from the Internet. The server was running Linux and had an Apache web server running on it. Being cautious, Anna has isolated the server from the network and is looking for any malicious traces on the server. Can you help Anna identify if the server was compromised, and if so, what malicious actions have been taken so far?

To identify if the server might have been compromised, Anna decided to look at the initial access vector. Since the server had been accessible over the Internet and hosted an Apache web server, this would be the most obvious attack vector.

    Apache2 access log  
```Apache2 access log 
ubuntu@tryhackme:~$ grep "404" /var/log/apache2/access.log* 
[Redacted] - - [23/Jun/2024:21:02:04 +0000] "[redacted] /[redacted].ico HTTP/1.1" 404 493 "http://10.10.133.134:8080/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
[Redacted] - - [23/Jun/2024:21:30:45 +0000] "[redacted] /[redacted].php HTTP/1.1" 404 494 "http://10.10.133.134:8080/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
[Redacted] - - [23/Jun/2024:21:33:14 +0000] "[redacted] /[redacted].php HTTP/1.1" 404 494 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/109.0"
```

   
 We can see some POST attempts here that indicate something suspicious; however, all of these have a 404 response code. On further digging through the access logs, we find a reverse shell. Based on these logs, let's answer the first three questions.

Anna had set up an auditd rule to identify any changes to the `/var/www/html` directory. This rule was named `serverdir-changes`. She could use this rule to determine if any changes occurred during the exploitation.

    Auditd search directory changes  
```Auditd search directory changes 
ubuntu@tryhackme:~$ sudo ausearch -i -k serverdir-changes
----
time->Sun Jun 23 21:28:50 2024
type=PROCTITLE msg=audit(1719178130.725:305): proctitle=auditctl -w /var/www/html -p wax -k serverdir-changes
type=SYSCALL msg=audit(1719178130.725:305): arch=c000003e syscall=44 success=yes exit=1088 a0=4 a1=7ffda2ec3d70 a2=440 a3=0 items=0 ppid=15948 pid=15949 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0 ses=2 comm="auditctl" exe="/usr/sbin/auditctl" subj=unconfined key=(null)
type=CONFIG_CHANGE msg=audit(1719178130.725:305): auid=1000 ses=2 subj=unconfined op=add_rule key="serverdir-changes" list=4 res=1
----
```

   
 Hidden in these logs, we find out that one file was being executed using sudo even before the files were changed. This file could have been modified by injecting malicious code to achieve privilege escalation. Verifying the logs and the file on the disk provided evidence that privilege escalation was achieved.

Once privilege escalation is achieved, the threat actor generally moves to persistence. A service might be used to establish persistence, or a new account might be created. Digging through the different services, Anna found one that might be worth investigating. So, Anna opened the journalctl logs for this service.

    Journalctl logs  
```Journalctl logs 
ubuntu@tryhackme:~$ sudo journalctl -u tests.service 
-- Logs begin at Sun 2022-02-27 13:52:14 UTC, end at Mon 2024-06-24 03:38:32 UTC. --
Jun 23 21:13:19 tryhackme systemd[1]: Started Run Command Script.
Jun 23 21:13:19 tryhackme sudo[15109]:     root : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/var/www/html/[redacted]
Jun 23 21:13:19 tryhackme sudo[15109]: pam_unix(sudo:session): session opened for user root by (uid=0)
Jun 23 21:13:19 tryhackme command.sh[15110]: [INFO] All tests passed
```

   
 This service was linked to the script file we identified previously. Hence, when the script file was compromised, some level of persistence was already achieved. Anna dug deeper in to the journal logs and found that a new user had been created.

The investigation now took a new turn. Anna had to figure out if this newly created account was ever logged in to, so she looked into the auth logs (Since Anna wanted to search all the historical logs, including the ones which had been rotated and zipped, she used the `zgrep` utility instead of the `grep` utility.)

    Auth logs  
```Auth logs 
ubuntu@tryhackme:~$ zgrep -i [redacted] /var/log/auth*
/var/log/auth.log:Jun 23 22:03:25 tryhackme sudo:     root : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/sbin/useradd [redacted]
/var/log/auth.log:Jun 23 22:03:25 tryhackme useradd[16522]: new group: name=[redacted], GID=1001
/var/log/auth.log:Jun 23 22:03:25 tryhackme useradd[16522]: new user: name=[redacted], UID=1001, GID=1001, home=/home/[redacted], shell=/bin/sh, from=none
/var/log/auth.log:Jun 23 22:03:46 tryhackme sudo:     root : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/bin/passwd [redacted]
/var/log/auth.log:Jun 23 22:03:57 tryhackme passwd[16534]: pam_unix(passwd:chauthtok): password changed for [redacted]
/var/log/auth.log:Jun 23 22:04:59 tryhackme sudo:     root : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/sbin/usermod -aG sudo [redacted]
/var/log/auth.log:Jun 23 22:04:59 tryhackme usermod[16540]: add '[redacted]' to group 'sudo'
/var/log/auth.log:Jun 23 22:04:59 tryhackme usermod[16540]: add '[redacted]' to shadow group 'sudo'
```

   
 Anna looked further for any "session opened" events in the auth logs to verify her findings. She had finally reached the logical conclusion of the incident.

After verifying her findings, Anna created a report and sent the server for reimaging. The incident taught important lessons that would help Deer Inc. maintain a better security posture in the future.

### **Answer the questions below**

**Question:** What is the IP address from which the application was exploited?

*Answer:* 

     10.10.190.69

**Question:** What file contains the reverse shell?

*Answer:* 

     cmd.php

**Question:** At which port was the reverse shell running?

*Answer:* 

     5000

**Question:** What is the file name that was being executed with sudo privileges?

*Answer:* 

     tests.sh

**Question:** What is the name of the user created using the service?

*Answer:* 

     attacker

**Question:** Was the new account ever logged in to? y/n

*Answer:* 

     n

---

## Task 10 | Conclusion

That's a wrap for this room. Summing up, we learned about the following types of logs in this room:

- Syslogs and user activity logging
- Journalctl and logging about different services
- Auditd and its use in security
- Auth logs and login activity
- Application logs and the useful information they contain

Finally, we practised responding to an interesting incident by leveraging the different types of logs. Keep an eye out for more interesting content related to Incident Response and Linux investigations.

### **Answer the questions below**

**Question:** Yay! I have completed the room!

*Answer:* 

     No answer needed

---
