import 'package:flutter/material.dart';
import 'package:sum/pages/folders_page.dart';
import 'package:sum/utils/calculator_utils.dart';
import 'package:sum/widgets/build_button.dart';
import 'package:sum/widgets/show_alert_dialog.dart';
import 'package:sum/widgets/top_bar.dart';
import 'package:sum/widgets/show_bottom_sheet.dart';

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
  String _appTitle = 'All History';

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

  // comment modalBottomSheet
  void _showCommentSheet(int itemId) {
    // find item comment and set commentController with this comment
    final item = widget.history.firstWhere((item) => item['id'] == itemId);
    String comment = item['comment'];
    widget.commentController.text = comment;

    showCustomBottomSheet(
      context: context,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // top bar of comment modalBottomSheet
            topBar(
              context: context, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // close button
                  buildIconButton(
                    context: context, 
                    onTap: () { 
                      Navigator.pop(context);
                      widget.commentController.clear();
                    },
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icons.close
                  ),
                  const Text('Comment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  // done button
                  buildIconButton(
                    context: context, 
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        addComment(widget.history, widget.commentController.text, itemId);
                      });
                      widget.commentController.clear();
                    },
                    color: Theme.of(context).colorScheme.primary,
                    icon: Icons.check
                  )
                ],
              ),
            ),
            // comment text field
            TextField(
              controller: widget.commentController,
              minLines: 10,
              maxLines: 20,
              cursorColor: Theme.of(context).colorScheme.primary,
              decoration: InputDecoration(
                hintText: 'Enter Comment',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
                hoverColor: Colors.transparent
              ),
            )
          ],
        ),
      )
    );
  }

  // clear all history dialog
  void _showClearHistoryDialog() {
    showAlertDialog(
      context: context,
      title:  'Clear History',
      content: Text('It will clear all your history in folder $_appTitle'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  padding: EdgeInsets.all(25)
                ),
                child: const Text('Cancel'),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    clearHistory(
                      history: widget.history,
                      folderId: _currentFolderId,
                    );
                  });
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  padding: EdgeInsets.all(25)
                ),
                child: const Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            )
          ],
        )
      ],
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
    showCustomBottomSheet(
      context: context, 
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
                  SizedBox(width: 24),
                  const Text('Move To Folder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(width: 24),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('All History'),
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

  // actions for item in history
  void _showActionsSheet(int index) {
    showCustomBottomSheet(
      context: context, 
      child: Wrap(
        children: [
          // first section
          _buildActionTile(leadingIcon: Icon(Icons.download), title: Text('Take Expression'), onTap: () {
            Navigator.pop(context);
            insertData(_filteredHistory[index]['expression'], 'expression');
            widget.switchTab();
          }),
          _buildActionTile(leadingIcon: Icon(Icons.download), title: Text('Take Result'), onTap: () {
            Navigator.pop(context);
            insertData(_filteredHistory[index]['expression'], 'result');
            widget.switchTab();
          }),
          // second section
          Divider(color: Theme.of(context).disabledColor),
          _buildActionTile(leadingIcon: Icon(Icons.copy), title: Text('Copy Result'), onTap: () {
            Navigator.pop(context);
            String data = splitExpressionAndResult(_filteredHistory[index]['expression'], 'result');
            copyToClipboard(data);
          }),
          _buildActionTile(leadingIcon: Icon(Icons.copy_all), title: Text('Copy All'), onTap: () {
            Navigator.pop(context);
            String data = _filteredHistory[index]['expression'];
            copyToClipboard(data);
          }),
          // third section
          Divider(color: Theme.of(context).disabledColor),
          _buildActionTile(leadingIcon: Icon(Icons.drive_file_move_outline), title: Text('Move To Folder'), onTap: () {
            Navigator.pop(context);
            _moveToFolderSheet(index);
          }),
          _buildActionTile(leadingIcon: Icon(Icons.comment_outlined), title: Text('Comment'), onTap: () {
            Navigator.pop(context);
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
          // top bar
          topBar(
            context: context, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // back button
                buildIconButton(
                  context: context, 
                  onTap: _navigateToFoldersPage, 
                  color: Theme.of(context).colorScheme.primary,
                  icon: Icons.arrow_back
                ),
                Text(_appTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                // clear history button
                buildIconButton(
                  context: context, 
                  onTap: _showClearHistoryDialog,
                  color: Colors.red,
                  icon: Icons.delete_outline
                )
              ],
            ),
          ),
          // history list
          Expanded(
            child: (() {
              _filterHistory();
              return _filteredHistory.isEmpty
              ? const Center(child: Text('No History Available', style: TextStyle(fontSize: 25)))
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
                          onTap: () => _showActionsSheet(index),
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