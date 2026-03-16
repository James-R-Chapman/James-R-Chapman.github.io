---
title:      "Snort Challenge - Live Attacks"
date:       2025-02-05T20:55:22-05:00
tags:       ["tryhackme"]
identifier: "20250205T205532"
hubs: "TryHackMe/SOC Level 1/Network Security and Traffic Analysis"
id: ae39e56c-db90-4eb0-9a5f-592346b11595
---

### SOC Level 1 > Network Security and Traffic Analysis > Snort Challenge - Live Attacks

### [TryHackMe | Snort Challenge - Live Attacks](https://tryhackme.com/r/room/snortchallenges2)

# Task 1 | Introduction

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/6131132af49360005df01ae3/room-content/7d2e86ff6ec569ee33bcc30e23f33332.png)

The room invites you to a challenge where you will investigate a series of traffic data and stop malicious activity under two different scenarios. Let's start working with Snort to analyse live and captured traffic.

Before joining this room, we suggest completing the [Snort](https://tryhackme.com/r/room/snort) room. 
**Note:** There are two VMs attached to this challenge. Each task has dedicated VMs. You don't need SSH or RDP, the room provides a **"Screen Split"**  feature.

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/6131132af49360005df01ae3/room-content/ce7ed0edba5474a050296b933bc16693.png)

Answer the questions belowRead the task above.

Correct Answer

### **Answer the questions below**

**Question:** Read the task above.

*Answer:* 

     No answer needed

---

# Task 2 | Scenario 1 | Brute-Force

Start MachineUse the attached [VM]() to finish this task.

**[+] THE NARRATOR**

J&Y Enterprise is one of the top coffee retails in the world. They are known as tech-coffee shops and serve millions of coffee lover tech geeks and IT specialists every day.

They are famous for specific coffee recipes for the IT community and unique names for these products. Their top five recipe names are;

**WannaWhite** , **ZeroSleep** , **MacDown** , **BerryKeep**  and **CryptoY** .

J&Y's latest recipe, "**Shot4J** ", attracted great attention at the global coffee festival. J&Y officials promised that the product will hit the stores in the coming months.

The super-secret of this recipe is hidden in a digital safe. Attackers are after this recipe, and J&Y enterprises are having difficulties protecting their digital assets.

Last week, they received multiple attacks and decided to work with you to help them improve their security level and protect their recipe secrets.

This is your assistant **J.A.V.A. (Just Another Virtual Assistant).**  She is an AI-driven virtual assistant and will help you notice possible anomalies. Hey, wait, something is happening...

**[+] J.A.V.A.**

Welcome, sir. I am sorry for the interruption. It is an emergency. Somebody is knocking on the door!

**[+] YOU**

Knocking on the door? What do you mean by "knocking on the door"?

**[+] J.A.V.A.**

We have a brute-force attack, sir.

**[+] THE NARRATOR**

This is not a comic book! Would you mind going and checking what's going on! Please...

**[+] J.A.V.A** .

**Sir, you need to observe the traffic with Snort and identify the anomaly first. Then you can create a rule to stop the brute-force attack. GOOD LUCK!**

Answer the questions belowFirst of all, start Snort in sniffer mode and try to figure out the attack source, service and port.

Then, write an IPS rule and run Snort in IPS mode to stop the brute-force attack. Once you stop the attack properly, you will have the flag on the desktop!

Here are a few points to remember:

- Create the rule and test it with "-A console" mode.
- Use **"-A full"**  mode and the **default log path**  to stop the attack.
- Write the correct rule and run the Snort in IPS "-A full" mode.
- Block the traffic at least for a minute and then the flag file will appear on your desktop.

Stop the attack and get the flag (which will appear on your Desktop)

Correct AnswerHintWhat is the name of the service under attack?

Correct AnswerWhat is the used protocol/port in the attack?

Correct Answer

### **Answer the questions below**

**Question:** First of all, start Snort in sniffer mode and try to figure out the attack source, service and port.Then, write an IPS rule and run Snort in IPS mode to stop the brute-force attack. Once you stop the attack properly, you will have the flag on the desktop!Here are a few points to remember:Create the rule and test it with "-A console" mode. Use "-A full" mode and the default log path to stop the attack.Write the correct rule and run the Snort in IPS "-A full" mode.Block the traffic at least for a minute and then the flag file will appear on your desktop.Stop the attack and get the flag (which will appear on your Desktop)

*Answer:* 

     THM{81b7fef657f8aaa6e4e200d616738254}

**Question:** What is the name of the service under attack?

*Answer:* 

     SSH

**Question:** What is the used protocol/port in the attack?

*Answer:* 

     TCP/22

hubs:
    - [[TryHackMe]]
---

# Snort Challenge   Live Attacks


# Task 3 | Scenario 2 | Reverse-Shell

Start MachineUse the attached [VM]() to finish this task.

[+] THE NARRATOR

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/6131132af49360005df01ae3/room-content/4fe4d545da76a203e6aaff219cccfd2a.png)

Good Job! Glad to have you in the team!

**[+] J.A.V.A.**

Congratulations sir. It is inspiring watching you work.

**[+] You**

Thanks team. J.A.V.A. can you do a quick scan for me? We haven't investigated the outbound traffic yet.

**[+] J.A.V.A.**

Yes, sir. Outbound traffic investigation has begun.

**[+] THE NARRATOR**

The outbound traffic? Why?

**[+] YOU**

We have stopped some inbound access attempts, so we didn't let the bad guys get in. How about the bad guys who are already inside? Also, no need to mention the insider risks, huh? The dwell time is still around 1-3 months, and I am quite new here, so it is worth checking the outgoing traffic as well.

**[+] J.A.V.A.**

Sir, persistent outbound traffic is detected. Possibly a reverse shell...

**[+] YOU**

You got it!

**[+] J.A.V.A.**

Sir, you need to observe the traffic with Snort and identify the anomaly first. Then you can create a rule to stop the reverse shell. GOOD LUCK!

Answer the questions belowFirst of all, start Snort in sniffer mode and try to figure out the attack source, service and port.

Then, write an IPS rule and run Snort in IPS mode to stop the brute-force attack. Once you stop the attack properly, you will have the flag on the desktop!

Here are a few points to remember:

- Create the rule and test it with "-A console" mode.
- Use "-A full" mode and the default log path to stop the attack.
- Write the correct rule and run the Snort in IPS "-A full" mode.
- Block the traffic at least for a minute and then the flag file will appear on your desktop.

Stop the attack and get the flag (which will appear on your Desktop)

Correct AnswerHintWhat is the used protocol/port in the attack?

Correct AnswerWhich tool is highly associated with this specific port number?

Submit

### **Answer the questions below**

**Question:** First of all, start Snort in sniffer mode and try to figure out the attack source, service and port.Then, write an IPS rule and run Snort in IPS mode to stop the brute-force attack. Once you stop the attack properly, you will have the flag on the desktop!Here are a few points to remember:Create the rule and test it with "-A console" mode. Use "-A full" mode and the default log path to stop the attack.Write the correct rule and run the Snort in IPS "-A full" mode.Block the traffic at least for a minute and then the flag file will appear on your desktop.Stop the attack and get the flag (which will appear on your Desktop)

*Answer:* 

     THM{0ead8c494861079b1b74ec2380d2cd24}

**Question:** What is the used protocol/port in the attack?

*Answer:* 

     tcp/4444

**Question:** Which tool is highly associated with this specific port number?

*Answer:* 

     Metasploit

---

