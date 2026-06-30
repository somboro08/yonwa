import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/yonwa_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final letters = ['Y', 'O', 'N', 'W', 'A'];
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(5, (i) =>
      AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
    );
    for (int i = 0; i < letters.length; i++) {
      Future.delayed(Duration(milliseconds: 150 * i), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
    Future.delayed(const Duration(milliseconds: 2800), () async {
      if (!mounted) return;
      
      try {
        final prefs = await SharedPreferences.getInstance();
        final onboardingDone = prefs.getBool('onboarding_done') ?? false;
        final questionnaireDone = prefs.getBool('questionnaire_done') ?? false;

        if (!onboardingDone) {
          context.go('/onboarding');
        } else if (!questionnaireDone) {
          context.go('/questionnaire');
        } else {
          context.go('/app');
        }
      } catch (e) {
        context.go('/app');
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(letters.length, (i) {
            return AnimatedBuilder(
              animation: _controllers[i],
              builder: (context, child) {
                final value = CurvedAnimation(
                  parent: _controllers[i],
                  curve: Curves.easeOutCubic,
                ).value;
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Text(
                      letters[i],
                      style: GoogleFonts.poppins(
                        fontSize: 58,
                        fontWeight: FontWeight.w800,
                        color: YonwaColors.primary500,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
