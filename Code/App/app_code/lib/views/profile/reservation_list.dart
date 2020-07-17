import 'package:flutter/material.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/utils/general_utils.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/utils/time_utils.dart';
import 'package:mtahackathon/views/bookings/booking_detail.dart';

class ReservationList extends StatelessWidget {
  final List<Reservation> reservationList;

  const ReservationList({Key key, this.reservationList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reservationList.isNotEmpty
        ? Scrollbar(
            child: ListView.builder(
              physics: new NeverScrollableScrollPhysics(),
              // new
              shrinkWrap: true,
              itemCount: reservationList.length,
              padding: EdgeInsets.all(8.0),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                  child: _getListItem(context, reservationList[index]),
                );
              },
            ),
          )
        : Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                ' No reservations were found ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            ),
          );
  }

  Widget _getListItem(BuildContext context, Reservation res) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.maxFinite,
            color: Styles.cyan,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                '${res.arrivalStation ?? res.location}  >  ${res.departureStation}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context, rootNavigator: false).pushNamed("/reservation_detail", arguments: {'selected_reservation': res}),
            splashColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Text(
                      '${res.trainId}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Text(
                      '${TimeUtils.getTimeStamp(res.queueOpenMillis)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Text(
                      '${res.arrivalStation ?? res.location}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Text(
                      '${res.queueOccupancyPercentage}%',
                      style: TextStyle(
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
            ),
          )
        ],
      );
  }

}
