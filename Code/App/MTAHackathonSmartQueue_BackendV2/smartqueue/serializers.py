from . import models
from rest_framework import serializers

class CustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Customer
        fields = ('person_id', 'name', 'reward_points')

class QueueSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Queue
        fields = ('queue_id','start_datetime','end_datetime','max_capacity','address_id','address', 'destination','resource_id')

class LocationSerializer(serializers.ModelSerializer):
    queues = QueueSerializer(many=True)
    class Meta:
        model = models.Location
        fields = ('id','address','address_id','max_capacity','queues')

class ResourceSerializer(serializers.ModelSerializer):
    locations = LocationSerializer(many=True)
    class Meta:
        model = models.Resource
        fields = ('id','resource_id','train_from','train_to','max_occupancy','occupancy_sensor','updated_date','locations')