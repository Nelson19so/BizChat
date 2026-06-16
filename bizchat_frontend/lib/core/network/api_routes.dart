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
}
