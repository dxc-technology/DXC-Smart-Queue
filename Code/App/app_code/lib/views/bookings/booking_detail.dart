import 'package:flutter/material.dart';
import 'package:mtahackathon/blocs/reservation_bloc.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/utils/general_utils.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/utils/time_utils.dart';
import 'package:mtahackathon/views/shared/cancel_confirm.dart';
import 'package:mtahackathon/views/shared/loader_dialog.dart';

class BookingDetail extends StatelessWidget {

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  BookingDetail({Key key, this.reservation}) : super(key: key);

  final Reservation reservation;


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
      body: SingleChildScrollView(
        child: Column(
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
                              '${reservation.trainId}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 26,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'at ${TimeUtils.getTimeStamp(reservation.queueOpenMillis)}',
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
                        Icon(Icons.location_on, color: Colors.red, size: 32,),
                        SizedBox(width: 8),
                        Text(
                          '${reservation.departureStation}',
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
                                '${reservation.trainOccupancyPercentage}%',
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
                                '${reservation.queueOccupancyPercentage}%',
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
                                '${TimeUtils.getTimeStamp(reservation.queueOpenMillis)}',
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
                                '${TimeUtils.getTimeStamp(reservation.queueCloseMillis)}',
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
                              ),
                              textAlign: TextAlign.center,),
                            SizedBox(height: 8,),
                            GeneralUtils.getPointsColoredWidget(reservation.pointsWorth, padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
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
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                          CancelReservationConfirm(reservation: reservation,)));
                },
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Cancel reservation',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8,),
                      Image.asset(
                        "assets/images/ticket.png",
                        width: 26.0,
                        height: 26.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24,),
            Container(
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () {
                  Dialogs.showLoadingDialog(context, _keyLoader, 'Please wait...');
                  reservationBloc.completeReservation(reservation).then((value) {
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                    Navigator.pop(context);

                  });
                },
                color: Styles.green,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Complete reservation',
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
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}