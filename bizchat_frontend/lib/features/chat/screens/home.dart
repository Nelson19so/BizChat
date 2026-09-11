import 'package:bizchat_frontend/app_layout.dart';
import 'package:bizchat_frontend/core/helper/bottom_nav_helper.dart';
import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/core/widget/screen_loader.dart';
import 'package:bizchat_frontend/features/chat/widget/chat_list_widget.dart';
import 'package:bizchat_frontend/features/provider/provders.dart';
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
              color: const Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          const SizedBox(height: 24,),

          (chatRooms.error != null)
              ? Expanded(
            child: Center(
              child: Text(
                'Error: ${chatRooms.error}',
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            ),
          )
              : (chatRooms.rooms == null || chatRooms.rooms!.isEmpty)
              ? const Expanded(
            child: Center(
              child: Text(
                'No chats yet',
                style: TextStyle(
                  color: AppColors.secondaryBlack2,
                  fontSize: 16,
                ),
              ),
            ),
          )

              : Expanded(
            child: ListView.separated(
              itemCount: chatRooms.rooms!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 30,),
              itemBuilder: (context, index) {
                final room = chatRooms.rooms![index];
                final chatUser = room.user;

                final ImageProvider profileImage = (chatUser?.profile.profilePicture != null && chatUser!.profile.profilePicture!.isNotEmpty)
                    ? NetworkImage(chatUser.profile.profilePicture!)
                    : const AssetImage('assets/images/demo/demo_user.png');

                return GestureDetector(
                  onTap: () {
                    // Handle chat screen navigation here
                  },
                  child: ChatListWidget(
                    userName: '${chatUser?.firstName} ${chatUser?.lastName}',
                    userLastMessage: room.lastMessage.isNotEmpty ? room.lastMessage : "",
                    userLastMessageTimeOrDate: room.lastMessageTime != null
                        ? '${room.lastMessageTime!.hour}:${room.lastMessageTime!.minute}'
                        : '',
                    userProfilePic: profileImage,
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
