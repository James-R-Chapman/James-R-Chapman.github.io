---
title: TryHackMe  - AWS Security - S3cret Santa
Date: 2025-12-24
Tags: #TryHackMe
identifier: 20251231T104809
Hubs: "TryHackMe/Learn/AWS Security - S3cret Santa"
id: 6394f9bd-557b-47a4-b76a-331517a8efcc
URLs: (https://tryhackme.com/room/cloudenum-aoc2025-y4u7i0o3p6)
---

# TryHackMe | AWS Security - S3cret Santa

## Task 1 | Introduction

The Story

![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/5ed5961c6276df568891c3ea/room-content/5ed5961c6276df568891c3ea-1764055517343.png)

One of our stealthiest infiltrated elves managed to hop their way into Sir Carrotbane’s office and, lo and behold, discovered a bundle of cloud credentials just lying around on his desktop like forgotten carrots. The agent suspects these could be the key to regaining access to TBFC’s cloud network. If only the poor hare had the faintest clue what “the cloud” is, he’d burrow in himself. Let's help the elf utilise these credentials to try to regain access to TBFC's cloud network.

Learning Objectives

- Learn the basics of AWS accounts.
- Enumerate the privileges granted to an account, from an attacker's perspective.
- Familiarise yourself with the AWS CLI.

Lab Connection Before moving forward, review the questions in the connection card shown below:

![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/5ed5961c6276df568891c3ea/room-content/5ed5961c6276df568891c3ea-1764055687556.png)

Start your target machine by clicking the **Start Machine** button below. The machine will open in split view and need about 2 minutes to fully boot. In case you can not see it, click the **Show Split View** button at the top of the page.

Set up your virtual environmentTo successfully complete this room, you'll need to set up your virtual environment. This involves starting the Target Machine, ensuring you're equipped with the necessary tools and access to tackle the challenges ahead.

![Image 3](https://tryhackme.com/static/svg/target-machine.a3955286.svg)

Target machine

![Image 4](data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTciIGhlaWdodD0iMTYiIHZpZXdCb3g9IjAgMCAxNyAxNiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguODI1MiAwQzQuNDA2NDUgMCAwLjgyNTE5NSAzLjU4MTI1IDAuODI1MTk1IDhDMC44MjUxOTUgMTIuNDE4NyA0LjQwNjQ1IDE2IDguODI1MiAxNkMxMy4yNDM5IDE2IDE2LjgyNTIgMTIuNDE4NyAxNi44MjUyIDhDMTYuODI1MiAzLjU4MTI1IDEzLjI0MzkgMCA4LjgyNTIgMFpNOC44MjUyIDRDOS4zNzczOCA0IDkuODI1MiA0LjQ0NzgxIDkuODI1MiA1QzkuODI1MiA1LjU1MjE5IDkuMzc3MzggNiA4LjgyNTIgNkM4LjI3MzAxIDYgNy44MjUyIDUuNTUzMTIgNy44MjUyIDVDNy44MjUyIDQuNDQ2ODggOC4yNzIwNyA0IDguODI1MiA0Wk0xMC4wNzUyIDEySDcuNTc1MkM3LjE2MjcgMTIgNi44MjUyIDExLjY2NTYgNi44MjUyIDExLjI1QzYuODI1MiAxMC44MzQ0IDcuMTYxMTMgMTAuNSA3LjU3NTIgMTAuNUg4LjA3NTJWOC41SDcuODI1MkM3LjQxMTEzIDguNSA3LjA3NTIgOC4xNjQwNiA3LjA3NTIgNy43NUM3LjA3NTIgNy4zMzU5NCA3LjQxMjcgNyA3LjgyNTIgN0g4LjgyNTJDOS4yMzkyNiA3IDkuNTc1MiA3LjMzNTk0IDkuNTc1MiA3Ljc1VjEwLjVIMTAuMDc1MkMxMC40ODkzIDEwLjUgMTAuODI1MiAxMC44MzU5IDEwLjgyNTIgMTEuMjVDMTAuODI1MiAxMS42NjQxIDEwLjQ5MDggMTIgMTAuMDc1MiAxMloiIGZpbGw9IiM4NzhGQTIiLz4KPC9zdmc+Cg==)

Status:OffStart Machine AWS accounts can be accessed programmatically by using an Access Key ID and a Secret Access Key. For this room, both of those will be automatically configured for you. The AWS CLI will look for credentials at `~/.aws/credentials`, where you should see something similar to the following:

```
aws_access_key_id = REDACTED_ACCESS_KEY_ID
aws_secret_access_key = REDACTED_SECRET_ACCESS_KEY
```

Amazon Security Token Service (STS) allows us to utilise the credentials of a user that we have saved during our AWS CLI configuration. We can use the `get-caller-identity` call to retrieve information about the user we have configured for the AWS CLI. Let's run the following command:

`aws sts get-caller-identity`

We will see the following output when we run this command.

Checking AWS CLI Configuration

```Checking AWS CLI Configuration
user@machine$ aws sts get-caller-identity{    "UserId": "AIDAU2VYTBGYOHNOCJMX3",    "Account": "332173347248",    "Arn": "arn:aws:iam::332173347248:user/sir.carrotbane"}
```

Seeing the output, the elf was overjoyed. The credentials work, and as can be seen by the name at the end, they belong to Sir Carrotbane. The elf can now attempt to regain access to TBFC's cloud network using these credentials.

### **Answer the questions below**

**Question:**

_Answer:_

     123456789012

---

## Task 2 | IAM: Users, Roles, Groups and Policies

IAM Overview Amazon Web Services utilises the Identity and Access Management (IAM) service to manage users and their access to various resources, including the actions that can be performed against those resources. Therefore, it is crucial to ensure that the correct access is assigned to each user according to the requirements. Misconfiguring IAM has led to several high-profile security incidents in the past, giving attackers access to resources they were not supposed to access. Companies like Toyota, Accenture and Verizon have been victims of such attacks in the past, often exposing customer data or sensitive documents. Below, we will discuss the different aspects of IAM that can lead to sensitive data exposure if misconfigured.

IAM Users A user represents a single identity in AWS. Each user has a set of credentials, such as passwords or access keys, that can be used to access resources. Furthermore, permissions can be granted at a user level, defining the level of access a user might have.

![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/5ed5961c6276df568891c3ea/room-content/5ed5961c6276df568891c3ea-1764128605182.png)

IAM Groups Multiple users can be combined into a group. This can be done to ease the access management for multiple users. For example, in an organisation employing hundreds of thousands of people, there might be a handful of people who need write access to a certain database. Instead of granting access to each user individually, the admin can grant access to a group and add all users who require write access to that group. When a user no longer needs access, they can be removed from the group.

![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/5ed5961c6276df568891c3ea/room-content/5ed5961c6276df568891c3ea-1764127702407.png)

IAM Roles An IAM Role is a temporary identity that can be assumed by a user, as well as by services or external accounts, to get certain permissions. Think of Sir Carrotbane, and how, depending on the battle ahead, he might need to assume the role of an attacker or a defender. When becoming an attacker, he will get permission to wield his shiny swords, but when assuming the role of a defender, he will instead get permission to carry a shield to better defend King Malhare.

![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/5ed5961c6276df568891c3ea/room-content/5ed5961c6276df568891c3ea-1764127718214.png)

IAM Policies Access provided to any user, group or role is controlled through IAM policies. A policy is a JSON document that defines the following:

- What action is allowed (Action)
- On which resources (Resource)
- Under which conditions (Condition)
- For whom (Principal)

Consider the following hypothetical policy

IAM Policy example

```IAM Policy example
{  "Version": "2012-10-17",  "Statement": [    {      "Sid": "AllowSpecificUserReadAccess",      "Effect": "Allow",      "Principal": {        "AWS": "arn:aws:iam::123456789012:user/Alice"      },      "Action": [        "s3:GetObject"      ],      "Resource": "arn:aws:s3:::my-private-bucket/*"    }  ]}
```

This policy grants access to the AWS user Alice (Principal) to get an object from an S3 bucket (Action) for the S3 bucket named my-private-bucket (Resource).

### **Answer the questions below**

**Question:**

_Answer:_

     policy

---

## Task 3 | Practical: Enumerating a User's Permissions

Enumerating Users Alright, let's see what we can do with the credentials we got from Sir Carrotbane's office, since we have already configured them in our environment. We can start interacting with the AWS CLI to find more information. Let's begin by enumerating users. We can do so by running the following command in the terminal:

`aws iam list-users`

We will see an output that lists all the users, as well as some other useful information such as their creation date.

Enumerating User Policies Policies can be inline or attached. **Inline policies** are assigned directly in the user (or group/role) profile and hence will be deleted if the identity is deleted. These can be considered as hard-coded policies as they are hard-coded in the identity definitions. **Attached policies** , also called managed policies, can be considered reusable. An attached policy requires only one change in the policy, and every identity that policy is attached to will inherit that change automatically.

Let's see what inline policies are assigned to Sir Carrotbane by running the following command.

`aws iam list-user-policies --user-name sir.carrotbane`

Great! We can see an inline policy in the results. Let's take note of its name for later.

Maybe, Sir Carrotbane has some policies attached to their account. We can find out by running the following command.

`aws iam list-attached-user-policies --user-name sir.carrotbane`

Hmmm, not much here. Perhaps we can check if Sir Carrotbane is part of a group. Let's run this command to do that.

`aws iam list-groups-for-user --user-name sir.carrotbane`

Looks like **sir.carrotbane** is not a part of any group.

Let's get back to the inline policy we found for Sir Carrotbane's account. Let's see what permissions this policy grants by running the following command (replace `POLICYNAME` with the actual policy name you found):

`aws iam get-user-policy --policy-name POLICYNAME --user-name sir.carrotbane`

```
{
    "UserName": "sir.carrotbane",
    "PolicyName": "POLICYNAME",
    "PolicyDocument": {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "iam:ListUsers",
                    "iam:ListGroups",
                    "iam:ListRoles",
                    "iam:ListAttachedUserPolicies",
                    "iam:ListAttachedGroupPolicies",
                    "iam:ListAttachedRolePolicies",
                    "iam:GetUserPolicy",
                    "iam:GetGroupPolicy",
                    "iam:GetRolePolicy",
                    "iam:GetUser",
                    "iam:GetGroup",
                    "iam:GetRole",
                    "iam:ListGroupsForUser",
                    "iam:ListUserPolicies",
                    "iam:ListGroupPolicies",
                    "iam:ListRolePolicies",
                    "sts:AssumeRole"
                ],
                "Effect": "Allow",
                "Resource": "*",
                "Sid": "ListIAMEntities"
            }
        ]
    }
}
```

So, it looks like Sir Carrotbane has access to enumerate all the different kinds of users, groups, roles and policies (IAM entities), but that is about it. That is not a lot of help getting TBFC's access back. We might need to try something different to do that. If you look carefully, you'll notice sir.carrotbane can perform the `sts:AssumeRole` action. Maybe there's still hope!

### **Answer the questions below**

**Question:**

_Answer:_

     SirCarrotbanePolicy

---

## Task 4 | Assuming Roles

Enumerating Roles The `sts:AssumeRole` action we previously found allows sir.carrotbane to assume roles. Perhaps we can try to see if there's any interesting ones available. Let's start by listing the existing roles in the account.

`aws iam list-roles`

```
{
    "Roles": [
        {
            "Path": "/",
            "RoleName": "bucketmaster",
            "RoleId": "AROARZPUZDIKJJZ6OWN27",
            "Arn": "arn:aws:iam::123456789012:role/bucketmaster",
            "CreateDate": "2025-11-26T01:54:01.342203+00:00",
            "AssumeRolePolicyDocument": {
                "Statement": [
                    {
                        "Action": "sts:AssumeRole",
                        "Effect": "Allow",
                        "Principal": {
                            "AWS": "arn:aws:iam::123456789012:user/sir.carrotbane"
                        }
                    }
                ],
                "Version": "2012-10-17"
            },
            "MaxSessionDuration": 3600
        }
    ]
}
```

Bingo! There's a role named `bucketmaster`, and it can be assumed by `sir.carrotbane`. Let's find out what policies are assigned to this role. Just as users, roles can have inline policies and attached policies. To check the inline policies, we can run the following command.

`aws iam list-role-policies --role-name bucketmaster`

There is one policy assigned to this role. Before checking that policy, let's see if there are any attached policies assigned to the role as well.

`aws iam list-attached-role-policies --role-name bucketmaster`

Looks like we only have the inline policy assigned. Let's see what permissions we can get from the policy.

`aws iam get-role-policy --role-name bucketmaster --policy-name BucketMasterPolicy`

```
{
    "RoleName": "bucketmaster",
    "PolicyName": "BucketMasterPolicy",
    "PolicyDocument": {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "s3:ListAllMyBuckets"
                ],
                "Effect": "Allow",
                "Resource": "*",
                "Sid": "ListAllBuckets"
            },
            {
                "Action": [
                    "s3:ListBucket"
                ],
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:s3:::easter-secrets-123145",
                    "arn:aws:s3:::bunny-website-645341"
                ],
                "Sid": "ListBuckets"
            },
            {
                "Action": [
                    "s3:GetObject"
                ],
                "Effect": "Allow",
                "Resource": "arn:aws:s3:::easter-secrets-123145/*",
                "Sid": "GetObjectsFromEasterSecrets"
            }
        ]
    }
}
```

Well, what do we have here? We can see that the `bucketmaster` role can perform three different actions (ListAllBuckets, ListBucket and GetObject) on some resources of a service named S3. This might just be the breakthrough we were looking for. More on this service later.

Assuming Role To gain privileges assigned by the `bucketmaster` role, we need to assume it. We can use AWS STS to obtain the temporary credentials that enable us to assume this role.

`aws sts assume-role --role-arn arn:aws:iam::123456789012:role/bucketmaster --role-session-name TBFC`

This command will ask STS, the service in charge of AWS security tokens, to generate a temporary set of credentials to assume the `bucketmaster` role. The temporary credentials will be referenced by the session-name "TBFC" (you can set any name you want for the session). Let's run the command:

```
{
    "Credentials": {
        "AccessKeyId": "REDACTED_TEMP_ACCESS_KEY_ID",
        "SecretAccessKey": "REDACTED_TEMP_SECRET_ACCESS_KEY",
        "SessionToken": "REDACTED_AWS_SESSION_TOKEN",
        "Expiration": "2025-11-26T03:40:11.117460+00:00"
    },
    "AssumedRoleUser": {
        "AssumedRoleId": "AROARZPUZDIKJJZ6OWN27:TBFC",
        "Arn": "arn:aws:sts::123456789012:assumed-role/bucketmaster/TBFC"
    },
    "PackedPolicySize": 6
}
```

The output will provide us the credentials we need to assume this role, specifically the `AccessKeyID`, `SecretAccessKey` and `SessionToken`. To be able to use these, run the following commands in the terminal, replacing with the exact credentials that you received on running the `assume-role` command.

Setting the Temporary Credentials to Assume Role

```Setting the Temporary Credentials to Assume Role
user@machine$ export AWS_ACCESS_KEY_ID="REDACTED_TEMP_ACCESS_KEY_ID"user@machine$ export AWS_SECRET_ACCESS_KEY="REDACTED_TEMP_SECRET_ACCESS_KEY"user@machine$ export AWS_SESSION_TOKEN="REDACTED_AWS_SESSION_TOKEN"
```

Once we have done that, we can officially use the permissions granted by the `bucketmaster` role. To check if you have correctly assumed the role, you can once again run:

`aws sts get-caller-identity`

This time, it should show you are now using the `bucketmaster` role.

### **Answer the questions below**

**Question:**

_Answer:_

     ListAllMyBuckets

---

## Task 5 | Grabbing a file from S3

What Is S3? Before we continue, we need to know what exactly is S3. Amazon S3 stands for **Simple Storage Service** . It is an object storage service provided by Amazon Web Services that can store any type of object such as images, documents, logs and backup files. Companies often use S3 to store data for various reasons, such as reference images for their website, documents to be shared with clients, or files used by internal services for internal processing. Any object you store in S3 will be put into a "Bucket". You can think of a bucket as a directory where you can store files, but in the cloud.

![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/5ed5961c6276df568891c3ea/room-content/5ed5961c6276df568891c3ea-1764128730134.png)

Now, let's see what our newly gained access to Sir Carrotbane's S3 bucket provides us.

Listing Contents From a Bucket Since our profile has permission to ListAllBuckets, we can list the available S3 buckets by running the following command:

`aws s3api list-buckets`

There is one interesting bucket in there that references easter. Let's check out the contents of this directory.

`aws s3api list-objects --bucket easter-secrets-123145`

Hmmm, let's copy the file in this directory to our local machine. This might have a secret message.

`aws s3api get-object --bucket easter-secrets-123145 --key cloud_password.txt cloud_password.txt`

Hooray! We have successfully infiltrated Sir Carrotbane's S3 bucket and exfiltrated some sensitive data.

### **Answer the questions below**

**Question:**

_Answer:_

     THM{more_like_sir_cloudbane}

---
