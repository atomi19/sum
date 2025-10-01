import 'package:flutter/material.dart';
import 'package:sum/utils/calculator_utils.dart';
import 'package:sum/widgets/calc_widgets.dart';
import 'package:sum/widgets/show_bottom_sheet.dart';

class MainTab extends StatefulWidget {
  final List<Map<String,dynamic>> history;
  final TextEditingController resultController;
  final TextEditingController expressionController;
  final void Function() switchTab;
  final VoidCallback toggleLightTheme;
  final VoidCallback toggleDarkTheme;
  final ThemeMode themeMode;

  const MainTab({
    super.key,
    required this.history,
    required this.resultController,
    required this.expressionController,
    required this.switchTab,
    required this.toggleLightTheme,
    required this.toggleDarkTheme,
    required this.themeMode,
  });

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab>{
  // handle button click, print the value to the expression field
  void onButtonPressed({required value}) {
    widget.expressionController.text += value;
  }

  // copy result options 
  void _showCopyBottomSheet() {
    showCustomBottomSheet(
      context: context, 
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.content_copy),
            title: const Text('Copy result'),
            onTap: () {
              Navigator.pop(context);
              String data = widget.resultController.text.split(' ')[1];
              copyToClipboard(data);
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy_all),
            title: const Text('Copy all'),
            onTap: () {
              Navigator.pop(context);
              String data = '${widget.expressionController.text} ${widget.resultController.text}';
              copyToClipboard(data);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // text field's
          Builder(
            builder: (context) {
              final screenHeight = MediaQuery.of(context).size.height;
              final topPadding = screenHeight * 0.15; // 15%
              final bottomPadding = screenHeight * 0.02; // 2%

              return Container(
                padding: EdgeInsets.fromLTRB(5, topPadding, 5, bottomPadding),
                child: Column(
                  children: [
                    // result text field
                    TextField(
                      controller: widget.resultController,
                      readOnly: true,
                      enableInteractiveSelection: false,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 50, ),
                      decoration: InputDecoration(
                        filled: false,
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        if(widget.resultController.text.trim().isNotEmpty) {
                          _showCopyBottomSheet();
                        }
                      },
                    ),
                    // expression text field
                    TextField(
                      autofocus: true,
                      controller: widget.expressionController,
                      textAlign: TextAlign.end,
                      onSubmitted: (String value) => processExpressionResult(
                        resultController: widget.resultController, 
                        expressionController: widget.expressionController, 
                        expression: widget.expressionController.text, 
                        history: widget.history, 
                        isAddingToHistory: true,
                      ),
                      keyboardType: TextInputType.none,
                      cursorColor: Theme.of(context).colorScheme.primary,
                      style: const TextStyle(fontSize: 25),
                      decoration: InputDecoration(
                        filled: false,
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
            calcButton(child: Icon(Icons.backspace_outlined, color: Theme.of(context).colorScheme.primary, size: 25), onPressed: () => removeCharacter(widget.expressionController), onLongPress: () => clearExpression(widget.resultController, widget.expressionController)),
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
            calcButton(child: const Text('0'), onPressed: () => onButtonPressed(value: '0'), flex: 2),
            calcButton(child: const Text('.'), onPressed: () => onButtonPressed(value: '.')),
            calcButton(
              child: const Text('='), 
              onPressed: () => processExpressionResult(
                resultController: widget.resultController, 
                expressionController: widget.expressionController, 
                expression: widget.expressionController.text, 
                history: widget.history, 
                isAddingToHistory: true,
              ),
            )
          ]),
          const SizedBox(height: 5),
        ],
      )
    );
  }
}