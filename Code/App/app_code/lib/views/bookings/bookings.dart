import 'package:flutter/material.dart';
import 'package:mtahackathon/api/api_response.dart';
import 'package:mtahackathon/blocs/reservation_bloc.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/views/bookings/booking_list.dart';
import 'package:mtahackathon/views/home/Home.dart';
import 'package:mtahackathon/views/partials/api_error.dart';
import 'package:mtahackathon/views/partials/drawer.dart';
import 'package:mtahackathon/views/partials/loading.dart';
import 'package:mtahackathon/views/profile/reservation_list.dart';


class BookingsView extends StatefulWidget {

  const BookingsView({ Key key, this.fragment }) : super(key: key);

  final Fragment fragment;

  @override
  _BookingsViewState createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {

  @override
  void initState() {
    super.initState();
    reservationBloc.fetchReservationsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
//        leading: IconButton(
//          icon: Icon(Icons.arrow_back_ios, ),
//          onPressed: () => Navigator.of(context).pop(),
//        ),
//          title: Text(
//            "Back",
//            style: TextStyle(color: Colors.black),
//          ),
        centerTitle: false,
        backgroundColor: Styles.cyan,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            color: Styles.cyan,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Bookings', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),),
            ),
          ),
          SizedBox(height: 24,),
          Expanded(
            child:
              _getReservationListView(),
          ),
        ],
      ),
    );
  }

  Widget _getReservationListView() {
    return StreamBuilder(
      stream: reservationBloc.reservationListStream,
      builder: (context, AsyncSnapshot<ApiResponse<List<Reservation>>> snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Loading(
                loadingMessage: snapshot.data.message,
              );
              break;
            case Status.COMPLETED:
              return BookingList(bookingList: reservationBloc.getActiveReservations());
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

  @override
  void dispose() {
    super.dispose();
  }
}

