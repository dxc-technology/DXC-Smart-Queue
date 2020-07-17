# DXC-Smart-Queue
**Business Value:** Our goal is to make it safer to use any public facility. Rather than predicting and restricting, we incentivize people (with a gaming experience) to look out for each other.
 
**Technical Innovation:** [Algorithmic mechanism design](https://en.wikipedia.org/wiki/Algorithmic_mechanism_design) is an under-used technique. We used it to reward those who willingly social distance.

**Business implementation:** The application uses Microsoft Azure’s native cloud services and scale. The roadmap to production requires customizing the application to a specific set of trains and times, deploying the system, and testing it.

## Overview
People respond a lot better when you make them part of the solution, not the problem. The transit system is complex and keeping it both useful and safe is difficult. What if instead of imposing travel restrictions, you gave people incentives to look out for each other? [Algorithmic mechanism design](https://en.wikipedia.org/wiki/Algorithmic_mechanism_design) lets you align the interests of each person with the common good. We built this technique into a system that we call the Smart Queue. The Smart Queue monitors the complex transit network and offers each rider real-time rewards for willingly keeping a safe social distance.

Choose where you want to be and when you want to be there. The Smart Queue estimates the social responsibility of each option, assigns points, and shows you the results. Choose whichever option you like, but the Smart Queue will gently nudge if more responsible choices are available. The better your choices, the more reward points you earn. You can check on the rewards you’ve earned at any time. The application notifies you of upcoming reservations or when, despite your best efforts, you might be entering an overcrowded zone.


## The App Demo
We created two versions of the app. One runs natively on Android mobile devices, the other runs natively on iOS mobile devices. Because deploying to an iOS device requires registration with iTunes and approval from Apple, the demo is for Android devices only.

### Install the App (Android)
From your Android device:
1. **Allow installation of third-party apps.** Go to Menu > Settings > Security > and check Unknown Sources to allow your phone to install apps from sources other than the Google Play Store
1. **Download the APK file.** From the browser, download the APK: https://link.APK
1. Go to the downloaded APK file, tap it, then hit Install

### Select a destination
1. From the main screen select [option]
1. In the [window] window, type [text]
1. In the [window] window, type [text]
1. In the [window] widget, select [selection]
1. Press the search icon
1. Select a queue from the [option] options

### Make reservations
1. From the [screen] screen select [option]
1. Select [option]

### Check reservations
1. From the [screen] screen select [option]
1. Select [option]

### Complete a reservation
1. From the [screen] screen select [option]
1. Select [option]

### Cancel a reservation
1. Make a reservation
1. From the [screen] screen select [option]
1. Select [option]

### Miss a reservation
Normally, the application will automatically mark your reservation as missed if you do not show up to the location at the scheduled time. The following instructions allow you to simulate this experience
1. Make a reservation
1. From the [screen] screen select [option]
1. Select [option]

### Check your points
1. From the [screen] screen select [option]
1. Select [option]

## The Design
The app uses the Flutter framework to run natively on Android and iOS. The app communicates with the Smart Queue, which is implemented as Python/Django app running in Azure. The data pipeline pulls real-time information from the MTA and updates the Azure PostgreSQL Database—which feeds the Smart Queue. Each component is designed to scale separately using Azure's native cloud services.

![](Documentation/Technical/architecture-diagram.png)

### The Smart Queue
The Smart Queue is written in Python and deployed as a Django app running in a Microsoft Azure Web App. The Smart Queue reads queue schedules (every 15 minutes) from data lake and updates itself.
The Smart Queue monitors the occupants of each train, the capacity of each station, and the capacity of each queue. When in demo deployment, readings on the occupancy of each train is simulated. But when deployed in production, the Smart Queue can be plugged into live train occupant updates. The Smart Queue assigns points based on remaining occupant capacity. The lower the remaining capacity, the lower the points. The Smart Queue takes into account queues that overlap at different locations and queues that lose capacity because the arriving train is already full.


### The Data Lake
Overview of the data lake

### The Data Pipeline
Overview of the data pipeline

## Supporting Documents
Links to important documents
