import 'package:flutter/material.dart';

Widget topBar({
  required BuildContext context,
  required Widget child,
}) {
  return Container(
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
    child: child
  );
}