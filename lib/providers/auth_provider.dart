import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;

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
  Future<bool> signUp(String name, String email, String password) async {
    final result = await _authService.signUp(
      name: name,
      email: email,
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