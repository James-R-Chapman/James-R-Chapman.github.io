---
layout: post
title: "TShark Challenge II - Directory"
date: 2025-02-08
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Network Security and Traffic Analysis"
identifier: "20250208T000000"
source_id: "680cf20f-ee27-4e92-83ac-ca5d3b67662b"
source_urls: "(https://tryhackme.com/room/tsharkchallengestwo)"
source_path: "SOC Level 1/Network Security and Traffic Analysis/20250208T000000--tshark-challenge-ii-directory__tryhackme.md"
---

{% raw %}


# TShark Challenge II: Directory

# Task 1 | Introduction

Start MachineThis room presents you with a challenge to investigate some traffic data as a part of the SOC team. Let's start working with TShark to analyse the captured traffic. We recommend completing the [TShark: The Basics](https://tryhackme.com/room/tsharkthebasics) and [TShark: CLI Wireshark Features](https://tryhackme.com/room/tsharkcliwiresharkfeatures) rooms first, which will teach you how to use the tool in depth.

Start the VM by pressing the green **Start Machine**  button in this task. The machine will start in split view, so you don't need SSH or RDP. In case the machine does not appear, you can click the blue **Show Split View**  button located at the top of this room.

**NOTE:** Exercise files contain real examples. **DO NOT**  interact with them outside of the given VM. Direct interaction with samples and their contents (files, domains, and IP addresses) outside the given VM can pose security threats to your machine. Answer the questions belowRead the task above and start the attached VM.
Correct Answer

### **Answer the questions below**

**Question:** Read the task above and start the attached VM.

*Answer:* 

     No answer needed

---

# Task 2 | Case: Directory Curiosity!

**An alert has been triggered:**  "A user came across a poor file index, and their curiosity led to problems".

The case was assigned to you. Inspect the provided **directory-curiosity.pcap**  located in `~/Desktop/exercise-files` and retrieve the artefacts to confirm that this alert is a true positive.

**Your tools:** TShark, [VirusTotal](https://www.virustotal.com/).

Answer the questions belowInvestigate the DNS queries.
Investigate the domains by using VirusTotal.
According to VirusTotal, there is a domain marked as malicious/suspicious.

What is the name of the malicious/suspicious domain?

Enter your answer in a defanged format.

Correct AnswerHintWhat is the total number of HTTP requests sent to the malicious domain?

Correct AnswerHintWhat is the IP address associated with the malicious domain?

Enter your answer in a defanged format.

Correct AnswerWhat is the server info of the suspicious domain?

Correct AnswerFollow the "first TCP stream" in "ASCII".
Investigate the output carefully.

What is the number of listed files?

Correct AnswerWhat is the filename of the first file?

Enter your answer in a defanged format.

Correct AnswerExport all HTTP traffic objects.
What is the name of the downloaded executable file?

Enter your answer in a defanged format.

Correct AnswerWhat is the SHA256 value of the malicious file?

Correct AnswerSearch the SHA256 value of the file on VirtusTotal.

What is the "PEiD packer" value?

Correct AnswerSearch the SHA256 value of the file on VirtusTotal.

What does the "Lastline Sandbox" flag this as?

Submit

### **Answer the questions below**

**Question:** Investigate the DNS queries.Investigate the domains by using VirusTotal.According to VirusTotal, there is a domain marked as malicious/suspicious.What is the name of the malicious/suspicious domain?Enter your answer in a defanged format.

*Answer:* 

     jx2-bavuong[.]com

**Question:** What is the total number of HTTP requests sent to the malicious domain?

*Answer:* 

     14

**Question:** What is the IP address associated with the malicious domain?Enter your answer in a defanged format.

*Answer:* 

     141[.]164[.]41[.]174

**Question:** What is the server info of the suspicious domain?

*Answer:* 

     Apache/2.2.11 (Win32) DAV/2 mod_ssl/2.2.11 OpenSSL/0.9.8i PHP/5.2.9

**Question:** Follow the "first TCP stream" in "ASCII".Investigate the output carefully.What is the number of listed files?

*Answer:* 

     3

**Question:** What is the filename of the first file?Enter your answer in a defanged format.

*Answer:* 

     123[.]php

**Question:** Export all HTTP traffic objects.What is the name of the downloaded executable file?Enter your answer in a defanged format.

*Answer:* 

     vlauto[.]exe

**Question:** What is the SHA256 value of the malicious file?

*Answer:* 

     b4851333efaf399889456f78eac0fd532e9d8791b23a86a19402c1164aed20de

**Question:** Search the SHA256 value of the file on VirtusTotal.What is the "PEiD packer" value?

*Answer:* 

     .NET executable

**Question:** Search the SHA256 value of the file on VirtusTotal.What does the "Lastline Sandbox" flag this as?

*Answer:* 

     MALWARE TROJAN

---
{% endraw %}
