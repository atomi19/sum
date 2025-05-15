import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Color(0xFF2E3436),
      backgroundColor: Color(0xFFe6e6e6),
      textStyle: const TextStyle(fontSize: 25,),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: Color(0xFFdeddda),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Color(0xFFf6f5f4),
    indicatorColor: Color(0xFFdeddda),
    iconTheme: WidgetStateProperty.all(
      IconThemeData(color: Color(0xFF2E3436))
    )
  ),
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.black,
    secondary: Color(0xFFdcdcdc)
  )
);