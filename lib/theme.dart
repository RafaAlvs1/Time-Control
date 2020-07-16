import 'package:flutter/material.dart';

class MyTheme {
  static const Color backgroundColor = Color.fromRGBO(247, 247, 247, 1);
  static const Color primaryTextColor = Colors.white;

  static const MaterialColor primaryColor = MaterialColor(_primaryPrimaryValue, <int, Color>{
    50: Color(0xFFE4ECE7),
    100: Color(0xFFBBCFC4),
    200: Color(0xFF8DB09C),
    300: Color(0xFF5F9074),
    400: Color(0xFF3D7857),
    500: Color(_primaryPrimaryValue),
    600: Color(0xFF185833),
    700: Color(0xFF144E2C),
    800: Color(0xFF104424),
    900: Color(0xFF083317),
  });
  static const int _primaryPrimaryValue = 0xFF0F7107;

  static const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
    100: Color(0xFF6DFF98),
    200: Color(_primaryAccentValue),
    400: Color(0xFF07FF50),
    700: Color(0xFF00EC45),
  });
  static const int _primaryAccentValue = 0xFF3AFF74;

  static const MaterialColor secondaryColor = MaterialColor(_secondaryPrimaryValue, <int, Color>{
    50: Color(0xFFFEF6E3),
    100: Color(0xFFFCEAB9),
    200: Color(0xFFFADC8B),
    300: Color(0xFFF7CD5C),
    400: Color(0xFFF6C339),
    500: Color(_secondaryPrimaryValue),
    600: Color(0xFFF3B113),
    700: Color(0xFFF1A810),
    800: Color(0xFFEFA00C),
    900: Color(0xFFEC9106),
  });
  static const int _secondaryPrimaryValue = 0xFFF4B816;

  static const MaterialColor secondaryAccent = MaterialColor(_secondaryAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_secondaryAccentValue),
    400: Color(0xFFFFDBAE),
    700: Color(0xFFFFD094),
  });
  static const int _secondaryAccentValue = 0xFFFFF2E1;
}

class MyTextStyle {
  static TextStyle headline1 = TextStyle(fontFamily: 'Raleway', fontSize: 72.0, fontWeight: FontWeight.bold,);
  static TextStyle headline2 = TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold);
  static TextStyle subtitle1 = TextStyle(fontSize: 14.0, fontFamily: 'Hind', fontWeight: FontWeight.bold);


  static TextStyle headline3 = TextStyle(
    color: MyTheme.primaryColor[800],
    fontSize: 39.0,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
  );

  static TextStyle headline4 = TextStyle(
    color: MyTheme.primaryColor[800],
    fontSize: 34.0,
    fontFamily: 'Raleway',
    letterSpacing: 0.25,
  );

  static TextStyle headline5 = TextStyle(
    color: MyTheme.primaryColor[800],
    fontSize: 24.0,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static TextStyle headline6 = TextStyle(
    color: MyTheme.primaryColor[800],
    fontSize: 20,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  );

  static TextStyle subtitle = TextStyle(
    color: MyTheme.primaryColor[800],
    fontSize: 22.0,
    fontFamily: 'Raleway',
    fontWeight: FontWeight.bold,
    letterSpacing: 0.15,
  );

  static TextStyle bodyText = TextStyle(
    color: MyTheme.primaryColor[800],
    fontSize: 16.0,
    fontFamily: 'Raleway',
    letterSpacing: 0.5,
  );

  static TextStyle captionText = TextStyle(
    color: MyTheme.primaryColor[800],
    fontSize: 14.0,
    fontFamily: 'Raleway',
    letterSpacing: 0.4,
  );
}