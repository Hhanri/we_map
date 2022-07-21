import 'package:flutter/material.dart';

class DisplayConstants {
  static const EdgeInsets scaffoldPadding = EdgeInsets.symmetric(horizontal: 15, vertical: 2);
  static const BorderRadius circularBorderRadius = BorderRadius.all(Radius.circular(16));
}

class AppTheme {

  //colors
  static const Color primaryColor = Color(0xFF306BAC);
  static const Color primary2Color = Color(0xFF6F9CEB);
  static const Color secondaryColor = Color(0xFFDADADA);
  static const Color placeholderColor = Color(0xFF747474);
  static const Color textColor = Color(0xFF4F4747);
  static const Color backgroundColor = Colors.white;

  static const Gradient linearGradient = LinearGradient(
    colors: [primaryColor, primary2Color],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter
  );

  //text style
  static const TextStyle elevatedButtonTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: backgroundColor,
  );

  static const TextStyle textButtonTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: backgroundColor,
  );

  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: textColor
  );

  static const TextStyle placeholderTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: placeholderColor
  );

  static const TextTheme textTheme = TextTheme(
    headline4: headerTextStyle,
    headline5: elevatedButtonTextStyle,
    bodyText1: bodyTextStyle,
    bodyText2: placeholderTextStyle,
    button: textButtonTextStyle,
  );

  //appbar
  static const AppBarTheme appBarTheme = AppBarTheme(
    centerTitle: true,
    titleTextStyle: elevatedButtonTextStyle,
  );

  //scaffold

  static final ThemeData theme = ThemeData(
    appBarTheme: appBarTheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: backgroundColor,
  );
}