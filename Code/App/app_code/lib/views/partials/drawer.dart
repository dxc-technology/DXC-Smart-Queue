import 'package:flutter/material.dart';
import 'package:mtahackathon/blocs/reservation_bloc.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/views/shared/missed_reservation.dart';
import 'package:mtahackathon/views/shared/proximity_warning.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeaderItem(),

          Proximity(),
          MissedReservationItem(),
          AboutItem(),
          RateAppItem(),
          SizedBox(height: 50,),
        ],
      ),
    );
  }
}

/// menu header
class DrawerHeaderItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
            image: AssetImage('assets/images/menu-bg.png'),
            fit: BoxFit.contain
        ),
      ),
    );
  }
}

class Proximity extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Simulate proximity warning", style: Styles.appDrawerTextStyle),
      leading: Icon(Icons.warning, color: Styles.appDrawerIconColor),
      onTap: () {
        Navigator.pop(context);

        Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) =>
                ProximityWarning()));
      },
    );
  }

}

class MissedReservationItem extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Simulate missed reservation", style: Styles.appDrawerTextStyle),
      leading: Icon(Icons.transfer_within_a_station, color: Styles.appDrawerIconColor),
      onTap: () {
        Navigator.pop(context);

        if (reservationBloc.reservations.length > 0) {
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) =>
                  MissedReservation(reservation: reservationBloc.reservations[0],)));
        }

      },
    );
  }

}

/// about item
class AboutItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("About", style: Styles.appDrawerTextStyle),
      leading: Icon(Icons.info_outline, color: Styles.appDrawerIconColor),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}


/// rate app item
class RateAppItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Rate Us", style: Styles.appDrawerTextStyle),
      leading: Icon(Icons.star, color: Styles.appDrawerIconColor),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

