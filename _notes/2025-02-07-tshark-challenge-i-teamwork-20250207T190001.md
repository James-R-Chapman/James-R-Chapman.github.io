---
layout: post
title: "TShark Challenge I - Teamwork"
date: 2025-02-07
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Network Security and Traffic Analysis"
identifier: "20250207T190001"
source_id: "5a92f90b-a2b4-4bad-958f-82f714876a58"
source_urls: "(https://tryhackme.com/room/tsharkchallengesone)"
source_path: "SOC Level 1/Network Security and Traffic Analysis/20250207T190001--tshark-challenge-i-teamwork__tryhackme.md"
---

{% raw %}


# TShark Challenge I: Teamwork

# Contents

# Task 1 | Introduction

Start MachineThis room presents you with a challenge to investigate some traffic data as a part of the SOC team. Let's start working with TShark to analyse the captured traffic. We recommend completing the [TShark: The Basics](https://tryhackme.com/room/tsharkthebasics) and [TShark: CLI Wireshark Features](https://tryhackme.com/room/tsharkcliwiresharkfeatures) rooms first, which will teach you how to use the tool in depth.

Start the VM by pressing the green **Start Machine** button attached to this task. The machine will start in split view, so you don't need SSH or RDP. In case the machine does not appear, you can click the blue **Show Split View** button located at the top of this room.

**NOTE:** Exercise files contain real examples. **DO NOT** interact with them outside of the given VM. Direct interaction with samples and their contents (files, domains, and IP addresses) outside the given VM can pose security threats to your machine. Answer the questions belowRead the task above and start the attached VM.
Correct Answer

### **Answer the questions below**

**Question:** Read the task above and start the attached VM.

_Answer:_

     No answer needed

---

# Task 2 | Case: Teamwork

An alert has been triggered: "The threat research team discovered a suspicious domain that could be a potential threat to the organisation."

The case was assigned to you. Inspect the provided **teamwork.pcap** located in `~/Desktop/exercise-files` and create artefacts for detection tooling.

**Your tools:** TShark, [VirusTotal](https://www.virustotal.com/gui/home/upload).

Answer the questions belowInvestigate the contacted domains.
Investigate the domains by using VirusTotal.
According to VirusTotal, there is a domain marked as malicious/suspicious.

What is the full URL of the malicious/suspicious domain address?

Enter your answer in defanged format.

Correct AnswerHintWhen was the URL of the malicious/suspicious domain address first submitted to VirusTotal?

Correct AnswerWhich known service was the domain trying to impersonate?

Correct AnswerWhat is the IP address of the malicious domain?

Enter your answer in defanged format.

Correct AnswerWhat is the email address that was used?

Enter your answer in defanged format. (**format:** aaa[at]bbb[.]ccc)

Correct AnswerCongratulations! You have finished the first challenge room, but there is one more ticket before calling it out a day!

- [TShark Challenge II: Directory](https://tryhackme.com/r/room/tsharkchallengestwo)

Complete

### **Answer the questions below**

**Question:** Investigate the contacted domains.Investigate the domains by using VirusTotal.According to VirusTotal, there is a domain marked as malicious/suspicious.What is the full URL of the malicious/suspicious domain address?Enter your answer in defanged format.

_Answer:_

     hxxp[://]www[.]paypal[.]com4uswebappsresetaccountrecovery[.]timeseaways[.]com/

**Question:** When was the URL of the malicious/suspicious domain address first submitted to VirusTotal?

_Answer:_

     2017-04-17 22:52:53 UTC

**Question:** Which known service was the domain trying to impersonate?

_Answer:_

     PayPal

**Question:** What is the IP address of the malicious domain?Enter your answer in defanged format.

_Answer:_

     184[.]154[.]127[.]226

**Question:** What is the email address that was used?Enter your answer in defanged format. (format: aaa[at]bbb[.]ccc)

_Answer:_

     johnny5alive[at]gmail[.]com

**Question:** Congratulations! You have finished the first challenge room, but there is one more ticket before calling it out a day!TShark Challenge II: Directory

_Answer:_

     No answer needed

---
{% endraw %}
