import '../repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository repository;
  
  LogoutUser(this.repository);
  
  Future<void> call() async {
    return await repository.logout();
  }
}
