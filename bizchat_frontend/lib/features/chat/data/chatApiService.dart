import 'package:bizchat_frontend/core/helper/error_helper.dart';
import 'package:bizchat_frontend/core/network/api_routes.dart';
import 'package:bizchat_frontend/features/chat/model/chatRoom.dart';
import 'package:dio/dio.dart';

class ChatApiService {
  final Dio _dio;

  ChatApiService(this._dio);
  
  Future<ChatRoomModel> getUserChatRoomsList() async {
    try {
      final api = await _dio.get(ApiRoutes.getAllChatList);
      
      return ChatRoomModel.fromJson(api);
    } on DioException catch (error) {
      throw ErrorHelper.getErrorMessage(error);
    }
  }
}