from django.contrib import admin
from .models import Resource
from .models import Location
from .models import Queue

# Register your models here.
admin.site.register(Resource)
admin.site.register(Location)
admin.site.register(Queue)

