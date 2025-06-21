import 'package:flutter/material.dart';
import 'package:sum/pages/folders_page.dart';
import 'package:sum/utils/calculator_utils.dart';

class HistoryTab extends StatefulWidget {
  final List<Map<String,dynamic>> history;
  final List<Map<String, dynamic>> folders;
  final TextEditingController controller;
  final TextEditingController commentController;
  final void Function() switchTab;

  const HistoryTab({
    super.key,
    required this.history,
    required this.folders,
    required this.controller,
    required this.commentController,
    required this.switchTab,
  });

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab>{
  late List<Map<String, dynamic>> _filteredHistory;
  int _currentFolderId = 0;
  String _appTitle = 'All history';

  @override
  void initState() {
    super.initState();
    setState(() {
      _filterHistory();
    });
  }

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
  void _showCommentSheet(int itemId) {
    Navigator.pop(context);
    // find item comment and set commentController with this comment
    final item = widget.history.firstWhere((item) => item['id'] == itemId);
    String comment = item['comment'];
    widget.commentController.text = comment;

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
                        color: Theme.of(context).disabledColor,
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
                              addComment(widget.history, widget.commentController.text, itemId);
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

  // clear all history dialog
  void _showClearHistoryDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Clear history'),
        content: Text('It will clear all your history in folder "$_appTitle"!'),
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
                clearHistory(
                  history: widget.history,
                  folderId: _currentFolderId,
                );
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
  }

  // change _currentFolderId from folders_page
  void _changeCurrentFolderId(int id) {
    _currentFolderId = id;
    setState(() {      
      _filterHistory();
    });
  }

  // show modalBottomSheet with all folders
  void _moveToFolderSheet(int itemIndex) {
    showModalBottomSheet(
      context: context, 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).disabledColor,
                      width: 1.0,
                    )
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Move to folder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: const Text('All history'),
                onTap: () {
                  Navigator.pop(context);
                  changeItemFolderId(widget.history, itemIndex, 0);
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.folders.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.folder_outlined),
                      title: Text(widget.folders[index]['folderName']),
                      onTap: () {
                        Navigator.pop(context);
                        final int selectedFolderId = widget.folders[index]['id'];
                        changeItemFolderId(widget.history, itemIndex, selectedFolderId);
                      },
                    );
                  }
                )
              ),
            ],
          ),
        );
      }
    );
  }

  void _navigateToFoldersPage() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => 
      FoldersPage(
        folders: widget.folders, 
        changeCurrentFolderId: _changeCurrentFolderId,
        changeAppTitle: _changeAppTitle,
        )
      )
    );
  }

  // filter history based on _currentFolderId
  // if _currentFolderId is 0, show all items in history
  void _filterHistory() {
    if(_currentFolderId == 0) {
      _filteredHistory = widget.history;
    } else {
      _filteredHistory = widget.history.where((item) => item['folderId'] == _currentFolderId).toList();
    }
  }

  // change app title based on folder
  void _changeAppTitle(String newTitle) {
    setState(() {
      _appTitle = newTitle;
    });
  }

  Widget _buildActionTile({
    required Widget leadingIcon,
    required Widget title,
    required Function() onTap,
  }) {
    return ListTile(
      leading: leadingIcon,
      title: title,
      onTap: onTap,
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
                TextButton(
                  onPressed: _navigateToFoldersPage,
                  child: const Icon(Icons.arrow_left)
                ),
                Text(_appTitle, style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _showClearHistoryDialog,
                  child: const Icon(Icons.delete_outline, color: Colors.red, size: 18,)
                ),
              ],
            ),
          ),
          // history list
          Expanded(
            child: (() {
              _filterHistory();
              return _filteredHistory.isEmpty
              ? const Center(child: Text('No history available', style: TextStyle(fontSize: 25)))
              : ListView.builder(
                itemCount: _filteredHistory.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1))
                        ),
                        child: ListTile(
                          title: Text(_filteredHistory[index]['expression'], style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20)),
                          subtitle: _filteredHistory[index]['comment'].toString().trim().isEmpty
                          ? null
                          : Text(_filteredHistory[index]['comment'], style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 13)),
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
                                      // first section
                                      _buildActionTile(leadingIcon: Icon(Icons.download), title: Text('Take expression'), onTap: () {
                                        Navigator.pop(context);
                                        insertData(_filteredHistory[index]['expression'], 'expression');
                                        widget.switchTab();
                                      }),
                                      _buildActionTile(leadingIcon: Icon(Icons.download), title: Text('Take result'), onTap: () {
                                        Navigator.pop(context);
                                        insertData(_filteredHistory[index]['expression'], 'result');
                                        widget.switchTab();
                                      }),
                                      // second section
                                      Divider(color: Theme.of(context).disabledColor),
                                      _buildActionTile(leadingIcon: Icon(Icons.copy), title: Text('Copy result'), onTap: () {
                                        Navigator.pop(context);
                                        String data = splitExpressionAndResult(_filteredHistory[index]['expression'], 'result');
                                        copyToClipboard(data);
                                      }),
                                      _buildActionTile(leadingIcon: Icon(Icons.copy_all), title: Text('Copy all'), onTap: () {
                                        Navigator.pop(context);
                                        String data = _filteredHistory[index]['expression'];
                                        copyToClipboard(data);
                                      }),
                                      // third section
                                      Divider(color: Theme.of(context).disabledColor),
                                      _buildActionTile(leadingIcon: Icon(Icons.drive_file_move_outline), title: Text('Move to folder'), onTap: () {
                                        Navigator.pop(context);
                                        _moveToFolderSheet(index);
                                      }),
                                      _buildActionTile(leadingIcon: Icon(Icons.comment_outlined), title: Text('Comment'), onTap: () {
                                        final int itemId = _filteredHistory[index]['id'];
                                        _showCommentSheet(itemId);
                                      }),
                                      _buildActionTile(leadingIcon: Icon(Icons.delete_outline, color: Colors.red,), title: Text('Delete', style: TextStyle(color: Colors.red),), onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          final int itemId = _filteredHistory[index]['id'];
                                          deleteItem(widget.history, itemId, 'history');
                                        });
                                      }),   
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
              );
            })()
          ),
        ],
      )
    );
  }
}