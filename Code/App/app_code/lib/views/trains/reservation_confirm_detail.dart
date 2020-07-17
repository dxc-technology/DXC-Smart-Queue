import 'package:flutter/material.dart';
import 'package:mtahackathon/blocs/reservation_bloc.dart';
import 'package:mtahackathon/blocs/train_search_bloc.dart';
import 'package:mtahackathon/models/Queue.dart';
import 'package:mtahackathon/models/train_schedule.dart';
import 'package:mtahackathon/utils/constants.dart';
import 'package:mtahackathon/utils/general_utils.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/utils/time_utils.dart';
import 'package:mtahackathon/views/shared/loader_dialog.dart';

class ReserveQueue extends StatelessWidget {

  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  ReserveQueue({Key key, this.queue}) : super(key: key);

  final Queue queue;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, ),
          onPressed: () => Navigator.of(context).pop(),
        ),
//          title: Text(
//            "Back",
//            style: TextStyle(color: Colors.black),
//          ),
        centerTitle: false,
        backgroundColor: Styles.cyan,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.maxFinite,
            color: Styles.cyan,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color: Colors.transparent, size: 32,),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${queue.resourceID}',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 26,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'at ${TimeUtils.getTimeStamp(queue.endTime)}',
                            style: TextStyle(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24,),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color: Color(Styles.redColor), size: 32,),
                      SizedBox(width: 8),
                      Text(
                        '${queue.address}',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(height: 24,),
                  Row(
                    children: <Widget>[
                      Expanded(flex: 2,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Train occupancy',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8,),
                          Text(
                            '${queue.trainPercentage}%',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),),
                      Expanded(flex: 1,
                      child: Container(),),
                      Expanded(flex: 2,
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Queue occupancy',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8,),
                            Text(
                              '${queue.queuePercentage}%',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),),
                    ],
                  ),
                  SizedBox(height: 24,),
                  Row(
                    children: <Widget>[
                      Expanded(flex: 2,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14.0),
                              child: Text(
                                'Queue opens at',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              '${TimeUtils.getTimeStamp(queue.startTime)}',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),),
                      Expanded(flex: 1,
                        child: Container(),),
                      Expanded(flex: 2,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                'Queue closes at',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              '${TimeUtils.getTimeStamp(queue.endTime)}',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),),
                    ],
                  ),
                  SizedBox(height: 24,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text('Queue points',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,),
                          SizedBox(height: 8,),
                          GeneralUtils.getPointsColoredWidget(queue.rewardPoints, padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24,),
                ],
              ),
            ),
          ),
          SizedBox(height: 24,),
          Container(
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () {
                // Show a loader dialog.
                Dialogs.showLoadingDialog(context, _keyLoader, 'Please wait...');

                reservationBloc.makeReservation(queue).then((value) {
                  Navigator.pop(context);

                  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

                  final BottomNavigationBar navigationBar = Constants.globalKey.currentWidget;
                  navigationBar.onTap(2);

                  // Future.delayed(const Duration(milliseconds: 500), () {
                    reservationBloc.fetchReservationsList();
                  // });

                }).catchError((error) {
                  Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                });
              },
              color: GeneralUtils.getBgBasedOnPoints(queue.rewardPoints),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Book',
                      style: TextStyle(
                          color: GeneralUtils.getBgBasedOnPoints(queue.rewardPoints) == Colors.red ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 8,),
                    Image.asset(
                      "assets/images/ticket.png",
                      width: 26.0,
                      height: 26.0,
                      color: GeneralUtils.getBgBasedOnPoints(queue.rewardPoints) == Colors.red ? Colors.white : Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}