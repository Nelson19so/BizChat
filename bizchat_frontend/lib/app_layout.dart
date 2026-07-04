import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLayout extends StatelessWidget {
  final Widget header;
  final Widget child;
  final bool isHome;
  final int currentIndex;
  final ValueChanged<int>? onTabSelected;
  final bool useBottomNav;
  final bool useDefaultPaddingForHome;

  const AppLayout({
    super.key,
    required this.header,
    required this.child,
    this.isHome = false,
    this.currentIndex = 0,
    this.onTabSelected,
    this.useBottomNav = false,
    this.useDefaultPaddingForHome = true
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // App layer header
            Padding(
              padding: EdgeInsets.only(
                top: 17,
                left: isHome ? 0 : 24,
                right: isHome ? 0 : 24,
                bottom: 30
              ),
              child: header,
            ),

            // App layout body
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 14,
                  left: useDefaultPaddingForHome ? 24 : 0,
                  right: useDefaultPaddingForHome ? 24 : 0,
                  bottom: 9
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)
                  ),
                ),
                child: child
              ),
            ),
          ],
        )
      ),

      // Bottom Navigation Bar Integration
      bottomNavigationBar: useBottomNav ? Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.secondaryWhite,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTabSelected,
          backgroundColor: AppColors.secondaryWhite,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: AppColors.secondaryWhiteGrey,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 16,
          unselectedFontSize: 16,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/svgs/Message.svg'),
              activeIcon: SvgPicture.asset('assets/svgs/Message.svg', color: AppColors.primaryColor,),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/svgs/user.svg'),
              activeIcon: SvgPicture.asset('assets/svgs/user.svg', color: AppColors.primaryColor,),
              label: 'Customers',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/svgs/settings.svg'),
              activeIcon: SvgPicture.asset('assets/svgs/settings.svg', color: AppColors.primaryColor,),
              label: 'Settings',
            ),
          ],
        ),
      ) : null,
    );
  }
}
