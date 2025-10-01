import 'package:flutter/material.dart';

// show alert dialog
void showAlertDialog({
  required BuildContext context,
  EdgeInsets? contentPadding,
  String? title,
  required Widget content,
  List<Widget>? actions,
}) {
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      contentPadding: contentPadding ?? EdgeInsets.fromLTRB(20, 0, 20, 10),
      actionsPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: title != null ? Text(title) : null,
      content: content,
      actions: actions,
    )
  );
}