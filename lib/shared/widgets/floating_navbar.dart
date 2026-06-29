import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import '../../core/responsive/breakpoints.dart';

class FloatingNavbar extends StatelessWidget {
  final VoidCallback onMenuPressed;
  const FloatingNavbar({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16), // Vertical margin removed as it's now positioned manually
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEF2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          // Mobile: hamburger | Web: espace vide (sidebar gère la nav)
          if (context.isMobile)
            IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedMenu01,
                color: Color(0xFF0D0D0D),
                size: 22,
              ),
              onPressed: onMenuPressed, // Use the passed callback
            ),
          Expanded(
            child: Center(
              child: Text(
                'Yonwa',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D0D0D),
                ),
              ),
            ),
          ),
          const HugeIcon(
            icon: HugeIcons.strokeRoundedNotification02,
            color: Color(0xFF0D0D0D),
            size: 22,
          ),
          const SizedBox(width: 12),
          // Bouton S'inscrire (outline pill)
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFC9A84C), width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              "S'inscrire",
              style: GoogleFonts.inter(
                color: const Color(0xFFC9A84C),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            onPressed: () {
              context.push('/auth');
            },
          ),
        ],
      ),
    );
  }
}
