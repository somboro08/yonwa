import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';
import '../booking/my_bookings_screen.dart';
import 'favorites_screen.dart';
import 'identity_verification_screen.dart';
import 'settings_screen.dart';
import 'support_screen.dart';

class ProfileScreenMock extends StatelessWidget {
  const ProfileScreenMock({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Profil',
              style: YonwaTextStyles.h3.copyWith(
                color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: YonwaColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(YonwaRadius.full),
              ),
              child: Text(
                'Test',
                style: YonwaTextStyles.caption.copyWith(
                  color: YonwaColors.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: YonwaSpacing.xl),
        child: Column(
          children: [
            const SizedBox(height: YonwaSpacing.lg),
            // Header
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: YonwaColors.primary100,
                        child: Text(
                          'T',
                          style: YonwaTextStyles.display.copyWith(
                            color: YonwaColors.primary600,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: YonwaColors.primary500,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: YonwaSpacing.md),
                  Text(
                    'Utilisateur Test',
                    style: YonwaTextStyles.h2.copyWith(
                      color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                    ),
                  ),
                  Text(
                    'test@email.com',
                    style: YonwaTextStyles.body.copyWith(
                      color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: YonwaColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(YonwaRadius.full),
                    ),
                    child: Text(
                      'Mode développement',
                      style: YonwaTextStyles.caption.copyWith(
                        color: YonwaColors.warning,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: YonwaSpacing.xl),
            // Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: YonwaSpacing.md),
              child: Column(
                children: [
                  _ProfileMenuItemMock(
                    icon: Icons.bookmark_outline_rounded,
                    title: 'Mes Réservations',
                    isDark: isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
                      );
                    },
                  ),
                  _ProfileMenuItemMock(
                    icon: Icons.favorite_border_rounded,
                    title: 'Mes Favoris',
                    isDark: isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                      );
                    },
                  ),
                  _ProfileMenuItemMock(
                    icon: Icons.verified_user_outlined,
                    title: 'Vérification d\'identité',
                    isDark: isDark,
                    trailing: const Icon(Icons.error_outline_rounded, color: YonwaColors.warning, size: 20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const IdentityVerificationScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: YonwaSpacing.lg),
                  _ProfileMenuItemMock(
                    icon: Icons.settings_outlined,
                    title: 'Paramètres',
                    isDark: isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  _ProfileMenuItemMock(
                    icon: Icons.help_outline_rounded,
                    title: 'Aide & Support',
                    isDark: isDark,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SupportScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: YonwaSpacing.lg),
                  _ProfileMenuItemMock(
                    icon: Icons.logout_rounded,
                    title: 'Déconnexion',
                    isDark: isDark,
                    textColor: YonwaColors.error,
                    iconColor: YonwaColors.error,
                    onTap: () {
                      // Mock logout
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Déconnexion'),
                          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
                              },
                              child: const Text('Déconnexion', style: TextStyle(color: YonwaColors.error)),
                            ),
                          ],
                        ),
                      );
                    },
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

class _ProfileMenuItemMock extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final Color? textColor;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileMenuItemMock({
    required this.icon,
    required this.title,
    required this.isDark,
    this.textColor,
    this.iconColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: YonwaSpacing.sm),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(YonwaRadius.lg),
        border: Border.all(
          color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          width: 0.5,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? YonwaColors.primary500),
        title: Text(
          title,
          style: YonwaTextStyles.label.copyWith(
            color: textColor ?? (isDark ? YonwaColors.neutral0 : YonwaColors.neutral800),
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.chevron_right_rounded,
          color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral300,
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}