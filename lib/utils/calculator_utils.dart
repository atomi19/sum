import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

// function to solve expression
String solveExpression(
  TextEditingController resultController, 
  TextEditingController expressionController, 
  String expression, 
  List<String> history,
  bool isAddingToHistory,
  ) {
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
        if(isAddingToHistory) {
          addToHistory(history, '$expression = $resultStr');
          resultController.text = '';
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

// save expression to history variable
void addToHistory(List<String> history, String expression) {
  history.add(expression);
  saveData(history);
}

// delete one item in history
void deleteItemInHistory(List<String> history, int index) {
  history.removeAt(index);
  saveData(history);
}

// clear all history
void clearHistory(List<String> history) {
  if(history.isNotEmpty) {
    history.clear();
    saveData(history);
  }
}

// save data to shared_preferences
Future<List<String>> saveData(List<String> history) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('history', history);
  return history;
}

// load data from shared_preferences
Future<List<String>> loadData(String keyToLoad) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(keyToLoad) ?? [];
}

// clear expression field
void clearExpression(TextEditingController resultController, TextEditingController expressionController) {
  resultController.text = '';
  expressionController.text = '';
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