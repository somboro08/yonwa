import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../role_profile_config.dart';

/// Bandeau d'actions rapides — les CTA métier (Ajouter produit, Créer atelier...).
class QuickActionsBar extends StatelessWidget {
  final List<ProfileQuickAction> actions;
  final ValueChanged<QuickActionType> onAction;
  const QuickActionsBar({super.key, required this.actions, required this.onAction});

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: actions.map((action) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A1A2E),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                icon: HugeIcon(icon: action.icon, color: Colors.white, size: 16),
                label: Flexible(
                  child: Text(
                    action.label,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () => onAction(action.type),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
