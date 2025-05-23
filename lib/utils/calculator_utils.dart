import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

// function to solve expression
String solveExpression({
  required TextEditingController resultController, 
  required TextEditingController expressionController, 
  required String expression, 
  required List<Map<String,dynamic>> history,
  required bool isAddingToHistory,
  }) {
  final Parser p = Parser();
  List<String> operators = ['/', '*', '-', '+', '^'];

  if(expression.trim().isEmpty) {
    resultController.text = '';
    expressionController.text = '';
  }

  try {
    Expression parsedExpression = p.parse(expression);
    double result = parsedExpression.evaluate(EvaluationType.REAL, ContextModel());

    // format result as a whole number if it's decimal is 0, otherwise show 2 decimals
    String resultStr = result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);
    // save expression to history
    // check if this expression contains math operators
    for(var operator in operators) {
      if(expression.contains(operator)) {
        // if true, then we have to add expression to history
        // so equals to button was pressed
        if(isAddingToHistory) {
          addToHistory(history, '$expression = $resultStr');
          resultController.clear();
          return expressionController.text = resultStr;
        }
        return resultController.text = '= $resultStr';
      }
    }

    return '';
  } catch (e) {
    return resultController.text = '';
  }
}

// new expression item with unique ID, expression itself, and empty comment
Map<String, dynamic> createExpression(List<Map<String,dynamic>> history, String expression) {
  return {
    'id': generateId(history),
    'expression': expression,
    'comment': '',
  };
}

// add comment to item in history
void addComment(List<Map<String,dynamic>> history, String comment, int index) {
  history[index]['comment'] = comment;
  saveData('history', history);
}

// generate id for item in history
int generateId(List<Map<String,dynamic>> history) {
  final random = Random();
  int id;


  // make sure id is unique, and there is no same id in history
  do {
    id = random.nextInt(1000000);
  } while (history.any((item) => item['id'] == id));

  return id;
}

// save expression to history variable
void addToHistory(List<Map<String,dynamic>> history, String expression) {
  history.add(createExpression(history, expression));
  saveData('history', history);
}

// delete one item in history
void deleteItemInHistory(List<Map<String,dynamic>> history, int index) {
  history.removeAt(index);
  saveData('history', history);
}

// clear all history
void clearHistory(List<Map<String,dynamic>> history) {
  if(history.isNotEmpty) {
    history.clear();
    saveData('history', history);
  }
}

// save data to shared_preferences
Future<void> saveData(String key, dynamic data) async {
  final prefs = await SharedPreferences.getInstance();

  if(data is String) {
    await prefs.setString(key, data);
  } else {
    final jsonData = json.encode(data);
    await prefs.setString(key, jsonData);
  }
}

// load data from shared_preferences
Future<String?> loadData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

// load history from shared_preferences
Future<List<Map<String, dynamic>>> loadHistory(String keyToLoad) async {
  final prefs = await SharedPreferences.getInstance();
  final expressionsJson = prefs.getString(keyToLoad) ?? '[]';
  final List<dynamic> decodedList = json.decode(expressionsJson);
  return decodedList.cast<Map<String, dynamic>>().toList();
}

// clear expression field
void clearExpression(TextEditingController resultController, TextEditingController expressionController) {
  resultController.clear();
  expressionController.clear();
}

// remove one character or selected text
String removeCharacter(TextEditingController controller) {
  final expression = controller.text;
  final selection = controller.selection;

  if(selection.start == selection.end) {
    // remove one character to the left from cursor
    if(selection.start > 0) {
      final newExpression = 
      expression.substring(0, selection.start - 1) + 
      expression.substring(selection.start);

      controller.value = TextEditingValue(
        text: newExpression,
        selection: TextSelection.collapsed(offset: selection.start - 1)
      );
    }
  } else {
    // remove selected text
    final newExpression = expression.substring(0, selection.start) + expression.substring(selection.end);

    controller.value = TextEditingValue(
      text: newExpression,
      selection: TextSelection.collapsed(offset: selection.start)
    );
  }
  return controller.text;
}