import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YonwaOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const YonwaOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFC9A84C), width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: const Color(0xFFC9A84C),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
