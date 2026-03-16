---
layout: post
title: "TryHackMe  - Windows User Activity Analysis"
date: 2025-09-04
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Advanced Endpoint Investigations/Windows Endpoint Investigation"
identifier: "20250904T000005"
source_id: "b67373b0-bc20-48c6-a612-75fefd2a5fbd"
source_urls: "(https://tryhackme.com/room/windowsuseractivity)"
source_path: "Advanced Endpoint Investigations/Windows Endpoint Investigation/20250904T000005--tryhackme-windows-user-activity-analysis__tryhackme.md"
---


# TryHackMe | Windows User Activity Analysis

## Task 1 | Introduction

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/d099eaf94dd40990ca7956c610c4092d.png)

Windows artifacts are important pieces of digital evidence that provide an understanding of user activities on a computer. Regarding user activity, these artifacts provide extensive records of interactions involving file access, program execution, browsing history, and logging in or out.

 Understanding them is critical for any cyber security and digital forensic investigator as they can show trends, possible security breaches, or unlawful activities.

 Let's go through an investigation scenario to understand these artifacts, where they are located, and why they can be helpful in tracking down user activities during a forensics investigation.

 Incident Scenario: 36 hours of Rampage

 James, who works in the HR department of Cybertees Pvt Ltd, has a bad habit of writing everything down on a sticky note, including passwords, and placing it around his computer. Last week, when he returned on Monday, he felt some changes on his workstation with some files missing and suspicious tools already installed.

 CCTV footage showed an employee named Johny, who was working over the weekend and somehow got logged into his machine. He is suspected of having the plans and may have accessed the sensitive documents. It has also been found that he recently resigned and planned to move to the competitor company. A glance at the workstation reveals that he not only accessed the files but also deleted most of them and the tools he ran to remove the traces.

 In this room, our task as forensics investigators would be to track down his activities, the files he had accessed, the tools he had executed, etc., during those 36 hours.

 Learning Objectives Some of the learning objectives being covered in this room are:

 
- Understand the User's activity traces.
- Revisit Registry Concepts.
- Examine Registry Artifacts.
- Examine Shell Bags and its forensics value.
- Examine Jumplist and its forensics value.
- Explore LNK files and its forensics value.

 Prerequisites

 This room expects users to have a basic understanding of forensics. The following rooms provide a basic knowledge needed to move forward in this room:

 
- [Windows Forensics 1](https://tryhackme.com/jr/windowsforensics1)
- [Windows Forensics 2](https://tryhackme.com/jr/windowsforensics2)
- [Expediting Registry Analysis](https://tryhackme.com/r/room/expregistryforensics)

 Let's dive in.

### **Answer the questions below**

**Question:** Continue to the next task.

*Answer:* 

     No answer needed

---

## Task 2 | Lab Connection Instructions

Start MachineBefore moving forward, start the lab by clicking the `Start Machine` button. It will take 3-5 minutes to load properly. The VM will be accessible on the right side of the split screen. If the VM is not visible, use the blue `Show Split View` button at the top of the page.

  

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

    **Username**  administrator   **Password**  thm_4n6   **IP**  MACHINE_IP      This machine contains the artifacts extracted from the suspected machine, and all required forensics tools are placed on the Desktop.

 In this room, we will be investigating a live Windows machine. Although some artifacts can be viewed/examined on a live machine, extracting the artifacts before starting analyzing is recommended to avoid the unintentional tempering of the evidence, which could result in a different outcome. Key artifacts that we will need in this room are:

 
- Registry Hives
- Prefetch
- LNK Files (Shortcut Files)
- JumpLists

 FTK Imager is available in the lab to extract and analyze the artifacts offline.

### **Answer the questions below**

**Question:** Connect with the lab. How many tools / folders are in the EZ tools folder on the Desktop?

*Answer:* 

     12

---

## Task 3 | Revisiting Registry

The Registry provides a centralized location for storing configuration settings for the operating system, device drivers, services, and installed applications. It keeps track of the User's activities as well. Let's start our Windows artifacts investigation with the Windows Registry.

 Windows Registry

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/b767d15af1d889958bd1c6cea80c6e8d.png)

 The Windows Registry is a hierarchical database that stores all kinds of settings and configuration information for your Windows operating system, as well as for installed applications and user preferences. Think of it as the control centre for your computer's settings.

 The Windows Registry is stored in various Hive files, mainly in the `%SystemRoot%\System32\config` directory. The main Hive files are:

    Hive File Mapped Key Path Purpose     **SAM**  `HKLM\Local_Machine\SAM` The Security Account Manager stores user account and security policy data.   **SECURITY**  `HKLM\SECURITY`  Holds security-related configuration data, including user authentication and permissions.

    **SYSTEM**  `HKLM\SYSTEM` Stores system-related configuration data, including hardware, device drivers, and startup settings.   **SOFTWARE**  `HKLM\SOFTWARE`  Contains configuration information for installed software and system-wide settings.

    **DEFAULT**  `HKU\.DEFAULT`  Acts as a template for creating new user profiles, providing default settings for user-specific configuration.

    **NTUSER.DAT**  `HKCU`  Contains user-specific settings for each user profile, including user preferences and specific configurations.

    **USRCLASS.DAT**  `HKCU\Software\Class`  Stores user-specific configuration.

     

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/a3ffd2d6d35b7b0043008b4f546bfa8f.png)

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/fe921fcab27cd2c0392b1df3513b6a05.png)

 Registry Hives The Registry also has hives that contain a specific type of information, like user settings, system settings, and hardware configurations. Here are the main registry Hives:

    Hive Name Description     HKEY_CLASSES_ROOT Information about file associations and OLE object classes.   HKEY_CURRENT_USER Settings for the currently logged-in user.   HKEY_LOCAL_MACHINE System-wide settings and configurations. SAM Hive is mapped into `HKLM\Local_Machine\SAM`   HKEY_USERS Settings for all user profiles on the system.   HKEY_CURRENT_CONFIG Information about the current hardware profile.    To access the Registry Hives on a live system:

 
- Launch `regedit` via `Win + R.`
- For offline analysis, use **Registry Explorer,**  which enables both live and offline Hive inspection.

 ![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/1162914a389ad4ab3a19a2847a88191e.png)

 Dirty Hives and Transaction Logs Transaction logs are records of changes made to a database over time, while dirty Hives are parts of the Windows registry that haven't been properly closed after changes. Both are important in forensics for understanding system activity and potential security issues.

 Sometimes, when your computer shuts down unexpectedly, or the Registry gets messed up, the Hive files can become "dirty," meaning they're inconsistent. To prevent corruption, Windows uses transaction logs. These logs track changes to the registry Hives, allowing Windows to roll back changes if something goes wrong.

 The transaction logs are stored in the `C:\Windows\system32\config` directory alongside the Hive files. They have names like `SYSTEM.LOG1`, `SYSTEM.LOG2`, and so on.

 Transaction logs are usually hidden files. One of the ways to view them is to open the terminal and run the command `dir /a` to display all the files present in the folder, including the hidden files, as shown below:

 ![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/4b6b6a934d673d0e41a9df32b181197a.gif)

 From a forensics point of view, it is important to know if the Hives we are investigating are dirty and if there are transaction logs that we need alongside the dirty Hives for an accurate investigation.

 **Note:**

 In this room, we will review the Registry Hives in two ways:

 
1. The Registry Editor loads the Live Hive to review, edit, delete the key/values, etc.
2. Registry Explorer let's us analyse the registry Hives, both in Offline and Live mode.

 ![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/835c5259d33543b5ea0daa6b42947116.png)

 Run Registry Explorer as an administrator to analyse the Live Hives. Please wait 1-2 minutes for the program to run.

### **Answer the questions below**

**Question:** Which Hive stores information about installed software?

*Answer:* 

     SOFTWARE

**Question:** What is the current size of the SAM Hive in the attached lab? (In KB)

*Answer:* 

     128

---

## Task 4 | Performing Registry Forensics

As we know, the Windows Registry contains a lot of useful artefacts related to user activities, including program execution, file access, document history, USB device usage, network connections, and more. Analysing these artefacts can provide valuable insights into a user's behaviour and help uncover evidence of suspicious or unauthorised activity. Some of the key artefacts that could help in tracing user activities are covered below:

 Analysing TypedPaths Adversaries can use File Explorer to search for a path within the victim's machine. The `TypedPaths` Registry key within the `NTUSER.dat` hive can help us identify the directories searched or accessed through the file explorer's address bar. Highlighting the paths adversaries visited can provide context for their activities.

 The registry key is found under `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths` and it is meant to store paths typed into the **Run**  dialogue window or **File Explorer's**  address bar.

 For a forensic analyst, knowing what paths a user has typed into the **Run**  dialogue window or **File Explorer**  can reveal which folders or files they were looking for or accessing. This can provide context for their activities and help reconstruct their workflow.

 Searching anything on the Explorer's address bar will end up in the `TypedPaths` subkey of the HKCU Hive as evidence.

 ![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/275bbd7fdf0628fba9ff089a468e6970.png)

 Let's examine the paths that were typed by the suspect in the Registry Editor, as shown below:

 ![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/9545fcde37ef780394e843b3dbe0cd5a.png)

 The evidence indicates that the suspect was trying to access sensitive documents and tools. One of the paths with the `tmp` directory also looks suspicious, as this does not exist on a normal C Drive.

 Analysing WordWheel Query Adversaries can use the search option in File Explorer to look for a certain tool or file within the system. WordWheel Query can keep track of all the terms that are searched in Explorer. Which can provide an insight into what the suspect is looking for.

 The registry key falls under `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery`.

 Searching anything using the search option of Explorer's address bar will end up in the `WordWheelQuery` subkey of the HKCU Hive as evidence.

 ![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/2c97031492cae447d6d42ced5cf2de40.png)

 Let's examine the WordWheelQuery in the Registry Editor and see what Johnny has been searching for on this machine. Well, the output looks like some gibberish values. It is because some values in the Registry are either encoded or presented in **hex values** , as shown below:

 ![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/8430269a696d5542b9a42f3d32aee839.png)

 The clear version can be viewed in the Registry Explorer. As we know, the `NTUser.dat` Hive is mapped into the **Current User Hive** . We will open the `NTUser.dat` Hive and go to the path mentioned above, or click on WordWheelQuery from the available bookmarks.

 ![Image 13](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/7227aaf818f06fd2bf4a5b40b73b7b8b.png)

 Clicking on the WordWheelQuery will open the results, as shown below:

 ![Image 14](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/48a6dd979856a329bea738175ae580a9.png)

 The values in WordWheelQuery indicate what he has searched for in the system, as it is evident that the latest search was about the tool to clean up the disk or remove the evidence.

 Analysing RecentDocs An adversary may intend to get hold of sensitive documents that could compromise critical data. RecentDocs artefacts keep track of the documents recently accessed on the system.

 The artefacts can be found under the registry key `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs`. RecentDocs contains information about recently accessed documents. It stores entries representing recently opened files, providing insight into the user's recent document activity.

 For forensics, analysing RecentDocs entries can reveal the documents the user has been working with, aiding in reconstructing their recent activities and identifying relevant files for the investigation.

 Let's examine the RecentDocs key live on the Registry Editor. The result shows the values in **hex** , which is not readable, as shown below:

 ![Image 15](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/3eb159ec5214b21810e9e690bd5ffa83.png)

 Let's use the Registry Explorer again to view the RecentDocs key values. It seems to be a critical artifact as it contains a list of files, documents, and folders accessed on this machine.

 ![Image 16](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/e5d4c9172b9ef3745688fecd6268de06.png)

 From the evidence, the intention of the Johnny is becoming clear. It looks like he has accessed many sensitive documents from different locations. Note down the sensitive and suspicious documents/files accessed by the suspect.

 Analysing Comdlg32 (Common dialogue Box) Comdlg32 (Common dialogue Box) is a very important artifact to keep track of the last file accessed or where the previous file was saved.

 The "CommonDlg" registry contains information about the Common dialogue box used on Windows operating systems. This dialogue box is commonly used by applications to allow users to browse and select files or folders.

 ![Image 17](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/726eaf7d6ef6cb31094b65af62d7dca0.png)

 Two main details it contains are:

 1) LastVisitedMRU 
- The  `LastVisitedPIdl MRU`  (Most Recently Used) artifact is another aspect of the Windows Registry that holds significant forensic value. This artifact specifically keeps track of the paths to the folders you've most recently visited on your system.
- This registry is found under the key path `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedMRU`
- The LastVisitedMRU registry keeps track of the most recently visited locations in File Explorer. It contains entries representing folder paths the user has navigated to or accessed.
- Examining LastVisitedMRU entries can help reconstruct the user's file navigation history, track their movements within the file system, and identify recently accessed folders of interest.

 ![Image 18](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/40ddf31b101e68ebe0e8582de5ddebb8.png)

 2) OpenSaveMRU 
- The `OpenSavePidlMRU` artifact refers to a part of the Windows Registry that stores information about the most recently accessed or saved files and folders. One would be able to identify which files were accessed last from which location and which files were saved last at which location.
- The artifact can be located under the registry path `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU`.

 ![Image 19](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/e7d47cb4c2b25ed03cf397cc42894437.png)

 Looking at the evidence, it seems the suspect, Johnny, had access to some critical files related to account details.

 User Assist When the adversary runs a tool, either a via the directory or through a shortcut file, it leaves a footprint on the Registry Hive key. This key is called `UserAssist`, and it can help identify if any suspicious tools have been executed on the system by the suspect.

 The registry path for the key is found under `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist`.

 UserAssist records the usage of programs and files, including those accessed via the **Start Menu**  or shortcuts. It contains entries representing user interactions with applications and files, including execution counts and last accessed timestamps.

 In forensic investigations, UserAssist entries can help reconstruct the user's interactions with the system, identify frequently used applications, and uncover any unusual or unauthorised activities.

 UserAssist keeps track of the GUI-based programs accessed by the users. It has two important GUIDs to note:

 
1. `{CEBFF5CD-ACE2-4F4F-9178-9926F41749EA}`:

 
- This GUID is associated with Windows Explorer and tracks user interactions with files and folders.
2. `{F4E57C4B-2036-45F0-A9AB-443BCFE33D9F}`:

 
- This GUID is associated with shortcut files or extensions like .LNK used to execute the programs.

 Let's examine the NTUser.dat UserAssist key hive in Registry Explorer and see what tools Johnny has recently executed on the system.

 ![Image 20](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/dda59d5a8e3f54427ee1a6500a299fdb.png)

 It is important to note that the UserAssist key provides us with the following key information about the program execution:

 
- Name of the program executed.
- The number of times it was executed.
- Last executed.
- Focus time.

 The evidence suggests that he executed a few hacking-related tools, including a network sniffing tool and another one used to clear the evidence from the system. It looks like the suspect accessed the critical files and tried to clear these traces.

 Analysing RunMRU Adversaries tend to use the run dialogue box to run tools/commands on the system, and it can also help us determine the suspect's intentions.

 The registry RunMRU registry key can be found under `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU`. RunMRU stores information about the most recently executed programs via the **Run**  dialogue window, as shown below:

 ![Image 21](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/179e9be2ea348c858c15e6a8fca475fe.png)

 Let's use the Registry Editor to see what command Johnny ran through the run dialogue.

 ![Image 22](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/ff0721a4208da86f51ee414e91f846cb.png)

 The evidence above shows Johnny's list of commands through the run dialogue. This could be very handy information from the forensics point of view. The value `dcba` shows the order in which the commands were entered, `d` being the latest one, as clearly shown.

 In this task, we explored some key activities associated with the suspect within the Registry Hives. This activity gives us a good understanding of the user's intentions and actions.

 Examine the live host and answer the following questions.

### **Answer the questions below**

**Question:** The suspect typed a suspicious path in the Windows Explorer, that points to a tmp directory in C drive. What is the full path?

*Answer:* 

     C:\system\home\tmp

**Question:** In the WordWheelQuery search, what was the latest term searched by the user?

*Answer:* 

     wipe

**Question:** Where was the last text file saved by the suspect?

*Answer:* 

     C:\system\home\tmp\code.txt

**Question:** From the Hacking-tools folder, which suspicious key logging tool was executed 5 times?

*Answer:* 

     keylogger.exe

**Question:** Which Disk Wiping utility was executed on this host?

*Answer:* 

     DiskWipe.exe

---

## Task 5 | ShellBags: Navigating the Past

Microsoft created various services/ways to enhance the user experience by storing how users interact with the files and folders, how they are customized, etc. In doing so, Microsoft favoured forensics investigators by providing a wealth of information to track and trace down user's activities. **ShellBags**  are one of those artifacts.

![Image 23](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/283835974141b7b09dbc7c6cc6947a7a.svg)

 From a forensic standpoint, ShellBag artifacts are incredibly valuable. They're like silent witnesses to a person's activity on a computer. Even if someone deletes files or folders or thinks they've covered their tracks, these artifacts can still be there, telling investigators which folders were accessed, when, and how they were viewed.

 This table outlines the primary registry files and paths where shell bag artifacts are located and briefly describes what each location entails. On the local disk, the location of these registry files are:

 The two key hives associated with the user's activities are stored in the following locations

 
- **NTUser.dat** :`%USERPROFILE%\NTUSER.dat`
- **USRCLASS.dat** : `%USERPROFILE%\AppData\Local\Microsoft\Windows\UsrClass.dat`

 ![Image 24](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/cbfacec027df276af46d8d3467e890a9.png)

 **Examining ShellBags through Registry Editor**

 The main Registry Hive that contains information about the Shellbags is `UsrClass.dat`, which is plugged into `Computer\HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell`, as shown below:

 ![Image 25](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/eb52b3530f9fa7ddd5880fe7e938ff4a.png)

 **Examining ShellBags through ShellBags Explorer**

 To investigate the files and folders Johnny accessed, we will use the tool Shellbags Explorer. Follow the steps mentioned below:

 
- Let's open `ShellBags Explorer` with administrator permissions from the path `C:\Users\Administrator\Desktop\EZ tools\ShellBagsExplorer`. This tool lets us explore the shellbags from the live system and the offline files.

 ![Image 26](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/9eaffbc6a592d0699450115dd203c827.png)

 
- Select the `Load active registry` option to load the live Hive from the system, as shown below:

 ![Image 27](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/26facfca69cd417878cc5511a09f2986.png)

 We can examine each directory, setting, network share, etc, accessed by the user, as shown below:

 ![Image 28](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/9f560dcc8c9b9e864efeef011293d8be.png)

 The evidence shows that the user accessed two network shares from this host. One of them further contains three shared folders.

 ![Image 29](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/ecf0a53b824b1ed01d2a42ecce013da7.png)

 The evidence clearly shows that Johnny accessed two network shares with existing tools. He copied and executed the tools from the network share on the host. He also accessed directories that contained confidential documents. His activities provide a clear picture of his intentions.

 **Key Information in ShellBags**

 ShellBags provides so much critical information that could aid our investigation. A summary of the key points about the information they contain:

 
- **Folder View Settings** : ShellBags record how a user has viewed a particular folder, such as the view mode (e.g., list, icons, details).
- **Folder Paths** : They keep track of the paths of accessed directories, including those on external devices or network shares.
- **Timestamps** : ShellBags store timestamps indicating when a folder was first created, last accessed, and possibly modified.
- **User Preferences** : Includes details like the position of icons, window size, and sort order in a folder.
- **Deleted Folders** : Interestingly, ShellBags can retain information about folders that have been deleted, which can be valuable for forensic investigations.
- **Network and External Drive Access** : They also log folders accessed on external drives and network locations, providing a history of external and network storage use.
- **Windows Version Specifics** : The structure and information in shellbags can vary depending on the version of Windows being used.

 In this task, we learned that shellbags are a feature of the Windows operating system that stores metadata about the browsing history and settings of folders accessed via the Windows Explorer shell. This information can be valuable in forensic investigations for reconstructing a user's file system activity and understanding their behaviour on the system.

 Examine the ShellBags and answer the following questions.

### **Answer the questions below**

**Question:** What is the IP address of the Network Share, where the user accessed three folders?

*Answer:* 

     10.10.17.228

**Question:** What is the name of the second sub-folder within the Documents folder of the network share that the user accessed?

*Answer:* 

     secret-doc

---

## Task 6 | LNK Files - Shortcut

A LNK file, commonly known as a shortcut file, is essentially a pointer or reference to an actual file or application stored elsewhere on a computer or a network. It’s a bit like a signpost that says, “Hey, what you’re looking for is over there.” These LNK files are created in Windows operating systems when you shortcut an application, document, or other resources.

![Image 30](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/9e0ec5393090346d0f940a313a7a1405.svg)

 LNK Files Location
 When we create or access any file, Windows creates an LNK or shortcut file. A few of the default paths to store shortcut files are:

 
- `%userprofile%\AppData\Roaming\Microsoft\Windows\Recent`
- `%userprofile%\recent`

 If we go to the path mentioned above, we can see the files and folders we have accessed in the past. These files are the shortcut files that were created when the user accessed those files.

 ![Image 31](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/a2742e4bf4ec11d4a789b40698f4d182.png)

 Analysing a LNK file To examine the files accessed by the suspect, we will examine the LNK files created as a result using a tool called `LECmd.exe`. Please navigate to the `EZ tools` folder on the Desktop, where `LEcmd.exe` is located.

 We will use this tool to examine one of the latest accessed PDF documents that Johnny accessed from the Network-share drive.

 Let’s use the above knowledge to analyse the LNK file we created earlier for the first file present in the recent directory, as shown below:

 ![Image 32](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/b15dff2da4d44097e608f922ebc1983b.png)

 By looking at the output, we can see the bulk of information that could be critical from a forensics point of view. It seems like Johnny had the documents in his network share. He connected to the shared and accessed the PDF document, indicating his malicious intentions.

 Analysing the Output

 An [LNK]() file contains various pieces of information that can be valuable in a forensic investigation:

 
- Name of the file accessed.
- When the file was accessed.
- What was the target path from where it was accessed?
- Network share name.
- Accessed from the hard drive
- File size.

 Now that we have examined the shortcut file of one of the recently accessed documents, it is time to look at the other LNK files and see what critical files were accessed and when.

### **Answer the questions below**

**Question:** What is the document that was last opened by the user on this machine?

*Answer:* 

     10_ways_to_Exfiltrate_Data.pdf

**Question:** Analyzing the code.lnk file shows that it was accessed from the network 
shared drive. What is the full path of the network directory?

*Answer:* 

     \\10.10.17.228\Users\Administrator\Documents\secret-documents

---

## Task 7 | JumpList: Leap Through Time

Jump Lists are a very useful feature on Windows, starting from Windows 7 and continuing in later versions. They keep track of the documents we open frequently, the websites we often visit, and the tasks we do regularly with specific applications. They pop up in the Taskbar and Start Menu, making it easy to pick up where we left off.

 Forensics Value Regarding digital forensics, `Jump Lists` are like a diary of your computer's activities, noting which files were opened, what apps were used, and which websites were visited. This information is incredibly useful in various situations, like figuring out someone's computer habits, finding evidence in legal cases, or investigating cybercrimes.

 Jump Lists keep their records in two types of files:

 
1. **AutomaticDestinations** : These are tied to specific applications and hold details about the many items you use, automatically adding them to the Jump List.
2. **CustomDestinations** : These come into play when an app manually adds items to its Jump List, like specific tasks or features.

 Location of the Artifact They're usually in directories like this:

 
- `%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations`

 ![Image 33](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/129f83a8599399ce4f90fc4ccc52d861.png)

 
- `%APPDATA%\Microsoft\Windows\Recent\CustomDestinations`

 ![Image 34](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/9f912a0f8be14ec7cc9a12af03f2ac69.png)

 But here's the catch: The file names are usually hashed, so it's not always obvious which app they belong to. This is to preserve data integrity and for investigators to verify that the file hasn't been tampered with. The tools we will use will automatically decode it for us.

 Analysing Jump Lists

 On the Taskbar, right-click the Adobe Application; JumpList will show the recently opened text documents. We will use JumpList Explorer to locate and analyse the recently accessed PDF documents by the suspect.

 ![Image 35](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/7425772089fb93b0768ba39deb2c6740.png)

 Launch the JumpList Explorer tool from the path. `C:\Users\Administrator\Desktop\EZ tools\JumpListExplorer`.

 ![Image 36](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/8682708c5cd4b23d4bd854f621bbe3a6.gif)

 Layout of the Tool

 The tool has different sections, as shown below. Each of them is explained below:

 ![Image 37](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/74c53bd4c662f6e42416cd4fbfe6ca26.png)

 
1. This section contains the Jump List files loaded. Clicking on any file will expand its details further in the other sections. Each file represents a single application.
2. This section contains the list of Jump List files accessed by the user and present in the particular application.
3. This section further expands the metadata about the Jump List file, including the timestamp, when it was accessed, the target file's absolute path, etc. 
- Clicking on the `secret-document.txt` file further shows more details about the file, as shown below:

![Image 38](https://tryhackme-images.s3.amazonaws.com/user-uploads/5e8dd9a4a45e18443162feab/room-content/4a763892b235f8b64d11c21ad85d52b1.png)
4. As already discussed earlier, each application is represented by a unique `AppID`. This section displays the AppID and the application name we are dealing with.

 Understanding the Output

 We examined the Jump Lists and understood the critical values it provides. The following points were extracted from the analysis:

 
- It includes the list of the recently accessed files.
- When these files were accessed.
- The absolute path of the accessed files.
- List of the documents accessed from the network share.
- Sensitive text and PDF documents were accessed.
- How many times those files were accessed.

### **Answer the questions below**

**Question:** A text file named code.txt was accessed from a tmp directory. What is the full path of the tmp directory?

*Answer:* 

     C:\system\home\tmp\code.txt

**Question:** What URL was accessed using Internet Explorer?

*Answer:* 

     http://10.10.17.228/

**Question:** When did the user access the "How to Hack.pdf" file?

*Answer:* 

     2024-03-04 12:28:26

---

## Task 8 | Conclusion

We examined various Windows artifacts in this room and confirmed that the Windows Operating system was spying on us. It keeps track of our activities, mostly not for forensics purposes but to assist users in improving user experience. But at the same time, the metadata contained by those artifacts can reveal a lot about user activities, intentions, etc.

 In this room, we learned the following:

 
- Explored Registry Hives.
- We analyzed various artifacts related to user activities in the Registry.
- Other Windows artifacts include ShellBags, LNK files, and Jump Lists.

 You can learn more about forensics in the following upcoming rooms:

 
- [Windows User Account Forensics](https://tryhackme.com/r/room/windowsuseraccountforensics)
- [Windows Applications Forensics](https://tryhackme.com/r/room/windowsapplications)
- [Secret Recipe](https://tryhackme.com/room/registry4n6)

### **Answer the questions below**

**Question:** Continue to complete the room.

*Answer:* 

     No answer needed

---
