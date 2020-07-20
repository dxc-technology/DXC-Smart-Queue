import 'dart:ui';
import 'package:flutter/material.dart';

// primaryColor = #9b51e0 rgb(155,81,224)

class Styles {


  static Color appPrimaryColor = Color.fromRGBO(51, 101, 181, 1);
  static Color appAccentColor = Colors.yellow[800];
  static Color brown = Color.fromRGBO(255, 170, 0, 1);
  static Color lightYellow = Color.fromRGBO(255, 255, 0, 1);
  static Color green = Color.fromRGBO(93, 255, 0, 1);
  static Color greenHeader = Color.fromRGBO(49, 117, 156, 1);
  static Color cyan = Color.fromRGBO(119, 142, 179, 1);


  static Color lightBlue = Color.fromRGBO(234, 241, 254, 1);
  static Color greyBackGround = Color.fromRGBO(123, 142, 176, 1);



  static Color appCanvasColor = Colors.white;
  static Color appBackground = Colors.blue;
  static Color commonDarkBackground = Colors.grey[200];
  static Color commonDarkCardBackground = Colors.grey[200];

  static TextTheme appTextTheme = TextTheme(

    bodyText1: TextStyle(
      color: Colors.black54,
    ),
    bodyText2: TextStyle(
      color: Colors.grey[100],
    ),
  );

  static Color appDrawerIconColor = Colors.grey[800];
  static TextStyle appDrawerTextStyle = TextStyle(color: Colors.grey[900]);

  static TextStyle defaultStyle = TextStyle(
    color: Colors.grey[800],
  );

  static TextStyle h1 = defaultStyle.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    height: 22 / 18,
    color: Colors.grey[700],
  );

  static TextStyle h1_app_name = defaultStyle.copyWith(
    fontSize: 30.0,
    height: 35,
    fontFamily: 'Prata',
  );

  static TextStyle title = defaultStyle.copyWith(
    fontSize: 30.0,
    height: 35,
    fontFamily: 'Prata',
  );

  static TextStyle display1 = defaultStyle.copyWith(
    fontSize: 30.0,
    fontFamily: 'Radicals',
  );

  static TextStyle h1_white = defaultStyle.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    height: 22 / 18,
    color: Colors.white,
  );

  static TextStyle p = defaultStyle.copyWith(
    fontSize: 16.0,
    color: Colors.grey[800],
  );

  static TextStyle p_theme = p.copyWith(
    color: appPrimaryColor,
  );

  static TextStyle p_white = p.copyWith(
    color: Colors.white,
  );

  static TextStyle p_muted = p.copyWith(
    color: Colors.grey[500],
  );

  static TextStyle p_forgot_password = p.copyWith(
    color: Colors.blue,
  );

  static TextStyle p_button = defaultStyle.copyWith(
    fontSize: 15.0,
  );

  static TextStyle error = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.red,
  );

  static InputDecoration input = InputDecoration(
    fillColor: Colors.white,
    focusColor: Colors.grey[900],
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      gapPadding: 1.0,
      borderSide: BorderSide(
        color: Colors.grey[600],
        width: 1.0,
      ),
    ),
    hintStyle: TextStyle(
      color: Colors.grey[600],
    ),
  );

  static int redColor = 0xffff2d55;
  static Color tipColor = Color.fromRGBO(255, 226, 108, 1);
  static Color matchWonCardSideColor = Color.fromRGBO(22, 160, 133, 1);
  static Color matchLostCardSideColor = Color.fromRGBO(211, 84, 0, 1);
  static Color vipCardBgColor = Colors.orange[100];

  // forums
  static Color forumBgColor = Color.fromRGBO(37, 35, 49, 1);

  static Color leftMessageBgColor = Color.fromRGBO(52, 49, 69, 1);
  static Color leftMessageAkaColor = Color.fromRGBO(107, 108, 127, 1);
  static Color leftMessageMessageColor = Colors.white;

  static Color rightMessageBgColor = Color.fromRGBO(37, 105, 253, 1);
  static Color rightMessageAkaColor = Color.fromRGBO(139, 172, 244, 1);
  static Color rightMessageMessageColor = Colors.white;
}
