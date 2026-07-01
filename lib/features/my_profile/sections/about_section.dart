import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/providers/user_provider.dart';
import '../role_profile_config.dart';

/// Onglet "À propos" — bio détaillée + coordonnées + "Mon Espace" (menu commun).
class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProviderRef);
    final config = RoleProfileConfig.forRole(user.role);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio
          _InfoCard(
            icon: HugeIcons.strokeRoundedUserAccount,
            title: 'Biographie',
            body: user.bio,
          ),
          const SizedBox(height: 12),

          // Tagline métier
          _InfoCard(
            icon: HugeIcons.strokeRoundedAward02,
            title: 'Activité',
            body: RoleProfileConfig.roleTagline(user.role),
          ),
          const SizedBox(height: 12),

          // Coordonnées
          _ContactRow(label: 'Téléphone', value: user.telephone),
          const SizedBox(height: 8),
          _ContactRow(label: 'Email', value: user.email),
          const SizedBox(height: 24),

          // Mon Espace — commun à tous les rôles
          _SpaceTitle(),
          const SizedBox(height: 12),
          _SpaceItem(
            icon: HugeIcons.strokeRoundedCalendar01,
            label: 'Mes réservations',
            onTap: () => context.go('/booking'),
          ),
          _SpaceItem(
            icon: HugeIcons.strokeRoundedFavourite,
            label: 'Mes favoris',
            onTap: () => context.go('/explore'),
          ),
          _SpaceItem(
            icon: HugeIcons.strokeRoundedShieldKey,
            label: 'Vérification d\'identité',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vérification d\'identité — bientôt disponible.')),
            ),
          ),
          _SpaceItem(
            icon: HugeIcons.strokeRoundedSettings02,
            label: 'Paramètres',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Paramètres — bientôt disponible.')),
            ),
          ),
          _SpaceItem(
            icon: HugeIcons.strokeRoundedLogout02,
            label: 'Déconnexion',
            isDestructive: true,
            onTap: () => context.go('/auth'),
          ),
          const SizedBox(height: 8),
          Text(
            'Rôle actif : ${user.role.displayName} · ${config.tabs.length} onglets',
            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFFB0B0BE)),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String title;
  final String body;
  const _InfoCard({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(icon: icon, color: const Color(0xFFC9A84C), size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D0D0D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF0D0D0D),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String label;
  final String value;
  const _ContactRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: const Color(0xFF6B6B7A),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF0D0D0D)),
          ),
        ),
      ],
    );
  }
}

class _SpaceTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Mon Espace',
      style: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF0D0D0D),
      ),
    );
  }
}

class _SpaceItem extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  const _SpaceItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFE53E3E) : const Color(0xFF0D0D0D);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEF2)),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: HugeIcon(icon: icon, color: color, size: 20),
        title: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFFB0B0BE),
        ),
      ),
    );
  }
}
