import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';

class AuthBottomSheet extends StatelessWidget {
  final VoidCallback onSuccess;

  const AuthBottomSheet({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle/Bar
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEF2),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Icon
          const Center(
            child: CircleAvatar(
              radius: 28,
              backgroundColor: YonwaColors.surfaceMuted,
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedLockKey,
                color: YonwaColors.accentGold,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Connexion requise',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: YonwaColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Veuillez vous connecter pour réserver cette expérience ou enregistrer vos favoris.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: YonwaColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // Connecter Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: YonwaColors.accentDeep,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.pop(context); // Close sheet
              context.push('/auth');
            },
            child: Text(
              'Se connecter',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Cancel
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFEEEEF2)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Plus tard',
              style: GoogleFonts.inter(
                color: YonwaColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
