import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;
  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _scale = Tween(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _opacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.6)));
    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0.5, 1.0)));

    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 2600), widget.onDone);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textDark,
      body: Stack(
        children: [
          // Geometric background pattern
          ..._buildPattern(),

          Center(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => Opacity(
                opacity: _opacity.value,
                child: Transform.scale(
                  scale: _scale.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: CustomPaint(painter: _LogoPainter()),
                          ),
                          Positioned(
                            bottom: -4,
                            right: -4,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.textDark, width: 2),
                              ),
                              child: const Icon(Icons.check, size: 11, color: AppColors.textDark),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Opacity(
                        opacity: _textOpacity.value,
                        child: const Text(
                          'YONWA',
                          style: TextStyle(
                            color: Color(0xFFFAF6F0),
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Opacity(
                        opacity: _textOpacity.value,
                        child: const Text(
                          'Découvrez le Bénin authentique',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPattern() {
    return List.generate(12, (i) {
      return Positioned(
        left: ((i * 17) % 100) / 100 * 400 - 30,
        top: ((i * 23) % 100) / 100 * 850 - 30,
        child: Container(
          width: 60.0 + (i % 5) * 30,
          height: 60.0 + (i % 5) * 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondary.withOpacity(0.2), width: 1),
          ),
        ),
      );
    });
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.secondary.withOpacity(0.9);
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.1);
    path.lineTo(size.width * 0.85, size.height * 0.82);
    path.lineTo(size.width * 0.15, size.height * 0.82);
    path.close();
    canvas.drawPath(path, paint);

    final inner = Paint()..color = AppColors.textDark.withOpacity(0.5);
    final innerPath = Path();
    innerPath.moveTo(size.width * 0.5, size.height * 0.3);
    innerPath.lineTo(size.width * 0.73, size.height * 0.73);
    innerPath.lineTo(size.width * 0.27, size.height * 0.73);
    innerPath.close();
    canvas.drawPath(innerPath, inner);

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      8,
      Paint()..color = const Color(0xFFFAF6F0),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
