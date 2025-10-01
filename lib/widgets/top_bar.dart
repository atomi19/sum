import 'package:flutter/material.dart';

Widget topBar({
  required BuildContext context,
  required Widget child,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.transparent,
    ),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: child
  );
}