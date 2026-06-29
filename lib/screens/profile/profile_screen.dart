// profile_screen.dart
import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';
import '../commerce/cart_screen.dart';
import '../booking/my_bookings_screen.dart';
import 'favorites_screen.dart';
import 'identity_verification_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'support_screen.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/layout/app_shell.dart';
import '../../shared/widgets/floating_navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final body = SingleChildScrollView(
      child: Column(
        children: [
          // Premium Header with Gradient Background
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Top Gradient Background
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      YonwaColors.primary500, // Terre cuite
                      YonwaColors.secondary,  // Orange coucher de soleil
                      isDark ? YonwaColors.neutral800 : YonwaColors.primary100,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(YonwaRadius.xl),
                    bottomRight: Radius.circular(YonwaRadius.xl),
                  ),
                ),
              ),
              // App Bar Title (Overlay)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: YonwaSpacing.md,
                    vertical: YonwaSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mon Profil',
                        style: YonwaTextStyles.h2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(YonwaRadius.full),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          'Test Mode',
                          style: YonwaTextStyles.caption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Profile Card overlapping the background
              Positioned(
                top: 120,
                left: YonwaSpacing.md,
                right: YonwaSpacing.md,
                child: Container(
                  padding: const EdgeInsets.all(YonwaSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark ? YonwaColors.neutral800 : Colors.white,
                    borderRadius: BorderRadius.circular(YonwaRadius.xl),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar with Gradient Ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  YonwaColors.primary500,
                                  YonwaColors.secondary,
                                  YonwaColors.accent,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? YonwaColors.neutral800 : Colors.white,
                            ),
                          ),
                          const CircleAvatar(
                            radius: 41,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=300',
                            ),
                            backgroundColor: YonwaColors.primary100,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: YonwaColors.success,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: YonwaSpacing.md),
                      Text(
                        'Utilisateur Test',
                        style: YonwaTextStyles.h2.copyWith(
                          color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'test@email.com',
                        style: YonwaTextStyles.body.copyWith(
                          color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                        ),
                      ),
                      const SizedBox(height: YonwaSpacing.sm),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: YonwaColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(YonwaRadius.full),
                          border: Border.all(
                            color: YonwaColors.warning.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.construction_rounded,
                              size: 14,
                              color: YonwaColors.warning,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Mode développement',
                              style: YonwaTextStyles.caption.copyWith(
                                color: YonwaColors.warning,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Height placeholder to compensate for the absolute positioned profile card
          const SizedBox(height: 180),
          
          // Menu Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: YonwaSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: YonwaSpacing.sm),
                  child: Text(
                    'Mon Espace',
                    style: YonwaTextStyles.label.copyWith(
                      color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _ProfileMenuItem(
                  icon: Icons.edit_outlined,
                  title: 'Modifier mon profil',
                  color: YonwaColors.info,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Panier',
                  color: YonwaColors.secondary,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.bookmark_outline_rounded,
                  title: 'Mes Réservations',
                  color: YonwaColors.primary500,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.favorite_border_rounded,
                  title: 'Mes Favoris',
                  color: YonwaColors.error,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.verified_user_outlined,
                  title: 'Vérification d\'identité',
                  color: YonwaColors.success,
                  isDark: isDark,
                  trailing: const Icon(
                    Icons.error_outline_rounded,
                    color: YonwaColors.warning,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const IdentityVerificationScreen()),
                    );
                  },
                ),
                
                const SizedBox(height: YonwaSpacing.lg),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: YonwaSpacing.sm),
                  child: Text(
                    'Paramètres & Aide',
                    style: YonwaTextStyles.label.copyWith(
                      color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                _ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Paramètres',
                  color: YonwaColors.secondary,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Aide & Support',
                  color: YonwaColors.accent,
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SupportScreen()),
                    );
                  },
                ),
                
                const SizedBox(height: YonwaSpacing.lg),
                _ProfileMenuItem(
                  icon: Icons.logout_rounded,
                  title: 'Déconnexion',
                  color: YonwaColors.error,
                  isDark: isDark,
                  textColor: YonwaColors.error,
                  onTap: () {
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
                            child: const Text(
                              'Déconnexion',
                              style: TextStyle(color: YonwaColors.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: YonwaSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );

    return ResponsiveLayout(
      mobile: Scaffold(
        backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
        drawer: const Drawer(),
        body: SafeArea(
          child: Builder(
            builder: (context) => Column(
              children: [
                FloatingNavbar(onMenuPressed: () => Scaffold.of(context).openDrawer()),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
      desktop: AppShell(child: body),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final bool isDark;
  final Color? textColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.isDark,
    this.textColor,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: YonwaSpacing.md,
          vertical: YonwaSpacing.xs,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(YonwaRadius.md),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: YonwaTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor ?? (isDark ? YonwaColors.neutral0 : YonwaColors.neutral800),
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.chevron_right_rounded,
          color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral300,
          size: 24,
        ),
        onTap: onTap ?? () {},
      ),
    );
  }
}
