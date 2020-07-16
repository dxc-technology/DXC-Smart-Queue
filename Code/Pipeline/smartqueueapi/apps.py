from django.apps import AppConfig


class SmartqueueapiConfig(AppConfig):
    name = 'smartqueueapi'

    def ready(self):
        from smartqueueupdater import updater
        updater.start()
