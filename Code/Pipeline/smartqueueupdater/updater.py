from apscheduler.schedulers.background import BackgroundScheduler
from smartqueueupdater import mtaapi


def start():
    scheduler = BackgroundScheduler()
    scheduler.add_job(mtaapi.update_schedule, 'interval', minutes=15)
    scheduler.start()
