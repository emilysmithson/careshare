import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTheme {
  ThemeData call() {
    return ThemeData(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(Colors.green[50]),
          foregroundColor: MaterialStateProperty.all(Colors.black),
        ),
      ),
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
        headline2: TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(8),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
