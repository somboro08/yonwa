import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/auth_service.dart';
import '../../theme/yonwa_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _navigateAfterAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final questionnaireDone = prefs.getBool('questionnaire_done') ?? false;
    if (mounted) {
      context.go(questionnaireDone ? '/app' : '/questionnaire');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: YonwaColors.error),
    );
  }

  Future<void> _authWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showError('Entrez un e-mail valide');
      return;
    }
    if (password.length < 6) {
      _showError('Le mot de passe doit faire au moins 6 caractères');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = AuthService();
      if (authService.isMockMode) {
        await Future.delayed(const Duration(seconds: 1));
      } else {
        try {
          await authService.signInWithEmail(email, password);
        } on AuthException catch (e) {
          final message = e.message ?? '';
          if (message.contains('invalid login credentials') ||
              message.contains('Invalid login credentials') ||
              message.contains('Invalid login credentials')) {
            await authService.signUpWithEmail(email, password);
          } else {
            rethrow;
          }
        }
      }
      await _navigateAfterAuth();
    } on AuthException catch (e) {
      _showError(e.message ?? 'Erreur d\'authentification');
    } catch (e) {
      _showError('Erreur d\'authentification');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _authWithPhone() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 8) {
      _showError('Entrez un numéro de téléphone valide');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (AuthService().isMockMode) {
        await Future.delayed(const Duration(seconds: 1));
        await _navigateAfterAuth();
        return;
      }
      await AuthService().signInWithPhone(phone);
      _showError(
        'Un code a été envoyé par SMS. Cette fonctionnalité nécessite de configurer Supabase OTP.',
      );
    } on AuthException catch (e) {
      _showError(e.message ?? 'Erreur d\'authentification');
    } catch (e) {
      _showError('Erreur d\'authentification');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image en haut
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/auth_header.jpg',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: YonwaColors.primary50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedCompass,
                            color: YonwaColors.primary500,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 20),

                  // Logo + Titre sur la même ligne
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: YonwaColors.neutral200,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: YonwaColors.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedCompass,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Titre
                        Text(
                          'Yonwa',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: YonwaColors.neutral900,
                          ),
                        ),
                      ],
                    ),
                  ).animate().scale(
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                    delay: 100.ms,
                  ),
                  const SizedBox(height: 8),

                  // Sous-titre
                  Text(
                    'Rejoignez la communauté du savoir-faire',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: YonwaColors.neutral500,
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                  const SizedBox(height: 24),

                  // TabBar
                  Container(
                    decoration: BoxDecoration(
                      color: YonwaColors.neutral100,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: YonwaColors.primary500,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: YonwaColors.neutral500,
                      labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      tabs: const [
                        Tab(text: 'E-mail'),
                        Tab(text: 'Téléphone'),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 300.ms),
                  const SizedBox(height: 24),

                  // TabBarView
                  SizedBox(
                    height: 180,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Email Tab
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'E-mail',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedMail02,
                                    color: YonwaColors.neutral500,
                                    size: 20,
                                  ),
                                ),
                                filled: true,
                                fillColor: YonwaColors.surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: YonwaColors.neutral200,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: YonwaColors.neutral200,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: 'Mot de passe',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedLockKey,
                                    color: YonwaColors.neutral500,
                                    size: 20,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: HugeIcon(
                                    icon: _isPasswordVisible
                                        ? HugeIcons.strokeRoundedView
                                        : HugeIcons.strokeRoundedViewOff,
                                    color: YonwaColors.neutral500,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: YonwaColors.surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: YonwaColors.neutral200,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: YonwaColors.neutral200,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Phone Tab
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: 'Numéro de téléphone (ex: 97123456)',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: HugeIcon(
                                    icon: HugeIcons.strokeRoundedSmartPhone01,
                                    color: YonwaColors.neutral500,
                                    size: 20,
                                  ),
                                ),
                                filled: true,
                                fillColor: YonwaColors.surface,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: YonwaColors.neutral200,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: YonwaColors.neutral200,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                  const SizedBox(height: 8),

                  // Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: YonwaColors.primary500,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_tabController.index == 0) {
                              _authWithEmail();
                            } else {
                              _authWithPhone();
                            }
                          },
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Continuer',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ).animate().scale(
                    begin: const Offset(0.95, 0.95),
                    duration: 300.ms,
                    delay: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
                  const SizedBox(height: 16),

                  // Continuer sans compte
                  TextButton(
                    onPressed: () {
                      context.go('/questionnaire');
                    },
                    child: Text(
                      'Continuer sans compte',
                      style: GoogleFonts.inter(
                        color: YonwaColors.neutral500,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
