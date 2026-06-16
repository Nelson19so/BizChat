import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:flutter/material.dart';

enum ScaffHoldMessageType { successful, failed }

// Added BuildContext context to the arguments
ScaffoldFeatureController<SnackBar, SnackBarClosedReason> scaffholdmessage({
  required BuildContext context,
  required String message,
  required ScaffHoldMessageType type,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: type == ScaffHoldMessageType.successful
          ? AppColors.primaryColor
          : Colors.red,
      duration: const Duration(seconds: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.only(
        bottom: 24.0,
        left: 16.0,
        right: 16.0,
      ),
    ),
  );
}
