abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<String?> getToken();
  Future<bool> isLoggedIn();
}
