import 'package:bizchat_frontend/core/widget/screen_loader.dart';
import 'package:bizchat_frontend/features/chat/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizchat_frontend/core/storage/token_storage.dart';
import 'package:bizchat_frontend/features/auth/screens/login.dart';

enum AccessMode { authOnly, guestOnly, both }

class SessionGate extends ConsumerWidget {
  final Widget child;
  final AccessMode mode;

  const SessionGate({
    super.key,
    required this.child,
    this.mode = AccessMode.authOnly,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(tokenStorageProvider);

    return FutureBuilder<String?>(
      future: storage.getAccessToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ScreenLoader();
        }

        final isLoggedIn = snapshot.data != null;

        switch (mode) {
          case AccessMode.authOnly:
            if (!isLoggedIn) {
              return const LoginScreen();
            }
            return child;

          case AccessMode.guestOnly:
            if (isLoggedIn) {
              return const HomeScreen();
            }
            return child;

          case AccessMode.both:
            return child;
        }
      },
    );
  }
}