import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Découvrez le vrai Bénin',
      'desc': 'Explorez des expériences authentiques proposées par les acteurs locaux.',
      'img': 'assets/images/hero30.jpeg'
    },
    {
      'title': 'Rencontrez les artisans',
      'desc': 'Découvrez des savoir-faire uniques et des histoires inspirantes.',
      'img': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2'
    },
    {
      'title': 'Rejoignez la communauté',
      'desc': 'Connectez-vous avec des voyageurs et partagez vos découvertes.',
      'img': 'https://images.unsplash.com/photo-1517760444937-f6397edcbbcd'
    },
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: PageView.builder(
        controller: _controller,
        itemCount: _pages.length,
        onPageChanged: (i) => setState(() => _currentPage = i),
        itemBuilder: (context, i) => _buildPage(_pages[i]),
      ),
    );
  }

  Widget _buildPage(Map<String, String> page) {
    return Column(
      children: [
        // 75% Image
        Expanded(
          flex: 3,
          child: ClipPath(
            clipper: WaveClipper(),
            child: CachedNetworkImage(
              imageUrl: page['img']!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: YonwaColors.neutral200),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        // 25% Content
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(YonwaSpacing.md),
            child: Column(
              children: [
                Text(
                  page['title']!, 
                  style: YonwaTextStyles.h1.copyWith(color: YonwaColors.primary600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: YonwaSpacing.sm),
                Text(
                  page['desc']!, 
                  style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral700), 
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _finishOnboarding();
                      } else {
                        _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: YonwaColors.primary500,
                    ),
                    child: Text(_currentPage == _pages.length - 1 ? 'Commencer' : 'Suivant'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


