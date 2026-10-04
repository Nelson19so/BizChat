import 'package:bizchat_frontend/features/chat/chat_state/chat_rooms_state.dart';
import 'package:bizchat_frontend/features/chat/data/chatApiService.dart';
import 'package:flutter_riverpod/legacy.dart';

class ChatRoomsController extends StateNotifier<ChatRoomsState> {
  final ChatApiService api;

  ChatRoomsController(this.api) : super(ChatRoomsState.initial());

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

  /// Getting all chat messages
  Future<void> getUserChatRoomMessages(int roomId) async {
    try {
      state = state.copyWith(
        isLoadingMessages: true,
        roomMessages: null,
        error: null,
      );

      final response = await api.getUserChatRoomMessageList(roomId);

      state = state.copyWith(
        isLoadingMessages: false,
        roomMessages: response,
      );
    } catch (err) {
      state = state.copyWith(
        isLoadingMessages: false,
        roomMessages: null,
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
