import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../theme/yonwa_theme.dart';
import '../services/auth_service.dart';

Future<void> navigateAfterAuth(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final questionnaireDone = prefs.getBool('questionnaire_done') ?? false;
  if (!context.mounted) return;
  Navigator.of(context).pushReplacementNamed(
    questionnaireDone ? '/home' : '/questionnaire',
  );
}

// ─────────────────────────────────────────────
//  AUTH SCREEN — Phone OTP with Enhanced UI/UX
// ─────────────────────────────────────────────

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String _selectedCountryCode = '+229';
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, String>> _countries = [
    {'code': '+229', 'flag': '🇧🇯', 'name': 'Bénin'},
    {'code': '+225', 'flag': '🇨🇮', 'name': 'Côte d\'Ivoire'},
    {'code': '+223', 'flag': '🇲🇱', 'name': 'Mali'},
    {'code': '+221', 'flag': '🇸🇳', 'name': 'Sénégal'},
    {'code': '+226', 'flag': '🇧🇫', 'name': 'Burkina Faso'},
    {'code': '+228', 'flag': '🇹🇬', 'name': 'Togo'},
    {'code': '+227', 'flag': '🇳🇪', 'name': 'Niger'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  void _authWithEmail() async {
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

    if (AuthService().isMockMode) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) await navigateAfterAuth(context);
      return;
    }

    setState(() => _isLoading = true);
    try {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          rethrow;
        }
      }
      if (mounted) await navigateAfterAuth(context);
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Erreur d\'authentification');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _authWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final authService = AuthService();
      final result = await authService.signInWithGoogle();
      
      if (result != null && mounted) {
        await navigateAfterAuth(context);
      }
    } catch (e) {
      debugPrint('Auth error: $e');
      if (AuthService().isMockMode && mounted) {
        await navigateAfterAuth(context);
      } else {
        _showError('Erreur de connexion avec Google');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: YonwaColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YonwaRadius.md),
        ),
      ),
    );
  }

  void _sendOTP() async {
    final phone = '$_selectedCountryCode${_phoneController.text.trim()}';
    if (_phoneController.text.trim().length < 8) {
      _showError('Entrez un numéro valide');
      return;
    }
    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) {
            await navigateAfterAuth(context);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isLoading = false);
          _showError(e.message ?? 'Échec de la vérification');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() => _isLoading = false);
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OTPScreen(
                  phone: phone,
                  verificationId: verificationId,
                  resendToken: resendToken,
                ),
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) setState(() => _isLoading = false);
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Une erreur est survenue');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.background,
      body: AnimatedBuilder(
        animation: _fadeController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Hero Section
                  SizedBox(
                    height: size.height * 0.50,
                    child: _buildHeroSection(isDark),
                  ),
                  
                  // Form Section
                  Expanded(
                    child: _buildFormSection(isDark),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection(bool isDark) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const NetworkImage(
                'https://afriquinfos.com/wp-content/uploads/2024/11/Ville-de-Cotonou-1024x858.webp',
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.darken,
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                isDark ? YonwaColors.neutral900.withOpacity(0.9) : YonwaColors.background.withOpacity(0.95),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(YonwaSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icons/yome.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenue sur',
                      style: YonwaTextStyles.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Yonwa',
                      style: YonwaTextStyles.display.copyWith(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Découvrez le Bénin authentique',
                      style: YonwaTextStyles.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(YonwaSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            const SizedBox(height: YonwaSpacing.xl),
            
            _buildAnimatedTabBar(isDark),
            
            const SizedBox(height: YonwaSpacing.xl),
            
            SizedBox(
              height: 180,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPhoneForm(isDark),
                  _buildEmailForm(isDark),
                ],
              ),
            ),
            
            const SizedBox(height: YonwaSpacing.lg),
            
            _buildMainButton(isDark),
            
            const SizedBox(height: YonwaSpacing.xl),
            
            _buildDividerWithText(isDark),
            
            const SizedBox(height: YonwaSpacing.xl),
            
            _buildGoogleButton(isDark),
            
            const SizedBox(height: 20),
            
            _buildTermsText(isDark),
            
            const SizedBox(height: YonwaSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTabBar(bool isDark) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral100,
        borderRadius: BorderRadius.circular(YonwaRadius.md),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: YonwaColors.primary500,
          borderRadius: BorderRadius.circular(YonwaRadius.md),
          boxShadow: [
            BoxShadow(
              color: YonwaColors.primary500.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
        labelStyle: YonwaTextStyles.label.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: YonwaTextStyles.label.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_android_rounded, size: 18),
                SizedBox(width: 8),
                Text('Téléphone'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email_rounded, size: 18),
                SizedBox(width: 8),
                Text('E-mail'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneForm(bool isDark) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral50,
            borderRadius: BorderRadius.circular(YonwaRadius.md),
            border: Border.all(
              color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral200,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showCountryPicker(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      Text(
                        _countries.firstWhere(
                          (c) => c['code'] == _selectedCountryCode,
                        )['flag']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _selectedCountryCode,
                        style: YonwaTextStyles.label.copyWith(
                          color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral400,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral200,
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: YonwaTextStyles.bodyLarge.copyWith(
                    color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                  ),
                  decoration: InputDecoration(
                    hintText: '97 00 00 00',
                    hintStyle: YonwaTextStyles.body.copyWith(
                      color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailForm(bool isDark) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral50,
            borderRadius: BorderRadius.circular(YonwaRadius.md),
            border: Border.all(
              color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral200,
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: YonwaTextStyles.bodyLarge.copyWith(
              color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
            ),
            decoration: InputDecoration(
              hintText: 'votre@email.com',
              hintStyle: YonwaTextStyles.body.copyWith(
                color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: YonwaSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral50,
            borderRadius: BorderRadius.circular(YonwaRadius.md),
            border: Border.all(
              color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral200,
              width: 0.5,
            ),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            style: YonwaTextStyles.bodyLarge.copyWith(
              color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
            ),
            decoration: InputDecoration(
              hintText: 'Mot de passe',
              hintStyle: YonwaTextStyles.body.copyWith(
                color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                ),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainButton(bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(YonwaRadius.lg),
        gradient: _isLoading
            ? LinearGradient(
                colors: [
                  YonwaColors.primary500.withOpacity(0.6),
                  YonwaColors.primary500.withOpacity(0.6),
                ],
              )
            : const LinearGradient(
                colors: [YonwaColors.primary500, YonwaColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: YonwaColors.primary500.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : () => _tabController.index == 0 ? _sendOTP() : _authWithEmail(),
          borderRadius: BorderRadius.circular(YonwaRadius.lg),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _tabController.index == 0 ? 'Recevoir le code' : 'Continuer',
                    style: YonwaTextStyles.button.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithText(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'ou',
            style: YonwaTextStyles.caption.copyWith(
              color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isLoading ? null : _authWithGoogle,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: isDark ? YonwaColors.neutral700 : Colors.white,
          side: BorderSide(
            color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral200,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(YonwaRadius.lg),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'G',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4285F4),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Continuer avec Google',
              style: YonwaTextStyles.label.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsText(bool isDark) {
    return Text(
      'En continuant, vous acceptez nos Conditions d\'utilisation\net notre Politique de confidentialité.',
      style: YonwaTextStyles.caption.copyWith(
        color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400,
        height: 1.6,
      ),
      textAlign: TextAlign.center,
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(YonwaRadius.xl)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(YonwaSpacing.md),
          decoration: BoxDecoration(
            color: isDark ? YonwaColors.neutral800 : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(YonwaRadius.xl)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: YonwaSpacing.md),
              Text(
                'Choisir le pays',
                style: YonwaTextStyles.h3.copyWith(
                  color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                ),
              ),
              const SizedBox(height: YonwaSpacing.md),
              ..._countries.map((c) => ListTile(
                leading: Text(c['flag']!, style: const TextStyle(fontSize: 28)),
                title: Text(
                  c['name']!,
                  style: YonwaTextStyles.body.copyWith(
                    color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                  ),
                ),
                trailing: Text(
                  c['code']!,
                  style: YonwaTextStyles.label.copyWith(
                    color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  setState(() => _selectedCountryCode = c['code']!);
                  Navigator.pop(ctx);
                },
              )),
              const SizedBox(height: YonwaSpacing.md),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────
//  OTP SCREEN with Enhanced UI
// ─────────────────────────────────────────────

class OTPScreen extends StatefulWidget {
  final String phone;
  final String verificationId;
  final int? resendToken;
  const OTPScreen({
    super.key,
    required this.phone,
    required this.verificationId,
    this.resendToken,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with TickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  int _resendCooldown = 0;
  
  late AnimationController _shakeController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  late String _verificationId;
  late int? _resendToken;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    _resendToken = widget.resendToken;
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _resendCode() async {
    if (_resendCooldown > 0) return;
    
    setState(() => _isLoading = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (mounted) await navigateAfterAuth(context);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _isLoading = false);
        _showError(e.message ?? 'Échec');
      },
      codeSent: (String vid, int? token) {
        setState(() {
          _isLoading = false;
          _verificationId = vid;
          _resendToken = token;
          _resendCooldown = 30;
        });
        _startCooldownTimer();
        _showSuccess('Code renvoyé !');
      },
      codeAutoRetrievalTimeout: (vid) => _verificationId = vid,
      forceResendingToken: _resendToken,
    );
  }

  void _startCooldownTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCooldown--;
        });
      }
      return _resendCooldown > 0 && mounted;
    });
  }

  void _verify() async {
    final smsCode = _controllers.map((c) => c.text).join();
    if (smsCode.length < 6) {
      _triggerShake();
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (mounted) {
        await navigateAfterAuth(context);
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      _triggerShake();
      _showError(e.message ?? 'Code invalide');
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Erreur lors de la vérification');
    }
  }

  void _triggerShake() {
    _shakeController.forward(from: 0);
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: YonwaColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YonwaRadius.md),
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: YonwaColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YonwaRadius.md),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.background,
      appBar: AppBar(
        title: const Text('Vérification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeController,
        child: Padding(
          padding: const EdgeInsets.all(YonwaSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified_user_rounded,
                size: 60,
                color: YonwaColors.primary500,
              ),
              const SizedBox(height: YonwaSpacing.lg),
              Text(
                'Code de vérification',
                style: YonwaTextStyles.h1.copyWith(
                  color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nous avons envoyé un code à',
                style: YonwaTextStyles.body.copyWith(
                  color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                ),
              ),
              Text(
                widget.phone,
                style: YonwaTextStyles.bodyLarge.copyWith(
                  color: YonwaColors.primary500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: YonwaSpacing.xl),

              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final shakeOffset = sin(_shakeController.value * 2 * pi) * 8;
                  return Transform.translate(
                    offset: Offset(shakeOffset, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (i) {
                        return SizedBox(
                          width: 48,
                          height: 56,
                          child: TextField(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: YonwaTextStyles.h2.copyWith(
                              color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: isDark ? YonwaColors.neutral700 : Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(YonwaRadius.md),
                                borderSide: BorderSide(
                                  color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral200,
                                  width: 0.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(YonwaRadius.md),
                                borderSide: const BorderSide(
                                  color: YonwaColors.primary500,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (val) {
                              if (val.isNotEmpty && i < 5) {
                                _focusNodes[i + 1].requestFocus();
                              }
                              if (_controllers.every((c) => c.text.isNotEmpty)) {
                                _verify();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: YonwaSpacing.xl),

              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(YonwaRadius.lg),
                  gradient: _isLoading
                      ? LinearGradient(
                          colors: [
                            YonwaColors.primary500.withOpacity(0.6),
                            YonwaColors.primary500.withOpacity(0.6),
                          ],
                        )
                      : const LinearGradient(
                          colors: [YonwaColors.primary500, YonwaColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: YonwaColors.primary500.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _isLoading ? null : _verify,
                    borderRadius: BorderRadius.circular(YonwaRadius.lg),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Vérifier',
                              style: YonwaTextStyles.button.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: YonwaSpacing.md),

              Center(
                child: _resendCooldown > 0
                    ? AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: 0.5 + 0.3 * _pulseController.value,
                            child: Text(
                              'Renvoyer le code (${_resendCooldown}s)',
                              style: YonwaTextStyles.body.copyWith(
                                color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                              ),
                            ),
                          );
                        },
                      )
                    : TextButton(
                        onPressed: _isLoading ? null : _resendCode,
                        child: Text(
                          'Renvoyer le code',
                          style: YonwaTextStyles.button.copyWith(
                            color: YonwaColors.primary500,
                          ),
                        ),
                      ),
              ),
              
              const Spacer(),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Un code à 6 chiffres vous a été envoyé par SMS',
                    style: YonwaTextStyles.caption.copyWith(
                      color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _shakeController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
