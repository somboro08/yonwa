import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../models/models.dart';
import '../role_profile_config.dart';

/// Chip de rôle coloré. Tappable pour ouvrir le sélecteur de rôle.
class RoleBadge extends StatelessWidget {
  final UserRole role;
  final bool canSwitch;
  final VoidCallback? onTap;
  const RoleBadge({
    super.key,
    required this.role,
    this.canSwitch = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = RoleProfileConfig.roleColor(role);
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedUserCircle,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            role.displayName,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          if (canSwitch) ...[
            const SizedBox(width: 4),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowDown01,
              color: color,
              size: 12,
            ),
          ],
        ],
      ),
    );

    if (!canSwitch || onTap == null) return badge;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: badge,
    );
  }
}
