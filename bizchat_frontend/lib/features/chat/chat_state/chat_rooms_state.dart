import 'package:bizchat_frontend/features/chat/model/chat_room.dart';
import 'package:bizchat_frontend/features/chat/model/message_model.dart';
import 'package:bizchat_frontend/features/chat/model/simple_user.dart';

class ChatRoomsState {
  final bool isLoadingRooms;
  final List<ChatRoomModel>? rooms;
  final SimpleUser? simpleUser;
  final String? error;
  final String? createGetRoomError;
  final int? roomId;
  final List<MessageModel>? roomMessages;
  final bool? isLoadingMessages;

  ChatRoomsState({
    required this.isLoadingRooms,
    required this.rooms,
    required this.error,
    required this.simpleUser,
    required this.roomId,
    required this.createGetRoomError,
    required this.roomMessages,
    required this.isLoadingMessages
  });

  factory ChatRoomsState.initial() {
    return ChatRoomsState(
      isLoadingRooms: false,
      rooms: null,
      error: null,
      simpleUser: null,
      roomId: null,
      createGetRoomError: null,
      roomMessages: null,
      isLoadingMessages: false,
    );
  }

  ChatRoomsState copyWith({
    bool? isLoadingRooms,
    List<ChatRoomModel>? rooms,
    String? error,
    SimpleUser? simpleUser,
    int? roomId,
    String? createGetRoomError,
    List<MessageModel>? roomMessages,
    bool? isLoadingMessages,
  }) {
    return ChatRoomsState(
      isLoadingRooms: isLoadingRooms ?? this.isLoadingRooms,
      rooms: rooms ?? this.rooms,
      error: error ?? this.error,
      simpleUser: simpleUser ?? this.simpleUser,
      roomId: roomId ?? this.roomId,
      createGetRoomError: createGetRoomError ?? this.createGetRoomError,
      roomMessages: roomMessages ?? this.roomMessages,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
    );
  }
}