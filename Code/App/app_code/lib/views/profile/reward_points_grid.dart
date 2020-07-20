import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mtahackathon/models/Reservation.dart';
import 'package:mtahackathon/models/reward_point.dart';
import 'package:mtahackathon/utils/styles.dart';
import 'package:mtahackathon/utils/time_utils.dart';

class RewardPointsGrid extends StatelessWidget {
  final List<Reservation> reservationsList;

  const RewardPointsGrid({Key key, this.reservationsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return reservationsList.isNotEmpty
        ? Scrollbar(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: StaggeredGridView.countBuilder(
                itemCount: reservationsList.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      color: Styles.greyBackGround,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _getGridItem(reservationsList[index]),
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.fit(1),
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              ' No reward points were earned yet. ',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          );
  }

  Widget _getGridItem(Reservation res) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '${res.pointsWorth}',
              style: TextStyle(
                  color: Styles.lightYellow,
                  fontSize: 32,
                  fontWeight: FontWeight.w500),
            ),
            Text('POINTS', style: TextStyle(
              fontSize: 20,
            ),),
            Text('on', style: TextStyle(
              fontSize: 16,
            ),),
            Text('${TimeUtils.getDateStamp(res.queueCloseMillis)}', style: TextStyle(
              fontSize: 18,
            ),)
          ],
        ),
      ),
    );
  }
}
