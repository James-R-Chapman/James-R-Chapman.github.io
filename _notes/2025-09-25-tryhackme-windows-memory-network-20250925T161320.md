---
layout: post
title: "tryhackme-windows-memory-network"
date: 2025-09-25
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Advanced Endpoint Investigations/Memory Analysis"
source_id: "3d9926d5-1095-4d9d-82c2-0d376a313611"
source_urls: "(https://tryhackme.com/room/windowsmemoryandnetwork)"
source_path: "Advanced Endpoint Investigations/Memory Analysis/20250925T161320--tryhackme-windows-memory-network__tryhackme.md"
---

{% raw %}


# TryHackMe | Windows Memory & Network

## Task 1 | Introduction

This room continues the memory investigation from the previous analysis. This is the last room out of 3, and we will be focusing on how network activity and post-exploitation behavior are captured in RAM. We’ll examine artifacts from a live attack involving advance payloads like Meterpreter, suspicious child processes, and unusual outbound connections. All analyses will be performed using Volatility 3 and hands-on techniques applied directly to the memory dump.

 We’ll walk through real indicators tied to remote shells, persistence via startup folder abuse, and malware attempting outbound communications. Users will use memory structures, plugin outputs, and process inspection to track network behavior step by step.

 Learning Objectives 
- Identify network connections in a memory dump.
- Identify suspicious ports and remote endpoints.
- Link connections to processes.
- Detect reverse shells and memory injections in a memory dump.
- Trace PowerShell and C2 activity in memory.

 Prerequisites 
- [Volatility](https://tryhackme.com/room/volatility)
- [Yara](https://tryhackme.com/room/yara)
- [Windows Memory & Processes](https://tryhackme.com/room/windowsmemoryandprocs)
- [Windows Memory & User Activity](https://tryhackme.com/room/windowsmemoryanduseractivity)

### **Answer the questions below**

**Question:** Click to continue to the room.

*Answer:* 

     No answer needed

---

## Task 2 | Scenario Information

Scenario You are part of the incident response team handling an incident at TryHatMe - a company that exclusively sells hats online. You are tasked with analyzing a full memory dump of a potentially compromised Windows host. Before you, another analyst had already taken a full memory dump and gathered all the necessary information from the TryHatMe IT support team. You are a bit nervous since this is your first case, but don't worry; a senior analyst will guide you.

 Information Incident THM-0001 
- On May 5th, 2025, at 07:30 CET, TryHatMe initiated its incident response plan and escalated the incident to us. After an initial triage, our team found a Windows host that was potentially compromised. The details of the host are as follows:
 
- Hostname: WIN-001
- OS: Windows 1022H 10.0.19045
- At 07:45 CET, our analyst Steve Stevenson took a full memory dump of the Windows host and made a hash to ensure its integrity. The memory dump details are: 
- Name: `THM-WIN-001_071528_07052025.dmp`
- MD5-hash: `78535fc49ab54fed57919255709ae650`

 Company Information TryHatMe **Network Map**

 **![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/66264cef7bba67a6bbbe7179/room-content/66264cef7bba67a6bbbe7179-1748384039516.png)**

### **Answer the questions below**

**Question:** I went through the case details and am ready to find out more.

*Answer:* 

     No answer needed

---

## Task 3 | Environment & Setup

Start MachineBefore moving forward, start the VM by clicking the **Start Machine**  button on the right.

 It will take around 2 minutes to load properly. The VM will be accessible on the right side of the split screen. If the VM is not visible, use the blue **Show Split View**  button at the top of the page.

 The details for the assignment are:

 
- File Name: **THM-WIN-001_071528_07052025.mem**
- File MD5 Hash: **78535fc49ab54fed57919255709ae650**
- File Location: `/home/ubuntu`

 To run volatility, you can use the `vol` command in the VM. For example: `vol -h` will display the help menu for volatility.

### **Answer the questions below**

**Question:** Click here if you were able to start your environment.

*Answer:* 

     No answer needed

---

## Task 4 | Analyzing Active Connections

In the previous room, we focused on identifying user activity within memory. Now, we shift our attention to network connections established by the suspected malicious actor. We'll begin by searching for artifacts in memory that reveal what connections were made and what kind of network activity took place during the intrusion.

 Scanning Memory for Network Evidence Let's start by scanning the memory dump with the **Windows.netscan**  plugin. This plugin inspects kernel memory pools for evidence of **TCP** and **UDP**  socket objects, regardless of whether the connections are still active. It's beneficial in cases where the process we are investigating may have terminated or cleaned up connections.

To inspect the network connections, volatility locates the [EPROCESS ](https://learn.microsoft.com/en-us/windows-hardware/drivers/kernel/eprocess#eprocess)structure to extract PIDs and map these to active **TCP ENDPOINT** or **UDP ENDPOINT** objects (undocumented) found in memory. This approach works even if a connection has already been closed, making it more useful than **netstat**  on a live system.

 When analysing connections to look for supicious traffic, we should be aware of the following:

 
- Unusual port activity or outbound connections to unfamiliar addresses
- Communication with external IPs on non-standard ports
- Local processes holding multiple sockets
- PIDs tied to previously identified suspicious binaries

 Let's look for the patterns mentioned above. We'll start by running the following command `vol -f THM-WIN-001_071528_07052025.mem windows.netscan > netscan.txt`, which will save the output in the `netscan.txt` file as shown below. We can then inspect it using the `cat` command or any text visualizer.

 **Note** : *This command can take some time to finish, depending on CPU usage and the size of the memory dump. In case you do not want to wait, you can access the same output in the already existing file `netscan-saved.txt`. There are also some other commands that have been pre-saved to save time if needed.*

   Example Terminal 
```Example Terminal 
user@tryhackme~$ vol -f THM-WIN-001_071528_07052025.mem windows.netscan >  netscan.txt
user@tryhackme$cat netscan.txt

Offset	Proto	LocalAddr	LocalPort	ForeignAddr	ForeignPort	State	PID	Owner	Created
[REDACTED]
0x990b28ae34c0	UDPv4	169.254.106.169	138	*	0		4	System	2025-05-07 07:08:58.000000 UTC
0x990b28bf3230	TCPv4	169.254.106.169	139	0.0.0.0	0	LISTENING	4	System	2025-05-07 07:08:58.000000 UTC
0x990b28bf3650	TCPv4	0.0.0.0	4443	0.0.0.0	0	LISTENING	10084	windows-update	2025-05-07 07:13:05.000000 UTC
[REDACTED]
0x990b299a81f0	UDPv4	127.0.0.1	1900	*	0		9496	svchost.exe	2025-05-07 07:09:11.000000 UTC
0x990b29ab8010	TCPv4	192.168.1.192	[REDACTED]	192.168.0.30	22	ESTABLISHED	6984	powershell.exe	2025-05-07 07:15:15.000000 UTC
0x990b29ade8a0	TCPv4	192.168.1.192	4443	10.0.0.129	47982	ESTABLISHED	10084	windows-update	2025-05-07 07:13:35.000000 UTC
0x990b2a32ca20	TCPv4	192.168.1.192	[REDACTED]	10.0.0.129	8081	ESTABLISHED	10032	updater.exe	[REDACTED] UTC
0x990b2a630a20	TCPv6	::1	55986	::1	445	CLOSED	4	System	2025-05-07 07:14:06.000000 UTC
0x990b2a824770	UDPv6	fe80::185b:1837:f9f7:bffd	49595	*	0		9496	svchost.exe	2025-05-07 07:09:11.000000 UTC
0x990b2a824900	UDPv6	fe80::185b:1837:f9f7:bffd	1900	*	0		9496	svchost.exe	2025-05-07 07:09:11.000000 UTC
0x990b2a824db0	UDPv6	::1	1900	*	0		9496	svchost.exe	2025-05-07 07:09:11.000000 UTC
[REDACTED]
```

   We can observe in the output above that some connections are marked as **ESTABLISHED** . We can notice that PID **10032** (**updater.exe** ) is connected to IP **10.0.0.129 on port 8081** . That is an external network and suggests it may be the attacker's infrastructure. Another connection of interest is from PID **6984** (**powershell.exe** ) reaching out to **192.168.0.30:22** , suggesting lateral movement. Also, as we know from previous analysis, the binary **windows-update.exe**  is also part of the chain of execution we are investigating and was placed for persistence purposes in the `C:\Users\operator\AppData\Roaming\Microsoft\Windows\StartMenu\Programs\Startup\` directory. It is listening on port **4443** , which makes sense to be set up like that since it seems to be the one listening for instructions. Let’s now move on to confirm this and spot which active listening ports are.

   Example Terminal 
```Example Terminal 
user@tryhackme~$ cat netscan.txt |grep LISTENING
0x990b236b3310	TCPv4	0.0.0.0	445	0.0.0.0	0	LISTENING	4	System	2025-05-07 07:08:50.000000 UTC
[REDACTED]
0x990b27ffee90	TCPv4	0.0.0.0	3389	0.0.0.0	0	LISTENING	364	svchost.exe	2025-05-07 07:08:49.000000 UTC
0x990b27ffee90	TCPv6	::	3389	::	0	LISTENING	364	svchost.exe	2025-05-07 07:08:49.000000 UTC
0x990b28bf3230	TCPv4	169.254.106.169	139	0.0.0.0	0	LISTENING	4	System	2025-05-07 07:08:58.000000 UTC
0x990b28bf3650	TCPv4	0.0.0.0	4443	0.0.0.0	0	LISTENING	10084	windows-update	2025-05-07 07:13:05.000000 UTC
0x990b28de7e10	TCPv4	0.0.0.0	49671	0.0.0.0	0	LISTENING	3020	svchost.exe	2025-05-07 07:08:51.000000 UTC
0x990b28de80d0	TCPv4	0.0.0.0	49671	0.0.0.0	0	LISTENING	3020	svchost.exe	2025-05-07 07:08:51.000000 UTC
0x990b28de80d0	TCPv6	::	49671	::	0	LISTENING	3020	svchost.exe	2025-05-07 07:08:51.000000 UTC
0x990b28de8390	TCPv4	0.0.0.0	5040	0.0.0.0	0	LISTENING	6124	svchost.exe	2025-05-07 07:08:59.000000 UTC
0x990b28de8910	TCPv4	192.168.1.192	139	0.0.0.0	0	LISTENING	4	System	2025-05-07 07:08:51.000000 UTC
```

   We can observe several system processes like **svchost.exe**  and**lsass.exe**  listening on [common Windows ports](http://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/service-overview-and-network-port-requirements). However, we can also confirm that the only non-standard process listening is **windows-update.exe (PID 10084)** , which is listening on port **4443** .

 This seems to be highly irregular. We already know that the process had established a connection with the potential attacker and is accepting inbound connections. This could be for **file staging** ,**secondary payloads** , or as we already confirmed, for **persistence** .

 **Note** :*As a sanity check, try also running **windows.netstat** . This plugin relies on live system structures instead of scanning memory, so it may return fewer results, but it is useful to compare what's still **active**  and also to check the connection's order by timestamp.*

 Great, at this point, we’ve confirmed:

 
- **updater.exe**  (PID **10032** ) was in an active session with a known attacker IP using port **8081** .
- **windows-update.exe**  (PID **10084** ) had its own established session and was listening on port **4443** .
- **powershell.exe**  (PID **6984** ) connected to **192.168.0.30:22** , likely the next internal target.

 These findings help confirm suspicions of remote control via **C2** , plus lateral movement activity. In the next section, we'll explore more into this in order to confirm our findings.

### **Answer the questions below**

**Question:** What is the remote source port number used in the connection between 192.168.1.192 and 10.0.0.129:8081?

*Answer:* 

     55985

**Question:** Which internal IP address received a connection on port 22 from the compromised host?

*Answer:* 

     192.168.0.30

**Question:** What is the exact timestamp when the connection from the IP addresses in question 1 was established?

*Answer:* 

     2025-05-07 07:13:56.000000

**Question:** What is the local port used by the system to initiate the SSH connection to 192.168.0.30?

*Answer:* 

     55987

**Question:** What is the protocol used in the connection from 192.168.1.192:55985 to 10.0.0.129:8081?

*Answer:* 

     TCPv4

**Question:** What is the order in which the potential malicious processes established outbound connections?

*Answer:* 

     windows-update.exe, updater.exe, powershell.exe

---

## Task 5 | Investigating Remote Access and C2 Communications

In the previous task, we discovered that **updater.exe**  (PID **10032** ) was communicating with the external IP **10.0.0.129**  over port **8081** . This activity was flagged as highly suspicious, especially considering the context: a process spawned from a malicious Word document chain, and now reaching out to what appears to be attacker infrastructure.

 Let’s take a closer look at this binary. The goal now is to determine whether this process was being used to maintain remote access. through a Meterpreter session or another **C2** framework, and whether any evidence of post-exploitation activity can be uncovered directly in memory.

 Confirming Process Relationships We already confirmed in the previous room the relationship between this process and their PIDs, but if we need to gather the information again, we can use the commands listed below to identify them.

 `vol -f THM-WIN-001_071528_07052025.mem windows.pslist > pslist.txt`
`vol -f THM-WIN-001_071528_07052025.mem windows.cmdline > cmdline.txt`

 This matches the chain we had already suspected: A **Word** document opened by the user, followed by the execution of three suspicious binaries in sequence, **pddfupdater.exe** , **windows-update.exe** , leading to **updater.exe** . On the other hand, from the **cmdline** plugin output that we already have (we can execute the command to get the output again by typing: `vol -f THM-WIN-001_071528_07052025.mem windows.cmdline > cmdline.txt`), we can try to determine how it was invoked. Let's inspect with the following command to filter by process ID `cat cmdline.txt | grep 10032`

   Example Terminal 
```Example Terminal 
user@tryhackme~$ cat cmdline.txt | grep 10032
10032	updater.exe	"C:\Users\operator\Downloads\updater.exe"
```

   As we can observe, no arguments have been passed. This is common for binaries that serve as droppers or loaders, especially those that use in-memory injection or reflective loading techniques, something Meterpreter is known for. Let's try to confirm our suspicions.

 Scanning for Code Injection: Detecting Meterpreter We’ll now inspect whether any foreign code was injected into updater.exe. Volatility’s windows.malfind plugin is useful for detecting memory regions with suspicious execution permissions (like [PAGE_EXECUTE_READWRITE](https://learn.microsoft.com/en-us/windows/win32/memory/memory-protection-constants#:~:text=2003%20with%20SP1.-,PAGE_EXECUTE_READWRITE,-0x40)), or shellcode that was injected at runtime using the command `vol -f THM-WIN-001_071528_07052025.mem windows.malfind --pid 10032 > malfind_10032.txt`. Then, let's analyze the output using cat, as displayed below.

   Example Terminal 
```Example Terminal 
user@tryhackme~$ cat malfind_10032.txt 
Volatility 3 Framework 2.26.0

PID	Process	Start VPN	End VPN	Tag	Protection	CommitCharge	PrivateMemory	File output	Notes	Hexdump	Disasm

10032	updater.exe	0x1a0000	0x1d1fff	VadS	PAGE_EXECUTE_READWRITE	50	1	Disabled	MZ header	
4d 5a 41 52 55 48 89 e5 48 83 ec 20 48 83 e4 f0 MZARUH..H.. H...
e8 00 00 00 00 5b 48 81 c3 37 5e 00 00 ff d3 48 .....[H..7^....H
81 c3 b4 b1 02 00 48 89 3b 49 89 d8 6a 04 5a ff ......H.;I..j.Z.
d0 00 00 00 00 00 00 00 00 00 00 00 f8 00 00 00 ................    
[REDACTED]:    pop    r10[REDACTED]:    push   r10[REDACTED]:    push   rbp[REDACTED]:    mov    rbp, rsp[REDACTED]:    sub    rsp, 0x20[REDACTED]:    and    rsp, 0xfffffffffffffff0[REDACTED]:    call   0x1a0015[REDACTED]:    pop    rbx[REDACTED]:    add    rbx, 0x5e37[REDACTED]:    call   rbx[REDACTED]:    add    rbx, 0x2b1b4[REDACTED]:    mov    qword ptr [rbx], rdi[REDACTED]:    mov    r8, rbx[REDACTED]:    push   4[REDACTED]:    pop    rdx[REDACTED]:    call   rax
```

   If we spot a memory region marked with suspicious flags and containing what looks like a shellcode or executable, this is a strong indication of runtime injection. Meterpreter, in particular, is known to use reflective DLL injection, which shows up this way. From the above, we can observe an injection or traces of process injection since we can observe the characters MZ, which are usually the first bytes of a [PE ](https://learn.microsoft.com/en-us/windows/win32/debug/pe-format)executable, meaning that **updater.exe**  injected this into memory.

**Note** : *We can dump the memory for the process **updater.exe**  **PID**  (**10032** ) for further inspection with the following command `vol -f THM-WIN-001_071528_07052025.mem windows.memmap --pid 10032 --dump`. This should create a file called **pid.10032.dmp**  in our current directory, which contains the information on the process in memory.*

 Confirming Meterpreter with YARA [YARA](https://yara.readthedocs.io/) is often used to search for known patterns or signatures inside malicious files. It allows us to define readable string or byte patterns that can help identify specific tools or payloads, like Meterpreter, based on their presence in memory or binaries.

 Since we suspect that **updater.exe**  may be running a Meterpreter session, we can validate this by applying a **YARA** rule that searches for known Meterpreter-related patterns within the process memory. We'll use a rule based on common Meterpreter patterns as shown below.

 
```
rule meterpreter_reverse_tcp_shellcode {
    meta:
        description = "Metasploit reverse_tcp shellcode"
    strings:
        $s1 = { fce8 8?00 0000 60 }
        $s2 = { 648b ??30 }
        $s3 = { 4c77 2607 }
        $s4 = "ws2_"
        $s5 = { 2980 6b00 }
        $s6 = { ea0f dfe0 }
        $s7 = { 99a5 7461 }
    condition:
        5 of them
}
```

 The rule below is designed to detect Metasploit's **reverse_tcp** shellcode by matching a combination of known byte patterns and strings commonly found in such payloads. It triggers if at least **5**  of the listed patterns are present. Let's execute the command `vol -f THM-WIN-001_071528_07052025.mem windows.vadyarascan --pid 10032 --yara-file meterpreter.yar` to see if we can have match. This will scan only the memory regions allocated to the specified process, increasing the accuracy of detection. If the condition is met, it strongly suggests the presence of Meterpreter shellcode.

   Example Terminal 
```Example Terminal 
user@tryhackme~$ vol -f THM-WIN-001_071528_07052025.mem windows.vadyarascan --pid 10032 --yara-file meterpreter.yar
Volatility 3 Framework 2.26.0
Progress:  100.00		PDB scanning finished                        
Offset	PID	Rule	Component	Value

0x140004104	10032	meterpreter_reverse_tcp_shellcode	$s3	
4c 77 26 07                                     Lw&.            
0x1400040d9	10032	meterpreter_reverse_tcp_shellcode	$s4	
77 73 32 5f                                     ws2_            
0x140004115	10032	meterpreter_reverse_tcp_shellcode	$s5	
29 80 6b 00                                     ).k.            
0x140004135	10032	meterpreter_reverse_tcp_shellcode	$s6	
ea 0f df e0                                     ....            
0x14000414a	10032	meterpreter_reverse_tcp_shellcode	$s7	
99 a5 74 61                                     ..ta
```

   As we can observe from the output above, there are five matches within the process **10032** (**updater.exe** ), confirming the presence of a Meterpreter session.

 By combining live connection details from **windows.netscan** , process ancestry and launch context via **pslist** and **cmdline** , memory injection indicators from **malfind** , signature-based confirmation through **yarascan** , and dump analysis using **memdump** and **strings** , we've confirmed that **updater.exe**  isn't just suspicious by behavior. It was injected with malicious code and was almost certainly acting as a reverse shell handler (**Meterpreter** ), closing the loop on the attacker’s foothold.

 In the next task, we’ll shift focus to possible exfiltration attempts or further staging activity using HTTP requests or services found in memory.

### **Answer the questions below**

**Question:** What Volatility plugin can be used to correlate memory regions showing suspicious execution permissions with processes, helping to detect Meterpreter-like behavior?

*Answer:* 

     windows.malfind

**Question:** What is the virtual memory address space of the suspicious injected region in updater.exe? Answer format: 0xABCDEF

*Answer:* 

     0x1a0000

**Question:** What is the first 2-bytes signature found in the shellcode that was extracted from updater.exe using windows.malfind? Answer format: In hex.

*Answer:* 

     4d5a

---

## Task 6 | Post-Exploitation Communication

In the previous step, we discovered that updater.exe had been injected with shellcode matching known Meterpreter patterns. That connection reached out to the attacker's infrastructure at **10.0.0.129:8081** . In this task, we shift focus to what happened after that foothold was established.

 Looking for Post-Exploitation Traffic Now that the attacker had a reverse shell running, it’s reasonable to expect secondary connections for lateral movement, data staging, or command retrieval. We already observed two suspicious indicators from the **windows.netscan**  output:

 
- powershell.exe (**PID 6984** ) established a connection to **192.168.0.30:22** , which appears to be a lateral move within the internal network.
- windows-update.exe **(PID 10084** ), previously seen listening on port **4443** , may have also generated outbound traffic.

 Let’s confirm if any of these processes performed external communication.

 We'll begin by confirming again that the network session is tied to **powershell.exe** . Re-analyzing the output of the command `vol -f THM-WIN-001_071528_07052025.mem windows.netscan`, which we previously saved in netscan.txt. We’ll search for any connection entries associated with the **powershell.exe**  process using grep, as shown below.

   Example Terminal 
```Example Terminal 
user@tryhackme~$ cat netscan.txt |grep powershell
0x990b29ab8010	TCPv4	192.168.1.192	55987	192.168.0.30	22	ESTABLISHED	6984	powershell.exe	2025-05-07 07:15:15.000000 UTC                                    ..ta
```

   The **PID**  of the process **powershell.exe**  can be observed above (**6984** ). Let's dump that process and investigate further with the command `vol -f THM-WIN-001_071528_07052025.mem windows.memmap --pid 6984 --dump`

 After that, we could look for interesting strings, but since we are already familiar with the connection we spotted, we can search for the IP we observed the connection made to, **192.168.0.30** . We can achieve that with the command strings, as shown below.

   Example Terminal 
```Example Terminal 
user@tryhackme~$ strings pid.6984.dmp|grep "192.168.0.30"
$client=New-Object Net.Sockets.TcpClient; $client.Connect("192.168.0.30",22); while($client.Connected){Start-Sleep 1}
$client=New-Object Net.Sockets.TcpClient; $client.Connect("192.168.0.30",22); while($client.Connected){Start-Sleep 1}
```

   As we can observe, we had two matches from our search, revealing the command used to connect to the host at **192.168.0.30**  (server network) that was used to connect to and from the previous analysis. We know it's involved in the attack chain and was installed for persistence.

 Let’s dump the memory space of the process that initiates this chain: **windows-update.exe**  (**PID 10084** ) to examine whether HTTP content was stored in memory, perhaps from a C2 address or data exfiltration, for that, we'll use the command `vol -f THM-WIN-001_071528_07052025.mem windows.memmap --pid 10084 --dump`

 After creating the dump, we can search for the known domain `attacker.thm` by using the `strings` command in combination with `grep`, as shown below.

   Example Terminal 
```Example Terminal 
user@tryhackme~$ strings pid.10084.dmp |grep "attacker.thm"
attacker.thm
http://attacker.thm/updater.exe
external-attacker.thm
Failed to connect to external-attacker.thm:25
Connected to external-attacker.thm:25 successfully.[REDACTED]
```

   We can see that, in addition to the domain `attacker.thm`, a subdomain `external.attacker.thm` also appears in the process memory. There's also a possible connection over port **25** (**SMTP** ), based on the extracted strings.

 Next, we’ll search for the term **POST** to check if any **HTTP** requests were made, possibly as part of a data exfiltration attempt. We'll use the**`-C 8`**  option with `grep `to display **8** lines before and after each match for better context.

   Example Terminal 
```Example Terminal 
ubuntu@tryhackme:~$ strings pid.10084.dmp |grep "POST" -C 8
bad cast
attacker.thm
C:\Windows\System32\drivers\etc\hosts
[!] Failed to open hosts file.
Exfiltrator
[!] InternetOpenA failed.
[!] InternetConnectA failed.
Content-Type: application/x-www-form-urlencoded
POST
[!] HttpOpenRequestA failed.
[!] HttpSendRequestA failed.
[+] Hosts file exfiltrated to http://
[*] Executing hello()
```

   As we can observe, the process tried a POST connection, but it seemed to fail. We've confirmed that **powershell.exe**  established a live connection to another host, and windows-update.exe attempted to send an **HTTP POST**  request to the attacker's domain. These behaviors point to continued activity beyond initial access, suggesting both processes were involved in the post-exploitation stage of the attack.

### **Answer the questions below**

**Question:** Which local port was used by powershell.exe to connect to the internal host 192.168.0.30?

*Answer:* 

     55987

**Question:** What was the remote IP address targeted by windows-update.exe during its HTTP POST attempt?

*Answer:* 

     10.0.0.129

**Question:** What port was windows-update.exe listening on, based on the netscan output?

*Answer:* 

     4443

---

## Task 7 | Putting it All Together

Across these three rooms, we reconstructed a full attack chain that started with a phishing-style document and ended with a Meterpreter shell and lateral movement. Each stage was uncovered by correlating memory artifacts using **Volatility 3** . Our starting point was a malicious macro-enabled Word document (**.docm** ) opened by **WINWORD.EXE** . Using plugins like **pslist** , **cmdline** , and **memmap** , we observed the macro spawning **pdfupdater.exe** , a first-stage dropper that quickly launched**windows-update.exe.**

 From there,**windows-update.exe**  launched **updater.exe** . Using **netscan** , we identified an active outbound connection from **updater.exe**  to an external IP address (**10.0.0.129:8081** ). Following this, we observed post-exploitation activity. **cmd.exe**  and **powershell.exe**  were both launched under the same session as the earlier processes, and **PowerShell** established a connection to an internal host (**192.168.0.30** ) over port 22. This behavior strongly indicates lateral movement. We can summarize the attack chain below.

 
1. **Initial Access** : The user opened a macro-enabled .docm document with **WINWORD.EXE** , which loaded a .**docm** template file containing a VBA macro. The macro downloaded and executed pdfupdater.exe.
2. **Execution & Persistence** : **pdfupdater.exe**  launched **windows-update.exe** , a malicious binary placed in the user’s Startup folder for **persistence** . This process spawned**updater.exe** .
3. **Remote Access (C2)** : **updater.exe**  established an outbound connection to **10.0.0.129:8081** , where reflective DLL injection was confirmed using malfind, and **Meterpreter**  shellcode was detected via vadyarascan.
4. **Post-Exploitation** : Following the **C2** session, **cmd.exe**  and **powershell.exe**  were launched. The latter connected to **192.168.0.30:22** , suggesting lateral movement to a second internal host. The **PowerShell** payload was recovered from memory.
5. Exfiltration Attempts: Memory strings in**windows-update.exe**  showed attempts to **POST** data to **attacker.thm**  and **external-attacker.thm** , although the exfiltration failed.

 MITRE ATT&CK Technique Mapping Below is a table summarizing each discovery, the corresponding Volatility plugin used to uncover it, and the mapped MITRE ATT&CK technique.

      Tactic Technique Details Volatility Plugin & Command(s) Used     Initial Access T1566.001 - Spearphishing Attachment Malicious `.docm` file opened in Word `cmdline`, `handles`, `userassist`   Execution T1059.005 - Visual Basic Macro downloaded and executed a payload `dumpfiles`, `olevba`   Persistence T1547.001 - Startup Folder `windows-update.exe` persisted via Startup folder `cmdline`, `handles`, `netscan`   Command & Control T1055.002 - Reflective DLL Injection Meterpreter shellcode injected into `updater.exe` `malfind`, `memmap`, `yarascan`   Command & Control T1071.001 - Web Protocols HTTP-based communication with attacker C2 `strings`, `dumpfiles`   Command & Control T1043 - Commonly Used Port Outbound to port 8081 (C2) and listening on 4443 `netscan`   Execution T1059.001 - PowerShell PowerShell used for command execution and remote connection `pslist`, `netscan`, `strings`   Lateral Movement T1021.004 - SSH PowerShell connected to `192.168.0.30:22` internally `netscan`, `strings`, `memmap`   Exfiltration T1041 - Exfiltration Over C2 Channel Attempted HTTP POST with content-type: application/x-www-form-urlencoded `strings`, `grep`   Defense Evasion T1140 - Deobfuscate/Decode Files or Info Malicious macro downloaded payload with no arguments to evade detection `cmdline`, `olevba`

### **Answer the questions below**

**Question:** What IP did updater.exe connect to for the reverse shell?

*Answer:* 

     10.0.0.129

**Question:** Which folder is used for persistence by the attack we analyzed within this memory dump?

*Answer:* 

     C:\Users\operator\AppData\Roaming\Microsoft\Windows\StartMenu\Programs\Startup\

**Question:** Which MITRE technique matches the reflective DLL injection used by updater.exe?

*Answer:* 

     T1055.002

**Question:** What is the domain that was discovered within the windows-update.exe file?

*Answer:* 

     external-attacker.thm

---

## Task 8 | Conclusion

In this room, we extended our forensic investigation by focusing on network activity and post-exploitation behavior captured in memory. We traced connections to attacker infrastructure, confirmed malicious payloads, and uncovered evidence of lateral movement, all from a single memory snapshot.

 What we practiced:

 
- Identifying active and closed network connections
- Correlating connections with processes.
- Detecting memory injection.
- Dumping and analyzing process memory.
- Matching Meterpreter shellcode.
- Investigating PowerShell-based lateral movement and HTTP from memory.

 Let's continue our memory analysis journey in the next room of this module.

### **Answer the questions below**

**Question:** Click to finish the room.

*Answer:* 

     No answer needed

---
{% endraw %}
