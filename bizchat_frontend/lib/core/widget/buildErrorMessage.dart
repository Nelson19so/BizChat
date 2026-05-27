import 'package:flutter/material.dart';

Widget buildErrorMessage(String? error) {
  if (error == null) return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.only(top: 5, left: 8),
    child: Text(
      '*$error',
      style: TextStyle(
        color: Colors.red, // Your custom color
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}