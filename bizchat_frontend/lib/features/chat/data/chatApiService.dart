import 'package:bizchat_frontend/core/helper/error_helper.dart';
import 'package:bizchat_frontend/core/network/api_routes.dart';
import 'package:bizchat_frontend/features/chat/model/chatRoom.dart';
import 'package:dio/dio.dart';

class ChatApiService {
  final Dio _dio;

  ChatApiService(this._dio);

  Future<List<ChatRoomModel>> getUserChatRoomsList() async {
    try {
      final response = await _dio.get(ApiRoutes.getAllChatList);

      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => ChatRoomModel.fromJson(json as Map<String, dynamic>)).toList();

    } on DioException catch (error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }
}