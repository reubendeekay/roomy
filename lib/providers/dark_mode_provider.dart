import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roomy/constants.dart';

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

// #090815 TO IMPLEMENT
class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.purple,
      primaryColor: isDarkTheme ? Color(0xff121212) : Colors.white,
      backgroundColor: isDarkTheme ? Colors.black : Colors.grey[50],
      scaffoldBackgroundColor:
          isDarkTheme ? Color(0xff121212) : Colors.grey[50],
      bottomAppBarColor: isDarkTheme ? Color(0xff121212) : Colors.white,
      indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
      hintColor: isDarkTheme ? Colors.grey : Colors.grey,
      highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),
      focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      iconTheme:
          IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
      textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      shadowColor: isDarkTheme ? Colors.black38 : Colors.grey[300],
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      textTheme: GoogleFonts.openSansTextTheme().copyWith(
        bodyText1: GoogleFonts.openSans(
            color: !isDarkTheme ? Color(0xff121212) : Colors.white),
        headline2: GoogleFonts.openSans(
            color: !isDarkTheme ? Color(0xff121212) : Colors.white),
        bodyText2: GoogleFonts.openSans(
            color: !isDarkTheme ? Color(0xff121212) : Colors.white),
        headline6: GoogleFonts.openSans(
            color: !isDarkTheme ? Color(0xff121212) : Colors.white),
        subtitle1: GoogleFonts.openSans(
            color: !isDarkTheme ? Color(0xff121212) : Colors.white),
      ),
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      appBarTheme: AppBarTheme(
          elevation: 0.0,
          iconTheme:
              IconThemeData(color: isDarkTheme ? Colors.white : Colors.black),
          color: isDarkTheme ? Color(0xff121212) : Colors.grey[50]),
    );
  }
}
