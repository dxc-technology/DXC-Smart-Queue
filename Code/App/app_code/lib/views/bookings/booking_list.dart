import 'package:recase/recase.dart';

import 'package:flutter/material.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/utils/general_utils.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/utils/time_utils.dart';
import 'package:mtahackathon/views/bookings/booking_detail.dart';
import 'package:mtahackathon/views/trains/reservation_confirm_detail.dart';

class BookingList extends StatelessWidget {
  final List<Reservation> bookingList;

  const BookingList({Key key, this.bookingList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return bookingList.isNotEmpty
        ? Column(
      mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _getBookingsHeader(),
            Divider(
              thickness: 3,
              color: Styles.greenHeader,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: bookingList.length,
                padding: EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                    child: _getListItem(context, bookingList[index]),
                  );
                },
              ),
            ),
          ],
        )
        : Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              ' No Bookings were found ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          );
  }

  Widget _getBookingsHeader() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8),
            child: Text(
              'Train information',
              style: _getHeaderLabelStyle(),
            ),
          ),
          flex: 2,
        ),
        Expanded(
          child: Text(
            'Queue opens at',
            style: _getHeaderLabelStyle(),
          ),
          flex: 1,
        ),
        Expanded(
          child: Text(
            'Queue closes at',
            style: _getHeaderLabelStyle(),
          ),
          flex: 1,
        ),
        Expanded(
          child: Text(
            'Queue Occu.',
            style: _getHeaderLabelStyle(),
          ),
          flex: 1,
        ),
        Expanded(
          child: Text(
            'Route Points',
            style: _getHeaderLabelStyle(),
          ),
          flex: 1,
        ),
      ],
    );
  }

  TextStyle _getHeaderLabelStyle() {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);
  }

  TextStyle _getListItemLabelStyle() {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black);
  }

  Widget _getListItem(BuildContext context, Reservation res) {
    return InkWell(
      splashColor: Colors.grey,
      onTap: (){
        _showBookingDetailPage(context, res);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.maxFinite,
            color: Styles.cyan,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                '${res.departureStation} > ${res.arrivalStation}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.transparent,
                      size: 32,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                            child: Text(
                              '${res.trainId}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${TimeUtils.getDateStamp(res.queueOpenMillis)}',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            'at ${TimeUtils.getTimeStamp(res.queueOpenMillis)}',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${res.departureStation}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                flex: 2,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${TimeUtils.getDateStamp(res.queueOpenMillis)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${TimeUtils.getTimeStamp(res.queueOpenMillis)}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '${TimeUtils.getDateStamp(res.queueCloseMillis)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${TimeUtils.getTimeStamp(res.queueCloseMillis)}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(
                    '${res.queueOccupancyPercentage}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: GeneralUtils.getPointsColoredWidget(res.pointsWorth),
                flex: 1,
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showBookingDetailPage(BuildContext context, res) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => BookingDetail(reservation: res)),);
  }

}
