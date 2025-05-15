import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFFffffff),
      backgroundColor: Color(0xFF171717),
      textStyle: const TextStyle(fontSize: 25,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Color(0xFF444444),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color(0xFF202020),
    indicatorColor: Color(0xFF303030),
    iconTheme: WidgetStateProperty.all(
      IconThemeData(color: Color(0xFFffffff))
    )
  ),
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Color(0xFFffffff),
    secondary: Color(0xFF303030)
  )
);