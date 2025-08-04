import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/app_constants.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  
  AuthRepositoryImpl({required this.localDataSource});
  
  @override
  Future<void> login(String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        throw const AuthFailure('Username and password are required');
      }
      
      await localDataSource.saveToken(AppConstants.fakeToken);
    } catch (e) {
      if (e is AuthFailure) {
        rethrow;
      }
      throw AuthFailure('Login failed: ${e.toString()}');
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await localDataSource.deleteToken();
    } catch (e) {
      throw AuthFailure('Logout failed: ${e.toString()}');
    }
  }
  
  @override
  Future<String?> getToken() async {
    try {
      return await localDataSource.getToken();
    } catch (e) {
      throw AuthFailure('Failed to get token: ${e.toString()}');
    }
  }
  
  @override
  Future<bool> isLoggedIn() async {
    try {
      return await localDataSource.isLoggedIn();
    } catch (e) {
      throw AuthFailure('Failed to check login status: ${e.toString()}');
    }
  }
}
