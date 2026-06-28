import 'package:flutter/material.dart';
import '../theme/yonwa_theme.dart';
import '../models/models.dart';

class CertificationBadge extends StatelessWidget {
  final CertificationStatus status;
  const CertificationBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (status) {
      case CertificationStatus.certified:
        bg = YonwaColors.certified;
        fg = Colors.white;
        icon = Icons.verified_rounded;
        label = 'Yonwa Certifié';
        break;
      case CertificationStatus.pending:
        bg = YonwaColors.warning;
        fg = Colors.white;
        icon = Icons.hourglass_top_rounded;
        label = 'En attente';
        break;
      case CertificationStatus.rejected:
        bg = YonwaColors.error;
        fg = Colors.white;
        icon = Icons.cancel_rounded;
        label = 'Non certifié';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(YonwaRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: YonwaTextStyles.caption.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class YonwaBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const YonwaBadge({super.key, required this.label, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    final c = color ?? YonwaColors.primary500;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(YonwaRadius.full),
        border: Border.all(color: c.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: c),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: YonwaTextStyles.caption.copyWith(
              color: c,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


