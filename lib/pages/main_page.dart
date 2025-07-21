import 'package:flutter/material.dart';
import 'package:sum/pages/history_tab.dart';
import 'package:sum/pages/home_tab.dart';
import 'package:sum/pages/convert_tab.dart';
import 'package:sum/pages/settings_tab.dart';
import 'package:sum/utils/calculator_utils.dart';

class MainPage extends StatefulWidget {
  final VoidCallback loadTheme;
  final VoidCallback toggleLightTheme;
  final VoidCallback toggleDarkTheme;
  final ThemeMode themeMode;

  const MainPage({
    super.key,
    required this.loadTheme,
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
  List<Map<String, dynamic>> _folders = [];
  final TextEditingController expressionController = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    widget.loadTheme();
    _loadData('history');
    _loadData('folders');
  }

  Future<void> _initializeControllers() async {
    final expression = await loadData('expression');
    expressionController.text = expression ?? '';

    expressionController.addListener(() {
      final expression = expressionController.text;
      saveData('expression', expression);
      processExpressionResult(
        resultController: resultController, 
        expressionController: expressionController, 
        expression: expression, 
        history: _history,
        isAddingToHistory: false,
      );
    });
  }

  // load data from shared_preferences
  Future<void> _loadData(String key) async {
    final loadedData = await loadHistory(key);
    setState(() {
      switch (key) {
        case 'history':
          _history = loadedData;   
          break;
        case 'folders':
          _folders = loadedData;
        default:
         return;
      }
    });
  }

  // create tab items(home, convert, history, and settings)
  Widget _createTabItem(IconData icon, IconData selectedIcon, label) {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(selectedIcon),
      label: label
    );
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
      ConvertTab(),
      HistoryTab(
        history: _history,
        folders: _folders,
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
          indicatorColor: Colors.transparent,
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return Colors.transparent;
            },
          ),
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: <Widget>[
            _createTabItem(Icons.home_outlined, Icons.home, 'Home'),
            _createTabItem(Icons.swap_horiz_rounded, Icons.swap_horizontal_circle_rounded, 'Convert'),
            _createTabItem(Icons.access_time_outlined, Icons.access_time_filled, 'History'),
            _createTabItem(Icons.settings_outlined, Icons.settings, 'Settings'),
          ]
        ),
      )
    );
  }
}