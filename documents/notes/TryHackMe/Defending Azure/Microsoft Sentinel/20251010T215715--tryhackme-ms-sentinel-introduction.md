---
title:      "TryHackMe | MS Sentinel: Introduction"
date:       2025-10-02
tags:       TryHackMe
identifier: 20251002T000000
hubs:       "TryHackMe/Defending Azure/Microsoft Sentinel"
urls:       "https://tryhackme.com/room/sentinelintroduction"
id: 3b24f4c5-bf57-4bc1-88b9-6b7825600490
---


# TryHackMe | MS Sentinel: Introduction

## Task 1 | Microsoft Security Operations Analyst

A **Security Operations Center (SOC)** is a centralized security unit with team(s) responsible for protecting the organization against security threats.

A **Security Operations Center** **Analyst** , also known as a SOC Analyst, works in a SOC team to monitor, analyze, and respond to security issues as the front line of an organization's cyber defenses. Similarly, a Microsoft SOC Analyst**** has the same security goals as a SOC Analyst but with the additional distinction of working and specializing in Microsoft Security products.
The main goal is to reduce organizational risk. The mission statement would include the following points:

- **Remediate active attacks** in the environment.
- **Advise on improvements** to threat protection practices.
- **Refer violations** of organizational policies to appropriate stakeholders.

 Responsibilities **Monitoring** [SOC Level 1 Analyst](https://tryhackme.com/r/resources/blog/become-level-1-soc-analyst)**Triage** [SOC Level 1 Analyst](https://tryhackme.com/r/resources/blog/become-level-1-soc-analyst)**Incident Response** [SOC Level 2 Analyst](https://tryhackme.com/r/resources/blog/become-level-2-soc-analyst)**Threat Hunting** [SOC Level 2 Analyst](https://tryhackme.com/r/resources/blog/become-level-2-soc-analyst)**Advanced Threat Hunting** SOC Level 3 Analyst**Threat Intelligence (TI) Analysis** SOC Level 3 Analyst**Vulnerability Management** SOC Level 3 Analyst
Prerequisites
- Understanding of Microsoft 365
- Fundamental understanding of **Microsoft Security, Compliance, and Identity** products
- Intermediate understanding of Microsoft Windows
- Familiarity with Azure services - specifically Azure SQL Database and Azure Storage, Azure VMs, and Virtual Networking
- Familiarity with scripting concepts

This role primarily **investigates** , **responds to** , and **hunts** for threats by using the following security products:

- Microsoft **Sentinel**
- Microsoft **Defender for Cloud**
- Microsoft **365 Defender**
- and third-party security products

Throughout the [Microsoft Sentinel](https://tryhackme.com/module/sentinel) module, we will dive deep into these security products and learn how they help SOC Analysts with their job tasks. Keeping this role definition in mind, let's see what Microsoft Sentinel**** is in the next task.

### **Answer the questions below**

**Question:** What security unit is responsible for protecting the organization against security threats?

*Answer:* 

     Security Operations Center

**Question:** Generally, which level of SOC Analyst is responsible for responding to incidents?

*Answer:* 

     SOC Level 2 Analyst

**Question:** Besides monitoring, what else do SOC Level 1 Analysts spend the majority of their time with?

*Answer:* 

     triage

---

## Task 2 | Introduction to Microsoft Sentinel

Before we can define what Microsoft Sentinel is, it is important to first define two concepts, namely **SIEM** and **SOAR** .

What Is SIEM?SIEM stands for **Security Information and Event Management** . It is a comprehensive approach to security management that combines **Security Information Management** (SIM)**** and **Security Event Management** (SEM)**** into a single solution. The primary purpose of SIEM is to provide a *holistic view* of an organization's information security by collecting and analyzing log data from various sources across its IT infrastructure.

 What Is SOAR? SOAR stands for **Security Orchestration, Automation, and Response** . It is a set of technologies and practices designed to improve the efficiency and effectiveness of an organization's cyber security operations. SOAR platforms integrate security orchestration and automation to streamline and accelerate incident response processes.

 What Is Microsoft Sentinel? Given the above concept definitions, Microsoft Sentinel's**** own definition becomes a combination of the two. It is essentially a scalable, cloud-native**** solution that provides the following:

 
- Security Information and Event Management (SIEM)**** functionality by:
- Collecting and querying logs
- Doing **correlation** or **anomaly detection**
- Creating **alerts** and **incidents** based on findings
- Security Orchestration, Automation, and Response (SOAR) functionality by:
- Defining playbooks
- Automating threat responses

 Microsoft Sentinel also delivers security analytics and threat intelligence**** across the organization. It's a one-stop-shop and bird's-eye view**** solution for:

- Attack detection
- Threat visibility
- Proactive hunting
- Threat response

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/6601e243753b8d484668851e/room-content/6601e243753b8d484668851e-1734522464655.png)

Microsoft Sentinel performs the above actions and enables security operations by means of 4 main pillars:

- **Collect**
- **Detect**
- **Investigate**
- **Respond**

As we go through the rooms in this module, it will be clear which functionalities are SIEM and which ones are SOAR-related. For now, we can think of Microsoft Sentinel as a **cloud-native SIEM+SOAR system** for security operations.

### **Answer the questions below**

**Question:** Microsoft Sentinel is a combination of two security concepts, namely SIEM and which other one?

*Answer:* 

     SOAR

**Question:** Creating security alerts and incidents is part of which security concept?

*Answer:* 

     SIEM

**Question:** By means of how many pillars does Microsoft Sentinel help us to perform security operations?

*Answer:* 

     4

---

## Task 3 | How Microsoft Sentinel Works

To understand how Microsoft Sentinel does what it does, maybe it is better to go through the journey together with the logs. Without log data ingested from different data sources, there wouldn't be any **correlation** , **alerting** , **threat intelligence,** or **response automation** .

 Phase 1: Collect ![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/5efbaebdaaea011c857b438d/room-content/6fee57080a29bf42ae18501904cc054b.svg)

****

- **Data connectors:** The first step is to **ingest data** into Microsoft Sentinel. This is exactly what data connectors are for. There are 100+ connectors to cover all various data sources and scenarios.

- **Log retention:**  Once the data has been ingested into Microsoft Sentinel, it must be stored for further **correlation** and **analysis** . This log storage mechanism is called **Log Analytics workspaces** . Data stored in these workspaces can be queried to gain further insights using Kusto Query Language (KQL).

 Phase 2: Detect ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/6601e243753b8d484668851e/room-content/6601e243753b8d484668851e-1736328938360.png)

 
- **Workbooks:** Workbooks are essentially **dashboards** in Microsoft Sentinel used to visualize data. There are many built-in workbooks, and custom ones can also be created by utilizing KQL.

- **Analytics rules:**  What good is a bunch of logs and visualizations if we can't gain insights from them? That's why there are Analytics rules. Analytics rules provide proactive analytics so that SOC teams get notified when suspicious things happen. The output of running Analytics rules are security alerts and incidents.

- **Threat hunting:**  Reacting to security incidents only after they happen is not good enough. SOC analysts also need to perform proactive threat hunting. Microsoft Sentinel has over 200 built-in threat-hunting queries to support that needle-in-a-haystack job.

 Phase 3: Investigate ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/5efbaebdaaea011c857b438d/room-content/326870fef9b3ac034f874eeb811208e8.svg)

****

- **Incidents and investigations:**  Once Analytics rules detect suspicious activities, i.e., once an alert is triggered, security incidents are created for SOC analysts to triage and **investigate** . Typical incident management activities include:
- **Changing**  the incident **status**
- **Assigning** to other analysts for further investigation
- **Mapping** entities to the investigation
- Investigating the incident **timeline**
- Deep-dive into investigation details using **investigation maps**
- Recording **investigation comments**

 Phase 4: Respond ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/5efbaebdaaea011c857b438d/room-content/d5cd2c27821eeb1df1237c49bef1d3c6.svg)

****

Let's first define the term **alert fatigue** . Alert fatigue occurs occurs when cyber security professionals are inundated with a high volume of security alerts, which leads to a diminished ability for SOC teams to react effectively to and investigate real threats.

- **Automation via playbooks:**  One of the main challenges of a SOC team is alert fatigue. To overcome alert fatigue, automation in security operations is a must. This is done by **automated workflows** , also known as **playbooks** , in response to events. By doing so, automated responses can be provided for:
- Incident management
- Enrichment
- Investigation
- Remediation

Referring to the definition of SOAR in Task 2, **Respond** is part of the **SOAR** (*Security Orchestration, Automation, and Response* ) capabilities of Microsoft Sentinel.

After defining the four phases above (Collect, Detect, Investigate, and Respond), it should be clearer how Microsoft Sentinel helps SOC analysts perform their job tasks and which of these phases map to L1/L2 SOC analyst's responsibilities.

### **Answer the questions below**

**Question:** What is used to ingest data into Sentinel?

*Answer:* 

     data connectors

**Question:** Where are the ingested logs stored for further correlation and analysis?

*Answer:* 

     log analytics workspaces

**Question:** Workbooks are essentially _______ used for visualization.

*Answer:* 

     dashboards

**Question:** When SOC teams are flooded with security alerts and incidents, this is called?

*Answer:* 

     alert fatigue

**Question:** In Microsoft Sentinel, automation is done via automated workflows, known as?

*Answer:* 

     playbooks

**Question:** The output of running Analytics rules includes security alerts and?

*Answer:* 

     Incidents

---

## Task 4 | When To Use Microsoft Sentinel

The short answer is: When there is a necessity to monitor cloud and on-premises infrastructures for security. Surely, many security products could be used for this purpose. However, where Microsoft Sentinel separates from the crowd is its ability to enable the majority of SOC teams' tasks from a single pane and with a 360-degree bird's-eye**** approach.

 Microsoft Sentinel serves as a solution for conducting security operations**** across cloud and on-premises environments. Security operations encompass various tasks such as:

- Visualizing log data
- Detecting anomalies
- Conducting threat hunting
- Investigating security incidents
- Implementing automated responses to alerts and incidents

 Opt for Microsoft Sentinel**** if the organization aims to:

- Gather event data from diverse data sources
- Execute security operations on the collected data to pinpoint suspicious activities

Also, some of Microsoft Sentinel's additional features are:

- **Cloud-native SIEM** - No need for server provisioning, facilitating seamless scalability
- Easy integration with Azure services and its extensive range of connectors
- Centralized monitoring
- Automated incident response
- Real-time advanced threat detection
- Leveraging Microsoft's **Research and Machine Learning** capabilities
- Support for hybrid **cloud and on-premises** environments

If the organization has requirements such as:

- Support for data from multiple cloud environments
- Features and functionality necessary for a Security Operations Center (SOC)**** without excessive administrative overhead

Microsoft Sentinel would be a great fit to address these requirements.

If the organization's objectives involve understanding the **security posture** , ensuring **compliance with policies** , and **checking for security misconfigurations** , you would use Microsoft Defender for Cloud (formerly known as Security Center) rather than mainly using Microsoft Sentinel. You could also use both in conjunction by ingesting Defender for Cloud alerts into Microsoft Sentinel, which would enhance the overall security framework.

### **Answer the questions below**

**Question:** Organizations use Microsoft Sentinel mainly because they need to _______ their cloud infrastructure.

*Answer:* 

     monitor

**Question:** With Microsoft Sentinel, there is no need for server provisioning. This means it is?

*Answer:* 

     cloud-native

---

## Task 5 | Conclusion

In this room, we have delved into an initial introduction to **security operations**  as a whole, understanding the responsibilities of a SOC Analyst and some key prerequisites.

We also discussed some key concepts of **Microsoft Sentinel** , how it works, and how SOC Analysts can use it to improve their security posture.

After completing this Microsoft Sentinel introductory room, you should have learnt the following:

- The roles of a SOC Analyst and the different levels
- How Microsoft Sentinel works as a SIEM solution
- The key features of Microsoft Sentinel

### **Answer the questions below**

**Question:** I understand how Microsoft Sentinel works!

*Answer:* 

     No answer needed

---

