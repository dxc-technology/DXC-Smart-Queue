import 'package:flutter/material.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/views/bookings/booking_detail.dart';
import 'package:mtahackathon/views/home/Home.dart';
import 'package:mtahackathon/views/profile/points_detail.dart';
import 'package:mtahackathon/views/profile/profile.dart';

/// Class to handle the nested routing of the Profile view.
class ProfileRootView extends StatefulWidget {
  const ProfileRootView({Key key, this.fragment}) : super(key: key);

  final Fragment fragment;

  @override
  _ProfileRootViewState createState() => _ProfileRootViewState();
}

class _ProfileRootViewState extends State<ProfileRootView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return ProfileView(fragment: widget.fragment);
              case '/points_detail':
                return PointsDetailPage(fragment: widget.fragment);
              case '/reservation_detail':
                return BookingDetail(reservation: _getReservation(context),);
              default:
                return ProfileView(fragment: widget.fragment);
            }
          },
        );
      },
    );
  }

  Reservation _getReservation(context) {
    Map<String, Reservation> param = ModalRoute.of(context).settings.arguments as Map<String, Reservation>;
    return param['selected_reservation'];
  }
}
