import 'package:bizchat_frontend/core/helper/error_helper.dart';
import 'package:bizchat_frontend/core/network/api_routes.dart';
import 'package:bizchat_frontend/features/chat/model/chat_room.dart';
import 'package:bizchat_frontend/features/chat/model/message_model.dart';
import 'package:bizchat_frontend/features/chat/model/simple_user.dart';
import 'package:dio/dio.dart';

class ChatApiService {
  final Dio _dio;

  ChatApiService(this._dio);

  Future<List<ChatRoomModel>> getUserChatRoomsList() async {
    try {
      final response = await _dio.get(ApiRoutes.getAllChatListImessage);

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => ChatRoomModel.fromJson(json as Map<String, dynamic>)).toList();

    } on DioException catch (error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }

  Future<List<ChatRoomModel>> getAllUserChatRoomsList() async {
    try {
      final response = await _dio.get(ApiRoutes.getAllChatList);

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => ChatRoomModel.fromJson(json as Map<String, dynamic>)).toList();

    } on DioException catch (error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }

  /// Get all chat room messages
  Future<List<MessageModel>> getUserChatRoomMessageList(int roomId) async {
    try {
      final response = await _dio.get(
          ApiRoutes.getRoomMessageList,
          queryParameters: {
            'room_id': roomId,
          }
      );

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => MessageModel.fromJson(json as Map<String, dynamic>)).toList();

    } on DioException catch (error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }

  /// search user by phone number
  Future<SimpleUser> searchOrAddUserByPhoneNumber(String phoneNumber) async {
    try {
      final Map<String, dynamic> queryParameters = <String, dynamic>{
        "phone_number": phoneNumber,
      };

      final response = await _dio.get(
        ApiRoutes.searchUserByPhone,
        queryParameters: queryParameters
      );

      return SimpleUser.fromJson(response.data);
    } on DioException catch (error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }

  /// Get Or Create User Room
  Future<int> getOrCreateRoom(int userId) async {
    try {
      final response = await _dio.post(
        ApiRoutes.getOrCreateUserRoom,
        data: {
          "user_id": userId,
        }
      );

      final data = response.data["room_id"];
      return data;
    } on DioException catch(error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }
}
