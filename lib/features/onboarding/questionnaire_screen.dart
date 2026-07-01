import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/models.dart';
import '../../shared/providers/user_provider.dart';
import '../../theme/yonwa_theme.dart';

class QuestionnaireScreen extends ConsumerStatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  ConsumerState<QuestionnaireScreen> createState() =>
      _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen> {
  UserRole? _selectedRole;

  final List<Map<String, dynamic>> _roleOptions = [
    {
      'role': UserRole.voyageur,
      'title': 'Touriste / Voyageur',
      'desc':
          'Je souhaite explorer la culture béninoise, découvrir des artisans et vivre des expériences.',
      'icon': Icons.explore_rounded,
      'image': 'assets/images/hero4.jpeg',
    },
    {
      'role': UserRole.artisan,
      'title': 'Artisan / Créateur',
      'desc':
          'Je souhaite exposer mon savoir-faire, proposer des ateliers et vendre mes créations.',
      'icon': Icons.brush_rounded,
      'image': 'assets/images/hero2.jpg',
    },
    {
      'role': UserRole.revendeur,
      'title': 'Revendeur / Marchand',
      'desc':
          'Je vends des produits d\'artisanat local, des souvenirs et des produits du terroir.',
      'icon': Icons.storefront_rounded,
      'image': 'assets/images/hero3.jpeg',
    },
  ];

  Future<void> _submit() async {
    if (_selectedRole == null) return;

    // Save to user provider
    final userProv = ref.read(userProviderRef);
    await userProv.updateRole(_selectedRole!);

    // Persist questionnaire done status
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('questionnaire_done', true);

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Qui êtes-vous ?',
                style: GoogleFonts.outfit(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: YonwaColors.neutral900,
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
              const SizedBox(height: 8),
              Text(
                'Choisissez le profil qui vous correspond le mieux pour personnaliser votre expérience.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
                  color: YonwaColors.neutral500,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _roleOptions.length,
                  itemBuilder: (context, index) {
                    final option = _roleOptions[index];
                    final role = option['role'] as UserRole;
                    final isSelected = _selectedRole == role;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRole = role;
                        });
                      },
                      child:
                          Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? YonwaColors.secondary
                                        : YonwaColors.neutral200,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
                                      blurRadius: 18,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        option['image'] as String,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          height: 120,
                                          color: YonwaColors.primary50,
                                          child: const Icon(
                                            Icons.image,
                                            color: YonwaColors.primary500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? YonwaColors.secondary
                                                          .withValues(
                                                            alpha: 0.16,
                                                          )
                                                    : YonwaColors.neutral100,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Icon(
                                                option['icon'] as IconData,
                                                color: isSelected
                                                    ? YonwaColors.secondary
                                                    : YonwaColors.neutral600,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    option['title'] as String,
                                                    style: GoogleFonts.outfit(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: YonwaColors
                                                          .neutral900,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    option['desc'] as String,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12,
                                                      color: YonwaColors
                                                          .neutral500,
                                                      height: 1.4,
                                                    ),
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
                              )
                              .animate()
                              .fadeIn(
                                duration: 400.ms,
                                delay: Duration(
                                  milliseconds: 100 * index + 200,
                                ),
                              )
                              .slideX(begin: 0.05, end: 0),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: YonwaColors.primary500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _selectedRole != null ? _submit : null,
                  child: Text(
                    'Continuer',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ).animate().scale(
                begin: const Offset(0.9, 0.9),
                duration: 300.ms,
                delay: 500.ms,
                curve: Curves.easeOutBack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
