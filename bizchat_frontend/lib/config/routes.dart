import 'package:bizchat_frontend/features/auth/screens/guards/session_gate.dart';
import 'package:bizchat_frontend/features/auth/screens/login.dart';
import 'package:bizchat_frontend/features/auth/screens/register.dart';
import 'package:bizchat_frontend/features/chat/screens/home.dart';
import 'package:flutter/material.dart';

class AppRoute {
  // Chat routes
  static const String homeScreen = '/chat';

  // Authentication & user routes
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';

  static final Map<String, WidgetBuilder> routes = {
    // Home screen
    homeScreen: (_) => SessionGate(
      mode: AccessMode.authOnly, child: HomeScreen()
    ),

    // Auth screens
    loginScreen: (_) => SessionGate(
      mode: AccessMode.guestOnly, child: LoginScreen()
    ),
    registerScreen: (_) => SessionGate(
      mode: AccessMode.guestOnly, child: Register()
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
