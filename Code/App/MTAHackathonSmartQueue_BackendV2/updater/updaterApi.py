import requests
import json
from smartqueue.smartqueue import sq

from datetime import datetime
from dateutil.parser import parse
import pytz

def filter_data(trains):
       sq_data = []
       now = datetime.now()
       timezone = pytz.timezone('US/Eastern')
       filtered_trains = [train for train in trains if parse(train['updated_date']).date() >= now.date()]
       for ft in filtered_trains:
               destination = ft['locations'][-1]
               queue = destination['queues'][0]
               end_datetime = parse(queue['end_datetime'])
               now_tz = timezone.localize(now)
               if (end_datetime >=now_tz):
                    sq_data.append(ft)
       return sq_data

#Retrieve the smartqueue schedule and convert to json
def _get_json():
    print("updaterapi")
    r = requests.get("https://smartqueueapi.azurewebsites.net/resource/")

    try:
        r.raise_for_status()
        return json.loads(r.text)
    except:
        return None

      
def update_smartqueue():
    json = _get_json()
    if json is not None:
        try:
            filter_data(json)
            sq.update(json)
        except:
            pass