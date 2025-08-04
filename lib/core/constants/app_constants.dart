class AppConstants {
  static const String appName = 'GitHub PR Viewer';
  static const String tokenKey = 'auth_token';
  static const String fakeToken = 'abc123';
  
  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardElevation = 4.0;
  static const double borderRadius = 8.0;
  
  // Error Messages
  static const String networkError = 'Network error occurred';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'Unknown error occurred';
  static const String loginRequired = 'Please login to continue';
}
