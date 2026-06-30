import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class UserProfileScreen extends StatelessWidget {
  final Function(String) navigate;
  const UserProfileScreen({super.key, required this.navigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: AppColors.primary,
                  child: CustomPaint(painter: _StripePainter()),
                ),
                Positioned(
                  bottom: -40,
                  left: 20,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.background, width: 4),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10)],
                        ),
                        child: const Icon(Icons.person, color: AppColors.textMuted, size: 40),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(color: AppColors.card, shape: BoxShape.circle, border: Border.all(color: AppColors.border)),
                          child: const Icon(Icons.camera_alt, size: 12, color: AppColors.textDark),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -32,
                  right: 20,
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined, size: 14),
                    label: const Text('Modifier'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 56),

            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Adama Konaté', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  const Text('adama.konate@email.com', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, size: 13, color: AppColors.textMuted),
                      SizedBox(width: 3),
                      Text('Cotonou, Bénin', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats
                  Row(
                    children: [
                      _StatCard(value: '7', label: 'Réservations'),
                      const SizedBox(width: 12),
                      _StatCard(value: '12', label: 'Favoris'),
                      const SizedBox(width: 12),
                      _StatCard(value: '5', label: 'Avis'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Menu
                  const Text('Mon compte', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.8)),
                  const SizedBox(height: 10),
                  _MenuItem(icon: Icons.calendar_month_outlined, label: 'Mes réservations', onTap: () => navigate('history')),
                  _MenuItem(icon: Icons.favorite_border, label: 'Mes favoris', onTap: () => navigate('favorites')),
                  _MenuItem(icon: Icons.star_border, label: 'Mes avis', onTap: () => navigate('reviews')),
                  _MenuItem(icon: Icons.credit_card_outlined, label: 'Moyens de paiement', onTap: () {}),
                  const SizedBox(height: 16),

                  const Text('Préférences', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.8)),
                  const SizedBox(height: 10),
                  _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () => navigate('notifications')),
                  _MenuItem(icon: Icons.settings_outlined, label: 'Paramètres', onTap: () => navigate('settings')),
                  _MenuItem(icon: Icons.help_outline, label: 'Aide & Support', onTap: () {}),
                  _MenuItem(icon: Icons.info_outline, label: 'À propos de YONWA', onTap: () {}),
                  const SizedBox(height: 16),

                  _MenuItem(
                    icon: Icons.logout,
                    label: 'Se déconnecter',
                    onTap: () {},
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primary)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _MenuItem({required this.icon, required this.label, required this.onTap, this.color = AppColors.textDark});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: color == AppColors.textDark ? AppColors.surface : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
      trailing: color == AppColors.textDark ? const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18) : null,
      onTap: onTap,
    );
  }
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.secondary.withOpacity(0.25)..strokeWidth = 20..style = PaintingStyle.stroke;
    for (var i = -4; i < 10; i++) {
      canvas.drawLine(Offset(size.width * i * 0.12, 0), Offset(size.width * i * 0.12 + size.height * 2, size.height * 2), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
