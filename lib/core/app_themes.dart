import 'package:flutter/material.dart';

enum AppTheme {
  GreenLight,
  GreenDark,
  BlueLight,
  BlueDark,
}

final appThemeData = {
  AppTheme.GreenLight: ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: Colors.green),
    brightness: Brightness.light,
    primaryColor: Colors.green,
    textTheme: TextTheme().copyWith(bodyText1: TextStyle(color: Colors.black)),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.green),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green,
    ),
  ),
  AppTheme.GreenDark: ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: Colors.green.shade700),
    brightness: Brightness.dark,
    textTheme: TextTheme().copyWith(bodyText1: TextStyle(color: Colors.white)),
    primaryColor: Colors.green.shade700,
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: Colors.green.shade700),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.green.shade700,
    ),
  ),
  AppTheme.BlueLight: ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
    brightness: Brightness.light,
    textTheme: TextTheme().copyWith(bodyText1: TextStyle(color: Colors.black)),
    primaryColor: Colors.blue,
    progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.blue),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
  ),
  AppTheme.BlueDark: ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: Colors.blue.shade700),
    brightness: Brightness.dark,
    textTheme: TextTheme().copyWith(bodyText1: TextStyle(color: Colors.white)),
    progressIndicatorTheme:
        ProgressIndicatorThemeData(color: Colors.blue.shade700),
    primaryColor: Colors.blue.shade700,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.blue.shade700,
    ),
  ),
};
