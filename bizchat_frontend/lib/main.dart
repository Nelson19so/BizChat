import 'package:bizchat_frontend/config/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BizChat',
      onGenerateRoute: AppRoute.generateRoute,
      initialRoute: AppRoute.loginScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}
