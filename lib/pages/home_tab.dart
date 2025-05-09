import 'package:flutter/material.dart';
import 'package:sum/utils/calculator_utils.dart';

class MainTab extends StatefulWidget {
  final List<Map<String,dynamic>> history;
  final TextEditingController resultController;
  final TextEditingController expressionController;

  const MainTab({
    super.key,
    required this.history,
    required this.resultController,
    required this.expressionController,
  });

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab>{
  // handle button click, print the value to the expression field
  void onButtonPressed({required value}) {
    widget.expressionController.text += value;
  }

  // build calculator button
  Widget calcButton({
    required Widget child,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
  }) {
    return Expanded(
      child: SizedBox.expand(
        child: TextButton(
          onPressed: onPressed, 
          onLongPress: onLongPress,
          child: child,
        ),
      )
    );
  }

  // build row with buttons
  Widget buttonRow(List<Widget> buttons) {
    return Expanded(
      child: Row(
        children: [
          const SizedBox(width: 5),
          ...buttons.expand((button) => [button, const SizedBox(width: 5)])
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // expression text field
        // with content padding in percents
        Builder(
          builder: (context) {
            final screenHeight = MediaQuery.of(context).size.height;
            final topPadding = screenHeight * 0.15; // 15%
            final bottomPadding = screenHeight * 0.02; // 2%

            return Container(
              padding: EdgeInsets.fromLTRB(5, topPadding, 5, bottomPadding),
              child: Column(
                children: [
                  TextField(
                    controller: widget.resultController,
                    readOnly: true,
                    enableInteractiveSelection: false,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 50, ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                  TextField(
                    autofocus: true,
                    controller: widget.expressionController,
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.none,
                    cursorColor: Color(0xFF2E3436),
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  )
                ],
              ),
            );
          },
        ),
        // rows with buttons
        buttonRow([
          calcButton(child: const Text('('), onPressed: () => onButtonPressed(value: '(')),
          calcButton(child: const Text(')'), onPressed: () => onButtonPressed(value: ')')),
          calcButton(child: const Icon(Icons.backspace_outlined, color: Color(0xFF2E3436), size: 25), onPressed: () => removeCharacter(widget.expressionController), onLongPress: () => clearExpression(widget.resultController, widget.expressionController)),
          calcButton(child: const Text('/'), onPressed: () => onButtonPressed(value: '/')),
        ]),
        const SizedBox(height: 5),
        buttonRow([
          calcButton(child: const Text('7'), onPressed: () => onButtonPressed(value: '7')),
          calcButton(child: const Text('8'), onPressed: () => onButtonPressed(value: '8')),
          calcButton(child: const Text('9'), onPressed: () => onButtonPressed(value: '9')),
          calcButton(child: const Text('*'), onPressed: () => onButtonPressed(value: '*')),
        ]),
        const SizedBox(height: 5),
        buttonRow([
          calcButton(child: const Text('4'), onPressed: () => onButtonPressed(value: '4')),
          calcButton(child: const Text('5'), onPressed: () => onButtonPressed(value: '5')),
          calcButton(child: const Text('6'), onPressed: () => onButtonPressed(value: '6')),
          calcButton(child: const Text('-'), onPressed: () => onButtonPressed(value: '-')),
        ]),
        const SizedBox(height: 5),
        buttonRow([
          calcButton(child: const Text('1'), onPressed: () => onButtonPressed(value: '1')),
          calcButton(child: const Text('2'), onPressed: () => onButtonPressed(value: '2')),
          calcButton(child: const Text('3'), onPressed: () => onButtonPressed(value: '3')),
          calcButton(child: const Text('+'), onPressed: () => onButtonPressed(value: '+')),
        ]),
        const SizedBox(height: 5),
        buttonRow([
          calcButton(child: const Text('0'), onPressed: () => onButtonPressed(value: '0')),
          calcButton(child: const Text('^'), onPressed: () => onButtonPressed(value: '^')),
          calcButton(child: const Text('.'), onPressed: () => onButtonPressed(value: '.')),
          calcButton(child: const Text('='), onPressed: () => solveExpression(widget.resultController, widget.expressionController, widget.expressionController.text, widget.history, true)),
        ]),
        const SizedBox(height: 5),
      ],
    );
  }
}