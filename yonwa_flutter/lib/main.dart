import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/map_screen.dart';
import 'screens/artisans_list_screen.dart';
import 'screens/artisan_profile_screen.dart';
import 'screens/guide_profile_screen.dart';
import 'screens/experience_profile_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/confirmation_screen.dart';
import 'screens/messaging_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/history_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/settings_screen.dart';
import 'widgets/shared_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const YonwaApp());
}

class YonwaApp extends StatelessWidget {
  const YonwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YONWA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AppNavigator(),
    );
  }
}

// ──────────────────────────────────────────────────────────
// APP NAVIGATOR — Single-screen state machine
// ──────────────────────────────────────────────────────────
class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  String _screen = 'splash';
  int _tabIndex = 0;

  final List<String> _history = [];

  void _navigate(String screen) {
    setState(() {
      _history.add(_screen);
      _screen = screen;

      // Sync tab index with main tabs
      switch (screen) {
        case 'home':
          _tabIndex = 0;
          break;
        case 'search':
        case 'categories':
          _tabIndex = 1;
          break;
        case 'history':
          _tabIndex = 2;
          break;
        case 'messaging':
          _tabIndex = 3;
          break;
        case 'userProfile':
          _tabIndex = 4;
          break;
      }
    });
  }

  void _goBack() {
    if (_history.isEmpty) return;
    setState(() {
      _screen = _history.removeLast();
    });
  }

  void _onTabTap(int index) {
    final screens = ['home', 'search', 'history', 'messaging', 'userProfile'];
    setState(() {
      _tabIndex = index;
      _screen = screens[index];
      _history.clear();
    });
  }

  bool get _showBottomNav {
    const mainScreens = {'home', 'search', 'history', 'messaging', 'userProfile'};
    return mainScreens.contains(_screen);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_history.isNotEmpty) {
          _goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
          child: KeyedSubtree(
            key: ValueKey(_screen),
            child: _buildScreen(),
          ),
        ),
        bottomNavigationBar: _showBottomNav
            ? BottomNavBar(currentIndex: _tabIndex, onTap: _onTabTap)
            : null,
      ),
    );
  }

  Widget _buildScreen() {
    switch (_screen) {
      case 'splash':
        return SplashScreen(onDone: () => _navigate('onboarding'));

      case 'onboarding':
        return OnboardingScreen(onDone: () => _navigate('login'));

      case 'login':
        return LoginScreen(
          onLogin: () => _navigate('home'),
          onSignup: () => _navigate('login'),
        );

      case 'home':
        return HomeScreen(navigate: _navigate);

      case 'search':
        return SearchScreen(navigate: _navigate);

      case 'categories':
        return CategoriesScreen(onBack: _goBack, navigate: _navigate);

      case 'map':
        return MapScreen(onBack: _goBack, navigate: _navigate);

      case 'artisansList':
        return ArtisansListScreen(onBack: _goBack, navigate: _navigate);

      case 'artisanProfile':
        return ArtisanProfileScreen(onBack: _goBack, navigate: _navigate);

      case 'guideProfile':
        return GuideProfileScreen(onBack: _goBack, navigate: _navigate);

      case 'experienceProfile':
        return ExperienceProfileScreen(onBack: _goBack, navigate: _navigate);

      case 'booking':
        return BookingScreen(onBack: _goBack, navigate: _navigate);

      case 'payment':
        return PaymentScreen(onBack: _goBack, navigate: _navigate);

      case 'confirmation':
        return ConfirmationScreen(navigate: _navigate);

      case 'messaging':
        return MessagingScreen(navigate: _navigate);

      case 'chat':
        return ChatScreen(onBack: _goBack);

      case 'notifications':
        return NotificationsScreen(onBack: _goBack);

      case 'favorites':
        return FavoritesScreen(onBack: _goBack, navigate: _navigate);

      case 'history':
        return HistoryScreen(navigate: _navigate);

      case 'reviews':
        return ReviewsScreen(onBack: _goBack);

      case 'userProfile':
        return UserProfileScreen(navigate: _navigate);

      case 'settings':
        return SettingsScreen(onBack: _goBack);

      default:
        return HomeScreen(navigate: _navigate);
    }
  }
}
