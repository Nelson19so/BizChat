import 'package:bizchat_frontend/app_layout.dart';
import 'package:bizchat_frontend/core/helper/bottom_nav_helper.dart';
import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/core/widget/screen_loader.dart';
import 'package:bizchat_frontend/features/provider/provders.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (_loaded) return;
      _loaded = true;

      ref.read(authControllerProvider.notifier).getUser();
      ref.read(chatRoomsControllerProvider.notifier).getUserChatRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final chatRooms = ref.watch(chatRoomsControllerProvider);

    final user = authState.user;

    if (authState.isLoading || chatRooms.isLoadingRooms) {
      return const ScreenLoader();
    }

    return AppLayout(
      isHome: true,
      useBottomNav: true,
      currentIndex: 0,
      onTabSelected: (index) {
        BottomNavHelper.navigate(context, index);
      },
      header: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.all(11),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.secondaryWhiteGrey
                        ),
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: SvgPicture.asset('assets/svgs/Search.svg', height: 24, width: 24,),
                  ),
                ),

                Text(
                  'Home',
                  style: TextStyle(
                    color: AppColors.secondaryWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),

                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: SvgPicture.asset('assets/svgs/clarity_bell-outline-badged.svg'),
                    ),

                    SizedBox(width: 13,),

                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/accountDetails'),
                      child: Container(
                        height: 44,
                        width: 44,
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
                    )
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 40,),

          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: GestureDetector(
                    onTap: () {

                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepOrangeAccent,
                            ),
                            borderRadius: BorderRadius.circular(100)
                          ),
                          child: CircleAvatar(
                            radius: 26,
                            backgroundImage: user?.profile.profilePicture != null
                                ? NetworkImage('${user?.profile.profilePicture}')
                                : const AssetImage('assets/images/demo/demo_user.png') as ImageProvider,
                          ),
                        ),

                        const SizedBox(height: 10,),

                        Text(
                          'Marina',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryWhite
                          ),
                        )
                      ],
                    )
                  ),
                );
              }
            ),
          )
        ],
      ),

      child: Column(
        children: [
          Container(
            height: 4,
            width: 45,
            decoration: BoxDecoration(
              color: Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          const SizedBox(height: 24,),

          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (kDebugMode) {
                      print(index);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundImage: user?.profile.profilePicture != null
                                ? NetworkImage('${user?.profile.profilePicture}')
                                : const AssetImage('assets/images/demo/demo_user.png') as ImageProvider,
                            ),

                            const SizedBox(width: 12,),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Alex Linderson',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondaryBlack,
                                    ),
                                  ),

                                  Text(
                                    'How are you doing today? How are you doing today?',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.secondaryWhiteGrey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 4,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('2 min ago', style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryWhiteGrey,
                          ),),

                          const SizedBox(height: 7,),

                          Container(
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(100)
                            ),
                            child: Text('8', style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryWhite,
                            ),),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },

              separatorBuilder: (context, index) => const SizedBox(height: 30,),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}
