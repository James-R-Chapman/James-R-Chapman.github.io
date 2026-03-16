---
layout: post
title: "TryHackMe  - Web Attack Forensics - Drone Alone"
date: 2025-12-24
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Learn/Web Attack Forensics - Drone Alone"
identifier: "20251231T213144"
source_id: "357b8475-8d0f-4827-92fc-6875a40e46f5"
source_urls: "(https://tryhackme.com/room/webattackforensics-aoc2025-b4t7c1d5f8)"
source_path: "20251231T213144--tryhackme-web-attack-forensics-drone-alone__tryhackme.md"
---

{% raw %}


# TryHackMe | Web Attack Forensics - Drone Alone

## Task 1 | Introduction

The Story

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5f04259cf9bf5b57aed2c476-1763538536985.png)

TBFC’s drone scheduler web UI is getting strange, long HTTP requests containing Base64 chunks. Splunk raises an alert: “Apache spawned an unusual process.” On some endpoints, these requests cause the web server to execute shell code, which is obfuscated and hidden within the Base64 payloads. For this room, your job as the Blue Teamer is to triage the incident, identify compromised hosts, extract and decode the payloads and determine the scope.

You’ll use Splunk to pivot between web (Apache) logs and host-level (Sysmon) telemetry.

Follow the investigation steps below; each corresponds to a Splunk query and investigation goal.

Learning Objectives

- Detect and analyze malicious web activity through Apache access and error logs
- Investigate OS-level attacker actions using Sysmon data
- Identify and decode suspicious or obfuscated attacker payloads
- Reconstruct the full attack chain using Splunk for Blue Team investigation

Connecting to the Machine Before moving forward, please review the questions on the connection card shown below:

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1761550866227.png)

Start your target VM by clicking the **Start Machine** button below. The machine will need about 3 minutes to fully boot. Additionally, start your AttackBox by clicking the **Start AttackBox** button below. The AttackBox will start in split view. In case you can not see it, click the **Show Split View** button at the top of the page.

Set up your virtual environmentTo successfully complete this room, you'll need to set up your virtual environment. This involves starting both your AttackBox (if you're not using your VPN) and Target Machines, ensuring you're equipped with the necessary tools and access to tackle the challenges ahead.

![Image 3](https://tryhackme.com/static/svg/attack-box-to-target-machine.e30b7a02.svg)

Attacker machine

![Image 4](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:Connected via Attackbox Show Split ViewTarget machine

![Image 5](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:OffStart Machine

### **Answer the questions below**

**Question:**

_Answer:_

     No answer needed

---

## Task 2 | Web Attack Forensics

Logging into Splunk After you have started the AttackBox and the target machine in the previous task, allow the system around 3 minutes to fully boot, then use Firefox on the AttackBox to access the Splunk dashboard at `http://MACHINE_IP:8000` using the credentials below.

Credentials

To access Splunk dashboard

Username Blue Password Pass1234 IP address MACHINE_IP Connection via HTTP http://MACHINE_IP:8000 The Splunk login page should look similar to the screenshot shown below.

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5f04259cf9bf5b57aed2c476-1761554754985.png)

After logging in successfully, you will be taken to the Search Page as shown in the screenshot below.

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5f04259cf9bf5b57aed2c476-1761554754946.png)

Make sure to adjust the Splunk time range to include the time of the events (e.g., "Last 7 days" or "All time"). If the default range is too narrow, you may see "_No results found."_

A Blue Teamer would explore various attack angles via Splunk. In this task, we will follow elf Log McBlue, who uses his Splunk magic to unravel the attack path.

Detect Suspicious Web Commands In the first step, let’s search for HTTP requests that might show malicious activity. The query below searches the **web access logs** for any HTTP requests that include signs of command execution attempts, such as `cmd.exe`, `PowerShell`, or `Invoke-Expression`. This query helps identify possible **Command Injection attacks** , where the evil attacker tries to execute system commands through a vulnerable CGI script (`hello.bat`).

`index=windows_apache_access (cmd.exe OR powershell OR "powershell.exe" OR "Invoke-Expression") | table _time host clientip uri_path uri_query status`

![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5f04259cf9bf5b57aed2c476-1761554754850.png)

At this step, we are primarily interested in base64-encoded strings, which may reveal various types of activities. Once you spot encoded PowerShell commands, decode them using [base64decode.org](https://www.base64decode.org/) or your favourite base64 decoder to understand what the attacker was trying to do. Based on the results we received, let’s copy the encoded PowerShell string `VABoAGkAcwAgAGkAcwAgAG4AbwB3ACAATQBpAG4AZQAhACAATQBVAEEASABBAEEASABBAEEA` and paste it into [https://www.base64decode.org/](https://www.base64decode.org/) upper field, then click on decode as shown in the screenshot below.

![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5f04259cf9bf5b57aed2c476-1761554754871.png)

Looking for Server-Side Errors or Command Execution in Apache Error Logs In this stage, we will focus on inspecting web server error logs, as this would help us uncover any malicious activity. We will use the following query:

`index=windows_apache_error ("cmd.exe" OR "powershell" OR "Internal Server Error")`

This query inspects the **Apache error logs** for signs of execution attempts or internal failures caused by malicious requests. As you can tell, we are searching for error messages with particular terms such as `cmd.exe` and `powershell`.

Please make sure you select `View: Raw` from the dropdown menu above the `Event` display field.

![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5f04259cf9bf5b57aed2c476-1761554754890.png)

If a request like `/cgi-bin/hello.bat?cmd=powershell` triggers a 500 “Internal Server Error,” it often means the attacker’s input was processed by the server but failed during execution, a key sign of exploitation attempts.

Checking these results helps confirm whether the attack **reached the backend** or remained blocked at the web layer.

Trace Suspicious Process Creation From Apache Let’s explore Sysmon for other malicious executable files that the web server might have spawned. We will do that using the following Splunk query:

`index=windows_sysmon ParentImage="*httpd.exe"`

This query focuses on **process relationships** from Sysmon logs, specifically when the **parent process is Apache** (`httpd.exe`).

Select `View: Table` on the dropdown menu above the `Event` display field.

![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5f04259cf9bf5b57aed2c476-1761554754951.png)

Typically, Apache should only spawn worker threads, not system processes like `cmd.exe` or `powershell.exe`.

If results show child processes such as:

`ParentImage = C:\Apache24\bin\httpd.exe`

`Image        = C:\Windows\System32\cmd.exe`

It indicates a successful **command injection** where Apache executed a system command.

The finding above is one of the strongest indicators that the web attack penetrated the operating system.

Confirm Attacker Enumeration Activity In this step, we aim to discover what specific programs we found from previous queries do. Let’s use the following query.

`index=windows_sysmon *cmd.exe* *whoami*`

This query looks for **command execution logs** where `cmd.exe` ran the command `whoami`.

Attackers often use the `whoami` command immediately after gaining code execution to determine which user account their malicious process is running as.

Finding these events confirms the attacker’s **post-exploitation reconnaissance** , showing that the injected command was executed on the host.

![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5f04259cf9bf5b57aed2c476-1761554755110.png)

Identify Base64-Encoded PowerShell Payloads In this final step, we will work to find all successfully encoded commands. To search for encoded strings, we can use the following Splunk query:

`index=windows_sysmon Image="*powershell.exe" (CommandLine="*enc*" OR CommandLine="*-EncodedCommand*" OR CommandLine="*Base64*")`

This query detects PowerShell commands containing -EncodedCommand or Base64 text, a common technique attackers use to **hide their real commands** .

If your defences are correctly configured, this query should return **no results** , meaning the encoded payload (such as the “Muahahaha” message) never ran.

If results appear, you can decode the Base64 command to inspect the attacker’s true intent.

![Image 13](https://tryhackme-images.s3.amazonaws.com/user-uploads/5f04259cf9bf5b57aed2c476/room-content/5f04259cf9bf5b57aed2c476-1761554755100.png)

### **Answer the questions below**

**Question:**

_Answer:_

     whoami.exe

**Question:**

_Answer:_

     PowerShell.exe

---

{% endraw %}
