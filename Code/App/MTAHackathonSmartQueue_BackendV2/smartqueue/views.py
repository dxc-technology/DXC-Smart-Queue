from django.http import JsonResponse, HttpResponse

from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.status import (
    HTTP_400_BAD_REQUEST,
    HTTP_404_NOT_FOUND,
    HTTP_200_OK,
    HTTP_201_CREATED
)

from datetime import datetime
import json
import requests
import arrow # advanced date data types

from . import models
from . import serializers
from . import smartqueue

from .smartqueue import sq

class CustomerViewSet(viewsets.ModelViewSet):
    queryset = models.Customer.objects.all()
    serializer_class = serializers.CustomerSerializer

class LocationViewSet(viewsets.ModelViewSet):
    queryset = models.Location.objects.all()
    serializer_class = serializers.LocationSerializer

class QueueViewSet(viewsets.ModelViewSet):
    queryset = models.Queue.objects.all()
    serializer_class = serializers.QueueSerializer

class ResourceViewSet(viewsets.ModelViewSet):
    queryset = models.Resource.objects.all()
    serializer_class = serializers.ResourceSerializer
    
@api_view(['POST'])
def reservations(request):
    #Get posted data from JSON request
    person_id = request.data.get("person_id")
    
    #list the reservations
    reservations = sq.list_reservations(person_id)
    for reservation in reservations:
        reservation['reservation_state'] = str(reservation['reservation_state'])
        reservation['start_time'] = str(reservation['start_time'])
        reservation['end_time'] = str(reservation['end_time'])

    return JsonResponse(reservations, safe=False)

@api_view(['POST'])
def miss_reservation(request):
    #Get posted data from JSON request
    queue_id = request.data.get("queue_id")
    person_id = request.data.get("person_id")

    #execute missed
    result = sq.miss_reservation(queue_id, person_id)

    return Response({'Missed'})
    # return JsonResponse(result, safe=False)

@api_view(['POST'])
def cancel_reservation(request):
    #Get posted data from JSON request
    queue_id = request.data.get("queue_id")
    person_id = request.data.get("person_id")

    #execute cancellation
    result = sq.cancel_reservation(queue_id, person_id)

    return Response({'Cancelled'})
    # return JsonResponse(result, safe=False)

@api_view(['POST'])
def complete_reservation(request):
    #Get posted data from JSON request
    queue_id = request.data.get("queue_id")
    person_id = request.data.get("person_id")

    #execute completion
    result = sq.complete_reservation(queue_id, person_id)

    return Response({'Completed'})
    # return JsonResponse(result, safe=False)

@api_view(['POST'])
def reserve(request):
    #Get posted data from JSON request
    person_id = request.data.get("person_id")
    proof_of_purchase = request.data.get("proof_of_purchase")
    occupants = request.data.get("occupants")
    queue_id = request.data.get("queue_id")

    #execute reservation
    result = sq.reserve(person_id, proof_of_purchase, occupants, queue_id)
    
    #update reward points
    # if result['code'] == smartqueue.ReserveActionResult.SUCCESS:
    #     queryset = models.Customer.objects.filter(person_id=person_id)
    #     for n in queryset:
    #         n.reward_points += result['reward_points']
    #         queryset.update()

    # return Response({'Your reservation has been made'})
    return JsonResponse(result['reward_points'], safe=False)

@api_view(['POST'])
def search(request):
    #Get posted data from JSON request
    # resource_id = request.data.get("resource_id")
    # address_id = request.data.get("address_id")
    address = request.data.get("address")
    destination = request.data.get("destination")
    datetime = request.data.get("datetime")
    sort_bestqueue = request.data.get("sort_bestqueue")

    datetime = arrow.get(datetime)
    
    options = sq.list_queue_options(8837, address, destination, datetime, datetime.shift(minutes=+60))

    if sort_bestqueue:
        options = sorted(options, key = lambda k:(-k['reward'],k['start_time']))
    # else:
    #     options = sorted(options, key = lambda k:k['start_time'])
    for option in options:
        option['start_time'] = str(option['start_time'])
        option['end_time'] = str(option['end_time'])
    return JsonResponse(options, safe=False)

    # location1 = 51, POUGHKEEPSIE
    # location2 = 1, GRAND CENTRAL
    # date = 2020/07/15
    # time = 1354

    #Create url api for stations
    # url = "https://mnorthstg.prod.acquia-sites.com/wse/trains/v4/"+location1+"/"+location2+"/DepartBy/"+date+"/"+time+"/9de8f3b1-1701-4229-8ebc-346914043f4a/Tripstatus.json"
    # test = "https://mnorthstg.prod.acquia-sites.com/wse/trains/v4/51/1/DepartBy/2020/07/15/1354/9de8f3b1-1701-4229-8ebc-346914043f4a/Tripstatus.json"

    #Retrieve json from api
    # r = requests.get(url)
    # r = json.loads(r.text)

    #Retrieve details of interest in api
    # resource_list = []
    # for x in r["GetTripStatusJsonResult"]:
    #     origintime = x["OriginDateTime"]
    #     otime = origintime[:10]+" "+origintime[11:16]
    #     destinationtime = x["DestinationDateTime"]
    #     dtime = destinationtime[:10]+" "+destinationtime[11:16]
    #     resource_list.append((int(x["TrainName"]), , otime, dtime))
    #     resource_list.append((int(x["TrainName"]), x["Origin"]))

    # print(resource_list)
    # for queue in sq._SmartQueue__queues:
    #     print(queue.id)
    # for resource in sq._SmartQueue__resources:
    #     print(resource.id)    
    # for location in sq._SmartQueue__locations:
    #     print(location.address)
    
    # final_date = date+" "+time
    # sample = sq.list_queue_options(8840, "POUGHKEEPSIE", '2020-07-06 13:00', '2020-07-16 13:20')
    # working sample
    # sample = sq.list_queue_options(8815, "Grand Central", '2020-07-06 13:00', '2020-07-16 13:20')
    
    # print(arrow.get(final_date))
    # #Create list that will be processed by smartqueue
    # final_list = []
    # for n in resource_list:
    #     options = sq.list_queue_options(n[0], n[1], arrow.get(final_date), arrow.get(final_date).shift(minutes=+30))
    #     final_list.append(options)

    # return JsonResponse(sample, safe=False)

@api_view(['GET'])
def home(request):
    return Response({'Welcome to Smartqueue API'})

@api_view(['GET'])
def test(request):
    queuelist = []
    for queue in sq._SmartQueue__queues:
        queuelist.append(queue.id)
    return JsonResponse(queuelist, safe=False)


