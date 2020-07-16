from rest_framework import serializers
from .models import Resource
from .models import Location
from .models import Queue


class QueueSerializer(serializers.ModelSerializer):
    class Meta:
        model = Queue
        fields = ('queue_id', 'start_datetime', 'end_datetime', 'max_capacity', 'address_id', 'address', 'destination','resource_id')


class LocationSerializer(serializers.ModelSerializer):
    queues = QueueSerializer(many=True)

    class Meta:
        model = Location
        fields = ('id', 'address', 'address_id', 'max_capacity', 'queues')


class ResourceSerializer(serializers.ModelSerializer):
    locations = LocationSerializer(many=True)

    class Meta:
        model = Resource
        fields = ('id', 'resource_id', 'train_from', 'train_to', 'max_occupancy', 'occupancy_sensor','updated_date','locations')
