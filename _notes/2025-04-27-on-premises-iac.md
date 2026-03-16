---
layout: post
title: "On-Premises IaC"
date: 2025-04-27
tags: ["TryHackMe"]
categories: [tryhackme]
hubs: "TryHackMe/DevSecOps/Infrastructure as Code"
source_id: "d462b5ea-1b6e-4512-8fd9-c78ec73850c3"
source_urls: "(https://tryhackme.com/room/onpremisesiac)"
source_path: "DevSecOps/Infrastructure as Code/On-Premises IaC.md"
---

{% raw %}


# On-Premises IaC

## Task 1 | Introduction

In this room, you will learn about on-premises infrastructure as code (IaC) deployments. While this may seem outdated in a cloud-based world, some good reasons exist for doing on-prem instead of cloud deployments, especially in heavily regulated industries.

 

 Prerequisites 
- Basic offensive security techniques and skills
- [Intro to IaC](https://tryhackme.com/room/introtoiac)

 Learning Objectives 
- Understand the reasons for on-prem IaC
- Understand the benefits and drawbacks of on-prem IaC
- Understand and know how to use Vagrant
- Understand and know how to use Ansible
- Understand the security concerns for Ansible and Vagrant

**Note: This room contains a non-guided challenge in Task 7. You will have to use the knowledge learned in this room together with basic offensive security skills to complete the challenge!**

### **Answer the questions below**

**Question:** I am ready to learn about on-prem IaC!

*Answer:* 

     No answer needed

---

## Task 2 | Why On-Premises

On-premises IaC refers to using infrastructure as code to deploy systems and services on an internal network. In essence, all the infrastructure that will host the systems and services can be found locally in the organisation's data centre.

 Reasons for On-Prem IaC In the modern world, where we have several cloud providers, using on-prem IaC may seem counter-intuitive. However, there are some cases where on-prem IaC will suit your needs much better. The biggest benefit is that it allows you much better control of your entire IaC pipeline. Let's use another popular example, GitHub vs self-hosted GitLab, as a case study.

 GitHub and GitLab are two popular source code management platforms, backed by the popular versioning software Git, that are used by organisations. However, deciding between the two often becomes a question of control. If you self-host the solution using GitLab, you fully control the entire stack. You are ultimately not only responsible for the management of the GitLab platform, but also the underlying infrastructure. While this is a lot more work, it also allows you to lock down access significantly. For example, you could only allow access to your GitLab instance via VPN, meaning it is not exposed to the internet for everyone.

 Conversely, using GitHub means you are shifting some of that security responsibility. It is important to remember that GitHub is a Software-as-a-Service (SaaS) solution. That means that if you use GitHub, you have no control over the infrastructure hosting your source code. Instead, you are transferring the security responsibility of infrastructure management to GitHub, which becomes a third party of your organisation. While these organisations take security measures seriously, their security is not without flaws, which can leave your organisation's source code [exposed](https://thehackernews.com/2023/01/github-breach-hackers-stole-code.html). This is a risk that you have to accept whenever you use a third party.

 Extrapolating from this case study, you should see why some organisations still prefer on-prem IaC, especially in heavily regulated sectors, such as the financial or governmental sectors. While on-prem IaC is definitely more effort, it provides an organisation with full control and customisation of their IaC pipeline.

 Benefits and Drawbacks To summarise why one would use on-prem IaC and determine if it is the correct solution for your specific problem, let's look at the benefits and drawbacks.

**On-prem IaC has the following benefits:**

 
- Allows full control of the IaC pipeline
- The IaC pipeline can be fully customised for your exact needs
- Data protection and regulation is easier to perform as the IaC pipeline does not host resources on third-party systems
- While the initial investment cost of the infrastructure is high, there are no monthly fees for hosting the IaC pipeline
- It is often easier to do small deployments

 **On-prem IaC has the following drawbacks:**

 
- As you are hosting your own IaC pipeline, you are fully responsible for its security and configuration
- Scalability of deployments is not as flexible as cloud-based IaC, which can lead to either not having sufficient resources for the deployment or an over-investment in resources
- The initial investment for on-prem IaC is significantly higher than cloud-based IaC

 Now that you understand why on-prem IaC can be used, let's dive into some of the tooling that can be used to create your very own on-prem IaC. While there are many different tools and software that can be used, for this room, we will focus on Vagrant and Ansible as examples.

### **Answer the questions below**

**Question:** If I want more control over my pipeline, should I use an on-prem IaC pipeline? (Yea/Nay)

*Answer:* 

     Yea

**Question:** If I want to have a flexible and easily scalable deployment, should I use an on-prem IaC pipeline? (Yea/Nay)

*Answer:* 

     Nay

**Question:** If I have strict data protection regulations enforced on my organisation, should I use an on-prem IaC pipeline? (Yea/Nay)

*Answer:* 

     Yea

---

## Task 3 | Vagrant Basics

In our on-prem IaC journey, we will start with [Vagrant](https://developer.hashicorp.com/vagrant). Vagrant is a software solution that can be used for building and maintaining portable virtual software development environments. In essence, Vagrant can be used to create resources from an IaC pipeline. You can think of Vagrant as the big brother of Docker. In the context of Vagrant, Docker would be seen as a provider, meaning that Vagrant could be used to not only deploy Docker instances but also the actual servers that would host them.

 Terminology Before diving into using Vagrant, let's brush up on some terminology first.

    Term Definition     Provider A Vagrant provider is the virtualisation technology that will be used to provision the IaC deployment. Vagrant can use different providers such as Docker, VirtualBox, VMware, and even AWS for cloud-based deployments.   Provision Provision is the term used to perform an action using Vagrant. This can be actions such as adding new files or running a script to configure the host created with Vagrant.   Configure Configure is used to perform configuration changes using Vagrant. This can be changed by adding a network interface to a host or changing its hostname.   Variable A variable stores some value that will be used in the Vagrant deployment script.   Box The Box refers to the image that will be provisioned by Vagrant.   Vagrantfile The Vagrantfile is the provisioning file that will be read and executed by Vagrant.    

Vagrant Example Let's take a look at a simple Vagrant provisioning script. In our example here, we have the following folder structure:

 
```
.
├── provision
│   ├── files.zip
│   └── script.sh
└── Vagrantfile
```

 The Vagrantfile script has the following code:

```
Vagrant.configure("2") do |cfg|
  cfg.vm.define "server" do |config|
    config.vm.box = "ubuntu/bionic64"
    config.vm.hostname = "testserver"
    config.vm.provider :virtualbox do |v, override|
       v.gui = false 
       v.cpus = 1
       v.memory = 4096
    end

    config.vm.network :private_network,
        :ip => 172.16.2.101
    config.vm.network :private_network,
        :ip => 10.10.10.101
  end

  cfg.vm.define "server2" do |config|
    config.vm.box = "ubuntu/bionic64"
    config.vm.hostname = "testserver2"
    config.vm.provider :virtualbox do |v, override|
       v.gui = false 
       v.cpus = 2
       v.memory = 4096
    end

    #Upload resources
    config.vm.provision "file", source: "provision/files.zip",    destination: "/tmp/files.zip"

    #Run script
    config.vm.provision "shell", path: "provision/script.sh"
  end
end
```

In this example, we are going to provision two servers. Both of these servers will start with the base Ubuntu Bionic x64 image. Like Docker, these images will be pulled from a public image repo. We could, however, tell Vagrant where to find these images, meaning they can be pulled from a private repo of images as well. You can see that both servers are configured with a hostname and how many CPUs (1) and RAM (4GB) each host will have. The first server will also have two network interfaces with static IPs attached. The second server will have a file called `files.zip` uploaded, and a script called `script.sh` will be executed on the host.

 If we want to provision the entire script, we would use the command `vagrant up`. This would provision both servers in the order specified in the Vagrantfile. We could also decide to only provision one of the servers by using the server name. For example, `testserver` could be provisioned using `vagrant up server`.

 If you want to play around with VirtualBox provisioning using Vagrant, look at this [repo](https://github.com/MWR-CyberSec/tabletop-lab-creation). Using VirtualBox and Vagrant, this repo will allow you to create your very own Active Directory (AD) network with two domain controllers, a server, and a workstation. Give the Vagrantfile a read to see what provisioning will be performed on each host.

 We will create our very own IaC deployment script a bit later in this room.

### **Answer the questions below**

**Question:** What is the name of the file that Vagrant uses for provisioning?

*Answer:* 

     Vagrantfile

**Question:** What command can be used to provision all hosts with Vagrant?

*Answer:* 

     vagrant up

**Question:** What command can be used to provision only the webserver host with Vagrant?

*Answer:* 

     vagrant up webserver

---

## Task 4 | Ansible Basics

The next IaC tool to learn about is [Ansible](https://www.ansible.com/). Like Vagrant, Ansible is another suite of software tools that allows you to perform IaC. Ansible is also open-source, making it a popular choice for IaC pipelines and deployments. One main difference between Ansible and Vagrant is that Ansible performs version control on the steps executed. This means that Ansible is similar to Docker, in that it will only perform updates on steps that require updates, instead of requiring a full reprovision.

 Terminology Before diving into using Ansible, let's brush up on some terminology first.

    Term Definition     Playbook An Ansible playbook is a YAML file with a series of steps that will be executed.   Template Ansible allows for the creation of template files. These act as your base files, like a configuration file, with placeholders for Ansible variables, which will then be injected into at runtime to create a final file that can be deployed to the host. Using Ansible variables means that you can change the value of the variable in a single location and it will then propagate through to all placeholders in your configuration.
   Role Ansible allows for the creation of a collection of templates and instructions that are then called roles. A host that will be provisioned can then be assigned one or more of these roles, executing the entire template for the host. This allows you to reuse the role definition with a single line of configuration where you specify that the role must be provisioned on a host.
   Variable A variable stores some value that will be used in the Ansible deployment script. Ansible can take this a step further by having variable files where each file has different values for the same variables, and the decision is then made at runtime for which variable file will be used.   

 Ansible Example Ansible makes use of a specific folder and file structure. The most important part of the structure is the playbook, a YAML file that ultimately dictates what commands will be executed for provisioning. Let's take a look at the typical folder structure:

```
.
├── playbook.yml
├── roles
│   ├── common
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   ├── apt.yml
│   │   │   ├── main.yml
│   │   │   ├── task1.yml
│   │   │   ├── task2.yml
│   │   │   └── yum.yml
│   │   ├── templates
│   │   │   ├── template1
│   │   │   └── template2
│   │   └── vars
│   │       ├── Debian.yml
│   │       └── RedHat.yml
│   ├── role2
│   ├── role3
│   └── role4
└── variables
    └── var.yml
```

The folder structure was only expanded for the `common` role. However, this same structure would apply for roles 2 to 3.

 Let's dive a little bit into what each of these files would do. Let's start with the playbook.yml file:

 
```
---
- name: Configure the server
  hosts: all
  become: yes
  roles:
    - common
    - role3
  vars_files:
    - variables/var.yml
```

 As we can see, the playbook specifies that the `common` and `role3` roles should be applied for all hosts where this Ansible playbook will be executed. It will also use the `var.yml` file to overwrite any default variables within the roles. This allows us to only change the default variables where needed, as the defaults will then still be applied to all other variables.

 To execute the `common` role, Ansible will load variables from the `defaults/main.yml` file and overwrite these variables with any new values found in the `var.yml` file. It will then read and execute the `tasks/main.yml` file. This file would look something like this:

```
---
- name: include OS specific variables
  include_vars: "{{ item }}"
  with_first_found:
    - "{{ ansible_distribution }}.yml"
    - "{{ ansible_os_family }}.yml"

- name: set root password
  user:
    name: root
    password: "{{ root_password }}"
  when: root_password is defined

- include: apt.yml
  when: ansible_os_family == "Debian"

- include: yum.yml
  when: ansible_os_family == "RedHat"

- include: task1.yml
- include: task2.yml
```

 The first section of the Ansible file will determine the OS distribution of the host. It will then use this information to include OS-specific provisioning steps. As you can see from our folder structure, we have specific provisioning steps based on whether the distribution is Debian or RedHat. The second section of the playbook will set the root user's password. In the third section, we update the host and install some packages. However, we only execute the installing step matching the OS distribution. If the host is Debian, we will execute the commands specified in the `apt.yml` file. If the host is RedHat, we will execute the commands specified in the `yum.yml` file. This allows our Ansible role to be OS distribution agnostic. Lastly, we will execute the commands contained within the `task1.yml` and `task2.yml` files. These can be any commands, such as adding files to the host or making configuration changes.

 This is quite a lot of information to take in, but as you start using these tools and follow along with what scripts get executed when, it makes a lot more sense.

 Combining Vagrant and Ansible While you could stick to one IaC tool for your entire pipeline, it can often be beneficial to combine toolings. For example, Vagrant could be used for the main deployment of hosts, and Ansible can then be used for host-specific configuration. This way, you only use Vagrant when you want to recreate the entire network from scratch but can still use Ansible to make host-specific configuration changes until a full rebuild is required. Ansible would then run locally on each host to perform these configuration changes, while Vagrant will be executed from the hypervisor itself. In order to do this, you could add the following to your Vagrantfile to tell Vagrant to provision an Ansible playbook:

```
config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "provision/playbook.yml"
    ansible.become = true
end
```

It is also worth noting some of the differences between Vagrant and Ansible, if you are looking to only stick to a single IaC solution:

**Feature/Aspect** 
**Vagrant** 
**Ansible** 
**Configuration Language** 
Ruby (for Vagrantfiles).
YAML (for Playbooks).**Integration with Other Tools** 
Often used with provisioning tools like Chef, Puppet, or Ansible.Can be used standalone or integrated with other CI/CD tools.**Complexity** 
Relatively straightforward for setting up development environments.Higher complexity for larger infrastructures and advanced configurations.**Scalability** 
More suited for smaller-scale, individual development environments.Highly scalable, suitable for managing complex, multi-tier applications.**Execution Model** 
Procedural style with sequential execution steps.Declarative model, describing the desired state of the system.Now that we have learned about Vagrant and Ansible, let's put this knowledge to use and build our very own IaC pipeline!

### **Answer the questions below**

**Question:** What is the name given to the file that Ansible will provision?

*Answer:* 

     Playbook

**Question:** What is the name given to an Ansible file that will be updated, through the injection of Ansible variables, to create a final file during the provisioning process?

*Answer:* 

     Template

**Question:** What is the name given to an Ansible collection that can be provisioned with a single configuration request?

*Answer:* 

     Role

---

## Task 5 | Building an On-Prem IaC Workflow

Start MachineCreating an IaC Pipeline Now that we have learned the basics about on-prem IaC, it is time to put our knowledge to the test! Start the machine attached to this task by pressing the green **Start Machine**  button. The machine will start in split-view. In case it's not showing up, you can press the blue**Show Split View**  button at the top-right of the page.

 Once the machine has started, you can navigate to the `/home/ubuntu/iac/` directory. All of the scripts that we will be using today can be found in this directory.

 Vagrantfile Let's start by taking a look at the Vagrantfile:

 Vagrantfile
```Vagrantfile 
Vagrant.configure("2") do |config|
  # DB server will be the backend for our website
  config.vm.define "dbserver"  do |cfg|
    # Configure the local network for the server
    cfg.vm.network :private_network, type: "dhcp", docker_network__internal: true
    cfg.vm.network :private_network, ip: "172.20.128.3", netmask: "24"

    # Boot the Docker container and run Ansible
    cfg.vm.provider "docker" do |d|
      d.image = "mysql"
      d.env = {
        "MYSQL_ROOT_PASSWORD" => "mysecretpasswd"
      }
    end
  end

  # Webserver will be used to host our website
  config.vm.define "webserver"  do |cfg|
    # Configure the local network for the server
    cfg.vm.network :private_network, type: "dhcp", docker_network__internal: true
    cfg.vm.network :private_network, ip: "172.20.128.2", netmask: "24"

    # Link the shared folder with the hypervisor to allow data passthrough.
    cfg.vm.synced_folder "./provision", "/tmp/provision"

    # Boot the Docker container and run Ansible
    cfg.vm.provider "docker" do |d|
      d.image = "ansible2"

      d.has_ssh = true

      # Command will keep the container active
      d.cmd = ["/usr/sbin/sshd", "-D"]
    end

    #We will connect using SSH so override the defaults here
    cfg.ssh.username = 'root'
    cfg.ssh.private_key_path = "/home/ubuntu/iac/keys/id_rsa"

    #Provision this machine using Ansible 
    cfg.vm.provision "shell", inline: "ansible-playbook /tmp/provision/web-playbook.yml"
  end
end
```

In this Vagrantfile, we can see that two machines will be provisioned.

**DB Server** 

The first machine that will be provisioned is the `dbserver`. Working through the lines of code, we can see that the machine will be added to a local network and receive the IP of `172.20.128.3`. We can also see that the provision directory will be mounted as a share. Lastly, using Docker as the provider, the `mysql` image will be booted and the mysql password will be configured to be `mysecretpasswd`.

**Web Server**

The second machine that will be provisioned is the `webserver`. Similar to the `dbserver` machine, it will be connected to the network and use Docker as its provider. However, there are some slight differences. Firstly, the webserver will expose SSH. Since we are using Docker, we have to alter some of the default Vagrant configurations to allow Vagrant to connect via SSH. This includes changing the username and the private key that will be used for the connection. Secondly, we can see that an Ansible playbook will be executed on the container by looking at the following line:

```Terminal 
cfg.vm.provision "shell", inline: "ansible-playbook /vagrant/provision/web-playbook.yml"
```

 Let's take a look and see what this Ansible playbook will do.

 Ansible Playbook Let's start by reviewing the `web-playbook.yml` file:

```Terminal 
- hosts: localhost
  connection: all
  roles:
    - webapp
```

 This is a simple Ansible script that indicates that the webapp role will be provisioned on the host.

 To better understand what the webapp role will entail, we can start by reviewing the `~/iac/provision/roles/webapp/tasks/main.yaml` file:

 
```Terminal 
- include_tasks: "db-setup.yml"
- include_tasks: "app-setup.yml"
```

 This shows us that there will be two main portions to the Ansible provisioning. At this point, it is worth taking a look as well at the default values in the `~/iac/provision/roles/webapp/defaults/main.yml` file:

 
```Terminal 
db_name: BucketList
db_user: root
db_password: mysecretpasswd
db_host: 172.20.128.3

api_key: superapikey
```

 We will get back to these variables in a bit, but keep them in mind.

**DB Setup**

Let's take a look at the `db-setup.yml` file:

```Terminal 
- name: Create temp folder for SQL scripts 
  ansible.builtin.file: 
    path: /tmp/sql state: directory

- name: Time delay to allow SQL server to boot 
    shell: sleep 10

- name: Copy DB creation script with injected variables 
    template: 
      src: templates/createdb.sql 
      dest: /tmp/sql/createdb.sql

- name: Copy DB SP script with injected variables 
    template: 
      src: templates/createsp.sql 
      dest: /tmp/sql/createsp.sql

- name: Create DB 
    shell: mysql -u {{ db_user }} -p{{ db_password }} -h {{ db_host }} < /tmp/sql/createdb.sql

- name: Create Stored Procedures 
    shell: mysql -u {{ db_user }} -p{{ db_password }} -h {{ db_host }} < /tmp/sql/createsp.sql

- name: Cleanup Scripts 
    shell: rm -r /tmp/sql
```

From the script, we can see that 7 tasks will be performed. Reading through these tasks, we can see that a temporary folder will be created where SQL scripts will be pushed to and then executed against the database host.

Let's take a look at how Ansible would inject those variables from before. Take a look at the `Create DB` task's shell command:

```Terminal 
shell: mysql -u {{ db_user }} -p{{ db_password }} -h {{ db_host }} < /tmp/sql/createdb.sql
```

As you can see, the three variables of `db_user`, `db_password`, and `db_host` will be injected using either the values for the default file, or the overwritten values, if they exist.

 Ansible allows us to take this a step further. Let's take a look at the actual `createdb.sql` file:

```Terminal 
drop DATABASE IF EXISTS {{ db_name }};

CREATE DATABASE {{ db_name }};
USE {{ db_name }};

drop TABLE IF EXISTS 'tbl_user';

CREATE TABLE {{ db_name }}.tbl_user ( 
  'user_id' BIGINT AUTO_INCREMENT, 
  'user_name' VARCHAR(45) NULL, 
  'user_username' VARCHAR(45) NULL, 
  'user_password' VARCHAR(162) NULL, 
  PRIMARY KEY ('user_id'));
```

As we can see, these variables are even injected into the file templates that will be used. This allows us to control the variables that will be used from a single, centralised location. When we change the user or password that will be used to connect to the database, we can change this in a single location, and it will propagate throughout all provisioning steps for the role.

**Web Setup**

Lastly, let's take a look at the `app-setup.yml` file:

 
```Terminal 
- name: Copy web application files
  shell: cp -r /vagrant/provision/roles/webapp/templates/app /

- name: Copy Flask app script with injected variables
  template:
    src: templates/app.py
    dest: /app/app.py
```

This file only has two tasks. The first copies the artefacts required for the web application and the second copies the web application file as a template. A template copy is performed to ensure that the variables, such as the database connection string, are injected into the script as well.

 We will not do a deep dive into the rest of the files that will be used for provisioning, however, it is recommended that you take a look at these files to gain a better understanding on what exactly we are provisioning.

 Running the IaC Pipeline Now that we have an understanding of our pipeline, it is time to start it! Let's start our pipeline and the provisioning using `vagrant up` from the `iac` directory. The pipeline will take a while to boot, but pay attention to what is happening.

**Note: While you may see some red on the terminal when the Ansible provisioning step is running, as long as these lines only indicate warnings and not an error, the provisioning will complete as expected.**

 Once our pipeline has provisioned the machines, we can verify that they are running using the `docker ps` command:

 Terminal
```Terminal 
ubuntu@tryhackme:~$ docker ps 
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                    NAMES 
04fc30613dd6   mysql     "docker-entrypoint.s…"   18 minutes ago   Up 18 minutes   3306/tcp, 33060/tcp      iac_dbserver_1706019401 
5529f04a2509   ansible   "/usr/sbin/sshd -D"      18 minutes ago   Up 18 minutes   127.0.0.1:2222->22/tcp   iac_webserver_1706019400
```

If this is running, we can start our web application using the following command:

 `vagrant docker-exec -it webserver -- python3 /app/app.py`

 Once loaded, you can navigate to the web application using the target machines's browser ([http://172.20.128.2/](http://172.20.128.2/)):

 

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/6093e17fa004d20049b6933e/room-content/39e697edab7cba60952ccdb28ece98c9.png)

Congratulations! You have executed your very first IaC pipeline!

### **Answer the questions below**

**Question:** What is the flag displayed on the web application that is hosted after your IaC pipeline provisioning? You will need to create a profile and authenticate to view the flag.

*Answer:* 

     THM{IaC.Pipelines.Can.Be.Fun}

---

## Task 6 | Security Concerns in On-Prem IaC

When using IaC, regardless of whether the deployment is on-prem or cloud-based, there are several things to consider for security. If you are looking for security best practices, cheat sheets such as [these from OWASP](https://cheatsheetseries.owasp.org/cheatsheets/Infrastructure_as_Code_Security_Cheat_Sheet.html) are a good place to start. Even frameworks such as [NIST](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-204C.pdf) provide information on how to secure IaC.

 However, in this room, we will focus more on the practical security of IaC and common mistakes that are seen in the real world. This is not a comprehensive list of things to take into consideration, but it is a great start either protecting your IaC pipeline against real-world attacks or what to look for if you are attacking an IaC pipeline on a red team engagement. In total, there are four main elements to consider.

 Dependencies![Image 2](https://tryhackme-images.s3.amazonaws.com/room-icons/317702e9ed406144f96699d72b09ef9c.png)

The first element of IaC pipelines where security has to be considered is the dependencies. Similar to a software pipeline, our IaC pipeline will have dependencies. In IaC pipelines, the biggest dependencies are the base images that are pulled and used to build the infrastructure. If these dependencies have any security issues, these issues will propagate through the pipeline.

A common example would be a vulnerability in the OS version of the image. If the image itself is not updated, the deployed hosts would have this vulnerability. As such, it is important to ensure adequate dependency management for resources used in the IaC pipeline. Anytime you are making use of third-party software or systems, it can introduce a dependency risk. For more information on dependency management and the potential vulnerabilities, have a look at the [Dependency Management](https://tryhackme.com/room/dependencymanagement) room.

 Defaults A common security flaw in IaC pipelines is not altering defaults. When hosts and services are initially provisioned through an IaC pipeline, it is extremely common for these systems to be provisioned using default credentials or connection strings. Ultimately, this is intended as these default credentials are used by the tools in the pipeline to provision the hosts. The security misconfiguration is therefore not the default credentials, but not removing or altering them as the final step in the IaC deployment.

![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/6093e17fa004d20049b6933e/room-content/b2355b480888d1f06134521274217192.png)

 An example of default credentials is the credentials used by Vagrant to provision Windows hosts. Windows images provisioned by Vagrant often have a built-in default account of `vagrant` that has the password of `vagrant`. This is to allow the Vagrant script running on the hypervisor to connect to the host for file transfer and script execution. If, at the end of the deployment, this default user is not removed, a threat actor could use this to connect to and take full control of all hosts deployed through the IaC pipeline.

Another issue with defaults is in the services deployed on the hosts. Let's say, for instance, that our IaC pipeline is used to deploy a CI/CD pipeline and would therefore install the Jenkins role on one of the hosts. It would be common for this role to be installed with the default credentials of Jenkins, which would be `jenkins:jenkins`. In this case, we cannot really alter these credentials in the last stages of the IaC deployment but expect the software engineers that will use the CI/CD infrastructure to alter the credentials. In some cases, this is not performed, which then leads to insecure infrastructure in the deployment. In other cases, even if the software would require the user to change their password with the first logon event, as the software is never used, the default credential remains, allowing a threat actor to compromise the service and potentially its underlying infrastructure.

 As such, when building an IaC pipeline, it is important to make note of cases where defaults are used and where they may be a risk if not altered. The alteration of these defaults should then either be embedded as the final steps in the IaC pipeline or, where required, be performed manually once the deployment is complete.

 Insufficient Hardening![Image 4](https://tryhackme-images.s3.amazonaws.com/room-icons/c37f3bd6e21e89c0a8de1607bf56fbab.svg)

The third element that commonly goes wrong in IaC pipelines is insufficient hardening. The primary goal of IaC is to rapidly deploy infrastructure. This often means that the infrastructure that is being deployed has not yet been fully hardened. Hardening is not something that just happens automatically; it has to be planned for. As such, it is important to ensure that hardening steps are either embedded in the IaC pipeline or performed manually post-deployment.

 A common example of insufficient hardening is the services used by the IaC pipeline for deployment. For example, when Vagrant does provisioning of a Windows host, it does this via a WinRM connection. It just so happens that WinRM is a service commonly used by threat actors for lateral movement. As such, it is important that if the service is no longer required for normal operation post-deployment, it should be disabled. When planning your IaC pipeline, it is important to include not only general hardening steps but also those that would close down the services used by the pipeline itself.

 Remote Code Execution as a Feature The last element to consider is to remember that, ultimately, IaC pipelines are nothing more than remote code execution as a feature. In essence, the pipeline is effectively executing code that allows for new infrastructure to be created and integrated into existing networks. While this is incredibly powerful in the right hands, it could also be extremely detrimental.

![Image 5](https://tryhackme-images.s3.amazonaws.com/room-icons/23854ddd89de7b9574e1d71b7609ce43.png)

 Taking this into consideration, it is important to apply security to the IaC pipeline to prevent unauthorised access. This can be done through two main security efforts, namely secret management and following the principle of least privilege.

 With secret management, we can ensure that sensitive information, such as final credentials or keys, is securely stored and cannot simply be read from the IaC source code to compromise the deployment.

Following the principle of least privilege ensures that access to the IaC pipeline is only provided to users and services that require it. This includes implementing the same security controls that should be in any pipeline as taught in the [CI/CD and Build Security](https://tryhackme.com/room/cicdandbuildsecurity) room. If a threat actor can compromise the pipeline, they would often have the ability to also compromise the deployed infrastructure.

 These are some of the key security considerations that are required to secure your IaC pipeline against real-world threats. Now that you know what to look for, let's use this knowledge to attack a vulnerable IaC pipeline!

### **Answer the questions below**

**Question:** I understand the potential security concerns with using IaC pipelines and I'm ready to put my knowledge to the test!

*Answer:* 

     No answer needed

---

## Task 7 | Attacking On-Prem IaC

Start MachineIaC Challenge Now that you have learned how on-prem IaC deployments work and the security concerns that arise when using IaC, it is time to put your knowledge to the test. Start the machine attached to this task by pressing the green **Start Machine**  button and wait for the machine to boot.

**Note: In order for us to provide you with this challenge, a significant amount of software had to be kept at specific version levels. As such, the machine itself has some outdated software, which could be used with kernel exploits to bypass the challenge itself. However, if you choose to go this route of kernel exploitation to bypass the challenge and recover the flags, it will only affect your own learning opportunity. Our suggestion, try to solve the challenge by using what you have learned in this room about on-prem IaC!**

 Once the machine is booted, you can use SSH with the credentials below to connect to the machine:

   

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/63588b5ef586912c7d03c4f0/room-content/be629720b11a294819516c1d4e738c92.png)

      **Username**    entry     **Password**    entry     **IP**    MACHINE_IP     

   Once authenticated, you will find an IaC pipeline's scripts. Work through these files to identify vulnerabilities and attack the machines deployed by the IaC pipeline to ultimately gain full control of the pipeline! You can also use this SSH connection to "catch shells" as required. You will have to leverage these files together with what you learned in Task 5 to be able to compromise the pipeline!

To assist you on this journey, you can make use of the hints provided below. However, since the main goal is attacking an IaC pipeline, you are provided with the following:

- [Nmap](https://tryhackme.com/module/nmap) has been installed for you on the host, allowing you to scan the port range of the Docker network, if required.
- Use [SSH to proxy](https://tryhackme.com/room/lateralmovementandpivoting) out the traffic of the web application, or any other port, as required.
- You can use the SCP command of SSH to transfer out the IaC configuration files.

### **Answer the questions below**

**Question:** What is the value stored in the flag1-of-4.txt file?

*Answer:* 

     THM{Dev.Bypasses.and.Checks.can.be.Dangerous}

**Question:** What is the value stored in the flag2-of-4.txt file?

*Answer:* 

     THM{IaC.Deployment.Keys.Must.be.Removed}

**Question:** What is the value stored in the flag3-of-4.txt file?

*Answer:* 

     THM{IaC.Shares.Should.be.Restricted}

**Question:** What is the value stored in the flag4-of-4.txt file?

*Answer:* 

     THM{Provisioners.Usually.Have.Privileged.Access}

---

## Task 8 | Conclusion

In this room, we learned about on-prem IaC. Let’s have a recap:

 
- There are still reasons today why IaC could be performed on-prem instead of in the cloud
- Vagrant and Ansible are two sets of software that can be used for IaC pipelines
- With IaC pipelines, we have even larger security concerns as the IaC pipeline itself is remote code execution that a threat actor could leverage to create new machines
- While IaC pipelines provide automation for the deployment of infrastructure, we are still responsible for manually, or through the use of the automation, harden the deployed infrastructure

 Now that you have learned on-prem IaC, it is time to take a look at [Cloud-Based IaC](https://tryhackme.com/jr/cloudbasediac)!

### **Answer the questions below**

**Question:** I understand on-prem IaC pipelines and know what to look for to keep them secure!

*Answer:* 

     No answer needed

---

{% endraw %}
