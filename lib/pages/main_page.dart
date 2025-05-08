import 'package:flutter/material.dart';
import 'package:sum/pages/history_tab.dart';
import 'package:sum/pages/home_tab.dart';
import 'package:sum/utils/calculator_utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0; // current tab index
  List<String> _history = [];
  final TextEditingController expressionController = TextEditingController();
  final TextEditingController resultController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHistory();

    expressionController.addListener(() {
      final expression = expressionController.text;
      solveExpression(resultController, expressionController, expression, _history, false);
    });
  }

  // load history from shared_preferences
  Future<void> _loadHistory() async {
    final loadedHistory = await loadData('history');
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
      ),
      HistoryTab(
        history: _history, 
        controller: expressionController, 
        onExpressionSelected: () => setState(() {_currentIndex = 0;}),
      )
    ];

    return Scaffold(
      backgroundColor: Colors.white,
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
            )
          ]
        ),
      )
    );
  }
}