import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as legacy_provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme/yonwa_theme.dart';
import 'theme/theme_provider.dart';
import 'providers/user_provider.dart';
import 'providers/commerce_provider.dart';
import 'providers/booking_provider.dart';
import 'core/theme/theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint(
      'Yonwa: Running in development mode without Firebase configuration.',
    );
  }

  await initializeDateFormatting('fr', null);
  runApp(
    const ProviderScope(
      child: YonwaApp(),
    ),
  );
}

class YonwaApp extends ConsumerWidget {
  const YonwaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return legacy_provider.MultiProvider(
      providers: [
        legacy_provider.ChangeNotifierProvider(create: (_) => ThemeProvider()),
        legacy_provider.ChangeNotifierProvider(create: (_) => UserProvider()),
        legacy_provider.ChangeNotifierProvider(create: (_) => CommerceProvider()),
        legacy_provider.ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: MaterialApp.router(
        title: 'Yonwa',
        debugShowCheckedModeBanner: false,
        theme: getYonwaTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}

class _Splash extends StatefulWidget {
  const _Splash();

  @override
  State<_Splash> createState() => _SplashState();
}

class _SplashState extends State<_Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _logoSlideAnim;
  late Animation<Offset> _textSlideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _logoSlideAnim =
        Tween<Offset>(begin: const Offset(0.0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
          ),
        );

    _textSlideAnim =
        Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
          ),
        );

    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    try {
      await Future.delayed(const Duration(milliseconds: 3500));
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool('onboarding_done') ?? false;
      final questionnaireDone = prefs.getBool('questionnaire_done') ?? false;

      bool isLoggedIn = false;
      try {
        isLoggedIn = FirebaseAuth.instance.currentUser != null;
      } catch (e) {
        debugPrint('Auth error: $e');
      }

      if (!mounted) return;

      if (!onboardingDone) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      } else if (!isLoggedIn) {
        Navigator.of(context).pushReplacementNamed('/auth');
      } else if (!questionnaireDone) {
        Navigator.of(context).pushReplacementNamed('/questionnaire');
      } else {
        Navigator.of(context).pushReplacementNamed('/app');
      }
    } catch (e) {
      debugPrint('Error during navigation: $e');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/hero1.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: YonwaColors.primary500),
          ),

          // Dark Tint Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.65),
                  Colors.black.withOpacity(0.85),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
          ),

          // Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container with scale and slide animation
                  SlideTransition(
                    position: _logoSlideAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/icons/yome.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.explore_rounded,
                                size: 50,
                                color: YonwaColors.primary500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Title & Subtitle with slide animation
                  SlideTransition(
                    position: _textSlideAnim,
                    child: Column(
                      children: [
                        const Text(
                          'Yonwa',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 42,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black38,
                                offset: Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Le Bénin à travers ceux qui le font vivre',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.85),
                            letterSpacing: 0.5,
                            shadows: const [
                              Shadow(
                                color: Colors.black38,
                                offset: Offset(0, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 56),

                  // Custom loading indicator
                  const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
