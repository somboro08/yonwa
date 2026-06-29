import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/questionnaire_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/explore/explore_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/my_profile/my_profile_screen.dart';
import '../../features/booking/booking_screen.dart';
import '../layout/app_shell.dart';

CustomTransitionPage<void> _buildCube3DTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final angle = (1 - animation.value) * -math.pi / 2;
          return Transform(
            alignment: Alignment.centerRight,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: child,
          );
        },
      );
    },
  );
}

CustomTransitionPage<void> _buildFadeScaleTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => _buildFadeScaleTransition(
        state: state,
        child: const OnboardingScreen(),
      ),
    ),
    GoRoute(
      path: '/questionnaire',
      pageBuilder: (context, state) => _buildFadeScaleTransition(
        state: state,
        child: const QuestionnaireScreen(),
      ),
    ),
    GoRoute(
      path: '/auth',
      pageBuilder: (context, state) => _buildFadeScaleTransition(
        state: state,
        child: const AuthScreen(),
      ),
    ),
    
    // Main App pages wrapped in AppShell
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => _buildCube3DTransition(
            state: state,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: '/explore',
          pageBuilder: (context, state) => _buildCube3DTransition(
            state: state,
            child: const ExploreScreen(),
          ),
        ),
        GoRoute(
          path: '/profile/:id',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return _buildCube3DTransition(
              state: state,
              child: ProfileScreen(id: id),
            );
          },
        ),
        GoRoute(
          path: '/booking',
          pageBuilder: (context, state) => _buildCube3DTransition(
            state: state,
            child: const BookingScreen(),
          ),
        ),
        GoRoute(
          path: '/me',
          pageBuilder: (context, state) => _buildCube3DTransition(
            state: state,
            child: const MyProfileScreen(),
          ),
        ),
      ],
    ),
  ],
);
