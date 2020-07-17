import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtahackathon/blocs/reservation_bloc.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/views/shared/missed_reservation.dart';
import 'package:mtahackathon/views/shared/proximity_warning.dart';
import 'package:mtahackathon/views/shared/reservation_cancelled.dart';
import 'package:mtahackathon/views/shared/loader_dialog.dart';

class CancelReservationConfirm extends StatelessWidget {

  final Reservation reservation;
  final Function cancelCallBack;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  CancelReservationConfirm({this.cancelCallBack, this.reservation});

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
              color: Styles.appPrimaryColor,
              alignment: Alignment.center,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Text(
                  'Are you sure you want to cancel this reservation?',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 60,
                        child: RaisedButton(
                          child: Text('No',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )),
                    SizedBox(width: 32,),
                    SizedBox(
                        height: 60,
                        child: RaisedButton(
                          color: Styles.appPrimaryColor,
                          child: Text('Yes', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),),
                          onPressed: () {
                            Dialogs.showLoadingDialog(context, _keyLoader, 'Please wait...');
                            _showReservationCancelledDialog(context);
                          },
                        )),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text('Note: \n cancelling the reservation will result in losing ${reservation?.pointsWorth ?? 100 } points'
                  ,textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),),
              ),
            ),
            Divider(thickness: 2, color: Styles.greenHeader, height: 0,),
          ],
        ),
      ),
    );
  }

  void _showReservationCancelledDialog(BuildContext context) async {
    reservationBloc.cancelReservation(reservation).then((value) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.pop(context);

      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) =>
              ReservationCancelled()));
    });
  }
}
