import 'package:flutter/material.dart';
import 'package:sum/pages/history_tab.dart';
import 'package:sum/pages/home_tab.dart';
import 'package:sum/pages/settings_tab.dart';
import 'package:sum/utils/calculator_utils.dart';

class MainPage extends StatefulWidget {
  final VoidCallback toggleLightTheme;
  final VoidCallback toggleDarkTheme;
  final ThemeMode themeMode;

  const MainPage({
    super.key,
    required this.toggleLightTheme,
    required this.toggleDarkTheme,
    required this.themeMode,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // current tab index
  List<Map<String,dynamic>> _history = [];
  final TextEditingController expressionController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadTheme();
    _loadHistory();

  }

  Future<void> _initializeControllers() async {
    final expression = await loadData('expression');
    expressionController.text = expression ?? '';

    expressionController.addListener(() {
      final expression = expressionController.text;
      saveData('expression', expression);
      solveExpression(
        resultController: resultController, 
        expressionController: expressionController, 
        expression: expression, 
        history: _history, 
        isAddingToHistory: false,
      );
    });
  }

  // load string from shared_preferences
  Future<void> _loadTheme() async {
    final String? loadedData = await loadData('theme_mode');

    setState(() {
      if(loadedData == 'light') {
        widget.toggleLightTheme();
      } else {
        widget.toggleDarkTheme();
      }
    });

  }

  // load history from shared_preferences
  Future<void> _loadHistory() async {
    final loadedHistory = await loadHistory('history');
    setState(() {
      _history = loadedHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      MainTab(
        history: _history,
        resultController: resultController,
        expressionController: expressionController,
        toggleLightTheme: widget.toggleLightTheme,
        toggleDarkTheme: widget.toggleDarkTheme,
        themeMode: widget.themeMode,
        switchTab: () => setState(() {_currentIndex = 2;}),
      ),
      HistoryTab(
        history: _history, 
        controller: expressionController, 
        commentController: commentController,
        switchTab: () => setState(() {_currentIndex = 0;}),
      ),
      SettingsTab(
        toggleLightTheme: widget.toggleLightTheme, 
        toggleDarkTheme: widget.toggleDarkTheme, 
        themeMode: widget.themeMode
      )
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: SizedBox(
        height: 65,
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings'
            )
          ]
        ),
      )
    );
  }
}