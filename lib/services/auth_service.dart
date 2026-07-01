// lib/services/auth_service.dart
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:flutter/foundation.dart';

class AuthService {
  // --- CONFIGURATION DEV ---
  // Passez à 'false' dès que Supabase est configuré en production.
  bool get isMockMode => true;
  // --------------------------

  Stream<supabase.User?> get user {
    if (isMockMode) return Stream.value(null);
    return supabase.Supabase.instance.client.auth.onAuthStateChange.map(
      (event) => event.session?.user,
    );
  }

  supabase.User? get currentUser {
    if (isMockMode) return null;
    return supabase.Supabase.instance.client.auth.currentUser;
  }

  Future<void> signInWithEmail(String email, String password) async {
    if (isMockMode) {
      debugPrint('--- MODE SIMULATION ACTIVÉ ---');
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await supabase.Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    if (isMockMode) {
      debugPrint('--- MODE SIMULATION ACTIVÉ ---');
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await supabase.Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    if (isMockMode) {
      debugPrint('--- MODE SIMULATION ACTIVÉ ---');
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await supabase.Supabase.instance.client.auth.signInWithOAuth(
        supabase.OAuthProvider.google,
      );
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> signInWithPhone(String phoneNumber) async {
    if (isMockMode) {
      debugPrint('--- MODE SIMULATION ACTIVÉ ---');
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      await supabase.Supabase.instance.client.auth.signInWithOtp(
        phone: phoneNumber,
      );
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> signOut() async {
    if (isMockMode) {
      debugPrint('Simulation : Déconnexion (Mock)');
      return;
    }

    await supabase.Supabase.instance.client.auth.signOut();
  }
}

class AuthException implements Exception {
  final String? message;
  AuthException(this.message);

  @override
  String toString() => message ?? 'Erreur d\'authentification';
}
