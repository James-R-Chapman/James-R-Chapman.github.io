---
layout: post
title: "Elastic Stack"
date: 2025-11-25
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 1/Core SOC Solutions"
source_urls: "(https://tryhackme.com/room/soar)"
source_path: "SOC Level 1/Core SOC Solutions/Elastic Stack.md"
---

{% raw %}


# In the previous task, we studied how SOAR Playbooks are predefined workflows that tell the SOAR tool what actions to take during a specific investigation. SOC analysts make playbooks for a general category of recurring alerts. Let's have a look at two different playbooks, one for Phishing and one for CVE Patching. 
Phishing Playbook
Phishing attacks remain the most common attack vector used in breaches. Unfortunately for security analysts, investigating phishing emails becomes time-consuming and involves manual exercises such as analysing attachments and URLs and verifying through threat intelligence platforms. While other investigations are ongoing, SOAR solutions can execute these tasks in the background via a playbook. Additionally, remediation can be performed when a positive phishing email is identified.
Now, what would this playbook look like? 
Imagine you are a SOC analyst experienced in dealing with phishing alerts. You are training a junior analyst on how to respond to a phishing alert. For this, you make a flow diagram for them to take help from while investigating such alerts. What would you like to add to that flow diagram to assist your junior analyst?  Starting from receiving the alert "Suspicious email received", you will probably tell them the next steps they should take. They should create a ticket and check if the email contains a URL or an attachment. If it does not, just notify the users, but if it does, what would be the next steps? The next steps would further depend on whether it contains a URL or an attachment. So, a lot of "if this happens, do this; else, do this" instructions. This is how a plabook is made. The flow diagram below shows a playbook of phishing, telling what to do at what step.

CVE Patching Playbook
A CVE (Common Vulnerabilities and Exposures) is a vulnerability that is disclosed publicly and assigned a CVE number. As part of vulnerability management, the SOC team has to address newly released CVEs by verifying whether they exist in their network and patching them if they do.  An analyst must always be on the lookout for publications on new CVEs and remediation plans. The process can become overwhelming, resulting in a mounting backlog and patches not being applied, leaving the environment more vulnerable. Moreover, this process can take a lot of time and resources of the SOC team since CVEs are released frequently. So, to solve this problem, we can make a playbook for handling the CVEs inside the SOAR tool, just like we did for the phishing case.
This playbook will analyse the CVE details, assess its risk threshold, create a patching ticket, and test the patch before being pushed to the production environment. The following is an example of a playbook made for CVE patching.
Note: Please click to enlarge the image.

As you can see in both the playbooks' flow diagrams, most of the steps are automated, but a SOC analyst can be seen at a few points. This highlights that while SOAR reduces repetitive manual process burden, SOC analysts' roles remain essential for crucial decisions and verifications.

## Task 1 | Introduction

To defend against attacks, a SOC team relies on various security solutions, such as SIEM, EDR, firewalls, and threat intelligence platforms. They also communicate with IT and management teams as part of their processes. However, as threats grow more complex and advanced, SOC teams face challenges like alert fatigue, manual processes, too many disconnected tools, and difficulties in communication across teams.

 In this room, we will explore how the Security Orchestration, Automation, and Response (SOAR) tool overcomes these challenges for a SOC team.

 Learning Objectives 
- Understand the traditional SOC and its challenges
- Explore how SOAR overcomes these challenges
- Learn SOAR Playbooks
- Practically walk through a threat intelligence workflow

 Room Prerequisites A look at the following rooms would be helpful before starting this room:

 
- [SOC Fundamentals](https://tryhackme.com/room/socfundamentals)
- [Junior Security Analyst Intro](https://tryhackme.com/room/jrsecanalystintrouxo)
- [Intro to Detection Engineering](https://tryhackme.com/room/introtodetectionengineering)

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---

## Task 2 | Traditional SOC and Challenges

How Traditional SOCs Work Before we dive into learning the SOAR tool, let's take a look at how traditional Security Operations Centers (SOC) work and the challenges they face.

 Organisations have a Security Operations Center (SOC) as a centralised location for monitoring and protecting their digital assets. SOCs have evolved over time, with every generation adding new technology. The main advantage of an organisation having a SOC is to enhance its security incident handling through continuous monitoring and analysis. This is achievable by implementing the right amount of people, processes, and technologies to support the SOC's capabilities and business goals.

 Some key capabilities of a SOC include the following:

 
- **Monitoring and Detection:**  This focuses on continuously scanning and flagging suspicious activities within a network environment. It leads to awareness of emerging threats and how to prevent them in their early stages. The monitoring is mainly done through the SIEM. 
For example, detecting numerous failed login attempts on a critical workstation, or detecting a login from an unknown location, etc.
- **Recovery and Remediation:**  Organisations rely on their SOC to provide a hub for recovery and remediation when incidents occur. SOC teams operate as first responders when cyber threats are identified. They perform operations such as isolating or shutting down infected endpoints, removing malware, and stopping malicious processes. During this process, they often utilize other security solutions like EDR, firewalls, IAM, etc. 
For example, isolating an endpoint through EDR, blocking an IP on the firewall, disabling a user on the IAM, etc.
- **Threat Intelligence:**  Monitoring environments continuously requires a constant flow of threat intelligence. This ensures that SOC teams have continuous and the latest feeds of threat data, such as IP addresses, hashes, domains, and other indicators. 
For example, blocking a malicious domain flagged by the threat intelligence feeds.
- **Communication:**  The SOC teams not only detect and respond to threats but also coordinate with IT teams and management to effectively communicate the threats and ensure that the incidents are addressed.
For example, generating a ticket for the IT team to verify a recently deployed patch.

 You can see how SOC works on multiple tools and communicates with various teams to carry out its processes. While these many processes protect the organization, the SOC teams often face some challenges. Let's discuss them.

 Challenges Faced by SOCs 
- **Alert Fatigue:**  Using numerous security tools triggers a large number of alerts within an SOC. Many of these alerts are false positives or insufficient for an investigation, leaving analysts overwhelmed and unable to address any serious security events.
- **Too many Disconnected Tools:**  Security tools are often deployed without integration within an organisation. Security teams are tasked with navigating through firewall logs and rules, which are handled independently from endpoint security logs. This also leads to an overload of tools.
- **Manual Processes:**  SOC investigation procedures are often not documented, leading to inefficient means of addressing threats. Most rely on established tribal knowledge built by experienced analysts, and the processes are never documented. This results in slowing down the investigation and increasing response times.
- **Talent Shortage:**  SOC teams find recruiting and expanding their talent pool difficult to address the growing security landscape and sophisticated threats. Combining this with the alert overload teams face, security analysts become more overwhelmed with the responsibilities they have to undertake, resulting in less efficient work and extended incident response times that allow adversaries to wreak havoc within an organisation.

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1759490774771.png)

### **Answer the questions below**

**Question:** 

*Answer:* 

     Alert Fatigue

---

## Task 3 | Overcoming SOC Challenges with SOAR

In the previous task, we saw some challenges that Security Operations Centers (SOC) faced. In this task, we will learn about a tool that can overcome these challenges for a SOC team. This tool is called Security Orchestration, Automation, and Response (SOAR). Let's discuss what this tool is and how it overcomes these challenges.

 What is SOAR? Security Orchestration, Automation, and Response (SOAR) is a tool that unifies all the security tools used in a SOC. With SOAR, SOC analysts do not need to switch between SIEM, EDR, Firewall, and other security tools for their investigations. They can operate all these tools within a single SOAR interface. Along with unifying the security tools, it also provides ticketing and case management features to the analysts, through which they can document, track, and resolve their incidents in a structured way.

 ![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1759484710562.png)

 The core strength of a SOAR tool comes from the following three main capabilities:

 1. Orchestration Traditionally, while investigating an alert, a SOC analyst has to switch between multiple security tools for the analysis. For example, during a VPN brute force, the analyst typically switches between the following tools:

 
1. **SIEM** to check if the user usually uses the subject IP for logging
2. **Threat Intelligence (TI) platforms** to verify the IP's reputation
3. **IAM tool** to disable the user if there was any successful attempt
4. **Ticketing system**  to open and track the incident

 This manual switching between different tools slows down the process. Orchestration solves this problem by coordinating all these tools together inside the SOAR. It connects different tools from various vendors within the unified SOAR interface. It defines workflows for investigating various types of alerts, known as **Playbooks** . These playbooks are predefined steps that tell the SOAR how to investigate an alert.

 For example, the VPN brute force alert we discussed above would have the following playbook:

 
1. Received alert from SIEM
2. Query SIEM to check if the User normally uses the IP
3. Check TI platforms for the IP's reputation
4. Query SIEM for any successful logins
5. Escalate to containment actions

 The above actions are predefined in a playbook for a specific alert. These playbooks are dynamic and usually contain different paths. The result of each step determines the next action. For example, if the user normally uses the IP and the failed attempts were minimal, the playbook may stop early. In the upcoming tasks, we will discuss some real playbooks.

 2. Automation The art of coordinating with multiple tools through predefined actions (Playbooks), which we studied in Orchestration, can be automated. Automation means no more manual clicks needed from SOC analysts. SOAR will itself follow the playbooks. Let's resume the playbook for VPN brute force alert combined with the Automation.

 
1. SOAR receives the alert from SIEM
2. It automatically queries the SIEM for the user's historical logins
3. It automatically verifies the IP's reputation through TI platforms
4. If the IP is malicious, it automatically disables the user from the IAM
5. Lastly, it automatically opens a ticket in the ticketing system with all the details to initiate an investigation

 This saves a tremendous amount of time for SOC analysts. They can handle hundreds of alerts without burning out.

 3. Response SOAR gives the ability to take actions using different tools from one unified interface. It also automates the response, as we saw earlier while looking at its Automation capability. For example, SOAR can follow the playbook of VPN Brute force and block the IP on the firewall, disable the user in the IAM, and open a ticket with all the details.

 The Orchestration, Automation, and Response capabilities of SOAR solve the major challenges a SOC team faces. With SOAR, there is no more alert fatigue, most of the processes are automated, and all the different tools are connected for coordination.

 ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1759484710596.png)

 Do We Still Need SOC Analysts? While a SOAR tool can automate the majority of repetitive tasks, it does not replace SOC analysts. Complex investigations still require an SOC analyst. SOAR cannot give a judgment call at some critical points, but an analyst can. A SOC analyst understands the threats in the broader business context. The playbooks for different types of alerts are also made by the SOC analysts. So, the answer to this question is that the SOAR would ease the burden of SOC by automating repetitive tasks and organizing everything in a simplified structure, but we still need SOC analysts.

### **Answer the questions below**

**Question:** 

*Answer:* 

     Orchestration

**Question:** 

*Answer:* 

     Playbook

---

## Task 4 | Building SOAR Playbooks

In the previous task, we studied how SOAR Playbooks are predefined workflows that tell the SOAR tool what actions to take during a specific investigation. SOC analysts make playbooks for a general category of recurring alerts. Let's have a look at two different playbooks, one for Phishing and one for CVE Patching.

 Phishing Playbook Phishing attacks remain the most common attack vector used in breaches. Unfortunately for security analysts, investigating phishing emails becomes time-consuming and involves manual exercises such as analysing attachments and URLs and verifying through threat intelligence platforms. While other investigations are ongoing, SOAR solutions can execute these tasks in the background via a playbook. Additionally, remediation can be performed when a positive phishing email is identified.

 Now, what would this playbook look like?

 Imagine you are a SOC analyst experienced in dealing with phishing alerts. You are training a junior analyst on how to respond to a phishing alert. For this, you make a flow diagram for them to take help from while investigating such alerts. What would you like to add to that flow diagram to assist your junior analyst? Starting from receiving the alert "Suspicious email received", you will probably tell them the next steps they should take. They should create a ticket and check if the email contains a URL or an attachment. If it does not, just notify the users, but if it does, what would be the next steps? The next steps would further depend on whether it contains a URL or an attachment. So, a lot of "if this happens, do this; else, do this" instructions. This is how a plabook is made. The flow diagram below shows a playbook of phishing, telling what to do at what step.

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/750415d37d5d45da28ea0f83d3754857.png)

 CVE Patching Playbook A CVE (Common Vulnerabilities and Exposures) is a vulnerability that is disclosed publicly and assigned a CVE number. As part of vulnerability management, the SOC team has to address newly released CVEs by verifying whether they exist in their network and patching them if they do. An analyst must always be on the lookout for publications on new CVEs and remediation plans. The process can become overwhelming, resulting in a mounting backlog and patches not being applied, leaving the environment more vulnerable. Moreover, this process can take a lot of time and resources of the SOC team since CVEs are released frequently. So, to solve this problem, we can make a playbook for handling the CVEs inside the SOAR tool, just like we did for the phishing case.

 This playbook will analyse the CVE details, assess its risk threshold, create a patching ticket, and test the patch before being pushed to the production environment. The following is an example of a playbook made for CVE patching.

 **Note:** Please click to enlarge the image.

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/f33c952ffab8386408066e3fd7aef70a.png)

 As you can see in both the playbooks' flow diagrams, most of the steps are automated, but a SOC analyst can be seen at a few points. This highlights that while SOAR reduces repetitive manual process burden, SOC analysts' roles remain essential for crucial decisions and verifications.

### **Answer the questions below**

**Question:** 

*Answer:* 

     yay

**Question:** 

*Answer:* 

     ________ _____

**Question:** 

*Answer:* 

     __________ ____

---

## Task 5 | Threat Intel Workflow Practical

Scenario You are part of a SOC team that recently faced a large breach investigation that took ages due to a lack of automation. Your friend, McSkidy, recently advised adopting a SOAR and setting up automation workflows (also called playbooks) to help your security investigations. McSkidy sent you a checklist for a Threat Intelligence integration workflow, and your task is to figure out how it works. Click the **View site** button below to launch the site in split view. To automate the process, use the different screens to activate the elements required for the SOAR workflow. Run and test the workflow until you get a smooth transition on the flowchart to complete the task.

 View Site

### **Answer the questions below**

**Question:** 

*Answer:* 

     THM{AUT0M@T1N6_S3CUR1T¥}

---

## Task 6 | Conclusion

That's all for this room. In this room, we looked at the traditional SOC processes and their challenges. Then we saw how SOAR can overcome these challenges through its Orchestration, Automation, and Response. Finally, we examined some real playbooks used in a SOC and developed a Threat Intelligence workflow for automation.

### **Answer the questions below**

**Question:** 

*Answer:* 

     No answer needed

---

{% endraw %}
