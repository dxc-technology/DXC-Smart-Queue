import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mtahackathon/models/Queue.dart';
import 'package:mtahackathon/models/train_schedule.dart';
import 'package:mtahackathon/utils/general_utils.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/utils/time_utils.dart';

class TrainScheduleList extends StatelessWidget {
  final List<Queue> scheduleList;
  final Queue bestQueue;

  const TrainScheduleList({Key key, this.scheduleList, this.bestQueue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return scheduleList.isNotEmpty
        ? Scrollbar(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                child: Text(
                'Available options',
                style: TextStyle(
                    color: Styles.greenHeader,
                    fontSize: 22,
                    fontWeight: FontWeight.w500
                ),
            ),
              ),
                _getHeaderRow(),
                Divider(thickness: 3, color: Styles.greenHeader,),
                Expanded(
                  child: ListView.separated(
                    physics: new AlwaysScrollableScrollPhysics(),
                    // new
                    shrinkWrap: true,
                    itemCount: scheduleList.length,
                    padding: EdgeInsets.all(8.0),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                        child: _getListItem(context, scheduleList[index]),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      thickness: 1, color: Styles.greenHeader, height: 4,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              ' No reservations were found ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          );
  }

  Widget _getHeaderRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Train name',
              style: _getHeaderLabelStyle(),
            ),
          ),
          flex: 2,
        ),
        Expanded(
          child: Text(
            'Train Time',
            style: _getHeaderLabelStyle(),
          ),
          flex: 1,
        ),
        Expanded(
          child: Text(
            'Train Occu.',
            style: _getHeaderLabelStyle(),
          ),
          flex: 1,
        ),
        Expanded(
          child: Text(
            'Queue Occu.',
            style: _getHeaderLabelStyle(),
          ),
          flex: 1,
        ),
        Expanded(
          child: Text(
            'Route Points',
            style: _getHeaderLabelStyle(),
          ),
          flex: 1,
        ),
      ],
    );
  }

  Widget _getListItem(BuildContext context, Queue res) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12.0),
              child: Text(
                '${res.resourceID}',
                style: _getListItemLabelStyle(),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Text(
              '${TimeUtils.getTimeStamp(res.startTime)}',
              style: _getListItemLabelStyle(),
            ),
            flex: 1,
          ),
          Expanded(
            child: Text(
              '${res.trainPercentage}%',
              style: _getListItemLabelStyle(),
              textAlign: TextAlign.center,
            ),
            flex: 1,
          ),
          Expanded(
            child: Text(
              '${res.queuePercentage}%',
              style: _getListItemLabelStyle(),
              textAlign: TextAlign.center,
            ),
            flex: 1,
          ),
          Expanded(
            child: GeneralUtils.getPointsColoredWidget(res.rewardPoints),
            flex: 1,
          ),
        ],
      ),
      splashColor: Styles.appAccentColor,
      onTap: () {
        Navigator.pushNamed(context, '/schedule_details', arguments: {'selectedSchedule': res, 'bestSchedule': bestQueue});
      },
    );
  }

  TextStyle _getHeaderLabelStyle() {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);
  }

  TextStyle _getListItemLabelStyle() {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black);
  }
}
