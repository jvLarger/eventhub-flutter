import 'package:flutter/material.dart';
import 'package:eventhub/utils/constants.dart';

abstract class AppTheme {
  static ThemeData get light {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Color.fromRGBO(33, 33, 33, 1),
        ),
        titleTextStyle: TextStyle(
          color: Color.fromRGBO(33, 33, 33, 1),
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: "Urbanist",
        ),
        backgroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      primaryColor: const Color.fromRGBO(33, 33, 33, 1),
      splashColor: Colors.transparent,
      fontFamily: 'Urbanist',
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Color.fromRGBO(242, 242, 242, 1),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        hintStyle: TextStyle(
          fontFamily: 'Urbanist',
          color: Color.fromRGBO(150, 150, 150, 1),
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            fontFamily: 'Urbanist',
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: Colors.transparent),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            fontFamily: 'Urbanist',
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          elevation: 0,
        ),
      ),
      primarySwatch: colorBlue,
    );
  }
}
