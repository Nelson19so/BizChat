import 'dart:convert';

import 'package:bizchat_frontend/core/helper/get_time_ago_helper.dart';
import 'package:bizchat_frontend/core/network/api_routes.dart';
import 'package:bizchat_frontend/core/storage/token_storage.dart';
import 'package:bizchat_frontend/core/theme/theme.dart';
import 'package:bizchat_frontend/core/widget/scaffholdmessage.dart';
import 'package:bizchat_frontend/core/widget/screen_loader.dart';
import 'package:bizchat_frontend/features/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final int? roomId;
  final int? userId;
  final ImageProvider userProfilePic;
  final String userName;

  const MessageScreen({
    super.key,
    required this.roomId,
    required this.userProfilePic,
    required this.userName,
    required this.userId,
  });

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final _messageController = TextEditingController();

  bool _canShowSendButton = false;

  late WebSocketChannel _channel;

  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];

  void _handleMessageControllerChange() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _canShowSendButton = true;
      });
    } else {
      setState(() {
        _canShowSendButton = false;
      });
    }
  }

  void _connectWebSocket() async {
    String? token = await ref.read(tokenStorageProvider).getAccessToken();

    final url = Uri.parse(
      '${ApiRoutes.webSocketBaseUrl}${ApiRoutes.channelMessage}${widget.roomId}/?token=$token',
    );
    _channel = WebSocketChannel.connect(url);

    _channel.stream.listen(
      (data) {
        final decodeData = jsonDecode(data);

        setState(() {
          _messages.add({
            "message": decodeData['message'],
            "sender_id": decodeData['user_id'],
            "timestamp": decodeData['timestamp'],
          });
        });

        _scrollToBottom();
      },
      onError: (error) {
        if (!mounted) return;

        scaffholdmessage(
          context: context,
          message: error,
          type: ScaffHoldMessageType.failed,
        );
      },
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final payload = {"message": _messageController.text.trim()};

    _channel.sink.add(jsonEncode(payload));
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 100),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_handleMessageControllerChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messageState = ref.watch(chatRoomsControllerProvider).isLoadingMessages;

      if (messageState == false) {
        _scrollToBottom();
      }
    });

    Future.microtask(() {
      final roomId = widget.roomId;

      ref
          .read(chatRoomsControllerProvider.notifier)
          .getUserChatRoomMessages(roomId!);
    });

    _connectWebSocket();
  }


  @override
  void dispose() {
    _channel.sink.close();

    _messageController.dispose();
    _scrollController.dispose();

    _messageController.removeListener(_handleMessageControllerChange);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref
        .watch(chatRoomsControllerProvider);
    final historicalMessages = messageState.roomMessages;

    final List<Map<String, dynamic>> allMessages = [
      ...?historicalMessages?.map(
        (msg) => {
          "message": msg.text,
          "sender_id": msg.sender?.id,
          "timestamp": msg.createdAt,
        },
      ),
      ..._messages,
    ];

    // if (messageState.isLoadingMessages == true) {
    //   return ScreenLoader();
    // }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 12,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        shadowColor: Color(0xFFEEFAF8).withOpacity(0.5),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                  final state = ref
                      .read(chatRoomsControllerProvider.notifier);

                await state.getUserChatRooms();
                state.clearMessages();
                allMessages.clear();
                Navigator.pop(context, true);
              },
              icon: SvgPicture.asset(
                'assets/svgs/Back.svg',
                color: Colors.black,
              ),
            ),

            const SizedBox(width: 12),

            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: widget.userProfilePic,
                ),

                const SizedBox(width: 10),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),

                    Text(
                      'Active now',
                      style: TextStyle(fontSize: 12, color: Color(0xFF797C7B)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: GroupedListView<dynamic, DateTime>(
                controller: _scrollController,
                elements: allMessages,

                groupBy: (message) {
                  final dt = parseDate(message["timestamp"]);
                  return DateTime(dt.year, dt.month, dt.day);
                },

                itemComparator: (msg1, msg2) {
                  final dt1 = parseDate(msg1['timestamp']);
                  final dt2 = parseDate(msg2['timestamp']);
                  return dt1.compareTo(dt2);
                },
                useStickyGroupSeparators: true,

                groupSeparatorBuilder: (DateTime date) => Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.transparent
                  ),
                  child: Text(
                    formatHeaderDate(date),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ),

                itemBuilder: (context, message) {
                  final userId = ref.watch(authControllerProvider).user?.id;
                  final isMe = message['sender_id'] == userId;

                  final int currentIndex = allMessages.indexOf(message);

                  bool showTime = true;
                  if (currentIndex < allMessages.length - 1) {
                    final nextMessage = allMessages[currentIndex + 1];

                    final currentTime = getTimeAgo(parseDate(message["timestamp"]));
                    final nextTime = getTimeAgo(parseDate(message["timestamp"]));

                    if (nextMessage["sender_id"] == message["sender_id"] && currentTime == nextTime) {
                      showTime = false;
                    }
                  }

                  return Align(
                    alignment: isMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 20, top: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isMe == false)
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  backgroundImage: widget.userProfilePic,
                                ),

                                const SizedBox(width: 10),

                                Text(
                                  widget.userName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                          IntrinsicWidth(
                            child: Padding(
                              padding: EdgeInsetsGeometry.only(
                                left: isMe ? 0 : 50,
                                top: isMe ? 0 : 12,
                                bottom: 0,
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: isMe
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isMe
                                            ? AppColors.primaryColor2
                                            : Color(0xFFE9F3F3),
                                        borderRadius: BorderRadius.only(
                                          topLeft: isMe
                                              ? Radius.circular(20)
                                              : Radius.zero,
                                          topRight: isMe
                                              ? Radius.zero
                                              : Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Text(
                                        "${message['message']}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isMe
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  SizedBox(
                                    width: double.infinity,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        getTimeAgo(message['timestamp']),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: Color(0xff797C7B),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFDADADA))),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset('assets/svgs/clipattachment.svg'),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: _scrollToBottom,
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: Colors.black, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Write your message',
                        hintStyle: TextStyle(
                          color: Color(0xFF797C7B),
                          fontSize: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Color(0xFFE9F3F3),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                if (_canShowSendButton)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor2,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: SvgPicture.asset('assets/svgs/Send.svg'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
