import 'package:flutter/material.dart';

final ThemeData _androidTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.deepOrange,
  accentColor: Colors.deepPurple,
  buttonColor: Colors.deepPurple
);

final ThemeData _iosTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  accentColor: Colors.blue,
  buttonColor: Colors.blue
);

ThemeData getAdaptiveThemeData(BuildContext context){
  return Theme.of(context).platform == TargetPlatform.android ? _androidTheme : _iosTheme;
}