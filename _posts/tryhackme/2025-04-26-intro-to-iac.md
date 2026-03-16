---
layout: post
title: "Intro to IaC"
date: 2025-04-26
tags: ["TryHackMe"]
categories: [tryhackme]
hubs: "TryHackMe/DevSecOps/Infrastructure as Code"
source_id: "6d45679e-6893-4182-bd54-0e1ca53f65fe"
source_urls: "(https://tryhackme.com/room/introtoiac)"
source_path: "DevSecOps/Infrastructure as Code/Intro to IaC.md"
---


# Intro to IaC

## Task 1 | Introduction

If you aim to get into DevOps/DevSecOps, you may have encountered the term infrastructure as code (IaC). This is because IaC is a fundamental and integral part of DevSecOps. Due to the importance of this topic, there is no shortage of articles, blog posts or papers discussing IaC and its various uses in DevSecOps; however, these resources often brush past the many concepts and tools. This can leave DevSecOps newcomers confused over key IaC terms and lost on which IaC tools to use for what. This room will serve as a paced introduction to infrastructure as code and walk you through these key terms, giving you a foundational knowledge of IaC, which you can grow with the following rooms in this module.

 

 

Learning Prerequisites

This room will be a continuation of the [DevSecOps](https://tryhackme.com/path-action/devsecops/join) path, so all previous DevSecOps modules should be completed. Task 6 discusses virtualisation and specifically calls out [Virtualization and Containers](https://tryhackme.com/room/virtualizationandcontainers) and [Intro to Containerisation](https://tryhackme.com/room/introtocontainerisation) for further context on this topic.

Learning Objectives

- Understand why IaC is needed
- Understand IaC as a concept, the tools used and their characteristics
- Understand the IaC lifecycle and the difference between provisioning and configuring, being able to identify tools for both
- Understand how fundamental virtualisation is to IaC
- Understand the difference between on-prem IaC vs cloud-based IaC and the benefits of each

### **Answer the questions below**

**Question:** I am ready to learn about IaC!

*Answer:* 

     No answer needed

---

## Task 2 | IaC - The Concept

Infrastructure Before IaC

Before defining IaC, it’s important to understand why we need it. In other words, what problems is it solving?
Let us consider what was required when infrastructure was configured and managed in the days before IaC. Here are some tasks which would have been the responsibility of various teams (depending on companies structure), such as DevOps/DevSecOps, Platform, Infrastructure, Network and Systems Administration: 

- Manually provisioning servers (physically installing servers or manually deploying virtual machines)
- Network configuration (setting up a network for the infrastructure, including setting up IP addresses, subnets, routing tables and any network components that the infra needs like routers, switches or firewalls)
- Installing an OS
- Installation, configuration and updating of software (database, web server etc.)
- Disaster recovery (DR) (this involves having a backup infrastructure on standby, making a detailed “failover” plan, and having clear procedures in place should the primary data centre go down).

Infrastructure as Code Explained  Instead of provisioning and managing infrastructure manually, as discussed above, infrastructure as code allows the automation of these tasks through code. This code can be used to define a "desired state" for the infrastructure, acting as a blueprint for IaC tools to provision the infrastructure. For example, you may define some resources in your code, such as network components, virtual machines, and a database. An IaC tool will build this blueprint and ensure the infrastructure is always in line with it. Should you want to make an infrastructure change, like increasing the number of VMs, only a simple change needs to be made to the code, which will be reflected in your infrastructure once applied. Compare this to what was previously required to add a VM, which would involve making a manual request through a portal and waiting for that request to be actioned by a systems administrator, and it becomes easy to see the utility of IaC.
The Many Benefits of IaC
Having infrastructure deployed from code also means it can be a collaborative process and a shared responsibility. This means knowledge of infrastructure and its configuration isn't siloed to a single team member, avoiding knowledge dependencies whilst supporting continuous integration (CI). Continuous deployment (CD) is also supported through the ability to deploy consistent infrastructure across multiple environments. As well as reducing the manual efforts and risk of error, an IaC approach can make it possible to have a reliable infrastructure that is scalable, versionable, and repeatable.
**Scalable**

This technology begins to make even more sense when you consider the widespread adoption of cloud computing and its elastic nature, with virtual machines and resources being scaled up and down based on demand due to resources being billed per second/minute/hour. With IaC, you can do this scaling with a single command or even automate the process, whereas in the past, this would have involved weeks of work (e.g., logging tickets and manually provisioning and de-provisioning).

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/b6e2ee40f4e71121225f291804036b58.png)

**Versionable**

Infrastructure as code should be treated as any other code and versioned using a version control system. Versioning an infrastructure means it's self-documenting, allowing infrastructure changes to be tracked and recorded. This benefits the many teams that work with infrastructure with all sorts of tasks, from audits to troubleshooting infrastructure issues. Speaking of infrastructure issues, versioning also means that should your latest infrastructure start having problems, you can redeploy your infrastructure to the last known working version, an example of how IaC allows for reliable infrastructure. Versioning infrastructure can also improve testing capabilities; for example, an application can be tested using a historical infrastructure build.

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/af0e4d32762b91bc2df2ade961373378.svg)

**Repeatable**

In the dev world, it is common to work between multiple environments. Developers first build their code in a dev environment before testing it in a staging environment (which mirrors production) and finally deploying the fully functional and tested code into the production environment. In the past, these three environments would require the manual provisioning and configuration of 3 respective infrastructures. With IaC, you can use the same code/configuration to set up identical infrastructures across multiple environments with the push of a button. While saving massive amounts of time, this also ensures consistency/reliability across environments, which is critical when testing software and was very hard to achieve in the days of manual provisioning.

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/d82ac6ab32e5e5b1b3c5b49b61b35a5f.svg)

IaC in Practice

IaC is a powerful technology that can streamline and improve business-critical processes if used correctly. To demonstrate this utility, let us take one of the example responsibilities mentioned at the beginning of the task, disaster recovery, and examine how IaC can aid this process. As touched on above, disaster recovery is the process of restoring infrastructure after a catastrophic/disruptive event; for example, if you are working for a company that has a physical on-premises infrastructure located in a data centre, a disaster can range from a simple power outage to extreme examples such as natural disasters like wildfires or hurricanes bringing this "primary" data centre down. Failing over from this primary data centre to a secondary backup data centre, when done manually, is a very time-consuming, high-pressure situation which can lead to many issues. Here are a few ways in which IaC can help with disaster recovery:

**Infrastructure Automation:**  Since IaC allows the automation of the provisioning and configuration of an infrastructure, reprovisioning and re-configuring an infrastructure in a backup data centre is streamlined and less time-consuming.

**Data Backup and Recovery:**  Data loss or corruption is one of the most significant risks associated with disaster recovery and can be very costly to the affected company. Infrastructure as code can be used to automate the backup and recovery of data. Backup procedures can be defined in code, which will be triggered in the event of a disaster to ensure data is restored.

**Failover Automation:**  During a disaster, critical services can become unavailable as they will point to the broken infrastructure. IaC can be used to automate the failover process so critical services use the backup infrastructure, which reduces downtime.

**Configuration Consistency:**  IaC keeps infrastructure consistent and well-documented; this consistency is vital during the disaster recovery process and helps avoid misconfigurations (often caused by simple human error or lack of documentation on the current configuration) during the transition to a backup environment.

**Scaling Resources:**  The recovery process can be resource intensive, and IaC can be used to scale resources to handle the increased workloads (and scale back down afterwards).

These are just some examples of how IaC can aid and streamline processes, with a wide range of teams benefitting from infrastructure as code's versionable, scalable, and repeatable nature - saving them time and headaches.

Summary

In conclusion, infrastructure as code is a fundamental concept in DevSecOps, with the technology supporting key concepts like continuous integration (allowing for infrastructure development to be a collaborative process with versioning in place) and continuous deployment (allowing for the automation of infrastructure deployment across multiple environments consistently). IaC also improves efficiency by facilitating infrastructure changes in code, allowing for changes to be made quickly to adapt to developing infrastructure requirements and reduce manual tasks in the process.

**** ****

### **Answer the questions below**

**Question:** Your organisation is preparing to launch a new service called FlyNet. The DevSecOps team provisioned an infrastructure and tested this service in the dev environment. Which IaC characteristic will streamline the provisioning of this same infrastructure in staging and production?

*Answer:* 

     Repeatable

**Question:** It's the day before launch, and the latest infra change has started producing strange errors, something about "destroying humanity". Weird! Which IaC characteristic allows us to go back to the last known working version?

*Answer:* 

     Versionable

**Question:** It's launch day, and it couldn't have gone better; the service is almost running itself! The FlyNet launch has attracted a lot of new customers! Which IaC characteristic enables us to increase the resources available to our infrastructure to meet this increased demand with ease?

*Answer:* 

     Scalable

---

## Task 3 | IaC - The Tools Part 1

Get to Know Your Toolkit

Now that we’ve established *what* IaC is, we can start thinking about some of the tools used for infrastructure as code. Many tools fall under the IaC umbrella, including Terraform, AWS CloudFormation, Google Cloud Deployment Manager, Ansible, Puppet, Chef, SaltStack and Pulumi. It’s important to understand that some of these tools have different use cases, each with its own benefits. Due to the varied use cases of these IaC tools, having infrastructure provisioned, configured and deployed end-to-end will require using a combination of IaC tools rather than a single solution. To better understand these tools, this task will cover some of the key characteristics which distinguish these tools from each other so you know *what*  tool to use and *when* . Bear in mind that the behaviour of these tools can often depend on exactly how they are used, often leading to debate over some of their characteristics; with this in mind, we will define those characteristics in question and how each tool is *generally*  used.

Declarative vs. Imperative

First off, let’s establish the difference between declarative and imperative (also known as functional and procedural) IaC tools:

**Declarative**

This involves declaring an explicit desired state for your infrastructure, min/max resources, x components, etc.; the IaC tool will perform actions based on what is defined. A state file is kept to ensure your infrastructure’s current state matches the desired state. In other words, it focuses on the **what**  rather than the **how** . A declarative IaC tool is usually idempotent, meaning the same result will be achieved when run repeatedly. This is because that check is done against the state file, and if the infrastructure is already provisioned, it will make no changes if rerun. Examples of declarative IaC tools are Terraform, AWS CloudFormation, Pulumi and Puppet (Ansible also supports declarative).

![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/1fe8ba3fc1a6c19ff9a54e81d3d84580.svg)

**Imperative**

This approach involves defining specific commands to be run to achieve the desired state; these commands need to be executed in a particular order. Imperative IaC is usually not idempotent in that if you run these tools multiple times, the same result won’t be replicated, or the tool may run into some configuration issues. This is because these commands will be run regardless of the state of your infrastructure, so running these commands on an already provisioned infrastructure may cause additional unwanted infrastructure to be added or may break the configuration of some existing components (depending on the set-up of the infrastructure and the commands being run). Examples of imperative IaC tools: Chef is the best example of an imperative tool; however, SaltStack and Ansible both support imperative programming as well.

Imagine it like directions to an X on a map, where imperative will give you a list of directions which will bring you to X if you are at the known start point (e.g., an unconfigured server). However, if you are not at this known start point (e.g., a partially configured server), you will not arrive at X but somewhere slightly different. Declarative takes into account where you are on the map and works out which directions need to be taken to get to X from that point. Deciding which to use can depend on what your infrastructure needs are. Declarative is considered a more straightforward approach that is easier to manage, especially for long-term infrastructure. In contrast, imperative IaC is more flexible, giving the user more control and allowing them to specify exactly how the infrastructure is provisioned/managed rather than the tool itself taking care of it.

![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/2bd68304fbc939b4212c471a0868b202.png)

Agent-based vs. Agentless

Agent-based vs Agentless is a term that extends beyond infrastructure as code and is also used in the context of monitoring and security tools. In the context of IaC:

**Agent-based**

An “agent” will need to be installed on the server that is to be managed. It runs in the background and acts as a communication channel between the IaC tool and the resources that need managing. This agent is responsible for executing and reporting on the state of the infrastructure/managed resources. Note that this agent must be installed on every target system/node that needs to be managed. An agent-based IaC tool can perform tasks even when the system has limited connectivity or is offline, making it a robust choice for automation; however, you need to take care with maintenance when using these tools, monitoring the agent software closely so it can be restarted in the event of a crash.

Another thing to consider with agent-based IaC tools is that some of these tools will require opening ports on the server for inbound and outbound traffic so that the agent can push/pull configuration information; from a security perspective, more open ports are negative. Despite this, they offer a level of granular control over managed resources and can collect more detailed monitoring data. Because of this, they might be ideal if control is an important factor in your setup. Some agent-based IaC tools: Puppet, Chef, and Saltstack.

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/20605c0c3f9cb08bddf3d3d1b1fb5d81.png)

**Agentless**

Agentless IaC tools, as you may have guessed, do not require agents to be installed on target systems. Instead, these tools leverage existing communication protocols like SSH, WinRM or Cloud APIs to interact with and provision resources on the target system. Agentless IaC tools benefit from being easier to use; their simplicity during set-up can mean faster deployment time, and their agentless nature can also mean the tool can be deployed across multiple environments without custom agent changes needing to be made based on each environment’s needs, making it a flexible choice. Also, compared to agent-based IaC tools, there is less maintenance and no risks surrounding the securing of an agent. However, agentless IaC tools generally have less control over target systems than agent-based tools. Agentless tools are useful in environments which have to adapt to fluctuating workloads, with resources being created/destroyed to meet these workloads. These newly created resources can be managed without having to rely on pre-installed agents. Agentless IaC tools: Terraform, AWS CloudFormation, Pulumi and Ansible.

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/10e228ac974caf680f0fa21a854924c5.png)

Once again, both options have their advantages and disadvantages. Infrastructure provisioning and configuration can present developers with a very particular set of problems, and choosing the correct tool for the job, depending on what needs to be done, involves taking these into account.

### **Answer the questions below**

**Question:** In the scenario given, which type of IaC tool considers where you are on the map and gives instructions to reach the desired X point?

*Answer:* 

     Declarative

---

## Task 4 | IaC - The Tools Part 2

View SiteImmutable vs. Mutable

Immutable vs mutable infrastructure refers to whether or not changes can be made to an infrastructure. To define both, let’s imagine we have a simple infrastructure, a virtual machine with a web server and application. If you want to change this infrastructure, for example, deploy some application code to your web application, this code will mean your web application will go from version 1 to version 2. How might that look for each?

Mutable

Mutable infrastructure means you can make changes to that infrastructure in place. So, in our current example, we can upgrade the application on the server it’s currently running on. The advantage here is that no additional resources need to be provisioned for this update, with the resources already being used just needing to be changed. Where mutable infrastructure starts presenting issues is, imagine your web application update contains three changes, and whilst these updates are being made, one of the changes fails to apply. This is a common occurrence in development and can occur for several reasons, such as application misconfiguration or a network dropout. Now running on your server will be a web application version with two of the three changes required to be version 2. In other words, it’s no longer version 1 anymore but not quite version 2 either. When an application is updated in a production environment, it will have been tested first in development and staging environments. What won’t have been tested is this halfway version, leading to all kinds of potential issues. Imagine now that this update was not just rolled out on a single server, but many, maybe some updates succeeded, and some failed with errors in different changes. You can see how this can become an issue very quickly with different versions of the web application existing across many servers.

![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/48c0d1e0a1fdfa62bcdb829892462093.png)

Immutable

Immutable infrastructure means you cannot make changes to it. Once an infrastructure has been provisioned, that’s how it will be until it’s destroyed. Now, let’s apply that to our example. When this new version 2 of the web application is deployed, an entirely new infrastructure will be deployed with this new version. Now, you have two infrastructures stood up: one with version 1 of the web application and one with version 2. However, if all of the changes are implemented successfully (and only if they ALL are; otherwise, if it fails, the infrastructure will be torn down, and the process will be retried), the version 1 infrastructure can be torn down. This approach has some drawbacks, as having multiple infrastructures stood up side by side or retrying on failed attempts is more resource-intensive than simply updating in place, but it allows for consistency across servers. You know with certainty that x server is running version 2 of the web application.

Immutable IaC tools: Terraform, AWS CloudFormation, Google Cloud Deployment Manager, Pulumi (some of these tools can be configured to be used with a mutable infrastructure but work better with an immutable approach)

In the example given, it makes more sense to use an immutable infrastructure. However, to demonstrate further that each can have its own use case, imagine the server instead is a critical database system that requires regular maintenance updates and patching. If you were to use an immutable infrastructure for this, the critical database would have to be rebuilt from scratch every time, which can be a risky process when dealing with business-critical data. So, in this instance, it might make sense to use a mutable infrastructure.

![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/97dcbf50ca109f1e26f2751c3d3fbf16.png)

Provisioning vs. Configuration Management

All the characteristics discussed in this task so far are behavioural; in other words, how does this tool work? This way or that way. Considering what a tool's purpose is and when it is used in the development of infrastructure will tell us whether it is a *provisioning*  tool or a *configuration*  *management*  tool. You might see these primary functions defined differently elsewhere, for example, infrastructure as code vs. configuration as code, but to determine which tool falls into which category, you simply need to ask, "What can it do?". If we think about four key tasks: Infrastructure provisioning (the set-up of the infrastructure), infrastructure management (changes made to infrastructure), software installation (initial installation and configuration of software/applications), and software management (updates made to software or config changes).

There is no single tool that can perform all 4 of these tasks. Instead, combining two tools, a provisioning tool and a configuration management tool, is common practice to cover all these. There will be a practical example of exactly what tools can cover which tasks in the static site coming up. Some examples of each type of tool:

Provisioning tools: Terraform, AWS CloudFormation, Google Cloud Deployment Manager, Pulumi

Configuration management tools: Ansible, Chef, Puppet, Saltstack

Let’s consider a real-life industry example of how these two types of tools might be used. Say you work for a company which needs to set up a new infrastructure for a web application. A similar one has been deployed before and fell prey to some malicious activity, so this time, you will install an agent to monitor for this activity. The infrastructure would be defined and provisioned using a provisioning tool like Terraform, and then a configuration management tool like Ansible would be used to install an agent within the provisioned infrastructure to monitor for malicious behaviour.

Put That All Together

Now, you’ve been introduced to the world of infrastructure as code tools and their various uses. Each has its characteristics which best suit different use cases and scenarios. In that way, they are no different to physical tools; you have to assess the problem and choose the best tool to address it. Here's a little summary of what we've discussed, as well as a little bit more information about some of the tools mentioned:

**Terraform** : is a declarative, agentless infrastructure provisioning tool that works with immutable infrastructure. Terraform is one of the most popular infrastructure provisioning tools out there, allowing for the management of infrastructure across multiple cloud providers like AWS, GCP and Azure.

**Ansible:**  is a hybrid, typically agentless configuration management tool that works with mutable infrastructure. Another example of a massively popular tool in the DevSecOps space. It's slightly harder to categorise than some of the other tools, because of how this tool functions and what it does can depend on how you employ it. For example, there is much discussion over whether Ansible is an imperative or declarative tool. In reality, Ansible is sort of a hybrid in a sense.

**Pulumi:**  is a declarative, agentless infrastructure provisioning tool that works with immutable infrastructure. Pulumi is similar in nature to Terraform but has become increasingly popular in recent years due to its ability to let users define their desired infrastructure using familiar general-purpose languages like Python, JavaScript, Go, Java and markup languages like YAML.

**Aws CloudFormation:** is a declarative, agentless infrastructure provisioning tool which can be used to implement an immutable infrastructure on AWS. This is an AWS-managed service and provisions AWS cloud resources using JSON / YAML templates.

**Chef:**  is an imperative, agent-based configuration management tool that works with mutable infrastructure. Chef gets an infrastructure to a desired state by running a series of instructions contained in a file referred to as a 'Recipe'; a collection of these files is referred to as a 'Cookbook'.

**Puppet:**  is a declarative, agent-based configuration management tool that works with mutable infrastructure. In Puppet, you define the desired configuration state using their own domain-specific language (DSL), "Puppet Code"; Puppet then automates this configuration through a Puppet primary server and agent.

![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/63d2d4fc39187ca84cc6f9dc15197b01.png)

Static Site Scenario

The year is 2029. The destroyers have risen from the ashes of nuclear fire brought on by FlyNet, an artificial intelligence that has gained sentience. The destroyers have one objective: to destroy humankind. The resistance is led by Ron Connor, who has just received intel that the machines have discovered a technology which allows them to send a machine back to 1984 and kill his mother before he is born. Not cool! Ron Connor needs this technology to send his finest sergeant, Miles Creese, back to 1984 to protect his mother. The only problem is he needs to figure out where to find it! After a successful skirmish, Ron Connor has managed to get employee access to a FlyNet terminal. Boot up the static site, bypass the employee training and retrieve the location info he needs! What could go wrong?

![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/43fd14e1243069a5d81e88c83951c0be.png)

### **Answer the questions below**

**Question:** Can you retrieve the location and retrieve the flag?

*Answer:* 

     thm{l4b_C0mpl3x_co0rds}

---

## Task 5 | Infrastructure as Code Lifecycle

The Lifecycle

Now that it has been established what IaC is and the tools we use to implement it, it’s time to define the lifecycle. There is talk about an IaC lifecycle across forms, blog posts, and academic papers. Still, there is yet to be an agreed-upon and widely adopted lifecycle (as there is for DevOps/DevSecOps). Because we think you, the reader, would benefit from having an IaC lifecycle to use as an educational tool, we have defined one, the infrastructure as code lifecycle (IaCLC). The actions/tasks performed by developers and IaC tools can be broken down into phases, which together make a lifecycle; this lifecycle helps us understand that infrastructure as code has continual and repeatable processes, which don't simply follow a linear sequence of provision and management tasks. This task will outline the stages of the IaC lifecycle, its phases and how they are connected.

The IaCLC is designed to give DevOps Engineers (or anyone else assigned with the task) guidance on the tasks associated with provisioning infrastructure and the continued support of that infrastructure. Key DevOps practices such as continuous integration and continuous deployment are also parts of best practices throughout the lifecycle.

Due to IaC being a development process, some parallels can be drawn between the IaC lifecycle and the SDLC, which also covers a solution's planning/designing, implementation, testing, deployment and monitoring. While these parallels exist due to these lifecycles being created on the same foundations (providing developer guidance and improving output quality), they don't directly fit into each other. Both lifecycles break down tasks into phases. However, due to the frequently changing infrastructure needs, the IaCLC distinguishes between two different types of phases.

![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/248f6eebfa09c336733237216b1b4b8b.svg)

Breaking it Down

As mentioned above, these phases are separated into two types. Let's break that down:

**Continual (Best Practice) Phases:**  

![Image 13](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/5773fd17068a833784ff86ecaef4b97e.svg)

 These phases are continually done to ensure best practices throughout the various stages of infrastructure development and management. Continual phases can trigger repeatable phases 

![Image 14](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/821fd689bebc77ac57c22f309ee3caa9.svg)

**Repeatable(Infra Creation + Config) Phases:**  

![Image 15](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/f41d65ba204de1ab577d9e2cc981dfa8.svg)

 These phases are done during the creation/configuration of an infrastructure and are done one or many times at different points and with differing variations depending on what needs to be done. Some examples are below:

Activity: Entirely new infra

![Image 16](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/b01d5b3df9751d5b35a6d23b724ecfc3.svg)

Activity: Config change

![Image 17](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/feb147861ab6640feb45ea3494d08678.svg)

**The Continual (Best Practice) Phases**

Version Control
This phase involves versioning code while defining your infrastructure and making changes. This way, when it comes to the later rollback phase, there are clearly defined versions to fall back on should a new change break something.
Collaboration
When working as part of a team on infrastructure, it is crucial to communicate and collaborate so everyone is on the same page. Otherwise, this can lead to a disconnect between modular infrastructure components or general confusion over infrastructure.
Monitoring/Maintenance
Once an infrastructure has been provisioned/configured, it must be monitored for poor performance, security events, failure events, warnings, etc. Automated maintenance tasks (e.g. disk clean-up) can help avoid some of these events. In certain events, this phase can trigger the rollback phase.
Rollback
In the event of a failure event post-deployment, the infrastructure will need to be rolled back to the last known working version. 
Review + Change
Just because an infrastructure works doesn’t mean it’s as efficient as it could be. Perhaps a new security vulnerability has been discovered, or maybe there’s a new business requirement that would benefit from an infrastructure change. Infrastructure should routinely be reviewed to determine if this is the case, and changed if so.

**The Repeatable (Infra Creation + Config) Phases**

Design
The infrastructure needs to be designed based on needs, taking security into account throughout the whole process (for example, poor scaling policy design can lead to availability issues, which is a huge security concern).
Define
Use the design to define the infrastructure that needs to be provisioned in code.
Test
Using a linter, validate the code for syntax errors or logical issues. Before provisioning is done in production, test the infrastructure in a replica environment (staging).
Provision 
Provision the infrastructure that has been defined in the production environment using a provisioning tool, e.g. Terraform. 
Configure
Configure the provisioned environment using a configuration management tool, e.g. Ansible.

**IaCLC in Action**

****

### **Answer the questions below**

**Question:** A DevSecOps Engineer at CyberMyne is looking for guidance on developing their next infrastructure. What type of phases provide guidance during the development or configuration of an infrastructure?

*Answer:* 

     Repeatable

**Question:** What type of phases ensure best practices throughout infrastructure development and management?

*Answer:* 

     Continual

**Question:** The 'Monitoring/Maintenance' continual phase can trigger which other continual phase?

*Answer:* 

     Rollback

---

## Task 6 | Virtualisation & IaC

When discussing infrastructure as code, virtualisation is a fundamental concept. Virtualisation technologies, when used in conjunction with IaC, allow for some powerful and efficient infrastructure management. While some of these concepts have been touched on in the [Intro to Containerisation](https://tryhackme.com/room/introtocontainerisation) room, this task will review virtualisation and its relationship with infrastructure as code.

Virtualisation Levels

When we talk about virtualisation levels, we’re essentially talking about *what* is being virtualised. Here, we will briefly review the difference between hypervisor-level virtualisation and container-level virtualisation to provide context for upcoming concepts. Hypervisor virtualisation (e.g. VMware) enables multiple virtual machines to run on a single physical server. Imagine a physical server in a data centre. Using a hypervisor, this server’s resources (CPU, storage, etc.) can be divided and dedicated to separate virtual machines within this server. These machines will virtualise everything from the operating system, which can be a different OS than installed on the host, meaning multiple OSs can be installed on a single server; however, deploying a virtual machine at this level can take some time. Containerisation (platform example: Docker) is virtualisation at an operating system level, meaning the same operating system kernel is used to run multiple containers. Virtualising at this level makes these containers incredibly lightweight, allowing for rapid deployment and scaling.

![Image 18](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/cb3fc30824889e3deab9c1e1f04ae3a5.svg)

![Image 19](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/f568756a180e992f2b905840de5426c5.svg)

Use of Virtualisation in IaC

Let’s consider how virtualisation is used in IaC across six areas: Scalability, Resource Isolation, Testing / Snapshots / Rollbacks, Templates, Multi-tenancy, and Portability.

Scalability
IaC uses virtualisation to meet demands (higher or lower levels of demand). If there is a sudden increase in demand (scaling policies can be defined in your code to specify when this would be required) and you need more servers, virtual machines can be created to handle this increased load.
Resource Isolation
Virtualisation enabled resource isolation between different VMs/containers. Using IaC, you can define what components get how much of the available resources. This means if one component starts getting hammered (consuming all of its allocated CPU, memory, bandwidth, etc.), it won’t affect the performance of the other components.
Testing / Snapshots / Rollbacks
The virtualisation of OSs, software configurations and dependencies makes it easy to package them and, using infrastructure as code, deploy them in another identical environment for testing or development. The consistency this provides, combined with the ability to take snapshots of VMs/containers at specific points in time so rollbacks can be done if a deployment goes wrong, streamlines development and testing processes.

Templates
When using virtualisation, you can create a template (or blueprint) for VMs/containers. IaC can use these templates to provision new instances. These templates cut manual provisioning and configuration time down while ensuring consistency across instances.

Multi-tenancy

Virtualisation can support multi-tenancy, meaning multiple customers/tenants can be hosted on the same physical server whilst having their resources isolated. This removes the need for dedicated servers/single-tenant environments (although sometimes they are required), and using IaC means the resources for multiple tenants can be managed using the same underlying infrastructure.

Portability
Virtualisation makes it easier to move infrastructure between cloud providers or data centres. Having this portability, as discussed, can streamline critical business processes like disaster recovery but also allows the flexibility for hybrid cloud organisations to recreate environments regardless of their CSP.

Virtualisation Technology + IaC

Next, we will discuss some virtualisation technologies used in conjunction with IaC to unlock its power, focusing on Kubernetes. Kubernetes (also referred to as K8s) is a containerisation orchestration software, meaning once an application (and its dependencies) have been containerised, Kubernetes can be used to automate its deployment, scaling and management. Using Kubernetes requires a Kubernetes cluster, in other words, an infrastructure made up of a master node and one or many worker nodes (where the containerised applications run). Infrastructure as code tools can provision the underlying infrastructure needed for this Kubernetes cluster and automate the set-up of the required Kubernetes components. Infrastructure as code can also define scaling policies for a Kubernetes cluster, automating the scaling process and allowing pods/nodes to be added or decreased based on resource usage. The infrastructure provisioning/configuration and automation capability of IaC, combined with the ability to orchestrate lightweight rapid deployable containers, make for a very powerful set-up and is ubiquitous in the world of cloud computing.

![Image 20](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/9fc53ba4f63d6b8ef6f7b413d2de2769.png)

Consider a practical example from the world of DevOps. Say a DevOps Engineer is planning to deploy a new web application from scratch, and their tech stack includes both Terraform and Kubernetes. They can combine these tools and use Terraform to automate the creation of a new Kubernetes cluster, and once this cluster has been deployed, any other resources that might be needed, like an Nginx web server or a load balancer. This is just a simple, stripped-back example of a task that would even be possible by just using Kubectl (or other CLI-based tools) to manage K8s clusters and resources; however, using an IaC technology like Terraform boasts many benefits when you start to consider DevOps at the scale of a larger company where these tools allow you to define Kubernetes deployments, services, config maps etc. as Terraform modules, which are repeatable across different projects/clients/environments. We've also discussed how Terraform is a declarative tool ensuring that the state of the Kubernetes cluster matches the desired state making infrastructure management an easier task. Terraform is also aware of dependencies, meaning if 'resource x' is dependent on 'resource y' and 'resource y' fails to deploy, Terraform won't attempt the creation of 'resource x'. Another way in which Terraform can save time is by reducing the need for DevOps Engineers to sift through deployment errors, working out the point of failure. Again, both of these tools are powerful, but when used together, their true power and utility in the DevOps space are unlocked.

Kubernetes is just one example of how virtualisation technologies and IaC can work hand in hand and are nearly essential to each other (at least to get the most out of the respective tool). Some other examples include Vagrant (used by developers to spin up and manage VMs or containers for local development and testing; IaC can make this a consistent process) and OpenStack (an open source cloud computing platform where you can create your own cloud environments where IaC can also be used to automate the provisioning and management of cloud resources).

This is just an overview of virtualisation to emphasise its use within IaC, but if you want to learn more, we have plenty of rooms that go in-depth on this topic, like [Virtualization and Containers](https://tryhackme.com/room/virtualizationandcontainers) and [Intro to Containerisation](https://tryhackme.com/room/introtocontainerisation). Check them out!

### **Answer the questions below**

**Question:** CyberMine is deploying the latest machine model E-1000. This model requires virtualisation at an operating system level to allow for lightweight and rapid deployment behind the scenes! What level of virtualisation would be needed for this?

*Answer:* 

     Containerisation

**Question:** CyberMine's E-100 Model is still very popular for all your extermination needs, this model requires multiple OS to run on a single machine. Which level of virtualisation would be needed for this?

*Answer:* 

     Hypervisor

**Question:** The new E-1000 model has a feature that allows it to pass through physical objects. Wild! This new feature, however, is very resource-intensive. Which 'Use of IaC' will ensure that this resource consumption won't affect the performance of the machine's other components?

*Answer:* 

     Resource Isolation

**Question:** Due to the resource consumption of this new feature, it requires rapid scaling of resources. Which container orchestration software can be used to automate this process?

*Answer:* 

     Kubernetes

---

## Task 7 | On-Prem IaC vs. Cloud-Based IaC

Infrastructure as code has two use cases. On-premises IaC and cloud-based IaC. Going forward, this module will go in-depth and give practical examples of both of these. Let’s first establish the key differences between the two. Here, we outline key differences between on-prem IaC and cloud-based IaC across five categories: Location, Tech, Resources, Scalability and Cost.

Comparison

![Image 21](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/ec6e26a0a171e8f0177a0626903bb581.png)

**On-prem:**  As the name implies, if your infrastructure is on-prem, then the code written will configure servers, network devices, storage and software located on your premises. This can mean physical infrastructure in a premises owned by an organisation or rented in a data centre.

**Cloud-based:**  This means provisioning and configuring infrastructure resources in a cloud environment using cloud resources. This is done using a cloud service provider (CSP) such as AWS, Microsoft Azure, GCP, etc.

![Image 22](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/299069e9a2214ef21b905a52b39b0e60.png)

****

**On-prem:**  Typically, when working with an on-premises infrastructure, IaC tools like Ansible, Chef and Puppet would be used (although others can be configured to do so) to manage and provision infrastructure on physical servers or virtual machines in an on-prem data centre.

**Cloud-based:**  There are many tools available to provision and manage cloud infrastructure designed to leverage the elastic nature of cloud computing, with some cloud service providers having their own IaC tool/service. Some examples of tools that can be used for cloud-based IaC are Terraform, AWS CloudFormation, Azure Resource Manager (ARM) templates and Google Cloud Deployment Manager.

![Image 23](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/470fd2be85001e01882c12235ac8d787.png)

****

**On-prem:**  When using on-prem IaC, you’ll likely be dealing with physical hardware, which comes with the caveats of hardware compatibility, physical upkeep and limited physical resources. This will mean setting up and configuring those physical resources (physical servers, storage devices, network equipment, etc.). On-prem IaC may be used by companies who rely on their on-premises infrastructure due to legacy systems and require assistance in the efficient management of this infrastructure.

**Cloud-based:**  In the cloud, you interact with virtual resources provided by the cloud service provider (AWS, GCP, Azure, etc.). These resources can be provisioned/managed by cloud-based IaC tools. The underlying infrastructure is handled by the CSP and not the user. Cloud-based IaC would be perfect for companies that offer video streaming services. Due to the nature of this service, it can lead to a fluctuating demand on computing resources, which can peak. Cloud-based IaC makes it easy to gain access to additional cloud-based virtual machines or storage depending on resource consumption to ensure consistent performance during these peaks.

![Image 24](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/9b34ecfc02cb1c877a80306d889f6ab2.png)

****

**On-prem:**  Scaling resources using on-prem IaC can be a slow and cumbersome process. This can involve manual/physical changes and procurement. Because scalability is such a slow process, consideration is required, and hardware limitations must be enough to handle peak load. This can prove challenging in situations where an on-premises infrastructure starts receiving increased traffic (think enrolment or exam season at a university/college).

**Cloud-based:**  Due to the cloud’s elastic nature, scaling resources is far more flexible than on-premises. Cloud-based IaC tools can define scaling policies so resources can be scaled up or down based on demand and resource consumption, leveraging auto-scaling features. This ensures that only the resources needed are paid for. Cloud-based IaC can streamline the process of scaling infrastructure to meet demands during peak seasons. Imagine an infrastructure that supports an online game. This infrastructure would see increased traffic when the game releases a new update, or an event is underway.

****

![Image 25](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/59742076f49a1fa228dfd972a330ec7f.png)

****

**On-prem:**  On-premises infrastructure expenses mean having to pay for physical hardware (or leasing a server from a third-party data centre - depending on the use case); this also comes with the costs of physical upkeep (fault repairs/part replacements, etc.), operational costs and expenses involved in upgrading the infrastructure. An on-premises infrastructure and the use of on-prem IaC doesn't boast any cost benefits per se. If choosing on-prem, it would likely be due to a combination of other factors rather than cost.

**Cloud-based:**  When using cloud-based IaC, you’ll deal with infrastructure that cloud service providers bill for on a pay-as-you-go basis. This means you only need to pay for what you use (which can be made more cost-effective by the efficient use of auto-scaling). Cloud-based IaC tools are an ideal and cost-effective solution for scenarios where infrastructure needs to be automatically scaled up and down on demand. For example, if an online retailer is expecting an increase in traffic over Black Friday weekend or over the holiday period, they may want to scale up their resources but not have to pay for those resources when traffic returns to an average rate.

When comparing cloud-based infrastructure as code with on-premises infrastructure as code, it primarily comes down to the location of the infrastructure and what tools are used in their management and provisioning. Cloud-based IaC uses virtual elastic resources, which are charged on a pay-as-you-go basis and provided by a CSP, whereas on-prem IaC deals with physical hardware.

Benefits

Let’s examine how the above-mentioned differences translate into benefits depending on specific use cases. Here are some of the benefits of each to give you an idea of when you might use on-prem IaC and Cloud based IaC:

![Image 26](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/b85b36e8d1cc6a9e0a38c0e8ad908124.png)

**On-prem IaC:**  The main advantage of on-premises infrastructure as code is that it allows complete control. This complete control is sometimes required due to regulations/security and compliance requirements. This is common in bigger banking corporations or businesses that deal with customer-sensitive or government data. These regulations can call for data sovereignty (meaning the data has to be stored and processed within the country). Whilst cloud providers offer specialised government cloud environments for some of these cases (e.g. us gov cloud in AWS), these offerings are only available in certain regions; for regions like Africa, there is no dedicated government cloud, meaning on-premises infrastructure as code would need to be used to adhere to strict security/compliance requirements.

**Cloud** **-based** **IaC:**  It has many advantages for fast-paced and growing businesses. The scalability allows infrastructure to be rapidly scaled up or down to meet fluctuating demand without the constraints of physical on-premises infrastructure. Cloud-based infrastructure also allows infrastructure to be deployed globally across different regions, reducing user latency, which can be essential for businesses that need to provide a service to customers worldwide with little to no latency, like online gaming. With cloud providers billing on a pay-as-you-go basis, this can mean that companies can pay only for the infrastructure that they need/use, meaning investment doesn’t need to be made into physical hardware and the maintenance of that hardware.

### **Answer the questions below**

**Question:** Cloud-based resources are provisioned/configured in a cloud environment. Who handles the underlying infrastructure?

*Answer:* 

     cloud service provider

**Question:** What category does on-prem infrastructure struggle with due to hardware limitations when facing increased traffic?

*Answer:* 

     scalability

---

## Task 8 | IaC - The Final Push

View SiteTime to Fight

The technology required to send Sergeant Miles Creese back to 1984 is being held in a lab complex. All that's left now is to capture it and retrieve the tech. There's only one issue: it's located in a heavily fortified exterminator base, and the resistance doesn't have the resources to take them on. Lucky for the resistance, though, one piece of technology they *do* have their hands on is their 'Infrastructure at a Click' weapons system. This allows resistance fighters to deploy a weapon infrastructure (requiring a network and server components so the weapons can communicate with each other) to take on the machine army! After all, weapons can be reprovisioned; resistance fighters cannot! Simply define how many weapons you want using provision points and upgrade those weapons using configure points to defeat the incoming machines! Just don't let the machines take down your server, or it's game over!

![Image 27](https://tryhackme-images.s3.amazonaws.com/user-uploads/6228f0d4ca8e57005149c3e3/room-content/04561faf8994abe92b632aa9d88136f2.png)

### **Answer the questions below**

**Question:** Can you get the flag using your infrastructure as code skills?

*Answer:* 

     thm{1Nfr4StrUctUr3_Pr0}

---
