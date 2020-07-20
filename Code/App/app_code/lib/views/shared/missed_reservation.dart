import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/utils/time_utils.dart';
import 'package:mtahackathon/views/shared/reservation_cancelled.dart';

class MissedReservation extends StatelessWidget {

  final Reservation reservation;

  MissedReservation({this.reservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.75),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.red,
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Image.asset(
                      "assets/images/proximity.png",
                      width: 64.0,
                      height: 64.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 32.0),
                    child: Text(
                      'You failed to show up for your ${TimeUtils.getTimeStamp(reservation.queueCloseMillis)} reservation at ${reservation.departureStation}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: Text(
                      'Kindly reach on time for you reservations for getting the point in your account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Styles.lightYellow),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text('Back', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
            ),
            Divider(thickness: 2, color: Styles.greenHeader, height: 0,),
          ],
        ),
      ),
    );
  }
}
