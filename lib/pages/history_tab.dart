import 'package:flutter/material.dart';
import 'package:sum/utils/calculator_utils.dart';

class HistoryTab extends StatefulWidget {
  final List<String> history;
  final TextEditingController controller;
  final void Function() onExpressionSelected;

  const HistoryTab({
    super.key,
    required this.history,
    required this.controller,
    required this.onExpressionSelected,
  });

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab>{
  // insert expression or expression's result into expression field
  void insertData(String expression, String action) {
    List<String> expressionParts = expression.split('=');

    if(expressionParts.length == 2) {
      String expression = expressionParts[0].trim();
      String result = expressionParts[1].trim();

      switch (action) {
        case 'expression':
          widget.controller.text = expression;
          break;
        case 'result':
          widget.controller.text = result;
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Column(
        children: [
          // app bar
          Container(
            color: Color(0xFFfcfcfc),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Color(0xFFf6f5f4),
                        title: const Text('Clear history'),
                        content: const Text('It will clear all your history!'),
                        actions:<Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                clearHistory(widget.history);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      )
                    );
                  },
                  child: const Icon(Icons.delete_outline, color: Colors.red,)
                ),
              ],
            ),
          ),
          // history section
          Expanded(
            child: widget.history.isEmpty
            ? const Center(child: Text('No history available', style: TextStyle(fontSize: 25)))
            : ListView.builder(
              itemCount: widget.history.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFdeddda), width: 1))
                      ),
                      child: ListTile(
                        title: Align(
                          alignment: Alignment.centerRight,
                          child: Text(widget.history[index], style: TextStyle(color: Colors.black, fontSize: 20)),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                            ),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.download),
                                      title: const Text('Take expression'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        insertData(widget.history[index], 'expression');
                                        widget.onExpressionSelected();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.download),
                                      title: const Text('Take result'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        insertData(widget.history[index], 'result');
                                        widget.onExpressionSelected();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete_outline, color: Colors.red),
                                      title: const Text('Delete', style: TextStyle(color: Colors.red)),
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          deleteItemInHistory(widget.history, index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          );
                        },
                      ),
                    )
                  ]
                );
              }
            )
          ),
        ],
      )
    );
  }
}