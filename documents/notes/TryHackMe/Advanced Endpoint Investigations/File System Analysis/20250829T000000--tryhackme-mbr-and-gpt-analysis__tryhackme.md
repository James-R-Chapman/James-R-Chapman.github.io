---
title: TryHackMe  - MBR and GPT Analysis
date:       2025-08-29T00:00:00-04:00
tags:       ["tryhackme"]
identifier: 20250829T000000
Hubs: "TryHackMe/Advanced Endpoint Investigations/File System Analysis"
URLs: (https://tryhackme.com/room/mbrandgptanalysis)
id: eb79d056-ae07-4fe0-9256-d45a0d31c7fa
---

# TryHackMe | MBR and GPT Analysis

## Task 1 | Introduction

Imagine your disk as a large building storing all the data. This data is stored in binary format, as 1s and 0s, for the computers to understand. The challenge here is that without properly organizing this data, it would be a mess in the whole disk. To solve this problem, the disk is divided into multiple partitions, just like rooms in the building, and each partition contains specific data. For example, operating system files can be stored in one partition, personal files can be stored in another, etc. In the Windows OS, these partitions are represented by drive letters such as **C** , **D** ,**E** , etc. Other operating systems may use different ways to refer to these partitions.

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110541741.svg)

 This solves the problem of organizing the data on the disk. However, the computer still needs a map that helps guide it through these partitions, where they start and end, and what they contain. **MBR**  (Master Boot Record) and **GPT**  (GUID Partition Table) are different partitioning schemes that act as a map for all of the partitions used in the disk. They are like a blueprint of the building (disk) containing all the rooms (partitions). Both partitioning schemes differ in structure and properties, and choosing between them depends on multiple factors, including the disk size, hardware compatibility, and much more. The MBR/GPT is located in the very first sector of the disk and contains information about the structure and partitions of the disk. It also plays a key role during the boot process of a system. Due to this, the MBR/GPT has become an attractive target for attackers to manipulate the boot process by embedding their malware, often known as Bootkits, or tampering with them to make the system un-bootable.

 In this room, you will learn the boot process of a system and the role of the MBR/GPT partitioning schemes during this process. You will also explore some attacks on both partitioning schemes and solve practical scenarios to identify and resolve these attacks.

 Learning Objectives 
- Explore the Boot Process
- Understand the Structure of the MBR
- Understand the Structure of the GPT
- Learn the Attacks on the MBR/GPT
- Get Hands-On Practical Scenarios

**Note:**  This room contains a non-guided challenge in Tasks 5 and 7.

### **Answer the questions below**

**Question:** What are the separate sections on a disk known as?

*Answer:* 

     partitions

**Question:** Which type of malware infects the boot process?

*Answer:* 

     bootkits

---

## Task 2 | Boot Process

The boot process wakes up the whole system. It starts by initializing the system's hardware components, loading the operating system into memory, and finally allowing the user to interact with the system. In this task, we will cover the start of the boot process before the role of the MBR/GPT. The aim is to understand the basic booting of a system before we dive into the structure of the MBR/GPT and explore their forensic value.

The overall boot process of a system has multiple steps, as can be seen in the flow diagram below:

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110666165.svg)

 Power-On the System The first step of the boot process starts with pushing the power button, which sends electrical signals to the motherboard and initializes all the components. The CPU  is the first component to get the electrical signals and needs some instructions to move further. The CPU fetches and executes these instructions from a chipset deployed on the motherboard. This chipset is known as BIOS/UEFI, and it contains instructions on how to get the boot process going.

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110666101.svg)

 **BIOS**  (Basic Input/Output System) and **UEFI**  (Unified Extensible Firmware Interface) are responsible for verifying whether all the hardware components work properly. A system can either use BIOS or UEFI firmware. The difference between them lies in their capabilities and features.

 
- **BIOS** has been used for decades and is still used in some hardware. It runs in the basic 16-bit mode and supports only up to 2 terabytes of disks. The most important thing to note is that BIOS supports the MBR partitioning scheme, which we will discuss later in the task.
- **UEFI** came as a replacement for BIOS, offering 32-bit and 64-bit modes with up to 9 zettabytes of disks. UEFI offers a secure boot feature to ensure integrity during the system boot process. It also offers redundancy, allowing us to recover from the backup even if the boot code is corrupted. UEFI uses a GPT partitioning scheme, unlike the MBR partitioning scheme used by BIOS.

There are several ways to check if your system uses BIOS or UEFI firmware. The process can be different depending on the operating system you use. For the Windows OS, first open the Run dialog box by pressing `Windows+R` . Type `msinfo32` in this dialog box and press enter. This will show you the system summary. If it is running BIOS, the field named **BIOS Mode**  would be shown as the **Legacy** . Otherwise, it would be **UEFI** .

![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1731683551194.png)

 Power-On-Self-Test (POST) The system is now powered on, and the CPU has executed instructions from the firmware (BIOS/UEFI) installed. The BIOS/UEFI then starts a Power-On-Self-Test to ensure all the system’s hardware components are working fine. You may hear a single or multiple beeps during this process in your system; this is how the BIOS/UEFI communicates any errors in the hardware components and displays the error message on the screen, e.g., keyboard not found.

![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110666092.svg)

 Locate the Bootable Device After the BIOS/UEFI has performed the POST check, it is time for the BIOS/UEFI to locate bootable devices, such as SSDs, HDDs, or USBs, with the operating system installed. Once the bootable device is located, it starts reading this device. Now, here comes the role of the **MBR/** **GPT** . The very first sector of the device would either contain the MBR (Master Boot Record) or the GPT (GUID Partition Table). The MBR/GPT would be taking control of the boot process from here. In the upcoming tasks, we will see how the boot process propagates from here if the MBR partitioning scheme is used and what happens if it is GPT instead.

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110666094.svg)

**Note:** The method of checking your disk's partitioning scheme will differ for different operating systems. For the Windows OS, you can type `Get-Disk` in your PowerShell terminal, and it will show the partitioning schemes of the disks on your system.

The first 3 steps of the boot process that we discussed in this task were the initial steps to find the bootable disk on which the OS resides. From the first task, we imagined this disk as a building where all our data is stored, and there are multiple rooms (partitions) in this building. The next step of the boot process would be to get the map of this building. This map would be either MBR or GPT.

### **Answer the questions below**

**Question:** What is the name of the hardware diagnostic check performed during the boot process?

*Answer:* 

     Power-On-Self-Test

**Question:** Which firmware supports a GPT partitioning scheme?

*Answer:* 

     UEFI

**Question:** Which device has the operating system to boot the system?

*Answer:* 

     bootable device

---

## Task 3 | What if MBR?

Starting the Machine Let’s start the virtual machine by pressing the **Start Machine**  button below. The machine will start in split view.

 Start Machine In case the VM is not visible, use the blue **Show Split View**  button at the top of the page. You can also connect with the machine via your own VPN-connected machine using the RDP credentials below:

  

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

    **Username**  Administrator   **Password**  bootforensics@001   **IP**  MACHINE_IP      Analyzing the MBR In the previous task, we learned about the boot process, from when the computer powers on till the bootable device is located. In this task, we will assume that the bootable device found uses the MBR partitioning scheme. MBR has been used for decades and is now replaced by the GPT in modern systems. However, it is important to learn the MBR as it is still used in some systems.

 The bootable device, which was located in the 3rd step of the boot process, would be in the form of a disk. A disk is divided into multiple sectors, each with a standard size of 512 bytes. The first sector of this disk would contain the MBR. A disk's MBR can be viewed by taking the system's disk image and opening it in a hexadecimal editor.

 We will be using the HxD tool, a hexadecimal editor available in the taskbar of the attached machine. Open the HxD tool, click the File button in the options tab, and select Open from the options. Now, you have to input the file's location to be opened. We have extracted the MBR portion from a disk image and saved it at `C:\Analysis\MBR`. You can select this file to examine the MBR for this task.

 ![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1733912342396.png)

 This will open it in hexadecimal format. It is to be noted that the MBR provided to you in the attached machine is different from the one presented in the screenshots.

 ![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1734104958079.png)

 

 The Master Boot Record (MBR) takes up 512 bytes of space at the very first sector of the disk. Now, we know that it starts from the very first sector. We can easily analyze the MBR code by starting from the first line, but how do we know where this MBR code ends? The answer to this question is straightforward. Every two digits coupled in hexadecimal represents 1 byte, and once the first 512 bytes of the disk completes, the MBR has been ended. So, in the hexadecimal editor we are using, 16 bytes are present in each row, meaning that the first 32 rows of the disk would be the whole MBR. Another way to spot the end is by looking at the MBR signature. The MBR signature is represented by `55 AA`, which marks the end of the MBR code. You can look for these hexadecimal digits to identify where the MBR ends.

 The screenshot below shows the MBR portion (first 512 bytes) of a disk when opened into the hex editor. You can see that these are the first 32 rows (16 bytes for each row) and ending at 55 AA (MBR Signature). The first highlighted portion represents the bytes offset, the second represents the actual hexadecimal bytes, and the third represents the ASCII-converted text of the hexadecimal bytes. We would focus on the second portion, the hexadecimal bytes. In this task, we will analyze this whole MBR by decoding the meaning of these hexadecimal digits.

   ![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1731928542517.png)

 Before we start analyzing the bytes, it's important to understand that together, every two hexadecimal digits present a single byte. These 512 bytes of the MBR are further divided into three portions. The following screenshot highlights each of the three portions of the MBR with different colors.

 ![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1731917826750.png)

 The structure of the MBR can be seen below:

 ![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110716769.svg)

 

 Let's dissect each of the three portions of the MBR.

 Bootloader Code (Bytes 0-445) The first component of the MBR is the Bootloader code. They cover 446 out of the total 512 bytes of the MBR, as shown in the screenshot below:

 ![Image 13](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1731920146062.png)

 This Bootloader code contains the **Initial Bootloader** . The initial bootloader is the first thing that executes in the MBR. This initial bootloader code has a primary purpose of finding the bootable partition from the **partition table** present on the MBR.

 **Note:**  To better understand the initial bootloader code, it can be disassembled into assembly language, which is beyond the scope of this task.

 Partitions Table (Bytes 446-509) The second component of the MBR is the partition table, which comprises 64 bytes (Bytes 446-509). This table contains the details of all the partitions present on the disk. One of the partitions in the disk contains all the operating system files necessary for booting, known as a bootable partition. The initial bootloader that was started from the bootloader code of the MBR finds the bootable partition from this partition table, and it loads the second bootloader from it. The second bootloader then loads the **Operating System's Kernel** . A partition table is used during this boot process. However, this partition table can also give us valuable information during forensics. Let's dive into the details of this partition table.

 An MBR disk has a total of 4 partitions, and each partition is represented by 16 bytes in the partition table. In the screenshot below, four partitions (each with 16 bytes) are highlighted with different colors.

 ![Image 14](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1731920146057.png)

 Now, for your understanding, we have also shown the partition details of the same disk through the disk management utility of the Windows OS. The same four partitions can be seen here:

 ![Image 15](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1733741844707.png)

 Unlike the bootloader code, the hexadecimal digits of these partitions themselves can tell you many things. Let's use the first partition from the partition table screenshot as a reference to analyze the meaning of all the hexadecimal digits.

 The screenshot below shows the first partition from the partition table of the MBR. All the bytes have some specific meaning. Some bytes individually represent a field, while others are grouped together to form a field. We have highlighted all these different byte groups with different colors.

 ![Image 16](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1731927561284.png)

 The table below shows the fields represented by these bytes.

    Bytes Position Bytes Length Bytes Field Name     0 1 80 Boot Indicator   1-3 3 20 21 00 Starting CHS Address   4 1 07 Partition Type   5-7 3 FE FF FF Ending CHS Address   8-11 4 00 08 00 00 Starting LBA Address   12-15 4 00 B0 23 03 Number of Sectors    Each field tells you something about the partition. Below is an explanation of all these fields:

 
1. **Boot Indicator:**  This byte tells you whether the partition is bootable or not. A bootable partition contains files necessary for the operating system to boot. This boot indicator can only have one of the two values: `80` or `00`. If it's `80`, it means that the partition is bootable; else, if it's `00`, it means that the partition is not bootable. In Windows based systems, **C:**  is the partition that is typically bootable. If visualized through the partition table, this partition would have the boot indicator set to 80.
2. **Starting CHS Address:** Cylinder Head Sector (CHS) is the 3 bytes that tell you where this partition is starting from on the disk. It will give you the starting physical address of the partition, such as the cylinder, head, and sector number. This field is not that important as we now have the simplified logical address of the partition in the form of the Starting LBA Address discussed ahead.
3. **Partition Type:** Every partition uses a filesystem such as NTFS, FAT32, etc. This byte indicates the filesystem of the partition. The partition we are taking as a reference has this byte as `07`, which means it is an NTFS partition. Every filesystem has its own unique byte. You can learn about the bytes used for other filesystems from [here](https://www.writeblocked.org/resources/MBR_GPT_cheatsheet.pdf).
4. **Ending CHS Address:** The last 3 bytes at the end of the CHS Address indicates the physical location where the partition ends on the disk. This field is also not that important, just like the stated CHS address, as we mostly use the logical address (LBA) instead of the physical address.
5. **Starting LBA Address:** Logical Block Addressing (LBA) is the logical address that indicates the start of the partition. We saw that the Starting CHS Address also gives us the starting address of the partition, but because CHS gives you the physical address of the partition, it becomes difficult for us to locate it. However, the Starting LBA Address gives you the logical address of the partition rather than the physical address. You can use it to easily find the start of the partition on the disk in a hexadecimal editor. By locating the partition on the disk, you can also carve data from a disk's hidden or deleted partitions. Based on the partition we are analyzing as a reference with `00 08 00 00` LBA, we will use this logical address to locate our partition later in this task.
6. **Number of Sectors:** These last 4 bytes of a partition tell you the number of sectors in the partition. We will calculate the sector's size by using this field ahead.

 From the information above, the boot indicator and the partition type bytes are pretty straightforward and do not need any more explanation. The starting and ending CHS addresses are physical addresses and do not hold much importance. However, let's see how we can use the **Starting LBA Address**  to locate a partition and the **Number of Sectors**  to calculate the size of the partition.

 Locating the Partition

 The starting LBA address bytes of the partition we are using as a reference in this task is `00 08 00 00`. These bytes are stored in the little-endian format in which the Least Significant Byte (LSB) is first, and the Most Significant Byte (MSB) is last. So, we must first reverse these bytes. Reversing these bytes would make it `00 00 08 00`.

 The next step is to convert these into decimal format. You can either use an online tool for this or view the decimal converted value of these bytes within the HxD hex editor tool. Select the bytes for which you need the decimal value, and it will be displayed in the Int32 option of the Data Inspector pane on the right side.

 ![Image 17](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1731950113978.png)

 Now that we have the decimal value as `2048`, we have to multiply it by the size of the sector, which is 512 bytes.

 `2048 x 512 = 1,048,576`

 `1,048,576` is the exact value where the partition is stored. The last step is to search for this value in the HxD tool to jump to the start of this partition. To search this value, first click the **Search**  button and then click the **Go to** option.

 ![Image 18](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1731950875219.png)

 Now, input the value in the prompt, select the decimal format (dec) and click the OK button.

 ![Image 19](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1731950875220.png)

 This will take you to the start of this partition on the disk. This can help you in carrying out detailed forensics of a specific partition. You can also recover any hidden or deleted data from here that has not yet been overwritten. As the file provided to you in this task is just comprised of the MBR and not the whole disk, you would not be able to jump to the starting LBA of the partition, which is in a separate place from the MBR.

 **Note:** Please remember this method of reversing the LBA address (little endian), converting it to decimal, multiplying it with the sector size (512 bytes), and finally searching it into the hex editor to jump to the exact location. You will encounter some other Logical Block Addresses (LBA) in the GPT structure.

 Calculating the Size of Partition

 The last four partition bytes represent the Number of Sectors field. As per our partition, these bytes are `00 B0 23 03` and if we reverse it as they are in little-endian, they become `03 23 B0 00`. The next step is to convert them to decimal. You can find the decimal value within the HxD tool by highlighting the bytes just as we did for the starting LBA address while locating the partition. The decimal value comes out to be `52,670,464`. Now, as we know, each sector's size is 512 bytes. We can multiply them to get the size of this partition in bytes.

 `52,670,464 x 512 = 26,967,277,568 bytes`

 MBR Signature (Bytes 510-511) The last part of the MBR is the MBR Signature. It is just two bytes, which is short, but if messed up, it can cause huge trouble. The screenshot below shows the whole MBR with the MBR signature highlighted at the very bottom.

 ![Image 20](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1731920146058.png)

 These two bytes `55 AA` are also known as a **Magic Number**  and they indicate that the MBR has been ended now. If these two bytes are changed to some value other than `55 AA`, the system cannot boot. These bytes often get corrupted due to bad sectors on the disk and sometimes can be intentionally changed by malware to interrupt the normal boot process.

 To sum up the whole boot process of the MBR:

 
1. The initial bootloader starts from the bootloader code (the first component of the MBR).
2. It then finds the bootable partition from the partition table (the second component of the MBR).
3. Then it loads the second bootloader from this bootable partition.
4. Finally, with this, the OS kernel gets loaded, and after this process, the drivers, services, and filesystems are loaded into the memory, and the user is given control of the OS interface. This is a system's whole boot process using an MBR partitioned disk.

### **Answer the questions below**

**Question:** Which component of the MBR contains the details of all the partitions present on the disk?

*Answer:* 

     partition table

**Question:** What is the standard sector size of a disk in bytes?

*Answer:* 

     512 

**Question:** Which component of the MBR is responsible for finding the bootable partition?

*Answer:* 

     bootloader code

**Question:** What is the magic number inside the MBR?

*Answer:* 

     55 AA

**Question:** What is the maximum number of partitions MBR can support?

*Answer:* 

     4

**Question:** What is the size of the second partition in the MBR file found in C:\Analysis\MBR\? (rounded to the nearest GB)

*Answer:* 

     16

---

## Task 4 | Threats Targeting MBR

MBR is not that common nowadays and is replaced by GPT. This happened when the UEFI firmware (compatible with GPT), which is more efficient and redundant, replaced BIOS (compatible with MBR). However, as the MBR is still being used in some disks, it is important to understand the threat surface of the MBR.

As the MBR plays a crucial role in booting the operating system, it becomes an attractive target for attackers. The total 512 bytes of the MBR hold extreme importance for the whole system. Anybody who can play with these 512 bytes can hijack the whole system. Several types of malware are designed to target the MBR.  Let's explore some common malware leveraging the MBR to achieve their objective.

 

- 
- 
- **Bootkits:**
- OS
- craft themselves into the MBR to
- bypass the OS's protection mechanisms. Even complete malware removal or reinstallation of the OS cannot remove the bootkits as they reside in the MBR.
- 
- ![Image 21](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110798085.svg)

- 
- 
- 
- 
- 
- **Ransomware:**
- 
- ![Image 22](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737236441165.png)
- 
- 
- **Wiper Malware:**
- 
- 
- ![Image 23](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110798083.svg)

### **Answer the questions below**

**Question:** Complete this task.

*Answer:* 

     No answer needed

---

## Task 5 | MBR Tampering Case

Scenario An organization's critical database server suddenly became unbootable, causing widespread panic. The initial investigation found an employee opened a malicious email attachment, prompting a reboot. The employee rebooted the system, after which the system became completely unbootable. Most of the clues point to the malware's deliberate corruption of the server's Master Boot Record (MBR).

 A quick look at the server's MBR points to two corruptions. One of them is the logical address of the first partition, which was previously `00 08 00 00`, and the other is a critical component of the MBR that must be the same across all the MBRs. Fixing these corrupted bytes will make the system bootable again, which can be verified by re-opening the fixed disk image using FTK Imager.

 Instructions In this task, you will utilize two tools, FTK Imager and HxD. Both tools are available in the taskbar and Desktop of the machine.

 HxD HxD is a hexadecimal editor. You can view the MBR contents of a disk by opening it into the hexadecimal editor, just as we did in task #3. In this task, you will use HxD to examine the corrupted hexadecimal bytes of the MBR and fix these bytes by following the clues in the scenario. The disk under examination is placed at `C:\Analysis\MBR_Corrupted_Disk.001`. Open this disk image using the HxD tool. Now, to fix the corrupted bytes, you can click on the corrupted byte and type the new correct one. Once you are done with replacing all the corrupted bytes, save the disk image using the `Save` button located in the dropdown of the `File` option, as shown in a sample screenshot below:

![Image 24](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737107623828.png)

 

 **Note:** You may encounter an error message that says: **"There is not enough space on the disk."**  while saving the changes. This is because HxD creates a backup of the original file before saving the changes, and due to insufficient space, it cannot make a backup. However, it does not stop you from saving the file. It gives you the option to save anyway. Click **Yes** to proceed, and the file will be saved without the backup creation.

Now, as the corrupted bytes are fixed and saved into the disk image, open the fixed disk image using FTK Imager (guideline given ahead) and verify that you can see all the contents of the disk. If the disk contents are properly available, the corrupted MBR is recovered, and the disk is ready to boot again.

 FTK Imager FTK Imager is a forensics tool that you can use to create or examine a disk image's contents. The infected disk image was preserved immediately after the attack by booting the system with a live USB. You are provided with this disk image and you can use FTK Imager to test and examine its content. Initially, before you deploy the fix, this disk image, when opened with FTK Imager, will show the error "Unrecognized file system." However, once the disk's MBR is fixed, you will be able to examine the contents of the whole disk in the FTK Imager.

 To open a disk image using FTK Imager, you need the following steps:

 Click on the `File` button available in the options tab and then choose `Add Evidence Item`.

 ![Image 25](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1733910121279.png)

 Now, select the `Image File` option and click the `Next` button.

 ![Image 26](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1733910121296.png)

 Lastly, enter the source path of the image file and click the `Finish` button to view the contents of the disk image.

 ![Image 27](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737107623837.png)

 The left pane would display the disk image in a tree format. You can expand the contents of the disk by clicking the + icon. Currently, it displays `Unrecognized file system` as the disk's MBR is corrupted. The right pane will give you the contents and details of the files and folders you select inside the left pane.

 ![Image 28](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737107623829.png)

### **Answer the questions below**

**Question:** How many partitions are on the disk?

*Answer:* 

     1

**Question:** What is the first byte at the starting LBA of the partition? (represented by two hexadecimal digits)

*Answer:* 

     EB

**Question:** What is the type of the partition?

*Answer:* 

     NTFS

**Question:** What is the size of the partition? (rounded to the nearest GB)

*Answer:* 

     32

**Question:** What is the flag hidden in the Administrator's Documents folder?

*Answer:* 

     THM{Cure_The_MBR}

---

## Task 6 | What if GPT?

Previously, we studied how the boot process propagates with the MBR. In this task, we will explore what the boot process looks like when a modern GPT partitioning scheme is used in the disk instead of the MBR.

UEFI firmware with the GPT partitioning scheme replaced BIOS firmware with the MBR partitioning scheme. This replacement occurred due to some limitations in the BIOS and the MBR. The GPT supports up to 9 zettabytes of hard disks, unlike the MBR, which supports a maximum of 2 terabytes. The GPT also supports up to 128 partitions, unlike the MBR, which only supports 4. There are some other differences between both of the partitioning schemes.

GPT is now a preferred partitioning scheme in most modern systems. It is compatible with systems that have UEFI firmware. Let's take a look at the structure of the GPT.

We previously saw that the MBR only occupies the disk's first sector (512 bytes). However, this is not the case with the GPT. The GPT has five components spread across multiple sectors of the disk. Let's start dissecting each component of the GPT.

**Note:**  We have extracted the first two components of the GPT in hex format and saved them at `C:\Analysis\GPT`. You can use this file in HxD to examine the GPT in this task. It is to be noted that the GPT provided to you in the attached machine is different from the one presented in the screenshots.

![Image 29](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110838398.svg)

 Protective MBR Ideally, if the disk is GPT partitioned, the system should have UEFI firmware to handle it. However, some legacy systems still use BIOS firmware even though the disk is GPT partitioned. This can be a problem as the BIOS firmware is designed to work with the MBR and UEFI firmware is designed to work with the GPT. To solve this problem, the GPT has Protective MBR. The Protective MBR is in the disk's first sector, partitioned with the GPT. The purpose of the Protective MBR is to signal the BIOS system that this disk is using the GPT, so please don't mess up with it thinking that it is the MBR.

The Protective MBR also has three components, just like the general MBR, but with a few differences. Below is a screenshot of the Protective MBR found in the GPT, with its three components highlighted with different colors.

![Image 30](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1734943004432.png)

The details of these components are given below:

 
1. **Bootloader Code:** This bootloader code is not the same as it is in the general MBR. This bootloader code does not perform any function during the boot process. It is just there to look like it's the same standard MBR bootloader. This would be all 00s in most scenarios; however, sometimes, this can contain some placeholder code for legacy compatibility.
2. **Partition Table:** This partition table contains only one partition (the first 16 bytes), and this partition has one job; to redirect the system to the EFI Partition (which we will discuss later). The screenshot of the protective MBR above shows that it only has one partition in the table, and the other partitions are labeled with 0s. In this single partition, there is only one important thing: the 4th byte. This byte is set to `EE`, indicating that this is a GPT-formatted disk.
3. ![Image 31](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1732018952352.png)

****
4. 3. **MBR Signature:** The MBR signature is the same as in the standard MBR. It is set to `55 AA` and marks the end of the Protective MBR.

 Primary GPT Header The GPT header starts right from the next byte (the start of sector 1) after the Protective MBR ends at `55 AA` (the end of sector 0). It acts as a blueprint of the partitions on the disk. All the bytes in the GPT header have a specific meaning. Below is a screenshot of the GPT header with these bytes highlighted with different colors. It has the whole 512 sector space but occupies the first 92 bytes of space, and after these 92 bytes, there would be all `00` bytes for padding purposes to complete the sector's total bytes. So, for the Primary GPT header, you only need to focus on the first 92 bytes, which can give you some meaningful information.

![Image 32](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1732091427207.png)

The table below shows the position of these bytes and their field names.

    Bytes PositionBytes LengthBytes Field Name     0-7845 46 49 20 50 41 52 54 Signature   8-11400 00 01 00 Revision   12-1545C 00 00 00 Header Size   16-19471 89 13 1C CRC32 of Header   20-23400 00 00 00 Reserved   24-31801 00 00 00 00 00 00 00 Current LBA 32-398AF 32 CF 1D 00 00 00 00Backup LBA40-47822 00 00 00 00 00 00 00First Usable LBA48-5588E 32 CF 1D 00 00 00 00Last Usable LBA56-71161D F1 B0 D6 43 BE 37 4E B1 E6 38 66 EC B1 73 89Disk GUID72-79802 00 00 00 00 00 00 00Partition Entry Array LBA80-83480 00 00 00Number of Partition Entries84-87480 00 00 00Size of Each Partition Entry88-91441 0D C0 22CRC32 of Partition Array Each of these 14 fields has a specific purpose and meaning. Below is an explanation of all these fields. Before starting with the explanation of these fields, it is important to note that some of the fields represent Logical Block Addresses (LBA). To calculate the exact address through these LBAs, you must follow the same steps we performed while locating the partition in the MBR task. These steps included reversing the bytes stored in a little-endian format, then converting them to decimals and searching them on the HxD tool to jump to the exact LBA location.

 
1. **Signature:** This field has a value `45 46 49 20 50 41 52 54` which recognizes it as a GPT header. This value is always at the start of the GPT header.
2. **Revision:** The revision number is of 4 bytes and it represents the version of the GPT. Most of the times it would be `00 00 01 00` which means the GPT version is 1.0.
3. **Header Size:** This field represents the size of the GPT header. It is typically `5C 00 00 00` in hex and if you convert it to decimal (after reversing the order of bytes as they are in little-endian), it is 92 bytes which is the length of the GPT header.
4. **CRC32 of Header:** This is the CRC32 checksum of the GPT header, which if changed, would indicate that either the GPT header is tampered or corrupted.
5. **Reserved:** These are reserved bytes. The purpose of having them is to utilize them for any future changes in the GPT header.
6. **Current LBA:** The Current Logical Block Address (LBA) indicates the location of the GPT header. We know that its location is in sector 1, and we can verify this by converting the 8 Current LBA bytes `01 00 00 00 00 00 00 00` into decimal.
7. **Backup LBA:** In the GPT partitioning scheme, we have a backup of the GPT header as well, which we will be studying later on in this task. This field indicates the LBA of the backup GPT header.
8. **First Usable LBA:** This LBA address indicates the first address from which the partition can start on the disk.
9. **Last Usable LBA:** This LBA address indicates the last address to which the partitions on the disk can be written. Any partitions cannot occupy the disk space after the last usable LBA.
10. **Disk GUID:** This field is of 16 bytes and it presents a Globally Unique Identifier of the disk. The purpose of this GUID is to distinguish the disk from any other disks present in the system. In the current GPT header that we are analyzing, these bytes are `1D F1 B0 D6 43 BE 37 4E B1 E6 38 66 EC B1 73 89`. We can convert them to the standard GUID format of the disk by just reformatting them as `1DF1B0D6-43BE-374E-B1E6-3866ECB17389`.
11. **Partition Entry Array LBA:** This LBA address indicates the start of the Partition Entry Array which we are going to discuss ahead as the 3rd component of the GPT.
12. **Number of Partition Entries:** This field indicates the number of partitions that are on the disk. The GPT supports 128 partitions, unlike the MBR, which supports 4 partitions only. The value of this field is `80 00 00 00` which if converted to decimal will be 128.
13. **Size of Each Partition Entry:** This field indicates the size occupied by each partition entry array. In this example, it set to `80 00 00 00` which is 128 in decimal. It is important to note that this is not the size of the partition itself. This is just the size of partition entry array that we would be discussing next.
14. **CRC32 of Partition Array:** This is the CRC32 checksum of the whole partition entry array, which if changed, would indicate that either the partition entry array is tampered or corrupted.

 Partition Entry Array We saw that sector zero was occupied by the Protective MBR, and the GPT header occupied sector 1. Now, from sector 2, the Partition Entry Array starts, just like the partition table present in the MBR, with a few differences. There are a total of 128 partitions on a GPT disk, and this partition entry array contains information about all these partitions. Below is the screenshot of the Partition Entry Array of a GPT disk. Each partition entry is represented by 128 bytes. You can only see the 6 partition entries out of the total 128 partition entries of the GPT. This is because there are only six working partitions in this disk. These six partitions would be present in blocks (128 bytes each) in this partition entry array, and after these working partitions, all the remaining 122 partition entries would be marked with `00`.

![Image 33](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1732103336630.png)

Let's use the first partition of the above screenshot as a reference to analyze the meaning of all the hexadecimal digits present in it.

The screenshot below shows the first partition entry from the partition entry array of the GPT. All the bytes (or groups of bytes) have some specific meaning. We have highlighted the different byte groups with different colors.

![Image 34](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1732104106344.png)

The table below shows the fields represented by these bytes.

    Bytes Position Bytes Length Bytes Field Name     0-151628 73 2A C1 1F F8 D2 11 BA 4B 00 A0 C9 3E C9 3B Partition Type GUID   16-31169E 43 0D 72 EC 12 54 44 8F B2 EE 17 8D F3 CD 3B Unique Partition GUID   32-39800 08 00 00 00 00 00 00 Starting LBA   40-478FF 27 03 00 00 00 00 00 Ending LBA   48-55800 00 00 00 00 00 00 80 Attributes   56-1277245 00 46 00 49 00 20 00 73 00 79 00 73 ... Partition Name   Each of these six fields has a specific purpose. Below is an explanation of all these fields.

 
1. **Partition Type GUID:** This is the GUID of the partition type. This GUID will indicate the partition type, i.e., EFI System Partition, Basic Data Partition, etc. The 16 bytes of our partition entry are stored in mixed endian (little-endian and big-endian) format. This means we would have to reverse specific bytes and keep the other ones the same. In this case, we would do the following:
2. 1. Reverse the first 4 bytes from `28 73 2A C1` to `C1 2A 73 28`, as they are in little-endian format.
2. Reverse the next 2 bytes from `1F F8` to `F8 1F`, as they are in little-endian format.
3. Reverse the next 2 bytes from `D2 11` to `11 D2` as they are in little-endian format.
4. Keep the next 2 bytes `BA 4B` as it is, as they are in big-endian format.
5. Keep the last 6 bytes `00 A0 C9 3E C9 3B` as it is, as they are in big-endian format.

The resulting GUID from steps 1-5 will be `C12A7328-F81F-11D2-BA4B-00A0C93EC93B`. Whatever GUID you get from here, you can search it on the internet to get the partition type associated with that GUID. The GUID we calculated is used for EFI System Partition (ESP).

**EFI System Partition (ESP)**  is stored as a partition on every GPT disk and it is a very critical component in the boot process. In the MBR, we saw that the bootloaders are located in the bootcode and the bootable partition. In contrast, in the GPT, the bootloader is comprised of multiple files with **.efi**  extension, and they all are stored in this EFI System Partition (ESP). Once the bootloader is found from the EFI System Partition, it loads the **Operating System's kernel**  from the bootable partition of the disk, and after that, the drivers, services, and filesystems are loaded into the memory. Then the user is given the control of OS interface.

1. **Unique Partition GUID:** Unique Partition GUID is used to distinguish partitions on a disk. It is a unique GUID that is given to all the partitions on the disk. To convert these hexadecimal bytes into the standard GUID format, you can follow the same steps as we did for the first field (Partition Type GUID), as this is also stored in the mixed endian format.
2. **Starting LBA:** The starting LBA address indicates the area from where this partition starts on the disk.
3. **Ending LBA:** The ending LBA address indicates the area at which this partition is ending on the disk.
4. **Attributes:** This field contains some flags that indicates some features of the partition, for example, if it is bootable, hidden, or normal.
5. **Partition Name:** This is the last field of the partition entry, and its size is 72 bytes. It represents the name of the partition in string format and is UTF-16 encoded. If you decode these bytes using any online hex-to-string decoder, you will get the partition name of this partition.

 Backup GPT Header One of the biggest reasons the GPT replaced the MBR is its redundancy. In case of the MBR, if your MBR gets corrupted or changed due to hardware issues or malicious attacks, you have a minimal chance of recovery. On the other hand, the GPT has backups of its components. The Backup GPT Header is located at the last sector of the disk, and it can be used for recovery in case the Primary GPT Header is corrupted. It contains the same information as the Primary GPT Header.

 Backup Partition Entry Array There is also a backup copy of the partition entry array. It is stored at the end of the disk just before the backup GPT header. It contains the same information as the partition entry array. It acts as a fail-safe mechanism in case the original partition entry array is damaged.

### **Answer the questions below**

**Question:** How many partitions are supported by the GPT?

*Answer:* 

     128

**Question:** What is the partition type GUID of the 2nd partition given in the attached GPT file?

*Answer:* 

     E3C9E316-0B5C-4DB8-817D-F92DF00215AE

---

## Task 7 | Threats Targeting GPT

GPT offers many advantages over the MBR in terms of efficiency and redundancy. However, it is also prone to some attacks. Some of the common types of malware leveraging the GPT to achieve their objectives are discussed below:

 
- 
- 
- **Bootkits:**
- UEFI
- **.efi**
- **.efi**
- OS
- OS
- UEFI
- 
- ![Image 35](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110912111.svg)
- 
- **Ransomware:**
- 
- ![Image 36](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110912120.svg)
- 
- **Wiper Malware:**
- 
- 
- ![Image 37](https://tryhackme-images.s3.amazonaws.com/user-uploads/6645aa8c024f7893371eb7ac/room-content/6645aa8c024f7893371eb7ac-1737110912117.svg)
-

### **Answer the questions below**

**Question:** Complete this task.

*Answer:* 

     No answer needed

---

## Task 8 | UEFI Bootkit Case

When we use BIOS firmware, the bootloader responsible for loading the operating system is executed inside the MBR. However, when we use UEFI firmware, which supports a GPT partitioning scheme, the bootloader is not executed from the GPT. Instead, it is located in the EFI system partition (ESP) in the form of **.efi** extension files. These files include the **bootmgr.efi** , **bootx64.efi** , and others, depending on the OS.

 Earlier, we studied the bootloader code in the MBR, which can be tampered with, and a bootkit can reside there. Conversely, using UEFI firmware with the GPT, bootkits can reside in the .efi files in the ESP partition. However, this can only be successful if the secure boot feature of UEFI is disabled. Once enabled, the secure boot feature will verify the digital signatures of the bootloaders (.efi files) in the ESP and will not allow any tampered file to execute.

 Scenario A bootkit was detected in an organization's critical Windows server. The organization reported no damage yet, as the bootkit was contained during the initial stages. However, it is suspected that the bootkit was able to modify the bootloader files to some extent and embedded an encoded string in the initial unused space of the bootloader. The bootloader file, **bootmgr.efi,**  is located at `C:\Analysis\bootmgr.efi`. You are tasked with analyzing the tampered file in the HxD hex editor.

### **Answer the questions below**

**Question:** Which partition has the bootloader in it?

*Answer:* 

     EFI System Partition

**Question:** What is the malicious string embedded in the bootloader?

*Answer:* 

     _____, ___ ________

---

