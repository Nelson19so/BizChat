import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/features/chat/screens/message_screen.dart';
import 'package:bizchat_frontend/features/provider/providers.dart';
import 'package:bizchat_frontend/features/settings/screens/account_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widget/scaffholdmessage.dart';

class ChatListWidget extends ConsumerWidget {
  final int? userId;
  final String? userName;
  final String? userLastMessage;
  final String? userLastMessageTimeOrDate;
  final ImageProvider? userProfilePic;
  final int? unreadMessagesCount;
  final bool? isLoadingItem;

  const ChatListWidget({
    super.key,
    required this.userName,
    this.userLastMessage,
    this.userLastMessageTimeOrDate,
    required this.userProfilePic,
    this.unreadMessagesCount,
    required this.userId,
    this.isLoadingItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = isLoadingItem != true
        ? userProfilePic
        :  const AssetImage(
        'assets/images/ph_user-light.png'
    ) as ImageProvider;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isLoadingItem == true ? null : () async {
        // Create or get the room
        await ref.read(chatRoomsControllerProvider.notifier)
            .getOrCreateChatRoom(userId!);

        if (!context.mounted) return;

        final roomController = ref.read(chatRoomsControllerProvider);

        if (
          roomController.createGetRoomError != null &&
          roomController.createGetRoomError!.isNotEmpty
        ) {
          final controller = ref.read(chatRoomsControllerProvider);

          scaffholdmessage(
              context: context,
              message: '${controller.createGetRoomError}',
              type: ScaffHoldMessageType.failed
          );
        }

        Navigator.push(
            context, MaterialPageRoute(
            builder: (context) => MessageScreen(
              roomId: roomController.roomId,
              userProfilePic: avatar as ImageProvider,
              userName: "$userName",
              userId: userId,
            )
        )
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: isLoadingItem == false ? () => Navigator.push(
                    context, MaterialPageRoute(
                      builder: (context) => AccountProfileScreen(),
                    )
                  ) : null,
                  child: CircleAvatar(
                    radius: 26,
                    backgroundImage: avatar
                  ),
                ),

                const SizedBox(width: 12,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoadingItem != true ?
                        Text(
                          userName!,
                          maxLines: 1,
                          textAlign:TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondaryBlack,
                          ),
                        ) : Container(
                              height: 10,
                              width: 75,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),

                      ?isLoadingItem == true ? const SizedBox(height: 10,) : null,

                      if (isLoadingItem == true || (userLastMessage != null && userLastMessage!.isNotEmpty))
                        isLoadingItem != true ?
                          Text(
                            '$userLastMessage',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.secondaryWhiteGrey,
                            ),
                          ) : Container(
                            height: 10,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
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
              if (
                userLastMessageTimeOrDate != null &&
                userLastMessageTimeOrDate != 'null' &&
                userLastMessageTimeOrDate!.isNotEmpty
              )
                Text(
                  "$userLastMessageTimeOrDate",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryWhiteGrey,
                  ),
                ),

              const SizedBox(height: 7,),

              if (unreadMessagesCount != null)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: Text(
                    "$unreadMessagesCount",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondaryWhite,
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}
