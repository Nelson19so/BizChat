import 'package:bizchat_frontend/core/helper/capitalize_helper.dart';
import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/core/widget/scaffholdmessage.dart';
import 'package:bizchat_frontend/core/widget/screen_loader.dart';
import 'package:bizchat_frontend/core/widget/show_dialog.dart';
import 'package:bizchat_frontend/features/provider/provders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double avatarRadius = 60.0;
    final double headerHeight = MediaQuery.of(context).size.height * 0.22;

    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    if (authState.isLoading) {
      return const ScreenLoader();
    }

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset('assets/svgs/Back.svg'),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: headerHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryWhite,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: avatarRadius + 16,
                    left: 24,
                    right: 24,
                    bottom: 16,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                '${user?.firstName.toCapitalized()}',
                                style: TextStyle(
                                  fontSize: 20,
                                 fontWeight: FontWeight.bold
                                ),
                              ),
                            ),

                            SizedBox(height: 61),

                            Column(
                              children: [
                                _settingsList(
                                  title: 'Account Details',
                                  icon: 'assets/svgs/profile-circle.svg',
                                  onClick: () => Navigator.of(context).pushNamed('/accountDetails'),
                                ),

                                _settingsList(
                                  title: 'Settings',
                                  icon: 'assets/svgs/setting-2.svg',
                                  onClick: () => Navigator.of(context).pushNamed('/notificationSettings'),
                                ),

                                _settingsList(
                                  title: 'Contact Us',
                                  icon: 'assets/svgs/sms-notification.svg',
                                  onClick: () => Navigator.of(context).pushNamed('/contactUs'),
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            await ref.read(authControllerProvider.notifier).logout();

                            final state = ref.read(authControllerProvider);

                            if (state.error == null) {
                              scaffholdmessage(
                                context: context,
                                message: state.success ?? 'Logged out successfully',
                                type: ScaffHoldMessageType.successful,
                              );

                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                    (route) => false,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor, // Noticeable accent color
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final confirmed = await showAppDialog(
                              context: context,
                              message: 'Do you want to delete this account?',
                              confirmText: 'Delete',
                            );

                            if (confirmed == true) {
                              await ref.read(authControllerProvider.notifier).deleteUser();

                              final state = ref.read(authControllerProvider);

                              if (state.error == null) {
                                scaffholdmessage(
                                  context: context,
                                  message: state.success ?? 'Account deleted successfully.',
                                  type: ScaffHoldMessageType.successful,
                                );

                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/register',
                                      (route) => false,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.secondaryWhite, // Noticeable accent color
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: headerHeight - avatarRadius,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondaryWhite,
                    width: 5.5,
                  ),
                ),
                child: Container(
                  height: 151,
                  width: 151,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E1E1),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: user?.profile.profilePicture != null
                          ? NetworkImage('${user?.profile.profilePicture}')
                          : const AssetImage('assets/images/ph_user-light.png'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsList({
    required String title,
    required String icon,
    required VoidCallback onClick
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 21),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.secondaryGray4,
              width: 1.0,
            ),
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, height: 20, width: 20,),

            const SizedBox(width: 16,),

            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }
}
