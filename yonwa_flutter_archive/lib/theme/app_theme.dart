import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFFC4622D);
  static const Color secondary = Color(0xFFD4A853);
  static const Color background = Color(0xFFFAF6F0);
  static const Color card = Color(0xFFFFFBF5);
  static const Color surface = Color(0xFFF0E6D3);
  static const Color textDark = Color(0xFF2C1A0E);
  static const Color textMuted = Color(0xFF8B6E55);
  static const Color textLight = Color(0xFFD4BC9A);
  static const Color green = Color(0xFF5A7A3A);
  static const Color blue = Color(0xFF2E6E8E);
  static const Color purple = Color(0xFF8B3EC8);
  static const Color border = Color(0xFFF0E6D3);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.card,
        ),
        textTheme: GoogleFonts.dmSansTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: GoogleFonts.playfairDisplay(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.dmSans(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.dmSans(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: GoogleFonts.dmSans(color: AppColors.textDark),
          bodyMedium: GoogleFonts.dmSans(color: AppColors.textDark),
          bodySmall: GoogleFonts.dmSans(color: AppColors.textMuted),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.card,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.dmSans(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          iconTheme: const IconThemeData(color: AppColors.textDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );
}
