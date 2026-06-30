import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGuardNotifier extends StateNotifier<bool> {
  AuthGuardNotifier() : super(false) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool('is_authenticated') ?? false;
    state = isAuthenticated;
  }

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', true);
    state = true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_authenticated', false);
    state = false;
  }

  Future<void> checkStatus() => _checkAuthStatus();
}

final authGuardProvider = StateNotifierProvider<AuthGuardNotifier, bool>((ref) {
  return AuthGuardNotifier();
});