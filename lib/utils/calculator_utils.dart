import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

String processExpressionResult({
  required TextEditingController resultController, 
  required TextEditingController expressionController, 
  required String expression, 
  required List<Map<String,dynamic>> history,
  required bool isAddingToHistory,
  }) {
  List<String> operators = ['/', '*', '-', '+', '^'];

  if(expression.trim().isEmpty) {
    resultController.text = '';
    expressionController.text = '';
  }

  try {
    String resultStr = solveExpression(expression: expression);
    // fix showing equals sign without result(when result is empty)
    if(resultStr == '') {
      return '';
    }
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

// solve expression
String solveExpression({
  required String expression
}) {
    final Parser p = Parser();
    try {
    Expression parsedExpression = p.parse(expression);
    double result = parsedExpression.evaluate(EvaluationType.REAL, ContextModel());

    // format result as a whole number if it's decimal is 0, otherwise show 2 decimals
    return result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);
  } catch (e) {
    return '';
  }
}

// new expression item with unique ID, expression itself, and empty comment
Map<String, dynamic> createExpression({
  required List<Map<String,dynamic>> history, 
  required String expression,
  }) {
  return {
    'id': generateId(history),
    'expression': expression,
    'comment': '',
    'folderId': 0, // 0 - means no folder
  };
}

// add comment to item in history
void addComment(List<Map<String,dynamic>> history, String comment, int itemId) {
  final item = history.firstWhere((item) => item['id'] == itemId);
  item['comment'] = comment;
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
  history.add(createExpression(
    history: history, 
    expression: expression,
  ));
  saveData('history', history);
}

// delete one item in history
void deleteItem(List<Map<String,dynamic>> history, int itemId, String key) {
  history.removeWhere((item) => item['id'] == itemId);
  saveData(key, history);
}

// change the folder id for an item in history
void changeItemFolderId(List<Map<String,dynamic>> items, int index, int folderId) {
  items[index]['folderId'] = folderId;
  saveData('history', items);
}

// clear all history
void clearHistory({
  required List<Map<String,dynamic>> history, 
  required int folderId
  }) {
  if(history.isNotEmpty) {
    if(folderId == 0) {
      history.clear();
    } else {
      history.removeWhere((item) => item['folderId'] == folderId);
    }
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

// copy something to the clipboard
void copyToClipboard(String data) async {
  await Clipboard.setData(ClipboardData(text: data));
}