import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;
  
  LoginUser(this.repository);
  
  Future<void> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
