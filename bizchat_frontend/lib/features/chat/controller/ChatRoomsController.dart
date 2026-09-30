import 'package:bizchat_frontend/features/chat/data/chatApiService.dart';
import 'package:bizchat_frontend/features/chat/model/chatRoom.dart';
import 'package:bizchat_frontend/features/chat/model/simpleuser.dart';
import 'package:flutter_riverpod/legacy.dart';

class ChatRoomsControllerState {
  final bool isLoadingRooms;
  final List<ChatRoomModel>? rooms;
  final SimpleUser? simpleUser;
  final String? error;
  final String? createGetRoomError;
  final int? roomId;

  ChatRoomsControllerState({
    required this.isLoadingRooms,
    required this.rooms,
    required this.error,
    required this.simpleUser,
    required this.roomId,
    required this.createGetRoomError
  });

  factory ChatRoomsControllerState.initial() {
    return ChatRoomsControllerState(
      isLoadingRooms: false,
      rooms: null,
      error: null,
      simpleUser: null,
      roomId: null,
      createGetRoomError: null,
    );
  }

  ChatRoomsControllerState copyWith({
    bool? isLoadingRooms,
    List<ChatRoomModel>? rooms,
    String? error,
    SimpleUser? simpleUser,
    int? roomId,
    String? createGetRoomError,
  }) {
    return ChatRoomsControllerState(
      isLoadingRooms: isLoadingRooms ?? this.isLoadingRooms,
      rooms: rooms ?? this.rooms,
      error: error ?? this.error,
      simpleUser: simpleUser ?? this.simpleUser,
      roomId: roomId ?? this.roomId,
      createGetRoomError: createGetRoomError ?? this.createGetRoomError,
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

  Future<void> getOrCreateChatRoom(int userId) async {
    try {
      state = state.copyWith(
        isLoadingRooms: true,
        roomId: null,
        createGetRoomError: null,
      );

      final responseData = await api.getOrCreateRoom(userId);

      state = state.copyWith(
        isLoadingRooms: false,
        roomId: responseData,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingRooms: false,
        roomId: null,
        createGetRoomError: error.toString(),
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
