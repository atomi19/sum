import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey.shade200,
      textStyle: const TextStyle(fontSize: 25,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey.shade300,
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
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Colors.blue.shade200,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.grey.shade200,
    indicatorColor: Color(0xFFdeddda),
    iconTheme: WidgetStateProperty.all(
      IconThemeData(color: Color(0xFF2E3436))
    )
  ),
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.black,
    secondary: Colors.grey.shade200,
  )
);