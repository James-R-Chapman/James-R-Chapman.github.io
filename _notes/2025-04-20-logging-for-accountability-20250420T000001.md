---
layout: post
title: "Logging for Accountability"
date: 2025-04-20
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Security Engineer/Managing Incidents"
identifier: "20250420T000001"
source_id: "9242e2a2-dd0a-4609-bceb-ca80d118d03a"
source_urls: "(https://tryhackme.com/room/loggingforaccountability)"
source_path: "Security Engineer/Managing Incidents/20250420T000001--logging-for-accountability__tryhackme.md"
---

{% raw %}


# Logging for Accountability

## Task 1 | Introduction

Logging is used to provide a "source of truth" for activity that occurs on a network. Logging is most commonly used, but not limited to incident response and security monitoring. During the incident response process, a user may be held accountable for an action or behavior, and logging plays a crucial role in proving a user's actions.

 Accountability is the final pillar of the Identification, Authentication, Authorization, and Accountability (IAAA) model. The model is used to protect and maintain confidentiality, integrity, and availability of information.

 Accountability holds users and peers on a network responsible for their actions. Logging is a large part of this pillar and maintains a record of activities.

 To ensure the efficacy of accountability, logs and other data sources must be protected, and their authenticity must be proved. If it cannot be proven that a log was kept in its original state, it loses its integrity for accountability and the incident response process.

 Learning Objectives 
- Understand where data originates, how it is stored, and how a security engineer can leverage it.
- Understand why accountability is important to security and how logging can help improve its efficacy.
- Apply logs and other data sources to incident response and the principle of accountability.

 Before beginning this room, we recommend you understand logging capabilities and log data sources or complete [Intro to Logs](https://tryhackme.com/room/introtologs). We also recommend a basic understanding of Splunk or complete [Splunk Basics](https://tryhackme.com/room/splunk101).

 Throughout this room, we will introduce how logging and data maintain accountability. We will break down best practices and explain accountability in different stages of the incident response procedure.

### **Answer the questions below**

**Question:** Read the above before continuing to the next task.

*Answer:* 

     No answer needed

---

## Task 2 | Importance of Logging and Data Aggregation

Logging aids any member involved in the incident response process. Depending on the log source, it may provide different benefits or visibility into a network or device. Some examples may include:

- Files created.
- Emails sent.
- Other TTPs (Tactics, Techniques, and Procedures) as outlined by the [MITRE ATT&CK framework](https://attack.mitre.org/).

Because logs play an important role in incident response, they must be authentic and, when analyzed, identical to when they were produced.

Adding accountability to the incident response process, when log sources are guaranteed to be authentic, a user can be held accountable for their actions, as proven by logs.

This use of accountability is more formally known as non-repudiation and contributes to many threat models, such as the [STRIDE model](https://www.microsoft.com/en-us/security/blog/2007/09/11/stride-chart/). Non-repudiation means that an individual cannot contest an action, the opposite of repudiation, where an individual disputes an action.

Security Information and Event ManagementA **S** ecurity **I** nformation and **E** vent **M** anagement system **(SIEM)**  is a tool used to collect, index, and search data from various endpoints and network locations. While this room won't cover in-depth log analysis and SIEMs, it is important to create a basic level of understanding. We will leverage an SIEM in later tasks to get hands-on with the concepts presented in this room.

SIEMs have many features and capabilities, often for specific use cases. Below is a summary of the benefits and features that an SIEM can offer at the most basic level:

- Real-time log ingestion.
- Alerting against abnormal activities.
- 24/7 monitoring and visibility.
- Data insights and visualization.
- Ability to investigate past incidents.

Examples of SIEMs may include Wazuh, Splunk, ELK, and QRadar. For more information, check out [Auditing and Monitoring](https://tryhackme.com/room/auditingandmonitoringse).

### **Answer the questions below**

**Question:** A user being held accountable for their actions, as proven by logs, is known as what?

*Answer:* 

     non-repudiation

---

## Task 3 | Log Ingestion and Storage

While this room won't cover in-depth log analysis and SIEMs, it is important to create a basic level of understanding.

SIEMs are typically architected with three components used for searching, indexing, and load-balancing; these components are commonly known as the **search head** , **indexer** , and **forwarder** , respectively.

In this room, our objective is accountability, so we will focus primarily on the indexer and how data arrives from a device to the indexer; this process is commonly known as **data ingestion** .

- Types of data ingestion 
- Agent/forwarder
- Port-forwarding
- Syslog
- Upload

While there are several ways of ingesting data, there tend to be fewer ways to store the data. Although the primary point of failure for accountability is ingestion, storage can be equally challenging.

When dealing with storage concerns, it is often not attackers we must worry about, but technical faults; for example, an index is accidentally deleted, or a storage device is corrupted.

These are a few examples of things to consider when architecting a storage solution for log sources. While keeping this data authentic and secure is important for accountability, it often has overlapping themes with compliance. Compliance and regulations go hand in hand; one such regulation may be that log data must be archived or stored for X amount of time. This plays into accountability again, where non-repudiation must be applied to a log source for compliance. For example, an audit requires the past six months of X log source. As a stakeholder, you must guarantee that those log sources reflect the activity of the network.

One solution to the storage problem is cold storage. Cold storage is a process or standard for storing data, which can be summarized as storing a large quantity of data optimally.

Cold storage is rarely accessed and thus does not require high-performance storage devices. Examples of cold storage may include low-cost hard drives or even tape drives! Conversely, hot storage is data accessed often and requires higher performance, which may consist of solid-state drives and, in some cases, high-performance hard drives. There may be other levels of access and performance throughout the life cycle of data that can be referred to as warm storage.

The standard for how long data stays in each phase will depend on regulatory requirements and company guidelines. An example of a storage process may be that data is stored hot for six months, warm for three months, and cold for three years. Depending on the data, it may be indefinitely stored in cold storage.

Payment Card Industry Data Security Standard (PCI DSS) is one example of a standard that requires audit logs to be stored for a year and kept immediately available for 90 days to remain compliant.

### **Answer the questions below**

**Question:** What component of an SIEM is responsible for searching data?

*Answer:* 

     search head

**Question:** How many years must all audit data be stored to be PCI DSS compliant?

*Answer:* 

     1

---

## Task 4 | Types of Logs and Data Sources

Now that some problems are solved with how data will be sent to an indexer and SIEM solution, we must consider - what makes a good log.

While an SIEM provides excellent functionality, its purpose is to ingest any data and provide an effective and easy way to index and search it.

If a log does not give you the information required for an investigation, it cannot be used for accountability and does not uphold non-repudiation.

Many log sources exist to collect data efficiently with as much relevant information as possible. In this task, we will outline a few of the most common log sources and how they may be used in the incident response process.

- Manual log sources 
- Any log that is manually written or composed by an author
- Change logs
- Automated log sources 
- Any logs that are automatically generated by default, for example, a configuration, tool, or from a developer
- System logs
- Application logs
- Other types of logs 
- Some logs may not be categorized but are often required for compliance
- Email logs
- Messaging or other communication

A good log source may not include only one log. Due to the nature of a network, it may require multiple log types to create one quality log source, for example, a firewall log and a system log used together to hold each other accountable. That is, the validity of one log can be proven using another and vice-versa.

A log source could also be collecting too much information; that is, if several types of logs are collecting the same data or creating the same alerts, it can increase noise, storage complexity, and other consequences.

### **Answer the questions below**

**Question:** A change log is an example of what log source?

*Answer:* 

     Manual

**Question:** An application log is an example of what log source?

*Answer:* 

     Automated

---

## Task 5 | Using Logs Effectively

There are many types of SIEMs to choose from, and each feature and capability can impact how you can use logs effectively. If you are not using a specific feature of an SIEM, it does not signify that you are not effectively using logs, as it depends on log sources and usage requirements. For example, if you are only using logs as an incident response tool and not for real-time monitoring, you may not need or use the real-time feature of some SIEMs.

As briefly introduced in task four, using multiple log types and sources is beneficial for validating logs and creating a complete story of an incident. This concept is more formally known as **correlation**  or building a relationship between two things: logs and data. For example, if a user performed a suspicious action (created a DLL file on the disk), a browser application log could be used to correlate their browser search history with their behavior. If they were searching for a specific installer or troubleshooting process, it may explain the suspicious action. If email logs showed a potential phishing attempt directly followed by the suspicious action, it could cause more investigation. Data enrichment can also be included in correlation efforts.

### **Answer the questions below**

**Question:** What is the process of using multiple log types and sources as part of incident response formally known as?

*Answer:* 

     correlation

---

## Task 6 | Improving Incident Response with Accountability

Start MachineWe have provided web application access to a commonly used SIEM, Splunk. A dataset that contains all the information you need to answer the upcoming questions has already been loaded for you.

In this exercise, we are looking to practice the correlation of log sources and prove accountability's efficacy.

To access the terminal, deploy the virtual machine attached to this task by pressing the green **Start Machine**  button. Please allow the machine 3 - 5 minutes to deploy. You can access the web application from your web browser via [https://LAB_WEB_URL.p.thmlabs.com/](https://lab_web_url.p.thmlabs.com/).

### **Answer the questions below**

**Question:** How many total events are indexed by Splunk?

*Answer:* 

     12,256

**Question:** How many events were indexed from April 15th to 16th 2022?

*Answer:* 

     12,250

**Question:** How many unique users appear in the data set?

*Answer:* 

     4

**Question:** How many events are associated with the user "James"?

*Answer:* 

     5

**Question:** What utility was used in the oldest event associated with "James"?

*Answer:* 

     wmic

**Question:** What event ID followed process creation events associated with "James"?

*Answer:* 

     _

---

{% endraw %}
