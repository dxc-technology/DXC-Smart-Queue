import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtahackathon/blocs/train_search_bloc.dart';
import 'package:mtahackathon/models/Queue.dart';
import 'package:mtahackathon/models/train_schedule.dart';
import 'package:mtahackathon/utils/general_utils.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/utils/time_utils.dart';
import 'package:mtahackathon/views/trains/reservation_confirm_detail.dart';

class TrainScheduleDetails extends StatelessWidget {
  const TrainScheduleDetails({Key key, this.queue, this.bestQueue}) : super(key: key);

  final Queue queue;
  final Queue bestQueue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${queue.resourceID}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'at ${TimeUtils.getTimeStamp(queue.startTime)}, ${queue.address}',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Train occupancy',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${queue.trainPercentage}%',
                        style: TextStyle(
                            color: Styles.greenHeader,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Styles.greenHeader,
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          'Queue occupancy',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${queue.queuePercentage}%',
                        style: TextStyle(
                            color: Styles.greenHeader,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          'Queue opens at',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${TimeUtils.getTimeStamp(queue.startTime)}',
                        style:
                            TextStyle(color: Styles.greenHeader, fontSize: 14),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          'Queue closes at',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${TimeUtils.getTimeStamp(queue.endTime)}',
                        style:
                            TextStyle(color: Styles.greenHeader, fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Queue points',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GeneralUtils.getPointsColoredWidget(queue.rewardPoints),
                    ],
                  ),
                )
              ],
            ),
            Divider(
              thickness: 1,
              color: Styles.greenHeader,
              height: 24,
            ),
            Container(
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () => _showTicketBookPage(context),
                color: GeneralUtils.getBgBasedOnPoints(queue.rewardPoints),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Book',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8,),
                      Image.asset(
                        "assets/images/ticket.png",
                        width: 26.0,
                        height: 26.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            _getFindBestQueueIfApplicable(context, queue.rewardPoints),
          ],
        ),
      ),
    );
  }

  void _showTicketBookPage(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ReserveQueue(queue: queue)),);
  }

  Widget _getFindBestQueueIfApplicable(BuildContext context, num points) {
    if (_isThisBestQueue()) {
      return Container();
    } else {
      return Container(
        alignment: Alignment.center,
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/schedule_details', arguments: {'selectedSchedule': bestQueue, 'bestSchedule': bestQueue});
          },
          color: Styles.green,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Find best queue',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(width: 8,),
                Icon(Icons.search, color: Colors.black, size: 24,),
              ],
            ),
          ),
        ),
      );
    }
  }

  bool _isThisBestQueue() {
    return (queue.queueId == bestQueue.queueId);
  }

}
