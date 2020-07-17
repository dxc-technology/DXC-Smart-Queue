from django.apps import AppConfig

class SmartqueueConfig(AppConfig):
    name = 'smartqueue'

    #Sets the updater for the smartqueue schedule every 30 mins
    def ready(self):
        print("apps")
        from updater import updater
        updater.start()