import 'package:flutter/material.dart';
import 'package:mtahackathon/utils/styles.dart';

class GeneralUtils {

  static final rewardScale = 500;

  static num convertRewardPoints(double points) {
    return (points * rewardScale).ceil();
  }


  static Widget getPointsColoredWidget(int points, {EdgeInsets padding}) {
    return Container(
      color: getBgBasedOnPoints(points),
      child: Padding(
        padding: padding ?? EdgeInsets.all(8.0),
        child: Text(
          '$points',
          style: TextStyle(
              fontSize: 18, color: getTextColorBasedOnPoints(points), fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static Color getTextColorBasedOnPoints(int points) {
    if (points >= 100 && points < 250) {
      return Colors.black;
    } else if (points >= 200) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  static Color getBgBasedOnPoints(int points) {
    if (points >= 100 && points < 250) {
      return Styles.lightYellow;
    } else if (points >= 200) {
      return Styles.green;
    } else {
      return Colors.red;
    }
  }

}