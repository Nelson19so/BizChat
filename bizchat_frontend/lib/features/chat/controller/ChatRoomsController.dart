import 'package:bizchat_frontend/features/chat/data/chatApiService.dart';
import 'package:bizchat_frontend/features/chat/model/chatRoom.dart';
import 'package:flutter_riverpod/legacy.dart';

class ChatRoomsControllerState {
  final bool isLoadingRooms;
  final List<ChatRoomModel>? rooms;
  final String? error;

  ChatRoomsControllerState({
    required this.isLoadingRooms,
    required this.rooms,
    required this.error,
  });

  factory ChatRoomsControllerState.initial() {
    return ChatRoomsControllerState(
      isLoadingRooms: false,
      rooms: null,
      error: null,
    );
  }

  ChatRoomsControllerState copyWith({
    bool? isLoadingRooms,
    List<ChatRoomModel>? rooms,
    String? error,
  }) {
    return ChatRoomsControllerState(
      isLoadingRooms: isLoadingRooms ?? this.isLoadingRooms,
      rooms: rooms ?? this.rooms,
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
        rooms: null,
        error: null,
      );

      final response = await api.getUserChatRoomsList();

      state = state.copyWith(
        isLoadingRooms: false,
        rooms: response,
      );
    } catch (err) {
      state = state.copyWith(
        isLoadingRooms: false,
        rooms: null,
        error: err.toString(),
      );
    }
  }
}
