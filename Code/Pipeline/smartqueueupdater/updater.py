from apscheduler.schedulers.background import BackgroundScheduler
from smartqueueupdater import mtaapi


def start():
    scheduler = BackgroundScheduler()
    scheduler.add_job(mtaapi.update_schedule, 'interval', minutes=15)
    scheduler.add_job(mtaapi.clean_old_trains, 'cron', day_of_week='mon-sun', hour=4, minute=00)
    scheduler.start()
