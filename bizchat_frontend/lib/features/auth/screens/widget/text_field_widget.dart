import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:flutter/material.dart';

Widget textFieldWidget({
  required String hintLabelText,
  required TextEditingController textFieldController,
  required bool hasError
}) {
  final textFieldBorderColor =  hasError ? AppColors.secondaryGray4 : Colors.red;

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
        color: hasError ? AppColors.secondaryGray5 : Colors.red,
      ),
    ),
  );
}
