import 'package:bizchat_frontend/features/auth/screens/guards/session_gate.dart';
import 'package:bizchat_frontend/features/auth/screens/login.dart';
import 'package:bizchat_frontend/features/auth/screens/register.dart';
import 'package:bizchat_frontend/features/chat/screens/customer_screen.dart';
import 'package:bizchat_frontend/features/chat/screens/home.dart';
import 'package:bizchat_frontend/features/settings/screens/account_profile_screen.dart';
import 'package:bizchat_frontend/features/settings/screens/contact_us_screen.dart';
import 'package:bizchat_frontend/features/settings/screens/edit_profile_screen.dart';
import 'package:bizchat_frontend/features/settings/screens/notification_settings_screen.dart';
import 'package:bizchat_frontend/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class AppRoute {
  /// Chat routes
  static const String homeScreen = '/chat';

  /// Customer route
  static const String customerScreen = '/customer';

  /// Settings route
  static const String settingsScreen = '/settings';
  static const String contactUsScreen = '/contactUs';
  static const String notificationSettingsScreen = '/notificationSettings';
  static const String accountDetailsScreen = '/accountDetails';
  static const String editProfileScreen = '/editProfile';

  /// Authentication & user routes
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';

  static final Map<String, WidgetBuilder> routes = {
    /// Home screen
    homeScreen: (_) => SessionGate(
      mode: AccessMode.authOnly,
      child: const HomeScreen()
    ),

    /// Costumer screens
    customerScreen: (_) => SessionGate(
      mode: AccessMode.authOnly,
      child: const CustomerScreen(),
    ),

    /// Settings screens
    settingsScreen: (_) => SessionGate(
      mode: AccessMode.authOnly,
      child: const SettingsScreen(),
    ),
    contactUsScreen: (_) => SessionGate(
      mode: AccessMode.authOnly,
      child: const ContactUsScreen()
    ),
    notificationSettingsScreen: (_) => SessionGate(
      mode: AccessMode.authOnly,
      child: const NotificationSettingsScreen(),
    ),
    accountDetailsScreen: (_) => SessionGate(
      mode: AccessMode.authOnly,
      child: const AccountProfileScreen(),
    ),
    editProfileScreen: (_) => SessionGate(
      mode: AccessMode.authOnly,
      child: const EditProfileScreen()
    ),

    /// Auth screens
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
