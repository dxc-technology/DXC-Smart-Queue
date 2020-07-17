import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/utils/time_utils.dart';
import 'package:mtahackathon/views/shared/reservation_cancelled.dart';

class ProximityWarning extends StatelessWidget {

  ProximityWarning();

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
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    child: Image.asset(
                      'assets/images/proximity-bars.png',
                    ),
                    top: -12,
                    right: 0,
                    left: 0,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Image.asset(
                          "assets/images/warning.png",
                          width: 64.0,
                          height: 64.0,
                          color: Styles.lightYellow,
                        ),
                      ),
                      Text(
                        'PROXIMITY ALERT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Styles.lightYellow),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                        child: Text(
                          'You are standing too close to another person.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                        child: Text(
                          'Kindly maintain minimum 6ft distance, and keep your face covered.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Styles.lightYellow),
                        ),
                      ),
                      SizedBox(height: 16,)
                    ],
                  ),
                  Positioned(
                    child: Image.asset(
                      'assets/images/proximity-bars.png',
                    ),
                    bottom: -12,
                    right: 0,
                    left: 0,
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
