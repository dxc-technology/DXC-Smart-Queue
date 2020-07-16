from django.db import models


# Create your models here.

class Resource(models.Model):
    class Meta:
        db_table = 'resource'
        unique_together = ('resource_id', 'train_from', 'train_to', 'updated_date')

    id = models.UUIDField(max_length=32, primary_key=True)
    resource_id = models.IntegerField()
    train_from = models.CharField(max_length=30)
    train_to = models.CharField(max_length=30)
    max_occupancy = models.IntegerField()
    occupancy_sensor = models.CharField(max_length=20)
    updated_date = models.DateField()


class Location(models.Model):
    class Meta:
        db_table = 'location'

    id = models.UUIDField(max_length=32, primary_key=True)
    address = models.CharField(max_length=30)
    address_id = models.IntegerField()
    max_capacity = models.IntegerField()
    resource = models.ForeignKey(Resource, related_name='locations', on_delete=models.CASCADE)


class Queue(models.Model):
    class Meta:
        db_table = 'queue'

    queue_id = models.UUIDField(max_length=32, primary_key=True)
    start_datetime = models.DateTimeField()
    end_datetime = models.DateTimeField()
    max_capacity = models.IntegerField()
    address_id = models.IntegerField()
    address = models.CharField(max_length=30)
    destination = models.CharField(max_length=30)
    resource_id = models.IntegerField()
    location = models.ForeignKey(Location, related_name='queues', on_delete=models.CASCADE)
