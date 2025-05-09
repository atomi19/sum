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
        )
      ),
      home: MainPage()
    );
  }
}