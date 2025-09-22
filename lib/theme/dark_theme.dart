import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFF171717),
      textStyle: const TextStyle(fontSize: 25,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Color(0xFF171717),
      iconSize: 25,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
    )
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
    )
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.transparent,
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Colors.blue.shade800,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color(0xFF202020),
    indicatorColor: Color(0xFF303030),
    iconTheme: WidgetStateProperty.all(
      IconThemeData(color: Colors.white)
    )
  ),
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.white,
    secondary: Colors.grey.shade900,
    shadow: Color.fromARGB(166, 131, 131, 131)
  )
);