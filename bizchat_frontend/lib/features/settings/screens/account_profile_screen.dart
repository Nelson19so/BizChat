import 'package:bizchat_frontend/app_layout.dart';
import 'package:bizchat_frontend/core/helper/capitalize_helper.dart';
import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/core/widget/full_screen_image_viewer.dart';
import 'package:bizchat_frontend/core/widget/screen_loader.dart';
import 'package:bizchat_frontend/features/provider/provders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountProfileScreen extends ConsumerWidget {
  const AccountProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double avatarRadius = 60.0;

    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    if (authState.isLoading) {
      return const ScreenLoader();
    }

    String cleanValue(dynamic value) {
      if (value == null) return '--';
      final str = value.toString().trim();
      if (str.isEmpty || str.toLowerCase() == 'null') return '--';
      return str;
    }

    final profilePic = user?.profile.profilePicture;

    final fullName = cleanValue(
      '${user?.firstName.toCapitalized()} ${user?.lastName.toCapitalized()}'
    );
    final country = cleanValue(user?.profile.country);
    final dateOfBirth = cleanValue(user?.profile.dateOfBirth);
    final phone = cleanValue(user?.profile.phoneNumber);
    final email = cleanValue(user?.email);

    return AppLayout(
      header: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset('assets/svgs/Back.svg'),
              ),

              Text(
                'Profile',
                style: TextStyle(
                  color: AppColors.secondaryWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(),
            ],
          ),

          const SizedBox(height: 20,),
        ],
      ),

      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    final ImageProvider targetImage;

                    if (profilePic != null && profilePic!.contains('http')) {
                      targetImage = NetworkImage(profilePic!);
                    } else {
                      targetImage = const AssetImage('assets/images/ph_user-light.png');
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(imageProvider: targetImage),
                      ),
                    );
                  },
                  child: Container(
                    height: 151,
                    width: 151,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1E1E1),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: profilePic != null
                            ? NetworkImage(profilePic)
                            : const AssetImage('assets/images/ph_user-light.png'),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 44,),

                _profileDetails(
                  title: fullName,
                  type: 'name',
                  subTitle: country,
                  isVerified: user?.profile.verified,
                ),

                _profileDetails(
                  title: 'Birthday',
                  type: 'date',
                  subTitle: dateOfBirth,
                ),

                _profileDetails(
                  title: 'Phone Number',
                  type: 'phoneNo',
                  subTitle: phone,
                ),

                _profileDetails(
                  title: 'Email',
                  type: 'email',
                  subTitle: email,
                )
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // minimumSize: const Size(200, 50),
              ),
              onPressed: () => Navigator.of(context).pushNamed('/editProfile'),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  color: AppColors.secondaryWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20,),
        ],
      )
    );
  }

  Widget _profileDetails({
    required String title,
    required String type,
    required String subTitle,
    isVerified = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 21),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.secondaryGray4,
            width: 1.0,
          ),
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: type == 'name' ? 28 : 15,
                      fontWeight: type == 'name' ? FontWeight.w700 : FontWeight.bold
                    ),
                  ),

                  const SizedBox(width: 14,),

                  if (isVerified)
                    SvgPicture.asset('assets/svgs/verify.svg')
                ],
              ),

              if (type == 'date')
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3D4260),
                  ),
                ),
            ],
          ),

          if (type != 'date')
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF3D4260),
              ),
            ),
        ],
      )
    );
  }
}
