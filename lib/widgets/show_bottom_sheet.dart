import 'package:flutter/material.dart';

// template for showModalBottomSheet
void showCustomBottomSheet({
  required BuildContext context,
  Color? backgroundColor,
  required Widget child,
}) {
  showModalBottomSheet(
    context: context, 
    backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10))
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child
      );
    }
  );
}