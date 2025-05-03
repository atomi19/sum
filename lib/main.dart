import 'package:flutter/material.dart';
import 'package:sum/pages/main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sum',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Color(0xFF2E3436),
            backgroundColor: Color(0xFFf6f5f4),
            textStyle: const TextStyle(fontSize: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Color(0xFFf6f5f4)
        ),
      ),
      home: MainPage()
    );
  }
}