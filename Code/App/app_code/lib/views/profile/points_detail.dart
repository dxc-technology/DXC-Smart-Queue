import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/blocs/reservation_bloc.dart';
import 'package:mtahackathon/blocs/reward_points_bloc.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/models/reward_point.dart';
import 'package:mtahackathon/utils/device_relevant_dimens.dart';
import 'package:mtahackathon/utils/stateful_wrapper.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/views/home/Home.dart';
import 'package:mtahackathon/views/partials/api_error.dart';
import 'package:mtahackathon/views/partials/loading.dart';
import 'package:mtahackathon/views/profile/reward_points_grid.dart';

class PointsDetailPage extends StatelessWidget {
  const PointsDetailPage({Key key, this.fragment, this.reservations}) : super(key: key);

  final Fragment fragment;
  final List<Reservation> reservations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
//          title: Text(
//            "Back",
//            style: TextStyle(color: Colors.black),
//          ),
          centerTitle: false,
          backgroundColor: Styles.lightBlue,
          elevation: 0.0,
        ),
        body: StatefulWrapper(
          child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: double.maxFinite,
                      color: Styles.lightBlue,
                      child: _getTotalPointsWidget(
                        context,
                        reservationBloc.getTotalRewardPoints()),
                    ),
                    Container(
                      height: DevicePercentageDimes.getHeight(context, 0.50),
                      width: double.maxFinite,
                      child: RewardPointsGrid(reservationsList: reservationBloc.getCompletedReservations()),
                    ),
                    _getRedeemButton(reservationBloc.getTotalRewardPoints()),
                  ],
                ),
        ));
  }

  int _getTotalRewardPoints(List<RewardPoint> rewardsList) {
    if (rewardsList != null && rewardsList.isNotEmpty) {
      int totalPoints = 0;
      rewardsList.forEach((element) => totalPoints += element.points);
      return totalPoints;
    } else
      return 0;
  }

  Widget _getTotalPointsWidget(BuildContext context, int points) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 50.0,
              ),
              Text(
                'POINTS',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/images/points.png",
                width: 46.0,
                height: 46.0,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '$points',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 46,
                    color: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

//  Widget _getRewardPointsDetailsGrid(context, snapshot) {
//    print('snapshot.hasData : ${snapshot.hasData}');
//    if (snapshot.hasData) {
//      switch (snapshot.data.status) {
//        case Status.LOADING:
//          return Loading(
//            loadingMessage: snapshot.data.message,
//          );
//          break;
//        case Status.COMPLETED:
//          return RewardPointsGrid(reservationsList: snapshot.data.data);
//          break;
//        case Status.ERROR:
//          return ApiError(
//            errorMessage: snapshot.data.message,
//            onRetryPressed: () => rewardPointsBloc.fetchRewardsList(),
//          );
//          break;
//      }
//    } else {
//      return Container();
//    }
//  }

  Widget _getRedeemButton(num rewardPoints) {
    if (rewardPoints > 0) {
      return Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 16.0, horizontal: 32.0),
        child: SizedBox(
          height: 50,
          width: double.maxFinite,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: Styles.lightYellow)),
            color: Styles.lightYellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Redeem points',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Image.asset(
                  "assets/images/points.png",
                  width: 46.0,
                  height: 46.0,
                ),
              ],
            ),
            onPressed: () {},
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void _handleOnInit() {
    Future.delayed(const Duration(milliseconds: 500), () {
      rewardPointsBloc.fetchRewardsList();
    });
  }

}
