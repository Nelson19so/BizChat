import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.secondaryWhite,
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        )
      ),
    );
  }
}
