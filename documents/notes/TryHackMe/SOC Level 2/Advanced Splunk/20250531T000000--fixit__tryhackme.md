---
title:      "Fixit"
date:       2025-05-31T00:00:00-04:00
tags:       ["tryhackme"]
identifier: "20250531T000000"
Hubs: "TryHackMe/SOC Level 2/Advanced Splunk"
urls: (https://tryhackme.com/room/fixit)
id: d603af30-df44-4efa-a272-ba9d7ec912b8
---

# Fixit

## Task 1 | FIXIT Challenge

Start MachineIn this challenge room, you will act as John, who has recently cleared his third screening interview for the SOC-L2 position at MSSP Cybertees Ltd, and a final challenge is ready to test your knowledge, where you will be required to apply the knowledge to FIX the problems in Splunk.
You are presented with a Splunk Instance and the network logs being ingested from an unknown device.

 

 Pre-requisites
This challenge is based on the knowledge covered in the following rooms:

- [Regex](https://tryhackme.com/room/catregex)
- [Splunk: Exploring SPL](https://tryhackme.com/room/splunkexploringspl)
- [Splunk: Data Manipulation](http://tryhackme.com/jr/splunkdatamanipulation)

 Room Machine
Before moving forward, start the lab by clicking the `Start Machine` button. The lab will be accessible via split screen. If the VM is not visible, use the blue Show Split View button at the top-right of the page. Once the VM is in split screen view, you can click the `+` button to show it on a full screen. The VM will take 3-5 minutes to load properly. In this room, we will be working using the terminal of the VM and accessing the Splunk instance at `MACHINE_IP:8000`. **Note:**  Splunk is installed in the `/opt/splunk` directory, and you will be working in the App called Fixit.

Challenge: FIXIT
This challenge is divided into three levels:

 Level 1: Fix Event Boundaries Fix the Event Boundaries in Splunk. As the image below shows, Splunk cannot determine the Event boundaries, as the events are coming from an unknown device.

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/6e62548849068f986f25d9d0c8f52c9c.png)

 Level 2: Extract Custom Fields Once the event boundaries are defined, it is time to extract the custom fields to make the events searchable.

- Username
- Country
- Source_IP
- Department
- Domain

**Sample Logs:** 
To create regex patterns, sample Network logs are shown below:

```
[Network-log]: User named Johny Bil from Development department accessed the resource Cybertees.THM/about.html from the source IP 192.168.0.1 and country 
Japan at: Thu Sep 28 00:13:46 2023
[Network-log]: User named Johny Bil from Marketing department accessed the resource Cybertees.THM/about.html from the source IP 192.168.2.2 and country 
Japan at: Thu Sep 28 00:13:46 2023
[Network-log]: User named Johny Bil from HR department accessed the resource Cybertees.THM/about.html from the source IP 10.0.0.3 and country 
Japan at: Thu Sep 28 00:13:46 2023
```

 Level 3: Perform Analysis on the FIXED Events
Once the custom fields are parsed, we can use those fields to analyze the Event logs. Examine the events and answer the questions.

 Happy Fixing!

### **Answer the questions below**

**Question:** What is the full path of the FIXIT app directory?

*Answer:* 

     /opt/splunk/etc/apps/fixit

**Question:** What Stanza will we use to define Event Boundary in this multi-line Event case?

*Answer:* 

     BREAK_ONLY_BEFORE

**Question:** In the inputs.conf, what is the full path of the network-logs script?

*Answer:* 

     /opt/splunk/etc/apps/fixit/bin/network-logs

**Question:** What regex pattern will help us define the Event's start?

*Answer:* 

     \[Network-log\]

**Question:** What is the captured domain?

*Answer:* 

     Cybertees.THM

**Question:** How many countries are captured in the logs?

*Answer:* 

     12

**Question:** How many departments are captured in the logs?

*Answer:* 

     6

**Question:** How many usernames are captured in the logs?

*Answer:* 

     28

**Question:** How many source IPs are captured in the logs?

*Answer:* 

     52

**Question:** Which configuration files were used to fix our problem? [Alphabetic order: File1, file2, file3]

*Answer:* 

     fields.conf, props.conf, transforms.conf

**Question:** What are the TOP two countries the user Robert tried to access the domain from? [Answer in comma-separated and in Alphabetic Order][Format: Country1, Country2]

*Answer:* 

     Canada, United States

**Question:** Which user accessed the secret-document.pdf on the website?

*Answer:* 

     Sarah Hall

---

