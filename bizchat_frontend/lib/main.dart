import 'package:bizchat_frontend/config/routes.dart';
import 'package:bizchat_frontend/core/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  await container.read(tokenStorageProvider).getAccessToken();

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'BizChat',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
      ),

      onGenerateRoute: AppRoute.generateRoute,
      initialRoute: AppRoute.homeScreen,
    );
  }
}
