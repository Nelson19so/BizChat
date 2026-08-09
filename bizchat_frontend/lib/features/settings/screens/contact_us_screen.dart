import 'package:bizchat_frontend/app_layout.dart';
import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
                'Contact Us',
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
              'CONTACT',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondaryGray8,
              ),
            ),
          ),

          const SizedBox(height: 16,),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/svgs/sms.svg'),

                    const SizedBox(width: 8,),
                    
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.secondaryBlack,
                      ),
                    )
                  ],
                ),

                Text(
                  'Info@youremailid.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3D4260)
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
