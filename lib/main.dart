import 'package:flutter/material.dart';
import 'package:sum/pages/tab_page.dart';
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
  ThemeMode themeMode = ThemeMode.light;

  // load theme 
  Future<void> _loadTheme() async {
    final String? theme = await loadData('theme_mode');

    if(theme == 'light') {
      _toggleLightTheme();
    } else {
      _toggleDarkTheme();
    } 
  }

  void _toggleLightTheme() {
    setState(() {
      themeMode = ThemeMode.light;
      saveData('theme_mode', 'light');
    });
  }

  void _toggleDarkTheme() {
    setState(() {
      themeMode = ThemeMode.dark;
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
      themeMode: themeMode,
      home: TabPage(
        loadTheme: _loadTheme,
        toggleLightTheme: _toggleLightTheme,
        toggleDarkTheme: _toggleDarkTheme,
        themeMode: themeMode,
      )
    );
  }
}