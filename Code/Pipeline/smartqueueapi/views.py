from rest_framework import viewsets, status
from rest_framework.response import Response
from datetime import datetime
from .serializers import ResourceSerializer
from .models import Resource


# Create your views here.
class ResourceViewSet(viewsets.ModelViewSet):
    current_date = datetime.now().date()
    queryset = Resource.objects.filter(updated_date__gte=current_date)
    serializer_class = ResourceSerializer

    def create(self, request):
        # insert a resource via post request
        datas = request.data
        locs = datas.pop('locations')
        now = datetime.now()
        resource, created = Resource.objects.get_or_create(resource_id=datas['resource_id'], updated_date=now.date(),
                                                           defaults={'id': datas['id'],
                                                                     'train_from': datas['train_from'],
                                                                     'train_to': datas['train_to'],
                                                                     'max_occupancy': 100,
                                                                     'occupancy_sensor': "dummy_sensor"})
        if created:
            for loc in locs:
                ques = loc.pop('queues')
                location = resource.locations.create(**loc)
                for que in ques:
                    location.queues.create(**que)
            return Response(status=status.HTTP_201_CREATED)
        else:
            return Response(status=status.HTTP_400_BAD_REQUEST)

