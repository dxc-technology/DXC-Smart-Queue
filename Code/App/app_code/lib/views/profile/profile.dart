import 'package:flutter/material.dart';
import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/blocs/reservation_bloc.dart';
import 'package:mtahackathon/utils/device_relevant_dimens.dart';

import 'package:mtahackathon/views/home/Home.dart';
import 'package:mtahackathon/views/partials/api_error.dart';
import 'package:mtahackathon/views/partials/drawer.dart';
import 'package:mtahackathon/views/partials/loading.dart';
import 'package:mtahackathon/views/profile/reservation_list.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../utils/styles.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key key, this.fragment}) : super(key: key);

  final Fragment fragment;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  @override
  void initState() {
    super.initState();
    _handleOnInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          _getProgressSectionWidget(),
          _getReservationsWidget(),
        ],
      ),
    );
  }

  Widget _getProgressSectionWidget() {
    return  Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(vertical: 8),),
          _getProgressIndicator(0.7),
          _getPointsRowWidget(),
          SizedBox(height: 16,),
        ],
      ),
    );
  }

  Widget _getProgressIndicator(double progress) {
    return CircularPercentIndicator(
      radius: DevicePercentageDimes.getWidth(context, 0.30),
      lineWidth: 16.0,
      percent: progress,
      center: Icon(
        Icons.person_pin,
        size: 70.0,
        color: Theme.of(context).accentColor,
      ),
      footer: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Jane Doe',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 26, // light
            ),
          ),
          Text(
            '# 365692',
            style: TextStyle(
              fontSize: 20, // light
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      progressColor: Theme.of(context).accentColor,
    );
  }

  Widget _getPointsRowWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          child: _getPointsWidget(
            path: "assets/images/points.png",
            count: reservationBloc.getTotalRewardPoints(),
            label: 'POINTS',
          ),
          onTap: () => Navigator.of(context, rootNavigator: false).pushNamed("/points_detail"),
        ),
        _getPointsWidget(
          path: "assets/images/level.png",
          count: 04,
          label: 'LEVEL',
        ),
      ],
    );
  }

  Widget _getPointsWidget({String path, int count, String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(path, width: 42.0, height: 42.0,),
        Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 26,
          ),
        ),
        Text(
          '$label',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
      ],
    );
  }


  Widget _getReservationsWidget() {
    return Expanded(
      child: Scrollbar(
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  'Upcoming Reservations',
                  style: TextStyle(
                    color: Styles.greenHeader,
                    fontSize: 28,
                    fontWeight: FontWeight.w800
                  ),
                ),
              ),
            ),
            _getReservationListView(),
          ],
        ),
      ),
    );
  }

  Widget _getReservationListView() {
    return StreamBuilder(
      stream: reservationBloc.reservationListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Loading(
                loadingMessage: snapshot.data.message,
              );
              break;
            case Status.COMPLETED:
              return ReservationList(reservationList: reservationBloc.getActiveReservations());
              break;
            case Status.ERROR:
              return ApiError(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => reservationBloc.fetchReservationsList(),
              );
              break;
          }
        }
        return Container();
      },
    );
  }

  void _handleOnInit() {
      Future.delayed(const Duration(milliseconds: 500), () {
        reservationBloc.fetchReservationsList();
      });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
