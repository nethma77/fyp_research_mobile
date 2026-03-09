import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  Map<String, dynamic>? _userData;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) async {
      _user = user;
      // Fetch user data from Firestore when user logs in
      if (user != null) {
        _userData = await _authService.getUserData(user.uid);
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  String get userName => _userData?['name'] ?? 'Driver';
  String get userEmail => _userData?['email'] ?? '';
  String get userPhone => _userData?['phone'] ?? '';

  // =====================
  // SIGN IN
  // =====================
  Future<bool> signIn(String email, String password) async {
    final result = await _authService.signIn(email: email, password: password);
    return result != null;
  }

  // =====================
  // SIGN UP
  // =====================
  Future<bool> signUp(String name, String email, String phone, String password) async {
    final result = await _authService.signUp(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
    return result != null;
  }

  // =====================
  // SIGN OUT
  // =====================
  Future<void> signOut() async {
    await _authService.signOut();
  }
}