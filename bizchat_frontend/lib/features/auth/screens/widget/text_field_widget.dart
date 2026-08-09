import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:flutter/material.dart';

Widget textFieldWidget({
  required String hintLabelText,
  required TextEditingController textFieldController,
  required bool hasError
}) {
  final textFieldBorderColor =  hasError ? Colors.red : AppColors.secondaryGray4;

  return TextField(
    controller: textFieldController,
    decoration: InputDecoration(
      labelText: hintLabelText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: textFieldBorderColor,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: textFieldBorderColor,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      fillColor: AppColors.secondaryGray3,
      filled: true,
      labelStyle: TextStyle(
        color: hasError ? Colors.red : AppColors.secondaryGray5,
      ),
    ),
  );
}
