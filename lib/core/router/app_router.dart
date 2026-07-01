import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/questionnaire_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../screens/main_navigation_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/products/product_detail_screen.dart';
import '../../screens/chat/messages_inbox_screen.dart';

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
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
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
      pageBuilder: (context, state) =>
          _buildFadeScaleTransition(state: state, child: const AuthScreen()),
    ),

    // Main App with bottom navigation
    GoRoute(
      path: '/app',
      pageBuilder: (context, state) => _buildFadeScaleTransition(
        state: state,
        child: const MainNavigationScreen(),
      ),
    ),

    // Profile detail page
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

    // Search page
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) {
        return _buildFadeScaleTransition(
          state: state,
          child: const SearchScreen(),
        );
      },
    ),

    // Notifications page
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) {
        return _buildFadeScaleTransition(
          state: state,
          child: const NotificationsScreen(),
        );
      },
    ),

    // Product detail page
    GoRoute(
      path: '/product/:productId',
      pageBuilder: (context, state) {
        final productId = state.pathParameters['productId'] ?? '';
        return _buildFadeScaleTransition(
          state: state,
          child: ProductDetailScreen(productId: productId),
        );
      },
    ),

    // Messages inbox
    GoRoute(
      path: '/messages',
      pageBuilder: (context, state) {
        return _buildFadeScaleTransition(
          state: state,
          child: const MessagesInboxScreen(),
        );
      },
    ),
  ],
);
