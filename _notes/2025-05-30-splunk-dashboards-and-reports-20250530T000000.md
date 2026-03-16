---
layout: post
title: "Splunk - Dashboards and Reports"
date: 2025-05-30
tags: ["tryhackme"]
categories: [tryhackme]
hubs: "TryHackMe/SOC Level 2/Advanced Splunk"
identifier: "20250530T000000"
source_id: "df7fa2d1-7100-4d92-a7b3-f6f6442c0419"
source_urls: "(https://tryhackme.com/room/splunkdashboardsandreports)"
source_path: "SOC Level 2/Advanced Splunk/20250530T000000--splunk-dashboards-and-reports__tryhackme.md"
---

{% raw %}


# Splunk: Dashboards and Reports

## Task 1 | Introduction

Splunk is one of the most widely used Security Information and Event Management (SIEM) solutions in the enterprise environment. It helps aggregate data from different data sources in the enterprise environment to help enhance security monitoring. However, sometimes, this data becomes too overwhelming for analysts. In this room, we will learn how an analyst can better organize the data in Splunk. Broadly, we will have the following learning objectives.

 Learning Objectives: 
- Why do we need to organize data in Splunk
- Creating dashboards for the visualization of high-level information
- Scheduling reports for recurring searches of data
- Translating Security Operations Center (SOC) use cases to alerts

 Pre-requisites:Before starting this room, it is recommended that you complete the following rooms.

- [Splunk: Basics](https://tryhackme.com/room/splunk101)
- [Splunk: Exploring SPL](https://tryhackme.com/room/splunkexploringspl)
- [Splunk: Setting up a SOC Lab](https://tryhackme.com/room/splunklab)

### **Answer the questions below**

**Question:** I have completed the pre-requisite rooms.

*Answer:* 

     No answer needed

---

## Task 2 | Organizing Data in Splunk

Splunk does a great job of aggregating the security-related data of an organization's assets in a single place. However, this data is huge, difficult to grasp, and make sense of. We will learn how to make sense of the data in this room.

 When we open Splunk, this is the screen we might be greeted with after signing in.

 ![Image 1](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/0e9223ead2aa33080f94971ee8127812.png)

 To move forward, go to the first tab on the left menu, **Search & Reporting** . Clicking that, we see the following interface.

 ![Image 2](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/0dc6a592bc7c55bcbde3fc9d3ce9cabc.png)

 Now, we can see that we have an interface for the Search app. For starters, we can start a search with the search term `index=*` to see what data we have here. We have set the time window to 'all time' to see the data historically present here as well.

 ![Image 3](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/2a22505acdde8366e8eecbca63056ed6.png)

 Looking at the above screenshot, we can feel overwhelmed. There are more than 35000 events present in this data. If we are to sift through this data manually, it will make our lives difficult instead of making them easier. Therefore, looking at raw data is often not a good idea when our goal is to get an overview of an organisation's security posture. It also doesn't give us much information about the threats and attacks launched against the organization. Now this is just a sample of data in Splunk that we have added for this room. In production, we should avoid running searches for 'all time' as they can add undue load on the Splunk search head and make other searches difficult and slow.

 The above-mentioned problems are bound to appear when we deal with a lot of data. Splunk is a data analysis platform that provides solutions for these problems. In the coming tasks, we will see how to aggregate and visualize this data to find answers to our problems.

### **Answer the questions below**

**Question:** Which search term will show us results from all indices in Splunk?

*Answer:* 

     index=*

---

## Task 3 | Creating Reports for Recurring Searches

Start MachineUntil now, we have been using Splunk for broad searches mainly. However, we often need to run specific searches from time to time. For example, a certain organization might want to run a search every 8 hours when a new shift of SOC analysts arrives or is leaving. For this purpose, creating a report that will run at a specific time is efficient. Reports will then run the searches and save the results for viewing when the analysts for the incoming shift arrive.

 Reports can also help reduce the load on the Splunk search head. For example, if multiple searches need to be run at the start of every shift, running them simultaneously can increase the search head's load and processing times. If searches are scheduled with 5 or 10-minute intervals, they will accomplish two tasks.

 
1. The searches will run automatically without any user interaction.
2. The searches will not run simultaneously, reducing the possibility of errors or inefficiency.

Before moving forward, please start the attached VM by clicking the **Start Machine**  button on the top right corner. Once the IP address is visible, you can use the URL: [http://LAB_WEB_URL.p.thmlabs.com](http://lab_web_url.p.thmlabs.com/) to access the Splunk instance. It might take 3-5 minutes for the Splunk instance to start. A VPN connection is not needed to access the Splunk instances.

 Continuing from the previous task, move to the Reports tab to look at already saved reports in Splunk. We will see the following interface.

 ![Image 4](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/0aed9fcd210b163c605284680efc430d.png)

 Here, we see a list of reports already saved in Splunk. If we want to view the saved results of a report, we can click on the report's name. However, if we want to run a new search using the same query as the one in a report, we can use the 'Open in Search' option. The 'Edit' option allows us to edit the reports. The 'Next Scheduled Time' tab shows when the report will run again. We can also see the report's owner and its associated permissions. Please note that we have selected 'All' reports to be shown in the view above. There are options for viewing only the logged-in user's reports, as well as for viewing the reports added by the App.

 To create a new report, we can run a search and use the Save As option to save the search as a report.

 ![Image 5](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/0cf70ab30e4b7e3ef7ee4909924bf7db.png)

 Once we click the option to Save As Report, we see the following window.

 ![Image 6](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/7892bb7cb5332afca2520378eaee650b.png)

 Filling in the required data and clicking the 'Save' option here will save the search as a report.

 Let's practice the same in the attached Splunk instance. We ran a search in the previous task. To create a report on a search, we will first have to understand the data. On the left tab, we will see some fields Splunk has identified that might interest us. Let's click on hosts to see the number of hosts sending logs to our Splunk instance.

 ![Image 7](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/e7cd736aae3d8e8e234b8efea8cbf0d6.png)

 So, we have 3 hosts; network-server, web-server, and vpn_server. They are all sending different numbers of events. If we are to determine the number of times each VPN user logged in during our given time window (which is 'all time' for this room), we will run the following query.

`host=vpn_server | stats count by Username`

 This is what we get when we run this query in our instance.

 ![Image 8](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/a70e380a920c99fb120e94a15adefada.png)

 In a SOC environment, we might want to track users who logged in during a certain time window. This requirement might be repetitive. SOC analysts can create a report for this requirement that will run every few hours for ease of use. Let's practice that based on what we learned in this task. First, we click 'Save As' and select 'Report'.

 ![Image 9](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/a425a5b05047bcc8167e53f4f6233301.png)

 We fill in the required information.

 ![Image 10](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/a09eff4c9df3e76f6ddf989eba04e46d.png)

 Here, we can see the Content for this report will be a 'Statistics Table' because we used 'stats count' in our query. The 'Time Range Picker' has been set to 'Yes'. This means running the report will give us a time-range picker option. When we click 'Save', we get the following prompt, telling us the report has been created.

 ![Image 11](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/1e675560c1b6c0f2da5d65e15eacada4.png)

 We can click the 'View' option to view our report. This is how it will look.

 ![Image 12](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/bafea3aec0dd48d8be76e2907c0d61c5.png)

 On the reports tab, we can see our report now.

 ![Image 13](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/2ea776d9ae008ead16058bb5d2f22ffe.png)

 We see the owner of the report is 'admin', the logged-in user. The 'Sharing' is set to Private. This means that this report can only be accessed by admin. We can use the 'Edit' option to change the permissions and set it to be used by other users.

### **Answer the questions below**

**Question:** Create a report from the network-server logs host that lists the ports used in network connections and their count. What is the highest number of times any port is used in network connections?

*Answer:* 

     5

**Question:** While creating reports, which option do we need to enable to get to choose the time range of the report?

*Answer:* 

     Time Range Picker

---

## Task 4 | Creating Dashboards for Summarizing Results

Splunk provides us with the ability to create dashboards and visualizations. These dashboards and visualizations provide a user with quick info about the data present in Splunk. Dashboards are often created to help give a brief overview of the most important bits of the data. They are often helpful in presenting data and statistics to the management, such as the number of incidents in a given time frame, or for SOC analysts to figure out where to focus, such as identifying spikes and drops in data sources, which might indicate a surge in, say, failed login attempts. The primary purpose of dashboards is to provide a quick visual overview of the available information.

 To move forward, let's create a dashboard in the attached VM. To start, move to the Dashboards tab. We will see the below screen.

 ![Image 14](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/7b578741a3241d45e848ddfac934e3af.png)

 In this screen, we see an option to create dashboards labeled as 1 in the screenshot. Labeled as 2 is a list of available dashboards. Please note that we have selected 'All' dashboards here instead of 'Yours' or 'This App's', which can show a different list of dashboards. Labeled as 3 is information about these dashboards, such as owner, permissions, etc. Here, we also find the option to Edit the dashboard's different properties, or set it as the home dashboard. We can also view a dashboard by clicking on the name of the dashboard. However, we don't have any dashboards yet. We can start by creating a dashboard. For that, let's click the **Create Dashboard**  option to see the following window.

 ![Image 15](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/be9345e83d098e24621dc980759e89c0.png)

 After filling in the relevant details, such as the name and permissions, we can choose one of the two options for dashboard creation through Classic Dashboards or Dashboard Studio.

 ![Image 16](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/ae3bf1188ee513d8a5327da9d15d9932.png)

 We can see that we have set the permissions to 'Shared in App'. This will ensure that the dashboard is also visible to other users of Splunk. We will use the Classic Dashboard approach to create a dashboard for this room. Let's do that and click 'Create'. The Window tells us to 'Click Add Panel to Start'. When we click the 'Add Panel' option, we get the following menu on the right side.

 ![Image 17](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/1355c37ca97acafb650d7e30772624c8.png)

 We want to add the results from our report to the Dashboard. We can select the 'New from Report' option to do that.

 ![Image 18](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/8494ef44f7c6e667640b50cdc3c2e3e7.png)

 The 'Add to Dashboard' option will add these results to our dashboard. However, we were already seeing the results as a report. What benefit will a dashboard provide us? The answer to that lies in visualizations. We can select a visualization from the menu, as shown below.

 ![Image 19](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/6fd6d786cd7de2807bf0c7b61a782355.png)

 Let's select the column chart visualization and check out the results.

 ![Image 20](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/0d4636314e99375e15ff798c886fc460.png)

 Doesn't it look nice? We can see on a cursory glance that Emma logged in the least amount of times, and Sarah logged in the most. This is the kind of information that a dashboard is helpful for. Another way dashboards can help is by adding multiple reports to a single dashboard. The process for that will be similar, as we still see the Add Panel option above. However, we will keep this task to a single report. We can flip the switch to the Dark theme and click 'Save' to save the dashboard if we like it. This is how it will look when finished.

 ![Image 21](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/bdd06894dddfa316d0ec267df5f53e00.png)

 Now, we can go to the Dashboards menu to see our newly created dashboard.

### **Answer the questions below**

**Question:** Create a dashboard from the web-server logs that show the status codes in a line chart. Which status code was observed for the least number of times?

*Answer:* 

     400

**Question:** What is the name of the traditional Splunk dashboard builder?

*Answer:* 

     Classic 

---

## Task 5 | Alerting on High Priority Events

In the previous tasks, we practiced creating reports and dashboards. We understood that when we need to run a search repetitively, we can use reports, and if we want to club a few reports together or make visualizations, we can use dashboards. However, reports and dashboards will only be viewed by users at set time intervals. Sometimes, we want to be alerted if a certain event happens, such as, if the amount of failed logins on a single account reaches a threshold, it indicates a brute force attempt, and we would like to know as soon as it happens. In this task, we will learn how to set up alerts. Unfortunately, we cannot practice setting up alerts on the attached instance because of licensing issues. However, we will explain how to set up an alert in this task.

 First, we will run a search for our required search term. In the 'Save As' drop-down, we will see an option for saving as an alert. In the previous task, we identified that the user Sarah logged in the most during our time range. Therefore, let's narrow down our search to all the login events of the user Sarah.

 ![Image 22](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/b62596f1ec7d35d8be5f5c060367f7b7.png)

 When we click 'Alert' in the 'Save As' menu, we are asked to configure the alert's parameters.

 ![Image 23](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/75ef52a3c3b0a42d86fe76a3f52e1a7d.png)

 We see the usual settings such as Title, Description and Permissions. In addition to that, we have some more options specific to alerts. The alert type we are setting up is scheduled. This means that Splunk will run this search as per the schedule, and if the trigger condition is satisfied, an alert will be raised. Depending on the license and configuration for your Splunk instance, you might get an option for scheduling Real-time alerts. Next, we have trigger conditions.

 ![Image 24](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/f0d21b2e8e03df5c9f3484e4087ff656.png)

 Trigger conditions define the conditions when the alert will be raised. Here, let's say we raise the alert when the login count of our user is more than 5. In that case, we will use the 'Number of Results' option and set the 'is greater than' option to 5. We can trigger 5 alerts for the 5 login times, or we can just trigger a single alert for exceeding this count. The 'Throttle' option lets us limit the alerts by not raising an alert in the specified time period if an alert is already triggered. This can help reduce alert fatigue, which can overwhelm analysts when there are too many alerts. The final option here is for Trigger Actions. This option allows us to define what automated steps Splunk must take when the alert is triggered. For example, we might want Splunk to send an email to the SOC email account in case of an alert.

 ![Image 25](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/8a156dc2d6c94df4ae65aa458742c320.png)

 Below, we can see the configured alert. We have configured it to run every hour if Sarah logs in more than 5 times. The email will only be sent once every 60 minutes.

 ![Image 26](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/9960a9f78306e77c708469cf9f4ff582.png)

 If the alert is triggered, Splunk will send an email to soc@tryhackme.com.

 ![Image 27](https://tryhackme-images.s3.amazonaws.com/user-uploads/61306d87a330ed00419e22e7/room-content/06eb3fdc2a3418db77adeb3bd1ec395a.png)

 The email will be sent with the highest priority, and it will include the Subject and message mentioned above.

### **Answer the questions below**

**Question:** What feature can we use to make Splunk take some actions on our behalf?

*Answer:* 

     Trigger Action

**Question:** Which alert type will trigger the instant an event occurs?

*Answer:* 

     Real-time

**Question:** Which option, when enabled, will only send a single alert in the specified time even if the trigger conditions re-occur?

*Answer:* 

     Throttle

---

## Task 6 | Conclusion

That was a brief introduction on leveraging Splunk for better data management by creating Reports, Dashboards, and Alerts. In this task, we learned:

- Why do we need to have data organization in Splunk.
- How can we create Reports to schedule searches.
- Creating dashboards for visualizing data.
- Setting up alerts to get results of certain searches in our inbox.

But that's not all Splunk has to offer to a Security Analyst. For learning more about using Splunk to enhance the security posture of your organization, check out the rest of the rooms in this module. Let us know what you found interesting in this room on our [Discord channel](https://discord.gg/tryhackme) or [Twitter account](http://twitter.com/realtryhackme).

### **Answer the questions below**

**Question:** Yayy! I can create reports and dashboards in Splunk now!

*Answer:* 

     No answer needed

---
{% endraw %}
