import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/yonwa_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Découvrez le savoir-faire béninois',
      'desc': 'Explorez des ateliers de tissage, poterie, sculpture et cuisine locale authentiques.',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'
    },
    {
      'title': 'Rencontrez des artisans passionnés',
      'desc': 'Échangez directement avec des guides, créateurs et producteurs locaux.',
      'image': 'https://images.unsplash.com/photo-1517760444937-f6397edcbbcd'
    },
    {
      'title': 'Vivez des aventures culturelles',
      'desc': 'Réservez des excursions immersives uniques et soutenez l\'économie locale.',
      'image': 'https://images.unsplash.com/photo-1501854140801-50d01698950b'
    }
  ];

  Future<void> _skipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (mounted) {
      context.go('/questionnaire');
    }
  }

  Future<void> _goToAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (mounted) {
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Slide contents
            PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final slide = _slides[index];
                return Column(
                  children: [
                    // 75% Image
                    Expanded(
                      flex: 3,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            slide['image']!,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                                stops: const [0.6, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 25% Content
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                        child: Column(
                          children: [
                            Text(
                              slide['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: YonwaColors.neutral900,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              slide['desc']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: YonwaColors.neutral500,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // S'inscrire - Top Right
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _goToAuth,
                child: Text(
                  "S'inscrire",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: YonwaColors.secondary,
                  ),
                ),
              ),
            ),

            // Bottom controls
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Smooth page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _slides.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: YonwaColors.secondary,
                      dotColor: YonwaColors.neutral200,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  
                  // Continuer sans compte button
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Row(
                      children: [
                        Text(
                          "Continuer sans compte",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: YonwaColors.primary500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: YonwaColors.primary500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
