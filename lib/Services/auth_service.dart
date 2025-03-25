import 'package:flutter/material.dart';

// Global auth state để có thể truy cập từ bất kỳ đâu trong ứng dụng
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  // Auth state
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  String _userType = '';

  // Callback để thông báo khi trạng thái thay đổi
  VoidCallback? _onAuthStateChanged;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userType => _userType;

  // Đăng ký callback khi trạng thái thay đổi
  void setOnAuthStateChanged(VoidCallback callback) {
    _onAuthStateChanged = callback;
  }

  // Login with email/password
  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // For demo, any email/password combination will work
    _isLoggedIn = true;
    _userName = 'Cristiano Ronaldo'; // Demo name
    _userEmail = email;
    _userType = 'email';

    if (_onAuthStateChanged != null) {
      _onAuthStateChanged!();
    }
    return true;
  }

  // Register new user
  Future<bool> register(String name, String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    _userType = 'email';

    if (_onAuthStateChanged != null) {
      _onAuthStateChanged!();
    }
    return true;
  }

  // Login as guest
  Future<bool> loginAsGuest() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _isLoggedIn = true;
    _userName = 'Khách';
    _userEmail = '';
    _userType = 'guest';

    if (_onAuthStateChanged != null) {
      _onAuthStateChanged!();
    }
    return true;
  }

  // Logout
  void logout() {
    // Đặt lại các biến trạng thái
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    _userType = '';

    // Nếu có callback, gọi nó để thông báo thay đổi trạng thái
    if (_onAuthStateChanged != null) {
      _onAuthStateChanged!();
    }
  }
}
