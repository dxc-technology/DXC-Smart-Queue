import 'package:intl/intl.dart';

class TimeUtils {

  static String getTimeStamp(String date) {

    return DateFormat.jm().format(DateTime.parse(date));
  }

  static String getDateStamp(String date) {
    return DateFormat("MM/dd/yy").format(DateTime.parse(date));
  }
  
  

//  static String getTimeStamp(num millis) {
//    return DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(millis));
//  }
//
//  static String getDateStamp(num millis) {
//    return DateFormat("MM/dd/yy").format(DateTime.fromMillisecondsSinceEpoch(millis));
//  }
}