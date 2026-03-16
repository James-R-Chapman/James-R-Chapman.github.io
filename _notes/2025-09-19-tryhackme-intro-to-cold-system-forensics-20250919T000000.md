---
layout: post
title: "TryHackMe | Intro to Cold System Forensics"
date: 2025-09-19
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Advanced Endpoint Investigations/Disk Image Analysis"
identifier: "20250919T000000"
source_urls: "https://tryhackme.com/room/introtocoldsystemforensics"
source_path: "Advanced Endpoint Investigations/Disk Image Analysis/20250920T215404--tryhackme-intro-to-cold-system-forensics.md"
---

{% raw %}



# TryHackMe | Intro to Cold System Forensics

## Task 1 | Introduction

This room will introduce users to cold system forensics, focusing on how DFIR teams examine offline systems for forensics. It will cover the differences, advantages, and disadvantages of live system forensics and the challenges that this type of forensics poses. It will also introduce data acquisition techniques and forensic tools and cover legal considerations for chain of custody and data volatility.

 Objectives 
- Learn the differences between live system forensics and cold system forensics.
- Explore the challenges and opportunities of examining offline systems.
- Learn the process and considerations of acquiring and preserving data from cold systems.
- A brief introduction to various tools used in the field and when they would be applicable.

### **Answer the questions below**

**Question:** I'm ready to embark on cold systems forensics!

*Answer:* 

     No answer needed

---

## Task 2 | Challenges and Opportunities

Historical Context: The Evolution of Cold System Forensics In our cyber security journey, forensics plays a crucial role in gathering evidence and putting together the puzzle of a breach. While live forensics tackles actively running systems, cold system forensics focuses on dormant or powered-off machines, aiming to preserve the system's state and any potential evidence.

 Cold system forensics emerged as a direct response to a malicious technique known as a **cold boot attack** . Attackers would use this technique to take advantage of the fact that data in a computer's RAM persists for a short period, depending on the RAM's temperature, after the system is powered off. The cooler the RAM chips are, the longer the data can be retained. Attackers could rapidly reboot a compromised machine to access sensitive information, such as encryption keys, passwords, or in-memory data, before it is completely erased.

 To counter this threat, researchers began exploring methods to preserve and analyse the contents of a system's volatile memory even when powered off, marking the initiation of cold system forensics.

 Beyond Memory Analysis Initially focused on memory analysis, cold system forensics has evolved into a discipline encompassing the examination of the entire dormant system. This includes storage drives, peripheral devices, hardware configurations, and any other residual data lingering in volatile memory after the system is shut down.

 Analysis of a system in its powered-off state ensures that forensic analysts preserve the integrity of evidence, preventing potential tampering and modification. This is particularly crucial in legal proceedings where the admissibility of evidence hinges on its unaltered state.

 Cold vs. Live Forensics To appreciate the unique value of cold system forensics, it is essential to contrast it with live forensics. Each approach has unique challenges and opportunities, and knowing when to apply each method can significantly impact an investigation's effectiveness.

    **Aspect**  **Cold Forensics**  **Live Forensics**     **System State**  Examines powered-off systems Examines running systems   **Evidence Integrity**  Minimal risk High risk   **Data Capture**  Comprehensive capture of entire drives Limited to active data   **Volatile Memory Access**  Cannot retrieve Captures volatile data (memory, network)   **Time Efficiency**  Time-consuming Faster identification of threats   **Data Volume Handling**  Suitable for large data volumes Limited by system resources   **Legal Suitability**  Ideal for legal cases where integrity is paramount May alter evidence, less suitable for legal cases   **Access to Encrypted Files**  Risk of losing access if passwords are reset Immediate access while the system is running   
 Common Scenarios for Cold System Forensics Cold system forensics is particularly applicable in various scenarios:

 
- **Risk of modifying evidence** : As live analysis can alter critical evidence, cold system forensics must ensure the evidence remains unaltered and admissible in court. This can be seen during forensic investigations where any interaction with the running system could overwrite volatile data or change file timestamps, compromising the integrity of the evidence.
- **Comprehensive data capture** : This is necessary when a thorough examination of all data is necessary. It is essential for deep investigations where every piece of information matters, such as financial fraud investigations. By shutting down the system and creating a bit-by-bit image of the storage device, analysts can capture all the data, including deleted files, and analyse the system's complete state.
- **Incident response** : To preserve evidence from compromised systems without risk of alteration, shutting down a compromised server and performing cold analysis ensures the evidence remains intact. However, due to potential service disruptions, shutting down a compromised server in a large corporation running critical services might be avoided. Instead, forensic analysts might initially opt for live response techniques and later perform cold analysis on a cloned disk image to ensure no data is lost or modified.
- **Legal proceedings** : Cold system forensics ensures uncontaminated evidence that meets legal standards. Courts require a clear chain of custody and unaltered data, best achieved through cold analysis. When investigating intellectual property theft cases, demonstrating that the evidence was collected without any modification strengthens the case's credibility and legal standing.
- **Data recovery/File carving** : This process retrieves deleted or lost files from a system. Cold analysis allows for reconstructing deleted files from disk images without overlooking any data during recovery.
- **Legacy systems** : Where live analysis is not feasible due to outdated or unstable systems, cold system forensics is handy. Live analysis tools may not be supported in environments with legacy systems, such as older industrial control systems in manufacturing plants. Therefore, cold analysis allows forensic experts to examine these systems without risking further instability or data loss.
- **Cloud and virtualised environments** : In today's world, where cloud and virtualised environments are commonly used, cold system forensics can be used to analyse virtual machines without impacting running services. For example, a service provider might create snapshots of VMs suspected of being compromised, allowing analysts to analyse them and uncover any malice. This ensures that customer services remain uninterrupted while a thorough investigation is conducted.

### **Answer the questions below**

**Question:** Under what two system states are cold system forensics mainly applied?

*Answer:* 

     Dormant or Powered-off

**Question:** What type of attack provided a research basis for cold system forensics?

*Answer:* 

     cold boot attack

---

## Task 3 | Data Acquisition and Preservation

Data acquisition and preservation are critical components of cold system forensics. This task will explore the methodologies and best practices for acquiring and preserving data, ensuring its integrity and chain of custody. This process is vital for maintaining the credibility of the data and ensuring its use in legal proceedings.

 Order of Volatility The order of volatility is an essential concept in digital forensics. It refers to the sequence in which data should be collected based on its volatility or likelihood to change. This order helps forensic analysts prioritise data acquisition, with the most ephemeral data being captured before it is lost or altered.

 A typical order from the most volatile to the least volatile might look as follows:

 
- **CPU registers and cache:** These hold the most volatile data, typically lost once the host is powered down. When this data is captured, it can provide insights into current operations being executed.
- **Routing Table, ARP Cache, Process Table, Kernel Statistics, and RAM:** Data here changes rapidly, and capturing it may reveal information about running processes and network connections, which can help identify any malicious activity.
- **Temporary File Systems:** Data in temporary files is often cleared on reboot and thus changes frequently. The data can uncover recently accessed files or applications on a host.
- **Hard Disk:** Disk data is less volatile but can undergo alterations and deletions. Imaging the disk provides a comprehensive snapshot of all stored data, including deleted files and fragments.
- **Remote Logging and Monitoring Data:** These logs are relatively stable and less likely to change. They provide a record of network activity and system events over time.
- **Physical Configuration and Network Topology:** Documenting this data helps analysts understand the infrastructure and context of the investigation. Additionally, data transmitted over the network must be collected for forensics.
- **Archival media:** This data is stored offline, such as tapes and optical discs.

 Methods for Acquiring Data From Cold Systems Disk Imaging ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/5fc2847e1bbebc03aa89fbf2-1722438012706.png)

 This is the process of creating a bit-for-bit copy of a disk, a complete replica of the original data. It allows analysts to examine the data without altering the original evidence. A much-needed step in disk imaging is using write blockers to prevent data alteration during acquisition.

 **Write blocking**  is a crucial method for preventing data alteration during acquisition and ensuring the integrity of the evidence. Hardware and software write blockers perform the operations. We illustrate a hardware write blocker with a USB drive on the right. It is also crucial to document the use of write blockers in the data acquisition logs to inform any other individual working on the investigation.

 Physical Acquisition This involves removing and imaging hard drives from the target system. This method requires careful handling to avoid data corruption or damage. It is necessary to use this method when dealing with damaged devices or encrypted storage. Some of the methods used during physical acquisition include:

 
- **Chip-off forensics** : This delicate process involves removing the storage chip from the device and reading it with specialised equipment.
- **JTAG forensics** : This uses the Joint Test Action Group (JTAG) interface to access data from embedded systems. It is helpful for mobile and IoT devices.

 Secure Storage Once you have acquired the needed data, it must be stored securely to prevent tampering and its integrity. The best practices to use include:

 
- **Strong encryption** : Advanced encryption methods, such as AES-256, protect data at rest. Encryption ensures the data remains unreadable without the decryption key, even if unauthorised access occurs.
- **Access control** : Establishing access control measures will restrict data access and investigation access to authorised personnel. This goes hand in hand with chain of custody.
- **Environment control** : A physically secure environment, such as a locked storage safe or secure server room with controlled access, ensures protection against physical threats.
- **Regular audits** : Conduct regular audits of the storage environment and access logs to ensure compliance with security policies and identify any potential breaches.

 You will get to explore some of these acquisition techniques in an upcoming room in the module, **[Forensic Imaging](https://tryhackme.com/r/room/forensicimaging)*.***

 Ensuring Integrity and Chain of Custody ![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/5fc2847e1bbebc03aa89fbf2-1722410264472.svg)

 **Chain of custody**  refers to the documentation of the responsible personnel in charge of evidence, its transfer from the point of collection to its presentation in court or required body after investigation. Maintaining a chain of custody ensures that evidence has not been tampered with and can be trusted as the factual findings of an investigation.

 To maintain the integrity and chain of custody of forensic data, we can follow the following guidelines:

 
- **Document every step** : No matter how small an action is during the forensic analysis, it must be documented and aligned with whoever is handling the evidence, what time was taken, and the reasons behind their access to the evidence.
- **Secure transport** : Tamper-proof packaging should be utilised to transport disk drives and other evidence securely.
- **Hashing** : Using cryptographic hash functions such as MD5 and SHA-1 to create unique data fingerprints and verify that it has not been altered.
- **Write blocking** : As mentioned before in the acquisition step, using write blockers helps prevent any modification of the original data.

### **Answer the questions below**

**Question:** The making of a bit-by-bit copy of forensic data is known as?

*Answer:* 

     Disk imaging

**Question:** What restricts access to sensitive data?

*Answer:* 

     Access control

**Question:** Which sources of evidence are part of the most volatile on a host?

*Answer:* 

     CPU registers and cache

---

## Task 4 | Forensic Tools and Techniques

Every forensic investigation requires tools and techniques to produce reliable results. Different tools offer different features; therefore, choosing the right tool depends on the case and feasibility of analysis.

 The following tools are essential to know about and add to your toolset. We will not go into the details of using every tool, but it is vital to understand what each accomplishes.

 Overview of Tools Used in Cold System Forensics ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/5fc2847e1bbebc03aa89fbf2-1722437365076.svg)

 **Disk Imaging Tools**

 
- `dd and dc3dd`: These command-line utilities create exact bit-by-bit copies of hard drives. While `dd` is the foundational tool, `dc3dd` offers additional forensic features such as progress indicators, error handling, and integrated hashing, making it more suitable for forensic tasks where data integrity and visibility are critical.
- `Guymager`: A GUI-based imaging tool for Linux systems that supports multiple image formats (e.g. E01, AFF, raw). It provides built-in write-blocking functionality, calculates MD5/SHA1 checksums during acquisition, and logs all imaging steps. Guymager is suitable for both live and offline imaging and is known for its simplicity and speed.
- `FTK Imager`: A widely used forensic imaging and preview tool that supports imaging from various media types (e.g., hard drives, USBs, optical media). FTK Imager allows investigators to preview files and folders before imaging, mount disk images for read-only access, and generate multiple image formats while computing hash values for integrity verification.

 **Disk Image Analysis Tools**

 Once the image is acquired, forensic analysts use analysis tools to extract, examine, and interpret artefacts. Here are some of the most prominent tools available for disk analysis:

 
- `The Sleuth Kit (TSK)`: A robust set of command-line tools for disk image analysis. It supports parsing of various file systems (FAT, NTFS, EXT) and provides granular access to files, metadata, deleted entries, and unallocated space. Tools like `fls`, `icat`, and `tsk_recover` allow listing files, extracting content, and recovering deleted items. TSK is ideal for scripting and automating analysis tasks in environments without a GUI.
- `Autopsy`: A GUI frontend for The Sleuth Kit that streamlines the analysis process through an intuitive interface. It supports timeline analysis, keyword searching, file carving, hash matching, and more. Autopsy is modular and extendable, offering numerous plugins to parse web artefacts, emails, and user activity. It’s an excellent free alternative to commercial tools, especially for initial triage and investigative workflows. *Note: This module has an upcoming room to explore Autopsy in depth with practical demonstrations and show the workflows involved in disk image analysis.*
- `EnCase Forensic`: A professional-grade commercial suite for digital investigations. EnCase offers a complete case management system, automated evidence processing, artefact detection, advanced filtering, bookmarking, and comprehensive reporting capabilities. It is widely used in law enforcement and corporate investigations due to its robustness and court-proven reliability.
- `FTK (Forensic Toolkit)`: Known for its indexing engine, FTK pre-processes data to enable rapid keyword searching, email analysis, and file filtering. It supports distributed processing and collaborative investigations, making it a strong candidate for large-scale cases or e-discovery scenarios.
- `Magnet AXIOM`: This commercial tool excels in evidence correlation and analysis across computers, mobile devices, and cloud data. AXIOM provides automated artefact extraction and presents data in an investigator-friendly timeline view, supporting both disk image and logical acquisition sources.

 Other tools, such as `Bulk Extractor`and **`X-Ways Forensics`,**  which we have not discussed in this task but can be used for disk analysis, are also available.

 Basic Workflow for Disk Image Analysis 
1. **Load the Disk Image** : Open the forensic tool of choice and import the disk image (E01, AFF, or raw).
2. **Run Initial Processing** : Allow the tool to parse the file system, identify artefacts, build indexes, and extract metadata.
3. **Conduct Artifact Analysis** : Use keyword searches, hash comparisons, registry parsing, web history recovery, and other artifact-specific modules.
4. **Recover Deleted Files** : Employ file carving or unallocated space analysis to recover deleted content.
5. **Bookmark and Report** : Tag relevant evidence, take notes, and generate reports with metadata and timelines.

 In the upcoming room on **Autopsy** , we will apply many of these steps using the Autopsy tool specifically, giving learners hands-on experience with this workflow.

 Techniques for Analysing Disk Images ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/5fc2847e1bbebc03aa89fbf2-1722850549362.png)

 **Mounting and Exploring Disk Images**

 Mounting a disk image creates a virtual representation of the original drive. This allows forensic analysts to explore file structures without altering the original image. Tools like FTK Imager or `Mount` (with loop devices on Linux) enable image mounting. To maintain integrity, always mount images in read-only mode or within a forensic environment.

 **Extracting Relevant Artefacts**

 This involves identifying key digital artefacts such as:

 
- User documents and downloads
- Registry entries (Windows)
- Application and system logs
- Email archives
- Browser history and cache
- Installed programs and executables

 Analysis techniques include keyword searching, parsing system logs, examining metadata, correlating timestamps, and reviewing recent activity modules.

 **Recovering Deleted Data**

 Deleted data can often be recovered if it has not been overwritten. File carving techniques scan disk images for known file headers and footers, reconstructing files from raw data. Tools like The Sleuth Kit, X-Ways, and Autopsy support recovery from unallocated space and provide functionality for identifying deleted items in various file systems.

 Associated Risks and Common Mistakes 
- **Data integrity** : Always verify an image's hash before and after analysis. Use write blockers during acquisition to prevent accidental modification. Log all actions taken.
- **Misinterpretation of data** : Correlate findings across different sources and tools to avoid false conclusions. Understand each tool's limitations.
- **Documentation** : Maintain detailed logs of your analysis steps, tool versions used, timestamps, extracted artefacts, and a secure chain of custody. Clear documentation supports the admissibility of evidence.

 Using the right tools, following structured workflows, and maintaining forensic soundness, investigators can effectively analyse cold systems, uncover critical evidence, and contribute meaningfully to digital investigations.

### **Answer the questions below**

**Question:** Using hash functions seeks to minimise risks associated with what element?

*Answer:* 

     data integrity

**Question:** What is the name of the documentation responsible for listing the forensic evidence and its accompanying responsibilities?

*Answer:* 

     chain of custody

---

## Task 5 | Practical

View SiteYou are a digital forensics analyst at Swiftspend Finance, a prominent financial institution that has experienced a significant data breach. You've been tasked with using what you've learned to assist them in performing forensic tasks. Deploy the static site by clicking the green"**View Site** " button attached to this task. After completing the task, you will be given a flag to submit below.

### **Answer the questions below**

**Question:** What flag do you receive after completing the Order of Volatility challenge?

*Answer:* 

     THM{729a68a1253a5f4c7126110c0c600740}

**Question:** What flag do you receive after completing the Chain of Custody challenge?

*Answer:* 

     THM{4de91692a4057c140d5a09875aba0431}

---

## Task 6 | Conclusion

Although this room introduces cold system forensics, the concepts covered apply to all areas of digital forensics. You can explore further by looking at the following rooms, which cover some in-depth concepts.

 
- [Legal Considerations in DFIR](https://tryhackme.com/r/room/dfirprocesslegalconsiderations)
- [Linux Forensics](https://tryhackme.com/r/room/linuxforensics)
- [Windows Forensics 1](https://tryhackme.com/r/room/windowsforensics1)

 Furthermore, be on the lookout for the release of the following rooms and challenges within the Disk Image Analysis module.

 
- [Forensic Imaging](https://tryhackme.com/r/room/forensicimaging)
- [Autopsy ](https://tryhackme.com/room/btautopsye0)
- [DiskFiltration](https://tryhackme.com/room/diskfiltration)
- [ExfilNode ](https://tryhackme.com/room/exfilnode)

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/5fc2847e1bbebc03aa89fbf2/room-content/5fc2847e1bbebc03aa89fbf2-1723063247221.png)

### **Answer the questions below**

**Question:** I'm ready to learn more about Disk Image Analysis.

*Answer:* 

     No answer needed

---

{% endraw %}
