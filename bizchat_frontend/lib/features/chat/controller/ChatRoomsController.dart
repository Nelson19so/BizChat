import 'package:bizchat_frontend/features/chat/data/chatApiService.dart';
import 'package:bizchat_frontend/features/chat/model/chatRoom.dart';
import 'package:flutter_riverpod/legacy.dart';

class ChatRoomsControllerState {
  final bool isLoadingRooms;
  final ChatRoomModel? chatRooms;
  final String? error;

  ChatRoomsControllerState({
    required this.isLoadingRooms,
    required this.chatRooms,
    required this.error,
  });

  factory ChatRoomsControllerState.initial() {
    return ChatRoomsControllerState(
      isLoadingRooms: false,
      chatRooms: null,
      error: null,
    );
  }

  ChatRoomsControllerState copyWith({
    bool? isLoadingRooms,
    ChatRoomModel? chatRooms,
    String? error,
  }) {
    return ChatRoomsControllerState(
      isLoadingRooms: isLoadingRooms ?? this.isLoadingRooms,
      chatRooms: chatRooms ?? this.chatRooms,
      error: error ?? this.error
    );
  }
}

class ChatRoomsController extends StateNotifier<ChatRoomsControllerState> {
  final ChatApiService api;

  ChatRoomsController(this.api) : super(ChatRoomsControllerState.initial());

  Future<void> getUserChatRooms() async {
    try {
      state = state.copyWith(
        isLoadingRooms: true,
        chatRooms: null,
        error: null,
      );

      final response = await api.getUserChatRoomsList();

      state = state.copyWith(
        isLoadingRooms: false,
        chatRooms: response,
      );
    } catch (err) {
      state = state.copyWith(
        isLoadingRooms: false,
        chatRooms: null,
        error: err.toString(),
      );
    }
  }
}
