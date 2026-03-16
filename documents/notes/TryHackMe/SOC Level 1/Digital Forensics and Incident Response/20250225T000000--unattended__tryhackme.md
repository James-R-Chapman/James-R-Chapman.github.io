---
title:      "Unattended"
date:       2025-02-25T00:00:00-05:00
tags:       ["tryhackme"]
identifier: "20250225T000000"
Hubs: "TryHackMe/SOC Level 1/Digital Forensics and Incident Response"
urls: (https://tryhackme.com/room/unattended)
id: 8abaff32-d39f-4270-9b5f-4fd48d83bc1f
---

# Unattended

# Task 1 | Introduction

Start MachineWelcome to the team, kid. I have something for you to get your feet wet.Our client has a newly hired employee who saw a suspicious-looking janitor exiting his office as he was about to return from lunch.
I want you to investigate if there was user activity while the user was away **between** **12:05 PM to 12:45 PM on the 19th of November 2022** . If there are, figure out what files were accessed and exfiltrated externally.

You'll be accessing a live system, but use the disk image already exported to the `C:\Users\THM-RFedora\Desktop\kape-results\C` directory for your investigation. The link to the tools that you'll need is in `C:\Users\THM-RFedora\Desktop\tools`

Finally, I want to remind you that you signed an NDA, so avoid viewing any files classified as top secret. I don't want us to get into trouble.

Connecting to the machine

Start the virtual machine in split-screen view by clicking on the green "Start Machine" button on the upper right section of this task. If the VM is not visible, use the blue "Show Split View" button at the top-right of the page. Alternatively, you can connect to the [VM]() using the credentials below via "Remote Desktop".

  

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

   **Username** THM-RFedora **Password** Passw0rd! **IP** 10.10.66.237    ***Note:** Once the VM is fully running, please run Registry Explorer immediately, as this tool may take a few minutes to fully start up when executing the program for the first time.*

### **Answer the questions below**

**Question:** Connect to the machine and continue to the next task

*Answer:* 

     No answer needed

---

# Task 2 | Windows Forensics review

Download Task FilesPre-requisitesThis room is based on the [Windows Forensics 1](https://tryhackme.com/room/windowsforensics1) and [Windows Forensics 2](https://tryhackme.com/room/windowsforensics2) rooms. A cheat sheet is attached below, which you can also download by clicking on the blue `Download Task Files` button on the right.

 To better understand how to perform forensics quickly and efficiently, consider checking out the [KAPE room](https://tryhackme.com/room/kape).

Good luck!

### **Answer the questions below**

**Question:** Let's do this!

*Answer:* 

     No answer needed

---

# Task 3 | Snooping around

Initial investigations reveal that someone accessed the user's computer during the previously specified timeframe.

Whoever this someone is, it is evident they already know what to search for. Hmm. Curious.

### **Answer the questions below**

**Question:** What file type was searched for using the search bar in Windows Explorer?

*Answer:* 

     .pdf

**Question:** What top-secret keyword was searched for using the search bar in Windows Explorer?

*Answer:* 

     continental

---

# Task 4 | Can't simply open it

Not surprisingly, they quickly found what they are looking for in a matter of minutes.

Ha! They seem to have hit a snag! They needed something first before they could continue.

***Note:** W* *hen using the Autopsy Tool, you can speed up the load times by only selecting "Recent Activity" when configuring the Ingest settings.*

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/fda88f43a1c03a9959249945f061094a.png)

******

******

### **Answer the questions below**

**Question:** What is the name of the downloaded file to the Downloads folder?

*Answer:* 

     7z2201-x64.exe

**Question:** When was the file from the previous question downloaded? (YYYY-MM-DD HH:MM:SS UTC)

*Answer:* 

     2022-11-19 12:09:19 UTC

**Question:** Thanks to the previously downloaded file, a PNG file was opened. When was this file opened? (YYYY-MM-DD HH:MM:SS)

*Answer:* 

     2022-11-19 12:10:21

---

# Task 5 | Sending it outside

Uh oh. They've hit the jackpot and are now preparing to exfiltrate data outside the network.

There is no way to do it via USB. So what's their other option?

### **Answer the questions below**

**Question:** A text file was created in the Desktop folder. How many times was this file opened?

*Answer:* 

     2

**Question:** When was the text file from the previous question last modified? (MM/DD/YYYY HH:MM)

*Answer:* 

     11/19/2022 12:12

**Question:** The contents of the file were exfiltrated to pastebin.com. What is the generated URL of the exfiltrated data?

*Answer:* 

     https://pastebin.com/1FQASAav

**Question:** What is the string that was copied to the pastebin URL?

*Answer:* 

     ne7AIRhi3PdESy9RnOrN

---

# Task 6 | Conclusion

At this point, we already have a good idea of what happened. The malicious threat actor was able to successfully find and exfiltrate data. While we could not determine who this person is, it is clear that they knew what they wanted and how to get it.

I wonder what's so important that they risked accessing the machine in-person... I guess we'll never know.

Anyways, you did good, kid. I guess it was too easy for you, huh?

### **Answer the questions below**

**Question:** Let's see if you can handle the next one.

*Answer:* 

     No answer needed

---

