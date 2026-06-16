import 'package:bizchat_frontend/features/auth/screens/guards/session_gate.dart';
import 'package:bizchat_frontend/features/auth/screens/login.dart';
import 'package:bizchat_frontend/features/auth/screens/register.dart';
import 'package:bizchat_frontend/features/chat/screens/customer_screen.dart';
import 'package:bizchat_frontend/features/chat/screens/home.dart';
import 'package:bizchat_frontend/features/chat/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class AppRoute {
  // Chat routes
  static const String homeScreen = '/chat';
  static const String customerScreen = '/customer';
  static const String settingsScreen = '/settings';

  // Authentication & user routes
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';

  static final Map<String, WidgetBuilder> routes = {
    // Home screen
    homeScreen: (_) => SessionGate(
      mode: AccessMode.authOnly,
      child: const HomeScreen()
    ),

    customerScreen: (_) => SessionGate(
      mode: AccessMode.authOnly,
      child: const CustomerScreen(),
    ),

    settingsScreen: (_) => SessionGate(
      mode: AccessMode.authOnly,
      child: const SettingsScreen(),
    ),

    // Auth screens
    loginScreen: (_) => SessionGate(
      mode: AccessMode.guestOnly,
      child: const LoginScreen()
    ),

    registerScreen: (_) => SessionGate(
      mode: AccessMode.guestOnly,
      child: const Register()
    ),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('404 wrong page'))),
    );
  }
}
