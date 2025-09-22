import 'package:flutter/material.dart';

Widget topBar({
  required BuildContext context,
  required Widget child,
  required Color bgColor
}) {
  return Container(
    decoration: BoxDecoration(
      color: bgColor,
    ),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: child
  );
}