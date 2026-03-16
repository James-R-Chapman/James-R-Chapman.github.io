---
layout: post
title: "TryHackMe | macOS Forensics: Applications"
date: 2025-09-30
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/Advanced Endpoint Investigations/macOS Forensics"
identifier: "20250930T000000"
source_urls: "https://tryhackme.com/room/macosforensicsapplications"
source_path: "Advanced Endpoint Investigations/macOS Forensics/20251010T215625--tryhackme-macos-forensics-applications.md"
---

{% raw %}



# TryHackMe | macOS Forensics: Applications

## Task 1 | Introduction

In modern operating systems, users use applications to perform different activities. Therefore, when performing forensics, it is imperative to learn about the forensic artefacts created using various applications to fully understand user activity. In this room, we will learn about the forensic artefacts related to applications in macOS.

 Learning Objectives: 
- Leverage application data to perform forensic analysis on a Mac device.
- Explore persistence mechanisms in macOS.
- Identify user activity in built-in apps such as mail, calendar, phone, and messages.

 Prerequisites: Before starting this room, it is highly recommended that you complete:

 
- [macOS Forensics: The Basics](https://tryhackme.com/jr/macosforensicsbasics)
- [macOS Forensics: Artefacts](https://tryhackme.com/jr/macosforensicsartefacts)

 Please note that, similar to the previous room, this room requires advanced knowledge of the Linux command line and an understanding of the tools and techniques used in the earlier rooms.

 Machine Access Before moving forward, please press the **Start Machine**  button below to start the attached VM.

 Start Machine The machine will open in split view. The attached machine is a Linux machine with a macOS disk image named **mac-disk.img.** The image is placed in the home directory. As we learned previously, we will mount this disk image using the apfs-fuse utility and perform analysis on the image.

 In the coming tasks, we will demonstrate the artefacts on a live Mac machine and practice analysing them on the disk image in the attached Linux VM. Instructions will be provided on accessing the artefacts in the Linux VM if they differ from those in a live machine.

### **Answer the questions below**

**Question:** Let's see what application artefacts are present in macOS!

*Answer:* 

     No answer needed

---

## Task 2 | Common Application Information

Package Containers Like the `Program Files` directory in Windows, most macOS applications are installed in the `/Applications` directory. If we navigate this directory, we can see the installed applications in macOS as `.app` files.

   Applications Directory 
```Applications Directory 
umair@Umairs-MacBook-Pro /Applications % pwd
/Applications
umair@Umairs-MacBook-Pro /Applications % ls
Adobe Acrobat Reader.app
AnyDesk.app
Arc.app
Arduino IDE.app
Asana.app	
Blackmagic Disk Speed Test.app
CapCut.app
DB Browser for SQLite.app
Developer.app	
Discord.app	
Docker.app
```

   Each `.app` file is a directory, and we can navigate into this directory to view its contents. In the Finder app, we can do this by clicking `Show Package Contents` from the right-click menu. We can then navigate the files in the package.

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1744568255220.png)

 Similarly, we can see in the terminal that these files are marked as directories, as seen below.

   Application Packages in Terminal 
```Application Packages in Terminal 
umair@Umairs-MacBook-Pro /Applications % ls -l
total 0
drwxrwxr-x   3 root   wheel   96 Oct  5  2024 Adobe Acrobat Reader.app
drwxr-xr-x@  3 umair  admin   96 Oct 30 18:20 AnyDesk.app
drwxr-xr-x@  4 umair  admin  128 Apr 12 05:07 Arc.app
drwxr-xr-x@  3 umair  staff   96 Sep 25  2024 Arduino IDE.app
drwxr-xr-x@  3 umair  staff   96 Dec 16 21:26 Asana.app
drwxr-xr-x@  3 root   wheel   96 Oct 11  2024 Blackmagic Disk Speed Test.app
.
.
.
```

   We see a Contents directory when we navigate inside the `.app` directory for any application. This directory contains all the information and resources the application requires to function properly.

   Contents of .app Files 
```Contents of .app Files 
umair@Umairs-MacBook-Pro /Applications % cd AnyDesk.app/Contents 
umair@Umairs-MacBook-Pro Contents % ls
Info.plist	Library		MacOS		PkgInfo		Resources	_CodeSignature
```

   On a high level, every app contains the following parts to function properly.

    Info.plist The system requires this file for the application to work correctly. This is a structured plist file that contains configuration information for the application.   Application Executable The actual application executable is present in the `MacOS` directory. Its name is the same as the name of the application bundle, minus the `.app` extension. This executable contains the application code and any statically linked libraries.   Resources This directory is similar to the rsrc section in a PE file. It contains the resources the application needs to function correctly, such as language packs or images.   Frameworks This directory contains the application's shared libraries or frameworks, similar to dynamically linked libraries (DLLs) in Windows.   Plugins As the name indicates, this directory includes plugins, such as browser extensions, that might enhance the application's functionality.   SharedSupport This directory contains non-essential resources the application might use, such as document templates or clip art.    Application Install History A plist file located at `/Library/Receipts/InstallHistory.plist` contains valuable information about application installation. Information about each application is enclosed in a `<dict>` tag. It includes the date of application installation, display name, display version, package identifier, and the application/process used to install the application. Possible process names could be one of the following:

    macOS installer System/OS installer   softwareupdated System or Security updates   storedownloadd or appstoreagent Installed using App Store   installer Installed using an external installer    The following terminal shows a sample `InstallHistory.plist` file.

   InstallHistory.plist 
```InstallHistory.plist 
umair@Umairs-MacBook-Pro Receipts % cat InstallHistory.plist 
<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><array> <dict> <key>date</key> <date>2024-04-17T01:25:11Z</date> <key>displayName</key> <string>macOS 14.4</string> <key>displayVersion</key> <string>14.4</string> <key>processName</key> <string>softwareupdated</string> </dict> <dict> <key>date</key> <date>2024-04-17T01:27:14Z</date> <key>displayName</key> <string>Setup macOS Recovery Dependencies</string> <key>displayVersion</key> <string></string> <key>packageIdentifiers</key> <array> <string>com.apple.cdm.pkg.SetupMacOSRecoveryDependencies</string> </array> <key>processName</key> <string>installer</string> </dict> <dict> <key>date</key> <date>2024-07-25T02:38:09Z</date> <key>displayName</key> <string>‎WhatsApp</string> <key>displayVersion</key> <string>24.14.85</string> <key>packageIdentifiers</key> <array> <string>net.whatsapp.WhatsApp</string> </array> <key>processName</key> <string>appstoreagent</string> </dict>
```

   Further information about the installer process is available in the location `/private/var/db/receipts/<app-name>.plist`. This file also contains the install date, package version, and install prefix path. In the same directory, there is a `<app-name>.bom` file as well, which contains more details about the application install. This file can be opened using the `lsbom` utility, which is available in macOS by default but has also been installed in the attached VM.

   Install History Details 
```Install History Details 
umair@Umairs-MacBook-Pro receipts % plutil -p com.microsoft.package.Microsoft_Outlook.app.plist 
{
  "InstallDate" => 2025-04-23 08:34:21 +0000
  "InstallPrefixPath" => "Library/Caches/com.microsoft.autoupdate.helper/Clones.noindex"
  "InstallProcessName" => "installer"
  "PackageFileName" => "Microsoft_Outlook.pkg"
  "PackageIdentifier" => "com.microsoft.package.Microsoft_Outlook.app"
  "PackageVersion" => "16.96.25042021"
}
```

   Finally, we can also find information about installation details in the `/private/var/log/install.log` file. We can search for `Installed` in this log file to get the installation date and version information for installed applications.

   Install Log 
```Install Log 
umair@Umairs-MacBook-Pro ~ % cat /var/log/install.log|grep Installed
2024-04-16 18:27:14-07 MacBook-Pro installd[547]: Installed "Setup macOS Recovery Dependencies" ()
2024-04-16 18:27:28-07 MacBook-Pro system_installd[557]: Installed "MAContent10_AssetPack_0048_AlchemyPadsDigitalHolyGhost" (2.0.0.0)
2024-04-16 18:27:30-07 MacBook-Pro system_installd[557]: Installed "MAContent10_AssetPack_0310_UB_DrumMachineDesignerGB" (2.0.0.0)
2024-04-16 18:27:32-07 MacBook-Pro system_installd[557]: Installed "MAContent10_AssetPack_0312_UB_UltrabeatKitsGBLogic" (2.0.0.0)
.
.
.
2025-04-05 12:20:19+04 Umairs-MacBook-Pro system_installd[879]: Installed "Command Line Tools for Xcode" (16.3)
	    "__installState" = Installed;
2025-04-06 13:39:42+04 Umairs-MacBook-Pro installd[1790]: Installed "‎WhatsApp" (25.9.72)
2025-04-06 17:25:22+04 Umairs-MacBook-Pro installd[1790]: Installed "Microsoft OneDrive" ()
2025-04-07 18:43:40+04 Umairs-MacBook-Pro installd[1790]: Installed "Microsoft Teams" (25072.1704.3539.4369)
2025-04-08 23:54:13+04 Umairs-MacBook-Pro system_installd[879]: Installed "XProtectPlistConfigData" (5293)
2025-04-12 05:08:33+04 Umairs-MacBook-Pro installd[59531]: Installed "‎WhatsApp" (25.10.72)
2025-04-13 12:10:33+04 Umairs-MacBook-Pro installd[98329]: Installed "Microsoft OneDrive" ()
2025-04-15 20:51:03+04 Umairs-MacBook-Pro installd[98329]: Installed "Microsoft Excel" ()
2025-04-15 20:51:43+04 Umairs-MacBook-Pro installd[98329]: Installed "Microsoft Outlook" ()
```

   Now let's practice extracting these artefacts from the disk image in the attached VM.

### **Answer the questions below**

**Question:** When was Microsoft 365 and Office installed on the disk image in the attached VM? Format in GMT YYYY-MM-DD hh:mm:ss

*Answer:* 

     2025-04-26 06:41:43

**Question:** What is the name of the package used to install Microsoft Word?

*Answer:* 

     Microsoft_Word_Internal.pkg

---

## Task 3 | Autostart Items

We might have observed that applications can be configured to start at login in macOS. When applications restart, they often start from the same context from which they were shut down.

 Launch Agents and Daemons There are often background (or foreground) applications running in the OS that start with every reboot or login event, similar to applications in the autorun registry keys or Services in Windows. In macOS, these are called `LaunchAgents` or `LaunchDaemons`. `LaunchAgents` are user applications that execute at login, and `LaunchDaemons` are system applications that run with elevated privileges. `LaunchAgents` and `LaunchDaemons` are present in the `/System/Library`, `/Library` and `~/Library` directories, e.g. `~/Library/LaunchAgents/net.tunnelblick.tunnelblick.LaunchAtLogin.plist` as shown in the terminal below.

   LaunchAgent Plist File 
```LaunchAgent Plist File 
umair@Umairs-MacBook-Pro LaunchAgents % pwd   
/Users/umair/Library/LaunchAgents
umair@Umairs-MacBook-Pro LaunchAgents % plutil -p net.tunnelblick.tunnelblick.LaunchAtLogin.plist 
{
  "ExitTimeOut" => 0
  "Label" => "net.tunnelblick.tunnelblick.LaunchAtLogin"
  "LimitLoadToSessionType" => "Aqua"
  "ProcessType" => "Interactive"
  "ProgramArguments" => [
    0 => "/Applications/Tunnelblick.app/Contents/Resources/Tunnelblick-LaunchAtLogin"
  ]
  "RunAtLoad" => 1
}
```

   We can see some critical information in this plist file that can be helpful. We can see that the `ProcessType` has a value of `Interactive`, meaning this is a process with a GUI. The `ProgramArguments` key contains the executable path that will execute when logged in. We can also see that the `RunAtLoad` key has a value of `1`, indicating that this application is supposed to run at login. Please note that this information can be different for different types of files, as seen in the example below.

   Launch Agents and Daemons 
```Launch Agents and Daemons 
umair@Umairs-MacBook-Pro LaunchAgents % pwd   
/Library/LaunchAgentsumair@Umairs-MacBook-Pro LaunchAgents % plutil -p com.microsoft.OneDriveStandaloneUpdater.plist 
{
  "Label" => "com.microsoft.OneDriveStandaloneUpdater"
  "Program" => "/Applications/OneDrive.app/Contents/StandaloneUpdater.app/Contents/MacOS/OneDriveStandaloneUpdater"
  "ProgramArguments" => [
  ]
  "RunAtLoad" => 1
  "StartInterval" => 86400
}
umair@Umairs-MacBook-Pro LaunchAgents % cd ..
umair@Umairs-MacBook-Pro /Library % cd LaunchDaemons 
umair@Umairs-MacBook-Pro LaunchDaemons % plutil -p org.filezilla-project.filezilla-server.service.plist 
{
  "AssociatedBundleIdentifiers" => [
    0 => "org.filezilla-project.filezilla-server"
  ]
  "Disabled" => 0
  "EnvironmentVariables" => {
    "LC_CTYPE" => "en_US.UTF-8"
  }
  "GroupName" => "wheel"
  "Label" => "org.filezilla-project.filezilla-server.service"
  "ProgramArguments" => [
    0 => "/Applications/FileZilla Server.app/Contents/MacOS/filezilla-server"
    1 => "--config-dir=/Library/Preferences/org.filezilla-project.filezilla-server.service"
  ]
  "RunAtLoad" => 1
  "UserName" => "root"
}
umair@Umairs-MacBook-Pro LaunchDaemons % cd /System/Library/LaunchAgents
umair@Umairs-MacBook-Pro LaunchAgents % plutil -p com.apple.wallpaper.plist  
{
  "KeepAlive" => {
    "AfterInitialDemand" => 1
    "SuccessfulExit" => 0
  }
  "Label" => "com.apple.wallpaper.agent"
  "LimitLoadToSessionType" => [
    0 => "Aqua"
  ]
  "MachServices" => {
    "com.apple.usernotifications.delegate.com.apple.wallpaper.notifications.sonoma-first-run" => 1
    "com.apple.wallpaper" => 1
    "com.apple.wallpaper.CacheDelete" => 1
  }
  "POSIXSpawnType" => "App"
  "Program" => "/System/Library/CoreServices/WallpaperAgent.app/Contents/MacOS/WallpaperAgent"
  "RunAtLoad" => 0
  "ThrottleInterval" => 1
}
```

   Here, we explore three different plist files and observe that they often contain different information depending on the type of plist file and the program.

 Since macOS is based on Unix, it also supports cron jobs. However, most persistence mechanisms in macOS use LaunchAgents and LaunchDaemons, and cron jobs are rarely used.

 Saved Application State When a system reboots or a user logs in, the applications that are executed often execute in the same state as they were before the reboot. These saved states can be set when the user selects to reopen windows when logging in during a reboot or shutdown event. Therefore, we can consider the existence of these artefacts as evidence that the user used these applications at some point.

 This information about the state of applications is saved in macOS in the directory `~/Library/Saved Application State/<application>.savedState` for legacy applications, and `~/Library/Containers/<application>/Data/Library/Application Support/<application>/Saved Application State/<application>.savedState` for sandboxed macOS applications.

   Saved Application States 
```Saved Application States 
umair@Umairs-MacBook-Pro ~ % cd Library/Saved\ Application\ State 
umair@Umairs-MacBook-Pro Saved Application State % ls
cc.arduino.Arduino.savedState
cc.arduino.IDE2.savedState
com.Autodesk.eagle.savedState
com.amazon.aiv.AIVApp.savedState
org.filezilla-project.filezilla.savedState
com.apple.Maps.savedState				
com.electron.ollama.savedState				
org.raspberrypi.imagingutility.savedState
com.apple.Notes.savedState
com.apple.iCal.savedState
```

   We can assume that the user used the above applications at some point, as saved states for all these applications exist in the system.

### **Answer the questions below**

**Question:** What arguments does the Microsoft update agent launch with? Format "Argument 1", "Argument 2"

*Answer:* 

     "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/Microsoft Update Assistant.app/Contents/MacOS/Microsoft Update Assistant", "--launchByAgent"

---

## Task 4 | Notifications and Permissions

Reviewing an application's notifications and permissions can provide valuable information about its activity. In this task, let's review these artefacts.

 Notifications Application notifications can be found in a database on the location `/Users/<user>/Library/Group\ Containers/group.com.apple.usernoted/db2`. Attachments associated with notifications are in the attachments directory in this location, and the notifications database is in a file named `db` in the `db2` directory. We can use DB Browser to view this database and use the query from APOLLO's `notification_db` module. We might have to configure DB Browser to show all files instead of just the SQLite database files to view the database.

 ![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1745904088051.png)

 The notification data and category here are in the hex format and must be converted to ASCII to make them human-readable. We can convert hex to ASCII (maybe use Cyberchef) and save it as a plist file. Then we can view it as a plist file and read the notification data.

 Permissions Application permissions are in the Transparency, Consent, and Control (TCC) database, which is located in the locations `/Library/Application Support/com.apple.TCC/TCC.db` and `~/Library/Application Support/com.apple.TCC/TCC.db`. These databases can also be viewed using DB Browser, and we can use the query from the `tcc_db` module in APOLLO to extract data from this module.

 ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1745905057072.png)

 In the output, there is a tab named `SERVICE`. This tab tells us the permission requested by the application. For example, the service `kTCCServiceSystemPolicyAllFiles` is for Full Disk Access. Similarly, the tab named `AUTH_REASON` is for the reason for requesting the access, where `2` denotes User Consent and `4` denotes System Set. We can check [this](https://www.rainforestqa.com/blog/macos-tcc-db-deep-dive#all-services) blog for a complete list of values available for `SERVICE` and `AUTH_REASON`.

### **Answer the questions below**

**Question:** Which application has Full Disk Access permissions?

*Answer:* 

     com.apple.Terminal

---

## Task 5 | Contacts, Calls, and Messages

Contacts The Contacts application, which we often use to store contact information, can be found in the location `~/Library/Application Support/AddressBook`. This directory contains a `Sources` directory and a `Metadata` directory. Each contact has its metadata file. The metadata files are plist files, which we can parse using the plist utility, and the source files are database files, for which we can use DB Browser.

 However, when we navigate these directories, we will find that this information is scattered and can be confusing to collate. A better idea in such a scenario is to leverage the info Apple saves about interactions with different contacts. A database located on the location `/private/var/db/CoreDuet/People/interactionC.db` stores data related to interaction with contacts using apps such as Mail, Messages, or Phone. APOLLO's `interaction_contact_interactions` module contains queries that we can use to extract this information. If iCloud sync is enabled, this information will include all interactions with contacts using the same iCloud account, even from other devices. The screenshot below shows what the results from the query will look like.

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1745948165301.png)

 Calls Any calls made using a Mac are recorded in the database at `~/Library/Application Support/CallHistoryDB/CallHistory.storedata`. This is a database file that contains information about both phone calls and FaceTime calls. If iCloud sync is enabled, any calls made using other devices using the same iCloud account will also be synced to the same database. Therefore, if an iPhone is used to call someone, then a Mac with the same iCloud account might also have the records of the call saved to it if iCloud sync is enabled. We can use queries from the `call_history` module of APOLLO to extract call history information from this database.

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1745948165286.png)

 Messages SMS and iMessage history is saved in macOS in the database located at `~/Library/Messages/chat.db`. Attachments sent with messages are located in the directory `~/Library/Messages/Attachments`. We can explore the chat database using DB Browser and APOLLO's `sms_chat` module to parse it. This database contains both iMessage and SMS records. It also includes records from all iCloud-synced accounts, like contact interactions and call history.

 ![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1745948459333.png)

### **Answer the questions below**

**Question:** What is the email address of the user using this machine?

*Answer:* 

     thmguy535@gmail.com

**Question:** A call was made using FaceTime on 2025-04-26 05:40:04. Was this call answered? Y/N

*Answer:* 

     N

**Question:** The user received a message on 2025-04-26 05:38:20. This message contained an image as an attachment. What animal is present in that image?

*Answer:* 

     Dog

**Question:** On what date and time was the previous message read? Format YYYY-MM-DD hh:mm:ss

*Answer:* 

     2025-04-26 05:38:23

---

## Task 6 | Productivity Apps

Mail Emails configured in the Mail app are in the location `~/Library/Mail/V#/<UUID>/*.mbox`. We can navigate this directory and find multiple directories, such as `All Mail.mbox`, `Trash.mbox`, `Sent Mail.mbox`, and `Drafts.mbox`. Each of these directories further contains an `Info.plist` file that contains the metadata related to the emails.

   Info.plist File For "All Mail.mbox" 
```Info.plist File For "All Mail.mbox" 
umair@Umairs-MacBook-Pro All Mail.mbox % plutil -p Info.plist 
{
  "IMAPMailboxUnseenCount" => 0
  "MailboxID" => "A857F3FA-85BC-4BA7-8550-41864D236370"
  "MailboxIsFirstTimeSync" => "NO"
  "MailboxLastSyncDate" => 2025-04-26 08:06:38 +0000
  "MailboxName" => "All Mail"
  "SupportsCustomFlags" => "YES"
  "UIDNEXT" => "16"
  "UIDVALIDITY" => "12"
}
```

   The other directory, which looks like a mix of letters and numbers (or a UUID), contains a directory named Data. This directory further contains two directories: Messages and Attachments. The Messages directory contains email files in .emlx format, and the `Attachments` directory contains the attachments sent with the emails. If an email in the Messages directory is named `x.emlx`, the attachments with that email will be in a directory named `x`. Any meeting invites received via email can also be found in the `Attachments` directory.

   Messages and Attachments 
```Messages and Attachments 
umair@Umairs-MacBook-Pro Data % pwd
/Users/umair-thm/Library/Mail/V10/DEC2D507-7869-4151-98C3-E2F920A935CF/[Gmail].mbox/All Mail.mbox/708E1A15-F24E-40B5-8A69-FFD9A89FF251/Data
umair@Umairs-MacBook-Pro Data % ls *
Attachments:
16	17	22	23

Messages:
10.partial.emlx	11.partial.emlx	13.emlx		16.emlx		17.partial.emlx	20.emlx		22.partial.emlx	23.partial.emlx	24.emlx
```

   In the above example, we can see that emails 10, 11, 13, 20, and 24 did not have attachments. Emails 16, 17, 22, and 23 included attachments, which are present in the directories with the respective names.

 Calendar Calendar entries for a user are present in the directory `~/Library/Group\ Containers/group.com.apple.calendar/Calendar.sqlitedb`. We can open this database using DB Browser; the most helpful information can be found in the table `CalendarItem`. We can find information such as start date, end date, modification date, summary of the invite, and any meeting links. The time here is in the Mac Epoch time. We can add 978307200 to this time to convert it into Unix Epoch time and then use [this](https://www.epochconverter.com/) converter to convert into human-readable format.

 ![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1746015072731.png)

 Notes Apple Notes application data is in the location `~/Library/Group\ Containers/group.com.apple.notes/NoteStore.sqlite`. We can use DB Browser to browse this database; however, like we usually do for other databases, we can't use a query from APOLLO to run against this DB. We can use a query embedded in the `NOTES` module of mac_apt. However, a better way is to run mac_apt's `NOTES` module against the disk image to get the results. We can do that using the command:

 `python3 mac_apt.py -o <output path> -c DD <path to disk image> NOTES`

 This command will create a CSV file output with details about the notes. We can also create output in formats like XLSX or database files. Check out the help menu of mac_apt to learn about those options.

 Apple Notes can also contain attachments. These will be marked in the `AttachmentID` column in the output CSV file. These attachments are in the location `~/Library/Group\ Containers/group.com.apple.notes/Accounts/<UUID>/Media` directory. Each `AttachmentID` will have a directory of its own. Similarly, we can find the thumbnails associated with the notes files in the `~/Library/Group\ Containers/group.com.apple.notes/Accounts/<UUID>/Previews` directory.

 Reminders Reminders created by a user can be found in a database located in `~/Library/Group\ Containers/group.com.apple.reminders/Container_v1/Stores`. This directory contains multiple databases, each from a different source. We can get most of the information about our use from the table `ZREMCDREMINDER` in the databases. It includes the title, modified date, display date, creation date, calendar item UID, and source of the reminder. Time conversion follows the same format as discussed above for Calendar items.

 ![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1746008699646.png)

 Office Applications  Microsoft Office applications data is in the directory `~/Library/Containers/com.microsoft.<app>/Data`. Specifically, we can find some helpful information in the directory `~/Library/Containers/com.microsoft.<app>/Data/Library/Preferences`, in some plist files. For example, for Microsoft Word, the file `com.microsoft.Word.plist` contains general settings of Microsoft Word and the file `com.microsoft.Word.securebookmarks.plist` file contains the most recently used documents with their timestamps. Similarly, the file `com.microsoft.Outlook.Hx.plist` contains account information on the network configuration of Outlook and `com.microsoft.Outlook.plist` file includes general information about the Microsoft Outlook application.

   Microsoft Word Most Recently Used Documents 
```Microsoft Word Most Recently Used Documents 
umair@Umairs-MacBook-Pro Preferences % plutil -p com.microsoft.Word.securebookmarks.plist 
{
  "file:///Users/umair-thm/Downloads/Report-final-updated.pdf" => {
    "kBookmarkDataKey" => {length = 716, bytes = 0x626f6f6b cc020000 00000410 30000000 ... 04000000 00000000 }
    "kLastUsedDateKey" => 2025-04-26 07:19:51 +0000
    "kUUIDKey" => "1FEDB2BE-9030-4870-9E3C-AC7D994C1322"
  }
  "file:///Users/umair-thm/Downloads/Report-final.docx" => {
    "kBookmarkDataKey" => {length = 712, bytes = 0x626f6f6b c8020000 00000410 30000000 ... 04000000 00000000 }
    "kLastUsedDateKey" => 2025-04-26 07:18:57 +0000
    "kUUIDKey" => "3C17D0B3-D778-41B3-9234-9B0AA1F910A7"
  }
  "file:///Users/umair-thm/Downloads/Report-updated.rtf" => {
    "kBookmarkDataKey" => {length = 712, bytes = 0x626f6f6b c8020000 00000410 30000000 ... 04000000 00000000 }
    "kLastUsedDateKey" => 2025-04-26 07:19:12 +0000
    "kUUIDKey" => "5CCCF76E-F065-4D4E-8D7E-7EF3C82B075E"
  }
  "file:///Users/umair-thm/Downloads/Report1.doc" => {
    "kBookmarkDataKey" => {length = 704, bytes = 0x626f6f6b c0020000 00000410 30000000 ... 04000000 00000000 }
    "kLastUsedDateKey" => 2025-04-26 07:19:21 +0000
    "kUUIDKey" => "4265955E-1B9A-401F-83B0-52E1A2329A6F"
  }
}
```

   Similarly, the directory `~/Library/Containers/com.microsoft.<app>/Data/Library/Application\ Support/Microsoft `contains information such as the `AppData` directory, similar to Microsoft Windows, directories for fonts, and a `Temp` directory.

### **Answer the questions below**

**Question:** The user received a calendar invite in the mail from someone. What date is the calendar invite for? Format YYYY-MM-DD hh:mm:ss

*Answer:* 

     2025-04-27 11:00:00

**Question:** What was the timezone of the sender of the email invite? Format: GMT+XX:XX

*Answer:* 

     GMT+03:00

**Question:** The user's calendar has another entry named "Jungle cruise". When is this event going to start? Format in GMT YYYY-MM-DD hh:mm:ss

*Answer:* 

     2025-04-25 16:00:00

**Question:** The user saved two notes. Both have the same title. What is the title?

*Answer:* 

     Aquickbrownfoxjumpedoverthelazydog

**Question:** One of the notes has an attachment we already viewed while analysing iMessage. What animal is present in the other attachment?

*Answer:* 

     Giraffe

**Question:** The user has saved a reminder that has not been completed yet. What is the due date of this reminder? Format in GMT YYYY-MM-DD hh:mm:ss

*Answer:* 

     2025-04-26 21:00:00

**Question:** What is the complete path of the last file opened using Microsoft Word?

*Answer:* 

     /Users/umair-thm/Downloads/Report-final-updated.pdf

---

## Task 7 | Browsing History, Downloads, and Bookmarks

Browsers Browsers play a large part in understanding a user's activities. We can broadly group the browser activity into Safari and non-Safari browsers. We can further classify artefacts into browser history, session/tab information, extensions, and downloads. First, let's discuss the artefacts related to the Safari browser.

 Safari Artefacts related to the Safari browser are in the location `~/Library/Safari`. There are a lot of handy files here, with mostly self-explanatory names. For example, the `Downloads.plist` file contains the list of files downloaded using Safari, the `UserNotificationPermissions.plist` file contains user preferences for websites to show notifications, and the `Bookmarks.plist` file contains the bookmarks. But the most important of all files is the `History.db` file, which includes the Safari browsing history. We can use DB Browser to view this database file, and use the query from APOLLO's `safari_history` module to parse the data from this database in a more friendly manner.

 ![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1746038681667.png)

 In addition, more information related to Safari cache is present in the directory `~/Library/Containers/com.apple.Safari/Data/Library/Caches`. Specifically, we can find session restore information (`TabSnapshots`) and browser cache (`WebKitCache`) in this directory.

 Other Browsers For other browsers such as Brave, Chrome, Arc or Firefox, the directory structure of the artefacts is almost similar. For example, for Chrome, we can find the history file and many other artefacts of interest with self-explanatory names in the directory `~/Library/Application\ Support/Google/Chrome/Default`. The browsing history is present in a database named History. We can browse the `~/Library/Application\ Support/Google/Chrome/Default/Sessions/` directory for session restore information. For extensions, we can find information in the `~/Library/Application\ Support/Google/Chrome/Default/Extensions` directory. Similarly, other browsers follow a similar directory structure for their forensic artefacts. The following screenshot shows the browsing history of a browser as viewed in DB browser, with the table `visited_links` visible.

 ![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1746040412485.png)

 We might note that the table does not contain the time of the visits, which can be found in another table by correlating with the `id` of the visit and converting from Mac Epoch time.

### **Answer the questions below**

**Question:** The user seems to be a fan of TryHackMe. What is the URL of the THM room the user visited using Safari?

*Answer:* 

     https://tryhackme.com/room/macosforensicsartefacts

---

## Task 8 | Photos and Apple Pay

Photos The native Photos app of macOS keeps its data in the location `~/Pictures/Photos Library.photoslibrary`. This location contains pictures and videos taken from the camera, screenshots, and files synced from other devices such as iPhones, iPads, or iCloud. In this location, there are different directories. The directory named `original` contains the original images in HEIC or JPG formats. The directory named `database` contains multiple databases; the most interesting one is `Photos.sqlite`, which contains metadata for all the images, including location, detected persons, the date the image was taken, and album-related information.

 ![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1746043609773.png)

 Wallet and Apple Pay Cards and Passes saved in the Apple Wallet are stored in the location `~/Library/Passes.` In this location, a `Cards` directory contains data about cards saved in Apple Pay. Each card is stored in a package-format directory as a `*.pkpass `file. Inside it, we can find a `pass.json` file containing the actual card or pass data.

   Cinema Ticket Pass 
```Cinema Ticket Pass 
umair@Umairs-MacBook-Pro KvqnqUe+9bbxUHo0EePitn1AH5w=.pkpass % cat pass.json 
{"formatVersion":1,"teamIdentifier":"NQD6NBS7CH","passTypeIdentifier":"pass.com.voxcinemas.booking","serialNumber":"29c574a4-d5c7-4977-a5ba-27f7942d3bbb_0012-466232","description":"Booking at VOX Cinemas","organizationName":"VOX Cinemas","backgroundColor":"rgb(255, 255, 255)","foregroundColor":"rgb(0, 0, 0)","labelColor":"rgb(0, 116, 188)","relevantDate":"2025-01-19T14:05:00+04:00","eventTicket":{"headerFields":[{"key":"showtime","label":"SUN 19 JAN","value":"14:05"}],"secondaryFields":[{"key":"movie","label":"YAS MALL - ABU DHABI","value":"[PG] Sonic The Hedgehog 3"}],"auxiliaryFields":[{"key":"screen","label":"VOX MAX 6","value":"A-12, A-11, A-10"}],"backFields":[{"key":"reference","label":"reference_label","value":"WWDM5FP"},{"key":"runtime","label":"runtime_label","value":"110 min"},{"key":"language","label":"language_label","value":"English"},{"key":"experience","label":"experience_label","value":"MAX"},{"key":"seats","label":"seats_label","value":"A-12, A-11, A-10"},{"key":"tickets","label":"tickets_label","value":"3 x PREFERRED MAX 2D"},{"key":"total","label":"total_label","value":"210.00 AED"}]},"barcode":{"format":"PKBarcodeFormatQR","messageEncoding":"utf-8","message":"WWDM5FP","altText":"WWDM5FP"}}%
```

   Details of transactions completed through Apple Pay are in a database file named `passes23.sqlite` in the `~/Library/Passes` directory. APOLLO has a few modules with names starting with `passes23_*` that can provide us with the queries to extract data from this database. Please note that the queries in APOLLO modules use an older format, where `PAYMENT_TRANSACTION.PASS_PID` is used instead of the new `PAYMENT_TRANSACTION.PID`, so change the query when running against newer macOS versions.

 ![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/61306d87a330ed00419e22e7-1746042611678.png)

### **Answer the questions below**

**Question:** When using APOLLO queries to parse passes, to what should we change the field PAYMENT_TRANSACTION.PASS_PID on newer macOS versions?

*Answer:* 

     PAYMENT_TRANSACTION.PID

---

## Task 9 | Conclusion

And that's a wrap! In this room, we learned to trace user activity across multiple applications. In summary, we discovered:

 
- Where applications reside in macOS and how to trace their installation history.
- What type of persistence mechanisms are present in macOS
- How do you extract notifications from different applications, and what permissions do the applications have?
- Contacts and interactions with contacts using calls, messages and FaceTime on a Mac.
- What kind of artefacts do productivity apps like Notes, Reminders, and Calendars leave on macOS.
- Sensitive information of a Mac user, such as browsing history, photos, and wallet information.

 Do you know of any other artefacts that can be found in a macOS machine? Let us know in our [Discord channel](https://discord.gg/tryhackme) or [X account](http://x.com/realtryhackme). See you around.

### **Answer the questions below**

**Question:** I am confident I can forensicate a Mac now and am ready for a challenge!

*Answer:* 

     No answer needed

---
{% endraw %}
