import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  AuthLocalDataSourceImpl({required this.sharedPreferences});
  
  @override
  Future<void> saveToken(String token) async {
    try {
      await sharedPreferences.setString(AppConstants.tokenKey, token);
    } catch (e) {
      throw CacheFailure('Failed to save token: ${e.toString()}');
    }
  }
  
  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(AppConstants.tokenKey);
    } catch (e) {
      throw CacheFailure('Failed to get token: ${e.toString()}');
    }
  }
  
  @override
  Future<void> deleteToken() async {
    try {
      await sharedPreferences.remove(AppConstants.tokenKey);
    } catch (e) {
      throw CacheFailure('Failed to delete token: ${e.toString()}');
    }
  }
  
  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = sharedPreferences.getString(AppConstants.tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      throw CacheFailure('Failed to check login status: ${e.toString()}');
    }
  }
}
