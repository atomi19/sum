import 'package:flutter/material.dart';
import 'package:sum/utils/calculator_utils.dart';

class HistoryTab extends StatefulWidget {
  final List<Map<String,dynamic>> history;
  final TextEditingController controller;
  final TextEditingController commentController;
  final void Function() onExpressionSelected;

  const HistoryTab({
    super.key,
    required this.history,
    required this.controller,
    required this.commentController,
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
                        border: Border(bottom: BorderSide(color: Color(0xFFdeddda), width: 1))
                      ),
                      child: ListTile(
                        title: Text(widget.history[index]['expression'], style: TextStyle(color: Colors.black, fontSize: 20)),
                        subtitle: widget.history[index]['comment'].toString().trim().isEmpty
                        ? null
                        : Text(widget.history[index]['comment'], style: TextStyle(color: Colors.black, fontSize: 13)),
                        onTap: () {
                          // actions for a selected item in history
                          showModalBottomSheet(
                            context: context,
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
                                        widget.onExpressionSelected();
                                      },
                                    ),
                                    // take result action
                                    ListTile(
                                      leading: const Icon(Icons.download),
                                      title: const Text('Take result'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        insertData(widget.history[index]['expression'], 'result');
                                        widget.onExpressionSelected();
                                      },
                                    ),
                                    // comment item in history
                                    ListTile(
                                      leading: const Icon(Icons.comment_outlined),
                                      title: const Text('Comment'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        widget.commentController.text = widget.history[index]['comment'];
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                                          ),
                                          builder: (BuildContext context) {
                                            return Padding(
                                            padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: MediaQuery.of(context).viewInsets.bottom + 20
                                            ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    // comment
                                                    Row(
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
                                                          child: const Text('Done')
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextField(
                                                            controller: widget.commentController,
                                                            minLines: 10,
                                                            maxLines: 20,
                                                            decoration: InputDecoration(
                                                              hintText: 'Enter comment'
                                                            ),
                                                          )
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ),
                                            );
                                          }
                                        );
                                      },
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