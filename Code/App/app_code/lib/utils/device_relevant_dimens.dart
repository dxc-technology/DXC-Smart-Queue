import 'package:flutter/material.dart';

class DevicePercentageDimes {

 static getHeight(BuildContext context, double percentage) => MediaQuery.of(context).size.height * percentage;

 static getWidth(BuildContext context, double percentage) => MediaQuery.of(context).size.width * percentage;

}
