---
Date: 2025-09-21
Tags: #TryHackMe
Hubs: "TryHackMe/Advanced Endpoint Investigations/Disk Image Analysis"
URLs: (https://tryhackme.com/room/forensicimaging)
id: 359d10d8-2038-4d7d-baee-5d7ec60baa5c
---

# TryHackMe | Forensic Imaging

## Task 1 | Introduction

Introduction

In Digital Forensics, imaging is the process of creating an exact, bit-by-bit copy of digital storage media. This process ensures that all the data, including deleted files, hidden files, and unallocated space, is captured. By generating a forensic image, we preserve the original data, allowing for a thorough examination.

The primary goal of this process is to create a verifiable and reliable copy that can be used in investigations and legal proceedings. This process is crucial for maintaining the integrity of digital evidence, ensuring that the original data remains untouched and admissible in legal matters.

Furthermore, the process plays a critical role in maintaining the [chain of custody](https://tryhackme.com/r/room/dfirprocesslegalconsiderations), a crucial aspect of legal proceedings. By documenting the handling and transfer of digital evidence, we can demonstrate that the data has been preserved correctly and has not been tampered with, providing a reliable and transparent method for examining it.

Learning Objectives

- Learn the basics of the forensic imaging process
- Explore different environment settings for imaging
- Learn how to create a raw image from an attached device
- Perform an integrity check of an image

Prerequisites

- [Intro to Digital Forensics](https://tryhackme.com/r/room/introdigitalforensics).
- [DFIR: An Introduction](https://tryhackme.com/r/room/introductoryroomdfirmodule).
- [Linux Fundamentals 1](https://tryhackme.com/r/room/linuxfundamentalspart1).
- [Legal Considerations in DFIR](https://tryhackme.com/r/room/dfirprocesslegalconsiderations).

Caveats

Some topics not touched on in this room are performance and timing; while these topics are relevant to the imaging procedure, they were intentionally left behind to avoid the focus on the process itself.

### **Answer the questions below**

**Question:** Click to complete the task.

*Answer:* 

     No answer needed

---

## Task 2 | Preparation

Start Machine

The process of imaging a disk starts by identifying the target drive, preparing it for imaging, and then creating the image file which is later verified for integrity. This needs to be performed in an environment that allows us to perform these tasks and also ensures the process is properly logged.

Each operating system has specific file system structures and configurations that require different imaging tools and techniques. In our scenario, we will use Linux as the OS to acquire the data and create a forensic image of a drive. The use of open-source software for image acquisition is an advantage in many cases since it can satisfy guidelines for evidential reliability that need to be fulfilled. The Linux kernel also supports many [file systems](https://en.wikipedia.org/wiki/Category:File_systems_supported_by_the_Linux_kernel), which is a big advantage when analyzing different media types.

Start the attached machine in this task by clicking the Start Machine button. A split-screen view of the VM will appear. In case the VM is not visible, use the blue Show Split View button at the top of the page. Alternatively, you can access the machine via SSH using the following credentials below.

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

**Username** analyst**Password** forensics**IP** MACHINE_IPWrite-Blockers

It is important to mention that [write-blockers](https://en.wikipedia.org/wiki/Forensic_disk_controller)[ ](https://en.wikipedia.org/wiki/Forensic_disk_controller)are usually required when manipulating physical disks. A **write-blocker**  is a device used to prevent any modifications to data on a storage device during analysis. It ensures reading data without risking changes to the original evidence.

Write-blockers work by physically intercepting all drive commands that write data sent between the disk being imaged and the OS attached to it.

Audit Trail

An audit trail is a chronological record that tracks actions and events within a system, providing a detailed history for accountability and security. It ensures traceability by documenting each step. This step can be performed with different parameters depending on the legal or [compliance framework required](https://assets.publishing.service.gov.uk/media/64da431cc8dee4000d7f1c1e/FINAL_2023.1.18_Code_of_Practice.pdf) by the task.

We can manually or automatically record the actions and events with varying detail levels. Since we need to preserve the evidence and keep track of our activities, let's explore some methods for tracking tasks and automating command-line activity logging to help us have this audit trail of our process.

If we are using `bash`, the `history` command can help us log our activity. It can be saved using a timestamp and preserved in a file. Below, we can observe a chart with some commands recommended to use during our session.

`set -o history`

Enables command history in the shell, allowing it to record the commands you enter.
`shopt -s histappend`

Ensures that the command history is appended to the history file instead of overwriting it when the shell exits.
`export HISTCONTROL=`

Clears any settings that control which commands are saved in the history, ensuring all commands are recorded.
`export HISTIGNORE=`

Clears any settings that ignore specific patterns of commands, so all commands are saved in the history.
`export HISTFILE=~/.bash_history`

Sets the file where the command history is saved.
`export HISTFILESIZE=-1`

Sets no limit on the number of lines stored in the history file.
`export HISTSIZE=-1`

Sets no limit on the number of commands retained in the shell history.
`export HISTTIMEFORMAT="%F-%R "`

Formats timestamps in the history as "YYYY-MM-DD HH" for each command.Another good practice is to log all sessions. This could be achieved with bash internals, but other easy-to-use software can achieve the same, like [script](https://man7.org/linux/man-pages/man1/script.1.html), a UNIX tool present in several Linux distributions, or similar tools like [ttyrec](https://github.com/mjording/ttyrec).

Finally, we should always save the output of any command we execute to a file if possible. While this may not be the case in the next examples, this is to provide a more analytic approach to them, but it's recommended to do it in a real scenario.

Again, these requirements can be more demanding depending on the legal frameworks and the needs of the investigation.

Accessing the File System

While the disk and devices used may differ depending on the requirements and the environment, the process is similar for all disks physically or virtually attached to the Linux OS. Once we have our preparation setup and logging our steps, let's execute the `df` command to see the attached devices on the target machine.

    Example Terminal  
```Example Terminal 
user@tryhackme$ df
Filesystem     1K-blocks    Used Available Use% Mounted on
/dev/root       40581564 7776284  32788896  20% /
devtmpfs          994716       0    994716   0% /dev
tmpfs            1003800       0   1003800   0% /dev/shm
tmpfs             200760    1184    199576   1% /run
tmpfs               5120       0      5120   0% /run/lock
tmpfs            1003800       0   1003800   0% /sys/fs/cgroup
/dev/loop3        108032  108032         0 100% /snap/core/16574
/dev/loop0         25856   25856         0 100% /snap/amazon-ssm-agent/7993
/dev/loop1         27008   27008         0 100% /snap/amazon-ssm-agent/9881
/dev/loop4         57088   57088         0 100% /snap/core18/2829
/dev/loop5         56704   56704         0 100% /snap/core18/2846
/dev/loop6         65536   65536         0 100% /snap/core20/2318
/dev/loop9         69632   69632         0 100% /snap/lxd/22526
/dev/loop2        106752  106752         0 100% /snap/core/17200
/dev/loop7         65280   65280         0 100% /snap/core20/2496
/dev/loop8         75776   75776         0 100% /snap/core22/1748
/dev/loop10        94080   94080         0 100% /snap/lxd/24061
tmpfs             200760       0    200760   0% /run/user/1000
tmpfs             200760       8    200752   1% /run/user/114
tmpfs             200760       4    200756   1% /run/user/1001
```

   Drives are attached as devices under the `/dev` directory. In the output above, the current disk used by the OS is listed under `/dev/root`. Our device is not mounted yet, and since it is a Virtual Disk attached to a `loop interface`, it will not appear using the command `df`. This is also common for physical disks when not directly attached.

We can still list block devices using the `lsblk` command with the `-a` option to list all devices, as shown below.

Example Terminal  
```Example Terminal 
user@tryhackme$ lsblk -a
NAME    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0     7:0    0  25.2M  1 loop /snap/amazon-ssm-agent/7993
loop1     7:1    0  26.3M  1 loop /snap/amazon-ssm-agent/9881
loop2     7:2    0 104.2M  1 loop /snap/core/17200
loop3     7:3    0 105.4M  1 loop /snap/core/16574
loop4     7:4    0  55.7M  1 loop /snap/core18/2829
loop5     7:5    0  55.4M  1 loop /snap/core18/2846
loop6     7:6    0    64M  1 loop /snap/core20/2318
loop7     7:7    0  63.8M  1 loop /snap/core20/2496
loop8     7:8    0  73.9M  1 loop /snap/core22/1748
loop9     7:9    0  67.9M  1 loop /snap/lxd/22526
loop10    7:10   0  91.9M  1 loop /snap/lxd/24061
loop11    7:11   0   1.1G  0 loop 
loop12    7:12   0         0 loop 
xvda    202:0    0    40G  0 disk 
└─xvda1 202:1    0    40G  0 part /
xvdh    202:112  0     1G  0 disk
```

  Above, we can observe the `loop11` interface initialized with 1.1 GB, which matches our Disk Size. This should also be noticed since we need to know that we have enough space to create the images either on the disk we will copy it or on the disk where we will save the image. In our case, is the `xvda` block, which corresponds to the `/dev/root/`. The partition is 40 GB in size. 

**Note:** The upcoming terminal outputs and the ones shown above may sometimes differ from the outputs of the attached VM. This is because the loop devices might change. It is advised to follow the practical commands by identifying the loop device with a 1.1 GB size, which in our case is loop11.

We can get more info about the device using the `losetup` command with the `-l` option to list the device and the assigned interface path, in this case `/dev/loop11`.

Forensic Imaging  
```Forensic Imaging 
user@tryhackme$ sudo losetup -l /dev/loop11
NAME        SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE                 DIO LOG-SEC
/dev/loop11         0      0         0  0 /home/ubuntu/example1.img   0     512
```

   

It is possible to acquire further information like the UUID of the image using the `blkid` with the interface as an argument, as demonstrated in the following example.

   Forensic Imaging  
```Forensic Imaging 
user@tryhackme$ sudo blkid /dev/loop11
/dev/loop11: UUID="1895de04-f9ee-4b8b-b49d-9ef55770073c" TYPE="ext4"
```

   With the information above logged into our notes, we should proceed to create the disk's image. Note that if we were using a physical disk, we could also use commands like `hparn` to get information about the manufacturer, serial number, and other required data.

### **Answer the questions below**

**Question:** What command can be used to list all block devices in Linux OS?

*Answer:* 

     lsblk

**Question:** Which bash command displays all commands executed in a session?

*Answer:* 

     history

---

## Task 3 | Creating a Forensic Image

Now that we have identified the device, we want to create an image. Let's go ahead and copy this disk to a `raw` image file for further inspection. This could also be done to another disk if needed, which is a common practice, but in this case, we will do it to a local file in our system with the `.img` extension to identify the file as an image.

As we recall from our previous task, there is a great variety of tools we can use to create images. We will use `dc3dd` in this example, an enhanced version of the UNIX command `dd`. Below, you can find a list of some common tools used to create images.

`dd`

A standard Unix utility for copying and converting files, often used for creating raw disk images
`dc3dd`

An enhanced version of `dd` with additional features for forensic imaging, including hashing and logging
`ddrescue`

A data recovery tool that efficiently copies data from damaged drives, attempting to rescue as much data as possible
`FTK Imager`

A GUI-based tool for creating forensic images, widely used for its ease of use and comprehensive features
`Guymager`

A GUI-based forensic imaging tool that supports various image formats and provides detailed logs
`EWF tools (ewfacquire)`

 Tools for creating and handling Expert Witness Format (EWF) images, often used in digital forensics
Imaging

To start, let's execute the `dc3dd` command with the following parameters:

- The `if` option (input file), indicates the device we want to copy; in this case, `/dev/loop11`
- The `of` option (output file) indicates where we want to write the disk bytes, in this case, a file named `example1.img`
- The `log` options will save all the output into a file. In our example, `imaging_loop11.txt`

Below, we can observe the command output of `dc3dd` using the parameters mentioned.

   Forensic Imaging  
```Forensic Imaging 
user@tryhackme$ sudo dc3dd if=/dev/loop11 of=example1.img log=imaging_loop11.txt

dc3dd 7.2.646 started at 2024-06-28 22:58:59 +0000
compiled options:
command line: dc3dd if=/dev/loop11 of=example1.img log=imaging_loop11.txt
device size: 2252800 sectors (probed),    1,153,433,600 bytes
sector size: 512 bytes (probed)
  1153433600 bytes ( 1.1 G ) copied ( 100% ),   13 s, 84 M/s                  

input results for device `/dev/loop11':
   2252800 sectors in
   0 bad sectors replaced by zeros

output results for file `example1.img':
   2252800 sectors out

dc3dd completed at 2024-06-28 22:59:12 +0000
```

   

From the output above, we can confirm that the operation seemed to be successful and that we created a file of the same size, as shown below.

   Forensic Imaging  
```Forensic Imaging 
user@tryhackme$ ls -alh example1.img 
-rw-r--r-- 1 root root 1.1G Jun 28 22:28 example1.img
```

   

Now, let's check what other activities we can perform in the next rooms after the imaging process is over.

### **Answer the questions below**

**Question:** Click to complete the task.

*Answer:* 

     No answer needed

---

## Task 4 | Integrity Checking

Integrity checking in digital forensics imaging is crucial for ensuring that the forensic copy of data is identical to the original. This process uses cryptographic hash functions, such as MD5, SHA-1, or SHA-256, to generate unique hash values for both the original and the copied data. By comparing these hash values, investigators can confirm that the evidence was not altered during the imaging process, maintaining its reliability and admissibility in legal proceedings.

Methods for integrity checking include using tools that automatically calculate and verify hashes during the imaging process. Tools like `dc3dd` generate and compare hash values in real-time, providing an added layer of assurance. Regular integrity checks throughout the investigation ensure that data remains unchanged, preserving the chain of custody.

Let's again list the block devices on our system using the command `lsblk` with `-l` to list the devices.

    Example Terminal  
```Example Terminal 
user@tryhackme$ sudo lsblk -l
loop0    7:0    0  25.2M  1 loop /snap/amazon-ssm-agent/7993
loop1    7:1    0  26.3M  1 loop /snap/amazon-ssm-agent/9881
loop2    7:2    0 104.2M  1 loop /snap/core/17200
loop3    7:3    0 105.4M  1 loop /snap/core/16574
loop4    7:4    0  55.4M  1 loop /snap/core18/2846
loop5    7:5    0  55.7M  1 loop /snap/core18/2829
loop6    7:6    0    64M  1 loop /snap/core20/2318
loop7    7:7    0  63.8M  1 loop /snap/core20/2496
loop8    7:8    0  73.9M  1 loop /snap/core22/1748
loop9    7:9    0  67.9M  1 loop /snap/lxd/22526
loop10   7:10   0  91.9M  1 loop /snap/lxd/24061
loop11   7:11   0   1.1G  0 loop 
xvda   202:0    0    40G  0 disk 
xvda1  202:1    0    40G  0 part /
xvdh   202:112  0     1G  0 disk
```

  We can observe that the device is still listed in `/dev/loop11`. Let's ensure our imaging process was successful. To do that, let's calculate the MD5 hash of the image we created, `example1.img`, and let's do the same for the device`/dev/loop11`. The results should match.

   Example Terminal  
```Example Terminal 
user@tryhackme$ sudo md5sum example1.img 
483ca14c7524b8667974a922662b87e8  example1.img

user@tryhackme$ sudo md5sum /dev/loop11
483ca14c7524b8667974a922662b87e8  /dev/loop11
```

  

As shown above, the calculated hash indeed matches, passing the integrity check for this image we created. Thus, we can confirm that the imaging process has been successful through hashing.

### **Answer the questions below**

**Question:** What is the MD5 hash of the image "exercise.img" located in /home/analyst/?

*Answer:* 

     1f1da616156f73083521478c334841bb

---

## Task 5 | Other Types of Imaging

It is worth noting that other types of imaging procedures can be performed, not only on disk devices. These can include:

Remote ImagingInvolves creating an image over the network, allowing it to acquire data without physical access to the device.
USB ImagesCreates an image of a USB drive's contents.
Docker ImagesWhile not strictly an image, it creates a snapshot of a Docker container's filesystem and configuration.Once we have an image, we can also verify that the image is working and can be used to inspect it; for that, we could mount the image to verify the process is complete correctly. Let's go ahead and mount the image we created, `example1.img`.

As we observed before, our disk assigned to the loop interface `loop11` is not mounted as the command `df` displays.

   Forensic Imaging  
```Forensic Imaging 
user@tryhackme$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       40581564 8626756  31938424  22% /
devtmpfs          994716       0    994716   0% /dev
tmpfs            1003800       0   1003800   0% /dev/shm
tmpfs             200760    1172    199588   1% /run
tmpfs               5120       0      5120   0% /run/lock
tmpfs            1003800       0   1003800   0% /sys/fs/cgroup
/dev/loop3        108032  108032         0 100% /snap/core/16574
/dev/loop1         27008   27008         0 100% /snap/amazon-ssm-agent/9881
/dev/loop0         25856   25856         0 100% /snap/amazon-ssm-agent/7993
/dev/loop2        106752  106752         0 100% /snap/core/17200
/dev/loop5         57088   57088         0 100% /snap/core18/2829
/dev/loop4         56704   56704         0 100% /snap/core18/2846
/dev/loop9         69632   69632         0 100% /snap/lxd/22526
/dev/loop7         65280   65280         0 100% /snap/core20/2496
/dev/loop6         65536   65536         0 100% /snap/core20/2318
/dev/loop8         75776   75776         0 100% /snap/core22/1748
/dev/loop10        94080   94080         0 100% /snap/lxd/24061
tmpfs             200760       0    200760   0% /run/user/1000
tmpfs             200760       8    200752   1% /run/user/114
tmpfs             200760       4    200756   1% /run/user/1001
```

   

Let's mount it using the `mount` command

- First, create a mount point directory `/mnt/example1` with the command `sudo mkdir -p /mnt/example1`
- Then, use the command `sudo mount -o loop example1.img /mnt/example1` to mount the image
- After that, we can verify by exploring the mount point we created using the `ls` command.

   Forensic Imaging  
```Forensic Imaging 
user@tryhackme$ ls /mnt/example1/
dir01  dir03  dir05  dir07  dir09  dir11  dir13  dir15  dir17  dir19  dir21  dir23  dir25
dir02  dir04  dir06  dir08  dir10  dir12  dir14  dir16  dir18  dir20  dir22  dir24  lost+found
```

  

Great! We can list the directories on the mounted directory `/mnt/example1`.

### **Answer the questions below**

**Question:** Mount the image "exercise.img" located in the analyst home directory folder. What is the content of the file "flag.txt" located within exercise.img?

*Answer:* 

     THM{mounttt-mounttt-me}

---

## Task 6 | Practical Exercise

Start Machine**Note:**  Before you move forward with this task, please **turn off**  the VM in **task 2** .

Access the machine with the details below to complete the exercise and answer the question for this task.

You can start the attached machine in this task by clicking the Start Machine button. A split-screen view of the VM will appear. In case the VM is not visible, use the blue Show Split View button at the top of the page. Alternatively, you can access the machine via SSH using the credentials below.

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

**Username** practical**Password** forensics**IP** MACHINE_IP

### **Answer the questions below**

**Question:** Create an image of the attached 1gb loop device. What is the MD5 hash of the image?

*Answer:* 

     1fab86e499934dda789c9c4aaf27101d

**Question:** Mount the image from the 1 GB loop device. What is the content of the file "flag.txt"?

*Answer:* 

     THM{well-done-imaginggggggg}

---

## Task 7 | Conclusion

In this room, we learned the basics of forensic imaging, defining the main concepts and performing tasks that will put us in practical scenarios where we performed imaging of devices, mount, and check their integrity through hashing algorithms.

You can learn more about forensic imaging or more about Linux forensics in the rooms below.

- [Linux Forensics](https://tryhackme.com/r/room/linuxforensics)
- [Linux Fundamentals 2](https://tryhackme.com/r/room/linuxfundamentalspart2)
- [Linux Logs investigation](https://tryhackme.com/r/room/linuxlogsinvestigations)

### **Answer the questions below**

**Question:** Click to complete the task.

*Answer:* 

     No answer needed

---

