import 'package:bizchat_frontend/app_layout.dart';
import 'package:bizchat_frontend/core/helper/bottom_nav_helper.dart';
import 'package:flutter/material.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      useBottomNav: true,
      currentIndex: 1,
      onTabSelected: (index) {
        BottomNavHelper.navigate(context, index);
      },
      header: const Row(
        children: [],
      ),
      child: const Center(child: Text('Customers'))
    );
  }
}
