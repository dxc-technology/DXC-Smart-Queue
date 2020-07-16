import requests
from dateutil.parser import parse
from datetime import datetime
from datetime import timedelta
import uuid
from smartqueueapi.models import Resource, Location, Queue


def _get_departby_json(from_station, to_station, year, month, date, hour, min):
    url = 'https://mnorthstg.prod.acquia-sites.com/wse/trains/v4/{0}/{1}/DepartBy/{2}/{3}/{4}/{5}{6}/{7}/Tripstatus.json'
    access_token = '9de8f3b1-1701-4229-8ebc-346914043f4a'

    req = requests.get(url.format(from_station, to_station, year, month, date, hour, min, access_token))

    try:
        req.raise_for_status()
        return req.json()
    except Exception as e:
        return None


def _get_trainby_station_json(train_id, from_station):
    url = 'https://mnorthstg.prod.acquia-sites.com/wse/Mymnr/v5/api/train/{0}/{1}/{2}/'
    access_token = '9de8f3b1-1701-4229-8ebc-346914043f4a'

    req = requests.get(url.format(train_id, from_station, access_token))

    try:
        req.raise_for_status()
        return req.json()
    except Exception as e:
        return None


def update_schedule():
    print("API started")
    now = datetime.now()
    station_list = [[1, 51], [51, 1], [1, 177], [177, 1], [1, 149], [149, 1], [1, 33], [33, 1], [1, 94], [94, 1],
                    [1, 76], [76, 1], [1, 124], [124, 1], [149, 124], [124, 149]]
    for station in station_list:
        resource_json = _get_departby_json(station[0], station[1], now.year, now.month, now.day,
                                           "{0:02d}".format(now.hour), "{0:02d}".format(now.minute))
        if resource_json is not None:
            trains = resource_json['GetTripStatusJsonResult']
            for train in trains:
                train_id = train['TrainName']
                train_from = train['Origin']
                origin_id = train['OriginID']
                train_to = train['Destination']
                train_stop_json = _get_trainby_station_json(train_id, origin_id)
                if train_stop_json is None:
                    break
                else:
                    stops = train_stop_json['trainStops']
                    if stops:
                        try:
                            resource, created = Resource.objects.get_or_create(resource_id=train_id,
                                                                               updated_date=now.date(),
                                                                               train_from=train_from, train_to=train_to,
                                                                               defaults={'id': uuid.uuid4(),
                                                                                         'max_occupancy': 100,
                                                                                         'occupancy_sensor': "dummy_sensor"})
                            if created:
                                for stop in stops:
                                    location = Location(id=uuid.uuid4(), address=stop['LocationName'],
                                                    address_id=stop['LocationId'], max_capacity=100,
                                                    resource_id=resource.id)
                                    location.save()
                                    queue_starttime = parse(stop['ScheduleTime']) - timedelta(minutes=10)
                                    queue_endtime = stop['ScheduleTime']
                                    queue = Queue(queue_id=uuid.uuid4(), start_datetime=queue_starttime,
                                              end_datetime=queue_endtime, max_capacity=100,
                                              address_id=stop['LocationId'],
                                              address=stop['LocationName'],destination=train_to, resource_id=train_id,
                                              location_id=location.id)
                                    queue.save()
                                    print("saved entry")
                        except Exception as e:
                            raise e
    print("API stopped")
