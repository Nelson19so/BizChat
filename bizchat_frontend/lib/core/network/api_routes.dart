class ApiRoutes {
  /// Base url endpoint
  static const String baseUrl = 'http://10.0.2.2:8000';

  /// Auth user url endpoint
  static const String register = '/user/register/';
  static const String login = '/user/login/';
  static const String refreshToken = '/user/token/refresh/';

  /// User url endpoint
  static const String getUser = '/user/me/';
  static const String logoutUser = '/user/logout/';
  static const String deleteUser = '/user/delete_myaccount/';
  static const String updateUser = '/user/profile/';

  /// Chat User url endpoint
  static const String getAllChatList = '/api/chat_list/';
  static const String getAllChatListImessage = '/api/chat_list_imessage/';
  static const String searchUserByName = '/api/chat_list/SearchMyCustomersByNameView/';
  static const String searchUserByPhone = '/api/chat_list/searchUserNumber/';
  static const String getOrCreateUserRoom = '/api/chat_list/room_get_create/';
  static const String getRoomMessageList = '/api/chat_list/messages/';
}
