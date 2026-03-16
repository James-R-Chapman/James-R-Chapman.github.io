---
title:      "Retracted"
date:       2025-02-12T00:00:00-05:00
tags:       ["tryhackme"]
identifier: "20250212T000003"
Hubs: "TryHackMe/SOC Level 1/Endpoint Security Monitoring"
urls: (https://tryhackme.com/room/retracted)
id: 63884709-06b8-42f4-8624-981372fda9a0
---

# Retracted

# Task 1 | Introduction

Start MachineA Mother's Plea

"Thanks for coming. I know you are busy with your new job, but I did not know who else to turn to."

"So I downloaded and ran an installer for an antivirus program I needed. After a while, I noticed I could no longer open any of my files. And then I saw that my wallpaper was different and contained a terrifying message telling me to pay if I wanted to get my files back. I panicked and got out of the room to call you. But when I came back, everything was back to normal."

"Except for one message telling me to check my Bitcoin wallet. But I don't even know what a Bitcoin is!"

"Can you help me check if my computer is now fine?"

Connecting to the Machine

Start the virtual machine in split-screen view by clicking on the green "Start Machine" button on the upper right section of this task. If the VM is not visible, use the blue "Show Split View" button at the top-right of the page. Alternatively, you can connect to the [VM]() using the credentials below via "Remote Desktop".

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

UsernamesophiePasswordfluffy1960IPMACHINE_IP"Oh, the password doesn't work? Wait, I have it written somewhere. Uhmm... Try this:"

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

UsernamesophiePasswordfluffy19601234!IPMACHINE_IPAnswer the questions belowI'll handle it, Mom.Correct Answer

### **Answer the questions below**

**Question:** I'll handle it,  Mom.

*Answer:* 

     No answer needed

---

# Task 2 | The Message

"So, as soon as you finish logging in to the computer, you'll see a file on the desktop addressed to me."

"I have no idea why that message is there and what it means. Maybe you do?"

Answer the questions belowWhat is the full path of the text file containing the "message"?Correct AnswerWhat program was used to create the text file?

Correct AnswerWhat is the time of execution of the process that created the text file? Timezone UTC (Format YYYY-MM-DD hh:mm:ss)

Correct Answer

### **Answer the questions below**

**Question:** What is the full path of the text file containing the "message"?

*Answer:* 

     C:\Users\Sophie\Desktop\SOPHIE.txt

**Question:** What program was used to create the text file?

*Answer:* 

     notepad.exe

**Question:** What is the time of execution of the process that created the text file? Timezone UTC (Format YYYY-MM-DD hh:mm:ss)

*Answer:* 

     2024-01-08 14:25:30

---

# Task 3 | Something Wrong

"I swear something went wrong with my computer when I ran the installer. Suddenly, my files could not be opened, and the wallpaper changed, telling me to pay."

"Wait, are you telling me that the file I downloaded is a virus? But I downloaded it from Google!"

Answer the questions belowWhat is the filename of this "installer"? (Including the file extension)Correct AnswerWhat is the download location of this installer?Correct AnswerThe installer encrypts files and then adds a file extension to the end of the file name. What is this file extension?

Correct AnswerThe installer reached out to an IP. What is this IP?

Correct Answer

### **Answer the questions below**

**Question:** What is the filename of this "installer"? (Including the file extension)

*Answer:* 

     antivirus.exe

**Question:** What is the download location of this installer?

*Answer:* 

     C:\Users\Sophie\download

**Question:** The installer encrypts files and then adds a file extension to the end of the file name. What is this file extension?

*Answer:* 

     .dmp

**Question:** The installer reached out to an IP. What is this IP?

*Answer:* 

     10.10.8.111

---

# Task 4 | Back to Normal

"So what happened to the virus? It does seem to be gone since all my files are back."

Answer the questions belowThe threat actor logged in via RDP right after the “installer” was downloaded. What is the source IP?

Correct AnswerThis other person downloaded a file and ran it. When was this file run? Timezone UTC (Format YYYY-MM-DD hh:mm:ss)

Correct Answer

### **Answer the questions below**

**Question:** The threat actor logged in via RDP right after the “installer” was downloaded. What is the source IP?

*Answer:* 

     10.11.27.46

**Question:** This other person downloaded a file and ran it. When was this file run? Timezone UTC (Format YYYY-MM-DD hh:mm:ss)

*Answer:* 

     2024-01-08 14:24:18

---

# Task 5 | Doesn't Make Sense

"So you're telling me that someone accessed my computer and changed my files but later undid the changes?"

"That doesn't make any sense. Why infect my machine and clean it afterwards?"

"Can you help me make sense of this?"

Arrange the following events in sequential order from 1 to 7, based on the timeline in which they occurred.

Answer the questions belowSophie ran out and reached out to you for help.Correct AnswerSophie downloaded the malware and ran it.

Correct AnswerA note was created on the desktop telling Sophie to check her Bitcoin.Correct AnswerThe intruder downloaded a decryptor and decrypted all the files.

Correct AnswerThe malware encrypted the files on the computer and showed a ransomware note.Correct AnswerSomeone else logged into Sophie's machine via RDP and started looking around.

Correct AnswerWe arrive on the scene to investigate.

Correct Answer

### **Answer the questions below**

**Question:** Sophie ran out and reached out to you for help.

*Answer:* 

     3

**Question:** Sophie downloaded the malware and ran it.

*Answer:* 

     1

**Question:** A note was created on the desktop telling Sophie to check her Bitcoin.

*Answer:* 

     6

**Question:** The intruder downloaded a decryptor and decrypted all the files.

*Answer:* 

     5

**Question:** The malware encrypted the files on the computer and showed a ransomware note.

*Answer:* 

     2

**Question:** Someone else logged into Sophie's machine via RDP and started looking around.

*Answer:* 

     4

**Question:** We arrive on the scene to investigate.

*Answer:* 

     7

---

# Task 6 | Conclusion

"Adelle from Finance just called me. She says that someone just donated a huge amount of bitcoin to our charity's account!"

"Could this be our intruder? His malware accidentally infected our systems, found the mistake, and retracted all the changes?"

"Maybe he had a change of heart?"

Answer the questions belowYeah, possibly.Complete

### **Answer the questions below**

**Question:** Yeah, possibly.

*Answer:* 

     No answer needed

---

