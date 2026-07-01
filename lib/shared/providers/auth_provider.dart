// lib/shared/providers/auth_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider;
import '../../services/auth_service.dart';
import '../../features/auth/auth_bottom_sheet.dart';

// Provider pour l'état d'authentification
final authStateProvider = StateProvider<User?>((ref) {
  final authService = AuthService();
  return authService.currentUser;
});

// Provider pour l'état de chargement
final authLoadingProvider = StateProvider<bool>((ref) => false);

// Provider pour les erreurs d'authentification
final authErrorProvider = StateProvider<String?>((ref) => null);

// Provider pour vérifier si l'utilisateur est authentifié
final isAuthenticatedProvider = StateProvider<bool>((ref) {
  final user = ref.watch(authStateProvider);
  return user != null;
});

// Provider pour l'ID utilisateur
final currentUserIdProvider = StateProvider<String?>((ref) {
  final user = ref.watch(authStateProvider);
  return user?.id;
});

// Provider pour l'email utilisateur
final currentUserEmailProvider = StateProvider<String?>((ref) {
  final user = ref.watch(authStateProvider);
  return user?.email;
});

// Fonction pour vérifier l'authentification
void requireAuth(BuildContext context, WidgetRef ref, VoidCallback action) {
  final user = ref.read(authStateProvider);
  if (user == null) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AuthBottomSheet(onSuccess: action),
    );
  } else {
    action();
  }
}

// Fonctions d'authentification simplifiées
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  Future<void> login() async {
    state = true;
  }

  Future<void> logout() async {
    state = false;
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});
