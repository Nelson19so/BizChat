import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/features/chat/screens/message_screen.dart';
import 'package:flutter/material.dart';

class ChatListWidget extends StatelessWidget {
  final int userId;
  final String userName;
  final String? userLastMessage;
  final String? userLastMessageTimeOrDate;
  final ImageProvider userProfilePic;
  final int? unreadMessagesCount;

  const ChatListWidget({
    super.key,
    required this.userName,
    this.userLastMessage,
    this.userLastMessageTimeOrDate,
    required this.userProfilePic,
    this.unreadMessagesCount,
    required this.userId
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        // Create or get the room
        Navigator.push(
          context, MaterialPageRoute(
            builder: (context) => MessageScreen(roomId: userId)
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
                CircleAvatar(
                  radius: 26,
                  backgroundImage: userProfilePic,
                ),

                const SizedBox(width: 12,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondaryBlack,
                        ),
                      ),

                      Text(
                        userLastMessage ?? "--- No Message Yet ---",
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
              if (userLastMessageTimeOrDate != null)
                Text(userLastMessageTimeOrDate!, style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondaryWhiteGrey,
                ),),

              const SizedBox(height: 7,),

              if (unreadMessagesCount != null)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(100)
                  ),
                  child: Text("$unreadMessagesCount", style: TextStyle(
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
  }
}
