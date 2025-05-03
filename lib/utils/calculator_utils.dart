import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

// function to solve expression
String solveExpression(TextEditingController controller, String expression) {
  final Parser p = Parser();

  if(expression.trim().isEmpty) {
    return controller.text = '';
  }

  try {
    Expression parsedExpression = p.parse(expression);
    double result = parsedExpression.evaluate(EvaluationType.REAL, ContextModel());

    // format result as a whole number if it's decimal is 0, otherwise show 2 decimals
    return controller.text = result % 1 == 0 ? result.toInt().toString() : result.toStringAsFixed(2);
  } catch (e) {
    return controller.text = 'Error';
  }
}

// clear expression field
String clearExpression(TextEditingController controller) {
  return controller.text = '';
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