import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ChatListWidget extends StatelessWidget {
  final String userName;
  final String userLastMessage;
  final String userLastMessageTimeOrDate;
  final ImageProvider userProfilePic;

  const ChatListWidget({
    super.key,
    required this.userName,
    required this.userLastMessage,
    required this.userLastMessageTimeOrDate,
    required this.userProfilePic
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                      userLastMessage,
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
            Text('$userLastMessageTimeOrDate', style: TextStyle(
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
    );
  }
}
