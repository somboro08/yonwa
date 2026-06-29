import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class YonwaTypography {
  // Display (splash, hero, titres H1)
  static TextStyle get display => GoogleFonts.poppins(
        fontWeight: FontWeight.w800,
        fontSize: 48,
        letterSpacing: -1.5,
        color: YonwaColors.textPrimary,
      );

  // Heading (sections, cartes)
  static TextStyle get heading => GoogleFonts.outfit(
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: YonwaColors.textPrimary,
      );

  // Body
  static TextStyle get body => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.6,
        color: YonwaColors.textPrimary,
      );

  static TextStyle get bodySecondary => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.6,
        color: YonwaColors.textSecondary,
      );

  // Caption / Labels
  static TextStyle get caption => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
        fontSize: 11,
        letterSpacing: 0.6,
        color: YonwaColors.textSecondary,
      );

  static TextStyle get labelGold => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 10,
        letterSpacing: 0.5,
        color: YonwaColors.accentGold,
      );
}
