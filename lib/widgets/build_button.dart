import 'package:flutter/material.dart';

Widget buildIconButton({
  required BuildContext context,
  required VoidCallback onTap,
  required Color color,
  required IconData icon
}) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondary,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.shadow,
          blurRadius: 4,
          offset: Offset(0, 2),
        )
      ]
    ),
    child: Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(icon, color: color, size: 25),
        ),
      )
    )
  );
}