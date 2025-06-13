import 'package:flutter/material.dart';
import 'package:sum/utils/calculator_utils.dart';

class HistoryTab extends StatefulWidget {
  final List<Map<String,dynamic>> history;
  final TextEditingController controller;
  final TextEditingController commentController;
  final void Function() switchTab;

  const HistoryTab({
    super.key,
    required this.history,
    required this.controller,
    required this.commentController,
    required this.switchTab,
  });

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab>{
  // insert expression or expression's result into expression field
  void insertData(String expression, String action) {
    switch (action) {
      case 'expression':
        widget.controller.text = splitExpressionAndResult(expression, action);
        break;
      case 'result':
        widget.controller.text = splitExpressionAndResult(expression, action);
        break;
      default:
    }
  }

  // split the full expression into expression and result
  String splitExpressionAndResult(String expression, String action) {
    List<String> expressionParts = expression.split('=');

    if(expressionParts.length == 2) {
      String expression = expressionParts[0].trim();
      String result = expressionParts[1].trim();

      switch (action) {
        case 'expression':
          return expression;
        case 'result':
          return result;
      }
    }
    return '';
  }

  // comment showModalBottomSheet
  void _showCommentSheet(int index) {
    Navigator.pop(context);
    widget.commentController.text = widget.history[index]['comment'];

    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
        padding: EdgeInsets.only(
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // top bar of modal bottom sheet
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1.0,
                      )
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Comment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              addComment(widget.history, widget.commentController.text, index);
                            });
                            widget.commentController.clear();
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Done', style: TextStyle(fontSize: 18)),
                        )
                      ],
                    ),
                  ),
                ),
                // comment text field
                TextField(
                  controller: widget.commentController,
                  minLines: 10,
                  maxLines: 20,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: InputDecoration(
                    hintText: 'Enter comment',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                )
              ],
            )
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // app bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1.0,
                )
              )
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('History', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        title: const Text('Clear history'),
                        content: const Text('It will clear all your history!'),
                        actions:<Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                            ),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              setState(() {
                                clearHistory(widget.history);
                              });
                              Navigator.pop(context);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                            ),
                            child: const Text('OK'),
                          ),
                        ],
                      )
                    );
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 18,)
                ),
              ],
            ),
          ),
          // history list
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
                        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1))
                      ),
                      child: ListTile(
                        title: Text(widget.history[index]['expression'], style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20)),
                        subtitle: widget.history[index]['comment'].toString().trim().isEmpty
                        ? null
                        : Text(widget.history[index]['comment'], style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 13)),
                        onTap: () {
                          // actions for a selected item in history
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                            ),
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Wrap(
                                  children: [
                                    // take expression action
                                    ListTile(
                                      leading: const Icon(Icons.download),
                                      title: const Text('Take expression'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        insertData(widget.history[index]['expression'], 'expression');
                                        widget.switchTab();
                                      },
                                    ),
                                    // take result action
                                    ListTile(
                                      leading: const Icon(Icons.download),
                                      title: const Text('Take result'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        insertData(widget.history[index]['expression'], 'result');
                                        widget.switchTab();
                                      },
                                    ),
                                    Divider(color: Theme.of(context).disabledColor),
                                    ListTile(
                                      leading: const Icon(Icons.copy),
                                      title: const Text('Copy result'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        String data = splitExpressionAndResult(widget.history[index]['expression'], 'result');
                                        copyToClipboard(data);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.copy_all),
                                      title: const Text('Copy all'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        String data = widget.history[index]['expression'];
                                        copyToClipboard(data);
                                      },
                                    ),
                                    Divider(color: Theme.of(context).disabledColor),
                                    // comment item in history
                                    ListTile(
                                      leading: const Icon(Icons.comment_outlined),
                                      title: const Text('Comment'),
                                      onTap: () => _showCommentSheet(index),
                                    ),
                                    // delete item in history
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