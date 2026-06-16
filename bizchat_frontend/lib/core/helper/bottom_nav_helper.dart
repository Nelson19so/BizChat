import 'package:bizchat_frontend/config/routes.dart';
import 'package:flutter/material.dart';

class BottomNavHelper {
  static const routes = [
    AppRoute.homeScreen,
    AppRoute.customerScreen,
    AppRoute.settingsScreen,
  ];

  static void navigate(BuildContext context, int index) {
    Navigator.pushNamed(
      context,
      routes[index],
    );
  }
}