---
layout: post
title: "TryHackMe  - Dynamic Analysis - Debugging"
date: 2025-07-16
tags: [["tryhackme"]]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 2/Malware Analysis"
identifier: "20250716T000001"
source_id: "c23fe715-b337-4314-b416-432cc24d0d6d"
source_urls: "- (https://tryhackme.com/room/advanceddynamicanalysis)"
source_path: "SOC Level 2/Malware Analysis/20250716T000001--tryhackme-dynamic-analysis-debugging__tryhackme.md"
---

{% raw %}


# TryHackMe | Dynamic Analysis: Debugging

## Task 1 | Introduction

In the [Basic Dynamic Analysis](http://tryhackme.com/room/basicdynamicanalysis) room, we learned to identify malware traces in the infected system during execution. However, malware authors understand that the malware will be analyzed and want to thwart it. This can be done through various evasion techniques. To defeat these evasion techniques, a malware analyst desires more control over malware execution. In this room, we will learn how a malware analyst can control malware execution better to achieve the desired results.

 Learning Objectives: In this room, we will learn:

- The evasion techniques used to evade basic dynamic analysis.
- Introduction to debuggers and how they can help us control the execution flow of malware.
- Manipulating execution flow at runtime by changing registers or other parameters.
- Patching malware to force it to move past the evasion techniques and onto the actual malicious content.

 Pre-requisites: To get the best learning outcome from this room, it is recommended that you complete the following rooms:

- [Basic Static Analysis](https://tryhackme.com/room/staticanalysis1)
- [Basic Dynamic Analysis](http://tryhackme.com/room/basicdynamicanalysis)
- [Advanced Static Analysis](https://tryhackme.com/room/advancedstaticanalysis)

### **Answer the questions below**

**Question:** Complete the Pre-requisite rooms.

*Answer:* 

     No answer needed

---

## Task 2 | The Need for Advanced Dynamic Analysis

Analyzing malware is like a cat-and-mouse game. Malware analysts keep devising new techniques to analyse malware, while malware authors devise new techniques to evade detection. This task will review some techniques that hamper our efforts to analyse malware using static or basic dynamic analysis.

 Evasion of Static Analysis: In the static analysis rooms, we learned techniques to perform static analysis on malware. Malware often hides or tries to look like legitimate software to evade the prying eyes of a malware analyst. Because we are not executing the malware during static analysis, the main focus of evading static analysis is to obfuscate the true functionality of the program until the program is executed. The following techniques can be commonly used to achieve this.

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61492ae128e1b18ee8455380cb9c229c.png)

- **Changing the hash:**  We have learned previously that every file has a unique hash. Malware authors exploit this functionality by slightly changing their malware. This way, the malware's hash changes, bypassing the hash-based detection mechanism. Hashes can change even if one bit of the malware is changed (unless we are talking Context-Triggered Piecewise Hashes or fuzzy hashes), so just adding a NOP instruction or other such change can defeat the hash-based detection techniques.
- **Defeating AV signatures:** Anti-virus signatures and other signature-based detection often depend on static patterns found inside malware. Malware authors change those patterns to try to evade signatures. This technique is often accompanied by general obfuscation of malware code.
- **Obfuscation of strings:**  Some malware authors obfuscate the strings in malware by decoding them at runtime. When we search the malware for strings, we might find nothing useful. However, when the malware runs, it decodes those strings during execution. Malware authors might obfuscate important strings, such as URLs, C2 domains, etc., to avoid burning the infrastructure based on a single-string search.
- **Runtime loading of DLLs:**  Since we can identify malware imports while analyzing PE headers, malware authors often use the Windows libraries' LoadLibrary or LoadLibraryEx to load a DLL at runtime. When analyzing this malware statically, we might not see all the functions it is linked to while analyzing its headers.
- **Packing and Obfuscation:**  Packing is very popular amongst malware authors. Packing malware is like packing a present. When we look at a packed present, we can't say what might be inside it unless we unpack the wrapper and take out the present. Similarly, packers pack the malware in a wrapper by writing code that decodes the malware at runtime. So when performing static analysis, we might be unable to see what is inside the packer. However, when we execute the malware, it unpacks the code, loads the actual malicious code into the memory, and then executes it.

As we might have observed, most of these techniques are suitable for hiding in plain sight, but they can be defeated when the malware is executed while performing dynamic analysis.

 Evasion of Basic Dynamic Analysis: Malware authors do not just accept their fate and let dynamic analysis detect their samples. For evasion of dynamic analysis, a host of techniques are employed. These techniques generally depend on identifying whether the malware runs in a controlled analysis environment. The following techniques are commonly used for this purpose:

- **Identification of VMs:**  Though some of these techniques might backfire nowadays since a lot of enterprise infrastructure is hosted on VMs, one of the favourites of malware authors has been to identify if the malware is running inside a VM. For this, malware often checks for registry keys or device drivers associated with popular virtualization software such as VMWare and Virtualbox. Similarly, minimal resources, such as a single CPU and limited RAM, might indicate that the malware is running inside a VM. In this scenario, malware will take a different execution path that is not malicious to fool the analyst.
- **Timing attacks:**  Malware will often try to time out automated analysis systems. For example, when malware is executed, it will try to sleep for a day using the Windows Sleep library. After a few minutes, the automated analysis system will shut down, finding no traces of malicious activity. Newer malware analysis systems can identify these attacks and try to mitigate them by shortening the time the malware sleeps. However, malware can identify those mitigations by performing targeted timing checks to see if the time is being manipulated. This can be done by noting the time of execution and comparing it with the current time after the execution of the sleep call.
- **Traces of user activity:**  Malware tries to identify if there are traces of user activity in the machine. If no or very few traces are found, malware will decide that it is being executed inside a controlled system and take a different, benign execution path. Traces of user activity can include no mouse or keyboard movement, lack of browser history, no recently opened files, little system uptime, etc.
- **Identification of analysis tools:**  Malware can ask the Windows OS for a running process list using Process32First, Process32Next, or similar functions. If popular monitoring tools are identified among the list of running processes, malware can take a benign execution path. For example, if ProcMon or ProcExp is running, malware can identify that and switch to benign activities. Another way to identify analysis tools is by looking at the names of different windows open in a system. If the malware finds Ollydbg or ProcMon in the open Windows, it can switch to a different execution path.

By employing these techniques, malware authors make it difficult for malware analysts to perform analysis. However, malware analysts can use some tools and techniques to take greater control over malware execution, helping them defeat these evasion techniques. In the upcoming tasks, we will learn about some of these techniques.

### **Answer the questions below**

**Question:** Malware sometimes checks the time before and after the execution of certain instructions to find out if it is being analysed. What type of analysis technique is bypassed by this attack?

*Answer:* 

     basic dynamic analysis

**Question:** What is a popular technique used by malware authors to obfuscate malware code from static analysis and unwrap it at runtime?

*Answer:* 

     Packing

---

## Task 3 | Introduction to Debugging

The term Debugging is widely used by software programmers to identify and fix bugs in a program. Similarly, a malware sample trying to evade detection or reverse engineering can also be considered a program having a bug. A malware reverse engineer often has to debug a program to remove any roadblocks that prevent it from performing its malicious activity. Therefore, interactive debugging becomes an essential part of advanced malware analysis. Debuggers provide a malware analyst with the control desired to monitor a running program more closely, looking at the changes in different registers, variables, and memory regions as each instruction is executed. A debugger also allows a malware analyst to change the variables' values to control the program's flow at runtime, providing greater control over the execution path the malware follows.

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/dff36efedbacd9e2896e43cdb4e63541.png)

 Types of Debuggers: We can loosely categorize debuggers into one of the following three categories.

 Source-Level Debuggers: Source Level Debuggers work on the source code level. Most software programmers use source-level debuggers while writing code to check their code for bugs. A source-level debugger is a high-level debugger compared to the other two options. When using a source-level debugger, we often see the local variables and their values.

 Assembly-Level Debuggers: When a program has been compiled, its source code is lost and can't be recovered. This is the case with malware analysis. We don't have the malware's source code we are investigating; instead, we have a compiled binary. An assembly-level debugger can help us debug compiled programs at the assembly level. While debugging with an assembly-level debugger, we often see the CPU registers' values and the debuggee's memory. This is the most common type of debugger used for malware reverse engineering. The debugger attaches to the program that has to be debugged and executes it as per the analyst's desire.

 Kernel-Level Debuggers: Kernel-level debuggers are a step even lower than assembly-level debuggers. As the name suggests, these debuggers debug a program at the Kernel Level. For this level of debugging, generally, two systems are required. One system is used for debugging the code running on the other system. This is because if the kernel is stopped using a breakpoint, the whole system will stop.

 Now let's move to the next task to learn how to debug malware.

### **Answer the questions below**

**Question:** Can we recover the pre-compilation code of a compiled binary for debugging purposes? Write Y for Yes or N for No

*Answer:* 

     N

**Question:** Which type of debugger is used for debugging compiled binaries?

*Answer:* 

     assembly-level debugger

**Question:** Which debugger works at the lowest level among the discussed debuggers?

*Answer:* 

     Kernel-level debugger

---

## Task 4 | Familiarization With a Debugger

Start MachineFor malware analysis, there are many options to choose a debugger from. These options include Windbg, Ollydbg, IDA, and Ghidra. For this room, we will be using x32dbg and x64dbg. Before proceeding, please start the machine by clicking the option in the top-right corner. The machine will open in the split view. Alternatively, you can connect to the machine using the following credentials:

 **Username:** administrator
**Password:** Passw0rd!

 The attached VM is essentially a FLARE VM, distributed by Mandiant (previously FireEye, now part of Google), widely used for reverse engineering malware. It includes all the tools required for our analysis in this room. To start, we can navigate to Desktop > Tools > debuggers > x32dbg.exe to run the debugger. We will be greeted with the following interface.

 ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/122f3938f004ced754a5732cefeca9b0.png)

 To open a file in the debugger, we can navigate to File > Open and open our desired file. The below screenshot shows the interface with a sample opened in the debugger. We are currently seeing the CPU tab in the interface. Please note that we must use x32dbg for 32-bit samples and x64dbg for 64-bit samples.

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/b7d1b50712af9e82941388fe409e5c34.png)

 As we can see in the bottom left corner, the execution of the program is paused because a System breakpoint has been reached. We can control whether to execute one instruction at a time or the whole program. But before that, let's take a look at the screenshot above. Here, we can see Disassembly in the middle pane, with the Instruction pointer pointing to the next instruction executed if we start the program. In the right pane, we can see the registers and their values. We can note that the value in EIP is the address EIP is pointing to in the disassembly pane. Similarly, on the bottom pane, we can see the stack view (right), the dump view (left), and the timer showing the time we spent debugging the sample (right corner).

 Let's look at some of the other tabs. The breakpoints tab shows the current status of breakpoints. Breakpoints are points where the execution of the program is paused for the analyst to analyze the registers and memory. A breakpoint on a specific instruction can be enabled by clicking the dot in front of that instruction in the CPU tab.

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/79e896ba320e9345a1d363e45a8f20c7.png)

 The Memory Map shows the memory of the program.

 ![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/62a68abf449368d2f1ca833ad397d56f.png)

 We can also see the Call stack of the program.

 ![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/24780cf5def1f11fee9ef2cb137ee61d.png)

 The threads running in the program are shown in the threads tab.

 ![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/725747fd97bff2e4fb093a8fa3144252.png)

 Any handles to files, processes, or other resources the process accesses are shown in the handles tab.

 ![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/629c819b78c70d1d9061153e15142682.png)

 In the next task, we will learn how to utilize this information for malware analysis.

### **Answer the questions below**

**Question:** In which tab is the disassembly view shown in x32dbg?

*Answer:* 

     CPU tab

**Question:** If a process opens a file or a process, where can we see information regarding that opened file or process?

*Answer:* 

     Handles tab

---

## Task 5 | Debugging in Practice

Now that we are familiar with the UI of x32dbg, let's learn about debugging a program by executing it step-by-step. Let's start by opening one of the crackmes from the attached VM. We can do this by clicking File > Open. We will see the below window asking us to select the file we want to select. Select crackme-arebel.exe as the file we want to debug.

 ![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/4172b48611632cfdb735d7621b3e9a74.png)

 We select the file we need to open. The debugger attaches itself to the process and pauses it before it starts. We can see that a blank Command window opens in the background. This shows that the process has started but was stopped by the debugger. Please note that this window might not open with all processes. It will depend on the User Interface of the process. In the debugger window, we can see the familiar disassembly, the registers, the stack and other useful information. Please note that the address might not always be as shown in the images.

 ![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/40468f1c9a9284260a939e5e296b48fd.png)

 In the debugger window, we have some features that help us control the execution. In the below screenshot, we can see some of them highlighted.

 ![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/fa08515570b4fc7c68a46954178b9c82.png)

 Among these, from left to right, we have the feature for opening a new file, restarting the execution of the opened file from the start, and stopping the execution. The arrow key will execute the program until it is stopped or paused by some other control (Please do not press this button right now as it might freeze the program. If you did, kindly restart the program by terminating it through the Task Manager). Then we have the pause option. The last two options are for stepping into and stepping over. The rest of the options are also useful, but for the scope of this room, we will only be using the ones mentioned above.

 So now that we know how to control the execution, let's execute the program using the arrow key (Please only press it once). When we do that, we can see in the bottom right corner that the program's status changes to Running, then Paused. Along with the status, we have the reason for pausing the execution. It says "INT3 breakpoint "TLS Callback 1"....". This means that we have hit a [TLS callback](https://hex-rays.com/blog/tls-callbacks/), and the debugger was programmed to break execution on TLS callbacks.

 ![Image 13](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/89d37239a974b85ff285db05de3d8d51.png)

 

 In the debugger, we can set where to put automatic breakpoints on a program by going to the Options > Preferences menu. The following screenshot shows the different points where breakpoints are automatically placed. We can see that TLS Callbacks and System TLS Callbacks are checked, which means execution will be broken on these events.

![Image 14](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/218abdcbcc003bea8207e4c9265e666a.png)

 

 Since TLS callbacks are often used as an anti-reverse engineering technique, we should be careful when navigating this TLS callback. Therefore, it will be prudent to single-step each instruction while we are in the callback. We can do that by clicking the step-into option we discussed above. After stepping into every instruction, we see the EIP moving to the next instruction, and the values in the registers and stack change accordingly. After stepping in a few instructions, we reach a conditional jump instruction. In the pane below the disassembly, we can see that the debugger tells us that the jump is not taken. The registers pane shows that the ZF is set, so the jump is not taken.

![Image 15](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/097d86e3c54dcdd93f3577bdf144695a.png)

 

 If we analyze both execution paths, we see if the jump is taken, it goes to address D116E, which pops EBP and returns. On the contrary, the current execution path, where the jump is not taken, takes us to address D1000. We can see what is on this address by double-clicking on the address. So let's go there. Alternatively, we can hover over the address to get a glimpse of the instructions on that address. The below screenshot shows the code when we follow the address. Here we see a few API calls like CreateToolhelp32Snapshot, LoadLibrary and GetProcAddress if we follow it down further. If we were sure that this function call was intended and we wanted to return after the function was executed, we could step over, which will bring us back after the function has been executed. However, the function seems too important to bypass straight away.

![Image 16](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/d2675e587733af5f9e60d492e8a6643e.png)

 

 These libraries can be used to evade detection or for legitimate purposes, but we don't know that for now. So we can move along this path, and if we see a red flag, we just restart it again using the restart execution option. Moving forward, we see that the Library being loaded is Suspend Thread.

![Image 17](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/56b71a7c589da942a82fa719bd89086d.png)

 

 The SuspendThread API is being loaded. This TLS callback will suspend the thread based on detecting a running process, such as a debugger (the CreateToolhelp32Snapshot API helps identify running processes). This is why the program will freeze if we proceed with the execution. We can verify this hypothesis by moving forward along this code path. On verification, we find that this is an evasion code path. Therefore, we would like to bypass it. For that, we would like to take the jump in the start of the TLS callback. Let's restart the execution and get to the TLS callback in the next task.

### **Answer the questions below**

**Question:** The attached VM has a crackme in the directory Desktop > crackme-arebel. In that crackme, there is a TLS callback with a conditional jump. Is this conditional jump taken? Write Y for Yes or N for No

*Answer:* 

     N

**Question:** What is the value of the Zero Flag in the above-mentioned conditional jump?

*Answer:* 

     1

**Question:** Which API call in the mentioned sample is used for enumerating running processes?

*Answer:* 

     CreateToolhelp32Snapshot

**Question:** From which Windows DLL is the API SuspendThread being called?

*Answer:* 

     Kernel32.dll

---

## Task 6 | Bypassing unwanted execution path

In the below screenshot, we can see that the execution has been restarted and brought back to the branch of code where we identified a detection evasion, that is, at the TLS callback breakpoint.

![Image 18](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/136b6cf7bd7086addb9408698cc85e87.png)

 

 Stepping a few instructions to reach the conditional jump, we get to the following point.

![Image 19](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/4970b3bbb816d606848bd2dab7c31b15.png)

 

 We see that the jump is not being taken at this point. In the previous task, we identified that the ZF was the reason for the jump not being taken. By double-clicking ZF in the right pane, we can change the ZF to 0.

![Image 20](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/1f51023eeeb8a1f3e142cb90b9dd6471.png)

 

 We can see here that the ZF is now 0, and the jump is taken. This way, we can bypass the unwanted execution path. If we step further or execute the program, it will take the jump and move to address D116E.

What we did here changed the execution path on runtime by manipulating the registers. However, if we execute the sample again, it will again go on to the evasion path unless we change the registers. If we wish to defang the binary, we will have to change it so that the evasion path is not an option if it is just run through double-clicking. This is called patching. This way, after being defanged, we can perform dynamic analysis to reach our desired conclusion. Let's see how we can do that.

We can right-click on the instruction we want to edit to find the options related to that instruction. Among these is the option to edit, as seen in the following screenshot.

 ![Image 21](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/7b89d424bca2089cf9e9c782a2a7acb7.png)

 When we press edit, we see the following window.

 ![Image 22](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/1534838bea416e087e8dc36396e5d75f.png)

 In the lowermost pane, we see 75 05 in hex, the opcode for the conditional jump instruction. We can change this in the following ways.

1. Change the jne to je. This way, the jump will be taken without us changing the ZF.
2. Change the conditional jump to an unconditional jump. This way, the jump will always be taken regardless of the condition above.

Among these two options, the second one is better as it gives us surety for the jump. However, there is one more way we can edit the binary for it to take our preferred execution path. That is, by filling the call instruction at address D1169 with NOPs. As discussed in a previous room, NOPs are instructions that don't do anything. The screenshot below shows that we can fill the instruction with NOP by right-clicking and going to Binary > Fill with NOPs.

 ![Image 23](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/7d4efe1dfbb01540363d0452fd43fcce.png)

 Once done, we can go to File > Patch File to write this file to disk. We might see something like the below window once we navigate to that.

 ![Image 24](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/7330c3585ccd2dd3cb0b87a59c21d86f.png)

 By clicking Patch File on this window, the debugger will ask us where to save the patched file. This is how it will look once we have filled it with NOPs. Notice that a single instruction has been replaced with five NOP instructions. This is because the size of the single instruction was equal to five NOP instructions. This is more visible in the above screenshot, where each NOP instruction is mapped against equal sized Opcode.

 ![Image 25](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/da552159734d2a1b0fe694032f8c951e.png)

 In the attached VM, we can see that the file crackme-arebel1.exe is patched. This is how the same file looks when patched and saved.

 ![Image 26](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/3f919d19066331c51ca68c264f647608.png)

 Hurray, we have used the debugger to patch a file evading debuggers!

### **Answer the questions below**

**Question:** What is it called when a binary's assembly code is permanently altered to get the desired execution path?

*Answer:* 

     Patching

---

## Task 7 | Conclusion

This was it for this room. In this room, we learned the following:

- Common techniques to evade static and basic dynamic malware analysis.
- The use of debuggers for deeper analysis of malware.
- Using debuggers for changing the environment at runtime.
- Using debuggers to patch malware samples.

However, this is not it. Malware authors also use many techniques to evade dynamic analysis and debugging. Head over to the [Anti-Reverse Engineering](https://tryhackme.com/room/antireverseengineering) room to learn about more evasion techniques and how to counter them. Let us know what you found interesting in this room on our [Discord channel](https://discord.gg/tryhackme) or [Twitter account](http://twitter.com/realtryhackme).

### **Answer the questions below**

**Question:** Head over to our social channels for further discussion.

*Answer:* 

     No answer needed

---
{% endraw %}
