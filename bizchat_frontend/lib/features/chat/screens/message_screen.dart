import 'package:bizchat_frontend/features/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final int? roomId;
  final ImageProvider userProfilePic;
  final String userName;
  const MessageScreen({
    super.key,
    required this.roomId,
    required this.userProfilePic,
    required this.userName,
  });

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  @override
  void initState() {
    Future.microtask(() {
      final roomId = widget.roomId;

      ref
          .read(chatRoomsControllerProvider.notifier)
          .getUserChatRoomMessages(roomId!);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomMessages = ref.watch(chatRoomsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 12,
        elevation: 1,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: SvgPicture.asset(
                'assets/svgs/Back.svg',
                color: Colors.black,
              ),
            ),

            const SizedBox(width: 12),

            Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundImage: widget.userProfilePic,
                ),

                const SizedBox(width: 10),

                Text(widget.userName, style: TextStyle(fontSize: 15)),
              ],
            ),
          ],
        ),
      ),

      // body: SafeArea(
      //   child: ListView.separated(
      //     itemBuilder: (context, index) {
      //       final chatMessage = chatRoomMessages.roomMessages![index];
      //
      //       return Text("Text Message Screen ${chatMessage.id}");
      //     },
      //     separatorBuilder: (context, index) => const SizedBox(height: 30,),
      //     itemCount: chatRoomMessages.roomMessages!.length,
      //   )
      // )
    );
  }
}
