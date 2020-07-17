import 'package:flutter/material.dart';
import 'package:mtahackathon/views/home/Home.dart';
import 'package:mtahackathon/views/trains/reservation_confirm_detail.dart';
import 'package:mtahackathon/views/trains/trains.dart';

/// Class to handle the nested routing of the Profile view.
class TrainsRootView extends StatefulWidget {
  const TrainsRootView({Key key, this.fragment}) : super(key: key);

  final Fragment fragment;

  @override
  _TrainsRootViewState createState() => _TrainsRootViewState();
}

class _TrainsRootViewState extends State<TrainsRootView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch (settings.name) {
              case '/':
                return TrainsView(fragment: widget.fragment);
              case '/trains':
                return TrainsView(fragment: widget.fragment);
              case 'booking_detail':
                return ReserveQueue();
              default:
                return TrainsView(fragment: widget.fragment);
            }
          },
        );
      },
    );
  }
}
