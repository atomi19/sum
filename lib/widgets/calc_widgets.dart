import 'package:flutter/material.dart';

// build calculator button
Widget calcButton({
  required Widget child,
  required VoidCallback onPressed,
  VoidCallback? onLongPress,
  int flex = 1,
}) {
  return Expanded(
    flex: flex,
    child: SizedBox.expand(
      child: TextButton(
        onPressed: onPressed, 
        onLongPress: onLongPress,
        child: child,
      ),
    )
  );
}

// build row with buttons
Widget buttonRow(List<Widget> buttons) {
  return Expanded(
    child: Row(
      children: [
        const SizedBox(width: 5),
        ...buttons.expand((button) => [button, const SizedBox(width: 5)])
      ],
    )
  );
}