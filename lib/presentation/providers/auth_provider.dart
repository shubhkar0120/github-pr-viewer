import 'package:flutter/foundation.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failures.dart';

enum AuthState { initial, loading, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  final LoginUser _loginUser;
  final LogoutUser _logoutUser;
  final AuthRepository _authRepository;
  
  AuthState _state = AuthState.initial;
  String? _errorMessage;
  String? _token;
  
  AuthProvider({
    required LoginUser loginUser,
    required LogoutUser logoutUser,
    required AuthRepository authRepository,
  }) : _loginUser = loginUser,
       _logoutUser = logoutUser,
       _authRepository = authRepository {
    _checkAuthStatus();
  }
  
  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;
  
  Future<void> _checkAuthStatus() async {
    try {
      _state = AuthState.loading;
      notifyListeners();
      
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        _token = await _authRepository.getToken();
        _state = AuthState.authenticated;
      } else {
        _state = AuthState.unauthenticated;
      }
    } catch (e) {
      _state = AuthState.unauthenticated;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }
  
  Future<void> login(String username, String password) async {
    try {
      _state = AuthState.loading;
      _errorMessage = null;
      notifyListeners();
      
      await _loginUser(username, password);
      _token = await _authRepository.getToken();
      _state = AuthState.authenticated;
    } on AuthFailure catch (e) {
      _state = AuthState.unauthenticated;
      _errorMessage = e.message;
    } catch (e) {
      _state = AuthState.unauthenticated;
      _errorMessage = 'An unexpected error occurred';
    }
    notifyListeners();
  }
  
  Future<void> logout() async {
    try {
      _state = AuthState.loading;
      notifyListeners();
      
      await _logoutUser();
      _token = null;
      _state = AuthState.unauthenticated;
    } catch (e) {
      _errorMessage = 'Failed to logout';
    }
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
