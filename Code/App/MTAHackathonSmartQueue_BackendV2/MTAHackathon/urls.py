"""MTAHackathon URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include   
from rest_framework import routers
from smartqueue import views
from smartqueue.smartqueue import sq
import requests
import json

router = routers.DefaultRouter()
router.register(r'locations', views.LocationViewSet)
router.register(r'resources', views.ResourceViewSet)
router.register(r'queues', views.QueueViewSet)
router.register(r'customers', views.CustomerViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', views.home),
    path('home/', views.home),
    path('test/', views.test),
    path('api/', include(router.urls)),
    path('api/reservations', views.reservations),
    path('api/reserve', views.reserve),
    path('api/miss_reservation', views.miss_reservation),
    path('api/cancel_reservation', views.cancel_reservation),
    path('api/complete_reservation', views.complete_reservation),
    path('api/search', views.search),
    path('api/api-auth/', include('rest_framework.urls', namespace='rest_framework')),
]

#Gets initial smartqueue schedule
r = requests.get("https://smartqueueapi.azurewebsites.net/resource/")
print("urls")
r = json.loads(r.text)
sq.update(r)