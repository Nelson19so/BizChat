import 'package:bizchat_frontend/app_layout.dart';
import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _isSwitchedOn1 = false;
  bool _isSwitchedOn2 = false;

  @override
  Widget build(BuildContext context) {
    return AppLayout(
        useDefaultPaddingForHome: false,
        header: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset('assets/svgs/chevron-left.svg'),
            ),

            const SizedBox(width: 12,),

            const Text(
              'My Profile',
              style: TextStyle(
                color: AppColors.secondaryWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),

        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: 17),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 34,
                    color: AppColors.secondaryBlack,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15,),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.secondaryGray4,
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8
              ),
              child: Text(
                'GENERAL',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryGray8,
                ),
              ),
            ),

            const SizedBox(height: 16,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/svgs/message-notif.svg'),

                          const SizedBox(width: 8,),

                          const Text(
                            'Message Notifications',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.secondaryBlack,
                            ),
                          )
                        ],
                      ),

                      CupertinoSwitch(
                        value: _isSwitchedOn1,
                        activeTrackColor: CupertinoColors.systemGreen,
                        onChanged: (bool newValue) {
                          setState(() {
                            _isSwitchedOn1 = newValue;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/svgs/user-square.svg'),

                          const SizedBox(width: 8,),

                          const Text(
                            'no-reply message setting',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.secondaryBlack,
                            ),
                          )
                        ],
                      ),

                      CupertinoSwitch(
                        value: _isSwitchedOn2,
                        activeTrackColor: CupertinoColors.systemGreen,
                        onChanged: (bool newValue) {
                          setState(() {
                            _isSwitchedOn2 = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              )
            )
          ],
        )
    );
  }
}
