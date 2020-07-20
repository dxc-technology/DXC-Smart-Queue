import 'package:flutter/material.dart';
import 'package:mtahackathon/views/bookings/booking_detail.dart';
import 'package:mtahackathon/views/bookings/bookings.dart';
import 'package:mtahackathon/views/home/Home.dart';
import 'package:mtahackathon/views/trains/reservation_confirm_detail.dart';
import 'package:mtahackathon/views/trains/trains.dart';

/// Class to handle the nested routing of the Profile view.
class BookingsRootView extends StatefulWidget {
  const BookingsRootView({Key key, this.fragment}) : super(key: key);

  final Fragment fragment;

  @override
  _BookingsRootViewState createState() => _BookingsRootViewState();
}

class _BookingsRootViewState extends State<BookingsRootView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return BookingsView(fragment: widget.fragment);
              case '/booking_details':
                return BookingDetail();
              default:
                return BookingsView(fragment: widget.fragment);
            }
          },
        );
      },
    );
  }
}
