import 'package:bizchat_frontend/features/auth/screens/login.dart';
import 'package:bizchat_frontend/features/auth/screens/register.dart';
import 'package:bizchat_frontend/features/chat/screens/home.dart';
import 'package:flutter/material.dart';

class AppRoute {
  // Chat routes
  static const String homeScreen = '/';

  // Authentication & user routes
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';

  static final Map<String, WidgetBuilder> routes = {
    homeScreen: (_) => HomeScreen(),
    loginScreen: (_) => LoginScreen(),
    registerScreen: (_) => Register(),
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
