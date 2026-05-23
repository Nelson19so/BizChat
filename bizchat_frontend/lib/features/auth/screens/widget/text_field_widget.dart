import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:flutter/material.dart';

Widget textFieldWidget({required String hintLabelText, required TextEditingController textFieldController}) {
  return TextField(
    controller: textFieldController,
    decoration: InputDecoration(
      labelText: hintLabelText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.secondaryGray4,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.secondaryGray4,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      fillColor: AppColors.secondaryGray3,
      filled: true,
      labelStyle: TextStyle(
        color: AppColors.secondaryGray5,
      ),
    ),
  );
}
