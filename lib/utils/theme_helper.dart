import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color _themeColor = Color(0xFF4fc3f7);
var fontValueList = ['Tajawal'];

themeData({bool platformDarkMode: false}) {
  Brightness brightness = Brightness.light;

  var themeColor = _themeColor;
  var accentColor = _themeColor;
  var scaffoldBackgroundColor = Colors.white;
  var themeData = ThemeData(
    brightness: brightness,
    primaryColorBrightness: Brightness.dark,
    accentColorBrightness: Brightness.dark,
    primaryColor: themeColor,
    accentColor: accentColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor,
//      fontFamily: lang.currentLanguage == "ar" ? "Tajawal" : "Roboto"
  );

//  themeData = themeData.copyWith(
//    brightness: brightness,
//    accentColor: accentColor,
//    cupertinoOverrideTheme: CupertinoThemeData(
//      primaryColor: themeColor,
//      brightness: brightness,
//    ),
//
//    appBarTheme: themeData.appBarTheme.copyWith(elevation: 0),
//    splashColor: themeColor.withAlpha(50),
//    hintColor: themeData.hintColor.withAlpha(90),
//    errorColor: Colors.red,
//    cursorColor: accentColor,
//    textTheme: themeData.textTheme.copyWith(
//
//        subhead: themeData.textTheme.subhead
//            .copyWith(textBaseline: TextBaseline.alphabetic)),
//    textSelectionColor: accentColor.withAlpha(60),
//    textSelectionHandleColor: accentColor.withAlpha(60),
//    toggleableActiveColor: accentColor,
//    chipTheme: themeData.chipTheme.copyWith(
//      pressElevation: 0,
//      padding: EdgeInsets.symmetric(horizontal: 10),
//      labelStyle: themeData.textTheme.caption,
//      backgroundColor: themeData.chipTheme.backgroundColor.withOpacity(0.1),
//    ),
//          textTheme: CupertinoTextThemeData(brightness: Brightness.light)
//    inputDecorationTheme: ThemeHelper.inputDecorationTheme(themeData),
//  );
  return themeData;
}

class ThemeHelper {
  static InputDecorationTheme inputDecorationTheme(ThemeData theme) {
    var primaryColor = theme.primaryColor;
    var dividerColor = theme.dividerColor;
    var errorColor = theme.errorColor;
    var disabledColor = theme.disabledColor;

    var width = 0.5;

    return InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 14),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: errorColor)),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.7, color: errorColor)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: primaryColor)),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: dividerColor)),
      border: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: dividerColor)),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: disabledColor)),
    );
  }
}
