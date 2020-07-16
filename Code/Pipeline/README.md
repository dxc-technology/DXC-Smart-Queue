# SmartQueue Data API

### This Pipeline fetches data from Two MTA APIs.

##### 1. The following API provides the schedule of trains between any two stations for a given date.

* Schedule API:
https://mnorthstg.prod.acquia-sites.com/wse/trains/v4/{Origin}/{Destination}/DepartBy/{Year}/{Month}/{Day}/{Time}/{Api Key}/Tripstatus.json

##### 2. The second API provides the scheduled stop of the trains obtained by using Scheduled API.

* Mymnr API:
https://mnorthstg.prod.acquia-sites.com/wse/Mymnr/v5/api/train/{Train Number}/{Station Id}/{apiKey}/

##### Information obtained from both the APIs is modelled to the JSON format required by SmartQueue and inserted in to the database tables Resource, Location and Queue. 
