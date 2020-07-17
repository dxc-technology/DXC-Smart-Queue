# DXC-Smart-Queue
**Business Value:** Our goal is to make it safer to use any public facility. Rather than predicting and restricting, we incentivize people (with a gaming experience) to look out for each other.
 
**Technical Innovation:** [Algorithmic mechanism design](https://en.wikipedia.org/wiki/Algorithmic_mechanism_design) is an under-used technique. We used it to reward those who willingly social distance.

**Business implementation:** The application uses Microsoft Azure’s native cloud services and scale. The roadmap to production requires customizing the application to a specific set of trains and times, deploying the system, and testing it.

[![Watch the video](https://img.youtube.com/vi/__JuQAPp798/maxresdefault.jpg)](https://www.youtube.com/watch?v=__JuQAPp798&feature=youtu.be)

## Overview
People respond a lot better when you make them part of the solution, not the problem. The transit system is complex and keeping it both useful and safe is difficult. What if instead of imposing travel restrictions, you gave people incentives to look out for each other? [Algorithmic mechanism design](https://en.wikipedia.org/wiki/Algorithmic_mechanism_design) lets you align the interests of each person with the common good. We built this technique into a system that we call the Smart Queue. The Smart Queue monitors the complex transit network and offers each rider real-time rewards for willingly keeping a safe social distance.

Choose where you want to be and when you want to be there. The Smart Queue estimates the social responsibility of each option, assigns points, and shows you the results. Choose whichever option you like, but the Smart Queue will gently nudge if more responsible choices are available. The better your choices, the more reward points you earn. You can check on the rewards you’ve earned at any time. The application notifies you of upcoming reservations or when, despite your best efforts, you might be entering an overcrowded zone.


## The App Demo
[The app](https://github.com/dxc-technology/DXC-Smart-Queue/tree/master/Code/App/app_code) is written using the Flutter framework. We created two versions of the app. One runs natively on Android mobile devices, the other runs natively on iOS mobile devices.
During the [Metro-North MTA Virtual Hackathon]( https://www.mtahackathon.org/), we deployed the Smart Queue and end-user app, and ran it live on MTA data. There are two ways to see a demonstration of the app:
1.	Watch [the video]( https://www.youtube.com/watch?v=__JuQAPp798&feature=youtu.be) above. The demo runs from 0:45 to 1:30 of the video.
1.	Open the hackathon [final presentation]( https://github.com/dxc-technology/DXC-Smart-Queue/blob/master/Documentation/User/Team-16-Presentation%20OPEN%20IN%20PRESENTATION%20MODE.pptx) **in presentation mode.** The presentation includes an embedded demo video.


## The Design
[The app](https://github.com/dxc-technology/DXC-Smart-Queue/tree/master/Code/App/app_code) uses the Flutter framework to run natively on Android and iOS. The app communicates with the Smart Queue, which is implemented as Python/Django app running in Azure. The data pipeline pulls real-time information from the MTA and updates the Azure PostgreSQL Database—which feeds the Smart Queue. Each component is designed to scale separately using Azure's native cloud services.

![](Documentation/Technical/architecture-diagram.png)

### The Smart Queue
The [Smart Queue](https://github.com/dxc-technology/DXC-Smart-Queue/blob/master/Code/SmartQueue/smartqueue.py) is written in Python and deployed as a Django app running in a Microsoft Azure Web App. The Smart Queue reads queue schedules (every 15 minutes) from data lake and updates itself.
The Smart Queue monitors the occupants of each train, the capacity of each station, and the capacity of each queue. When in demo deployment, readings on the occupancy of each train is simulated. But when deployed in production, the Smart Queue can be plugged into live train occupant updates. The Smart Queue assigns points based on remaining occupant capacity. The lower the remaining capacity, the lower the points. The Smart Queue takes into account queues that overlap at different locations and queues that lose capacity because the arriving train is already full.


### The Data Lake
The Smart Queue reads [Queue Schedules]( https://github.com/dxc-technology/DXC-Smart-Queue/blob/master/Data/Schema_Resource_Locations_Queues.json) from the Data Lake. The Data Lake is a PostgreSQL database running in a Microsoft Azure for PostgreSQL Database cloud service. The Queue Schedule specifies waiting queues for each train and platform. This data is updated on a regular basis from a running data pipeline.

### The Data Pipeline
The [data pipeline](https://github.com/dxc-technology/DXC-Smart-Queue/tree/master/Code/Pipeline) is written in Python and deployed as a Django app running in a Microsoft Azure Web App. The data pipeline reads raw MTA data from [select MTA APIs]( https://github.com/dxc-technology/DXC-Smart-Queue/blob/master/Documentation/Technical/apiList_backend.txt), converts the raw data into a [queue schedule]( https://github.com/dxc-technology/DXC-Smart-Queue/blob/master/Data/Schema_Resource_Locations_Queues.json) and writes the queue schedule to the data lake. By default, the data pipeline runs every 15 minutes.

## Supporting Documents
Links to important documents
