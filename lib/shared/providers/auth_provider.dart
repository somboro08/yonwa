import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/auth/auth_bottom_sheet.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, User?>((ref) {
  return AuthStateNotifier();
});

class AuthStateNotifier extends StateNotifier<User?> {
  AuthStateNotifier() : super(FirebaseAuth.instance.currentUser) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (mounted) {
        state = user;
      }
    });
  }
}

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
