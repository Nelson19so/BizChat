import 'package:bizchat_frontend/features/chat/data/chatApiService.dart';
import 'package:bizchat_frontend/features/chat/model/chatRoom.dart';
import 'package:bizchat_frontend/features/chat/model/simpleuser.dart';
import 'package:flutter_riverpod/legacy.dart';

class ChatRoomsControllerState {
  final bool isLoadingRooms;
  final List<ChatRoomModel>? rooms;
  final SimpleUser? simpleUser;
  final String? error;

  ChatRoomsControllerState({
    required this.isLoadingRooms,
    required this.rooms,
    required this.error,
    required this.simpleUser,
  });

  factory ChatRoomsControllerState.initial() {
    return ChatRoomsControllerState(
      isLoadingRooms: false,
      rooms: null,
      error: null,
      simpleUser: null,
    );
  }

  ChatRoomsControllerState copyWith({
    bool? isLoadingRooms,
    List<ChatRoomModel>? rooms,
    String? error,
    SimpleUser? simpleUser,
  }) {
    return ChatRoomsControllerState(
      isLoadingRooms: isLoadingRooms ?? this.isLoadingRooms,
      rooms: rooms ?? this.rooms,
      error: error ?? this.error,
      simpleUser: simpleUser ?? this.simpleUser,
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

  Future<void> getUserChatListRooms() async {
    try {
      state = state.copyWith(
        isLoadingRooms: true,
        rooms: null,
        error: null,
      );

      final response = await api.getAllUserChatRoomsList();

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

  Future<void> searchUserByPhoneNo(String phoneNumber) async {
    try {
      state = state.copyWith(
        isLoadingRooms: true,
        simpleUser: null,
        error: null,
      );

      final response = await api.searchOrAddUserByPhoneNumber(phoneNumber);

      state = state.copyWith(
        isLoadingRooms: false,
        simpleUser: response,
      );
    } catch (err) {
      state = state.copyWith(
        isLoadingRooms: false,
        simpleUser: null,
        error: err.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearPhoneSearch() {
    state = state.copyWith(simpleUser: null);
  }
}
