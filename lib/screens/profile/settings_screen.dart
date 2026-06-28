import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';
import '../../theme/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/user_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      appBar: AppBar(
        title: const Text('Paramètres', style: YonwaTextStyles.h3),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(YonwaSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Compte & Rôle',
                style: YonwaTextStyles.label.copyWith(
                  color: YonwaColors.neutral500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: YonwaSpacing.sm),
              _SettingsItem(
                title: 'Mon Rôle / Métier',
                subtitle: 'Sélectionnez votre rôle dans la marketplace',
                isDark: isDark,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userProvider.role.displayName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: YonwaColors.primary500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: YonwaColors.primary500,
                    ),
                  ],
                ),
                onTap: () {
                  _showRoleSelectionDialog(context, userProvider, isDark);
                },
              ),
              const SizedBox(height: YonwaSpacing.lg),
              Text(
                'Apparence',
                style: YonwaTextStyles.label.copyWith(
                  color: YonwaColors.neutral500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: YonwaSpacing.sm),
              _SettingsItem(
                title: 'Mode sombre',
                subtitle: 'Activer le thème sombre pour économiser la batterie',
                isDark: isDark,
                trailing: Switch.adaptive(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: YonwaColors.primary500,
                ),
              ),
              const SizedBox(height: YonwaSpacing.lg),
              Text(
                'Notifications',
                style: YonwaTextStyles.label.copyWith(
                  color: YonwaColors.neutral500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: YonwaSpacing.sm),
              _SettingsItem(
                title: 'Notifications push',
                subtitle: 'Recevoir des alertes pour vos réservations',
                isDark: isDark,
                trailing: Switch.adaptive(
                  value: true,
                  onChanged: (value) {},
                  activeColor: YonwaColors.primary500,
                ),
              ),
              _SettingsItem(
                title: 'E-mails marketing',
                subtitle: 'Recevoir nos meilleures offres par mail',
                isDark: isDark,
                trailing: Switch.adaptive(
                  value: false,
                  onChanged: (value) {},
                  activeColor: YonwaColors.primary500,
                ),
              ),
              const SizedBox(height: YonwaSpacing.lg),
              Text(
                'Sécurité & Confidentialité',
                style: YonwaTextStyles.label.copyWith(
                  color: YonwaColors.neutral500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: YonwaSpacing.sm),
              _SettingsItem(
                title: 'Changer le mot de passe',
                isDark: isDark,
                onTap: () {},
              ),
              _SettingsItem(
                title: 'Supprimer mon compte',
                isDark: isDark,
                textColor: YonwaColors.error,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoleSelectionDialog(BuildContext context, UserProvider userProvider, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: isDark ? YonwaColors.neutral800 : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Choisir mon rôle',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: UserRole.values.map((role) {
                final isSelected = userProvider.role == role;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? YonwaColors.primary500.withOpacity(0.1) 
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? YonwaColors.primary500 : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      role.displayName,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected 
                            ? YonwaColors.primary500 
                            : (isDark ? Colors.white : YonwaColors.neutral900),
                      ),
                    ),
                    trailing: isSelected 
                        ? const Icon(Icons.check_circle_rounded, color: YonwaColors.primary500) 
                        : null,
                    onTap: () {
                      userProvider.updateRole(role);
                      Navigator.pop(ctx);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isDark;
  final Widget? trailing;
  final Color? textColor;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.title,
    this.subtitle,
    required this.isDark,
    this.trailing,
    this.textColor,
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
        title: Text(
          title,
          style: YonwaTextStyles.label.copyWith(
            color: textColor ?? (isDark ? YonwaColors.neutral0 : YonwaColors.neutral800),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500),
              )
            : null,
        trailing: trailing ?? (onTap != null ? Icon(
          Icons.chevron_right_rounded,
          color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral300,
        ) : null),
        onTap: onTap,
      ),
    );
  }
}


