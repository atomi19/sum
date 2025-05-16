import 'package:flutter/material.dart';
import 'package:sum/pages/main_page.dart';
import 'package:sum/theme/dark_theme.dart';
import 'package:sum/theme/light_theme.dart';
import 'package:sum/utils/calculator_utils.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleLightTheme() {
    setState(() {
      _themeMode = ThemeMode.light;
      saveData('theme_mode', 'light');
    });
  }

  void _toggleDarkTheme() {
    setState(() {
      _themeMode = ThemeMode.dark;
      saveData('theme_mode', 'dark');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sum',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: MainPage(
        toggleLightTheme: _toggleLightTheme,
        toggleDarkTheme: _toggleDarkTheme,
        themeMode: _themeMode,
      )
    );
  }
}