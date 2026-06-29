import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../shared/providers/user_provider.dart';
import '../role_profile_config.dart';
import 'role_badge.dart';

/// En-tête du profil self : cover + avatar + nom + badge rôle + bio + ligne de KPI.
class ProfileHeader extends ConsumerWidget {
  final VoidCallback onRoleTap;
  const ProfileHeader({super.key, required this.onRoleTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProviderRef);
    final config = RoleProfileConfig.forRole(user.role);
    final stats = user.stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Zone cover + avatar chevauchant ──
        SizedBox(
          height: 150,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Cover
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  child: user.coverImage.startsWith('http')
                      ? Image.network(user.coverImage, fit: BoxFit.cover)
                      : Image.asset(user.coverImage, fit: BoxFit.cover),
                ),
              ),

              // Bouton retour (si on peut pop)
              if (Navigator.canPop(context))
                Positioned(
                  top: 16,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.9),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0D0D0D)),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                ),

              // Avatar chevauchant
              Positioned(
                bottom: -36,
                left: 24,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 46,
                    backgroundImage: NetworkImage(user.photoUrl),
                    backgroundColor: const Color(0xFFF2F2F4),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Bloc texte + KPI ──
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 52, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      user.fullName,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D0D0D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedTickDouble02,
                    color: Color(0xFF38A169),
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RoleBadge(role: user.role, canSwitch: true, onTap: onRoleTap),
              const SizedBox(height: 8),
              Text(
                RoleProfileConfig.roleTagline(user.role),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF6B6B7A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.bio,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF0D0D0D),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),

              // Ligne de KPI
              Row(
                children: config.kpis.map((kpi) {
                  final value = stats[kpi.statsKey] ?? 0;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFEEEEF2)),
                      ),
                      child: Column(
                        children: [
                          HugeIcon(icon: kpi.icon, color: const Color(0xFFC9A84C), size: 18),
                          const SizedBox(height: 6),
                          Text(
                            '$value',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D0D0D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            kpi.label,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFF6B6B7A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
