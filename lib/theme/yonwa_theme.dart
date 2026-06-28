import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  YONWA DESIGN TOKENS
// ─────────────────────────────────────────────

class YonwaColors {
  // Palette Yonwa - Patrimoine Béninois
  static const primary50  = Color(0xFFFBEBE8);
  static const primary100 = Color(0xFFF7D8D1);
  static const primary200 = Color.fromARGB(255, 169, 238, 163);
  static const primary300 = Color.fromARGB(255, 117, 230, 134);
  static const primary400 = Color.fromARGB(255, 50, 184, 73);
  static const primary500 = Color.fromARGB(255, 129, 226, 91); // Terre cuite (Brand color)
  static const primary600 = Color.fromARGB(255, 73, 181, 93);
  static const primary700 = Color(0xFF884437);

  // Secondary - Orange coucher de soleil
  static const secondary  = Color(0xFFFF8C42);
  
  // Background - Beige sable
  static const background = Color(0xFFF5E6CA);
  
  // Accent - Vert nature
  static const accent     = Color(0xFF6B8E23);

  // Neutral - Warm grays
  static const neutral0   = Color(0xFFFFFFFF);
  static const neutral50  = Color(0xFFFAF9F7);
  static const neutral100 = Color(0xFFF2F0EC);
  static const neutral200 = Color(0xFFE5E2DC);
  static const neutral300 = Color(0xFFCCC8BF);
  static const neutral400 = Color(0xFF9E9A92);
  static const neutral500 = Color(0xFF706C65);
  static const neutral600 = Color(0xFF4A4740);
  static const neutral700 = Color(0xFF2E2B25);
  static const neutral800 = Color(0xFF1E1C18);
  static const neutral900 = Color(0xFF12100D);

  // Semantic
  static const success    = Color(0xFF22C55E);
  static const warning    = Color(0xFFF59E0B);
  static const error      = Color(0xFFEF4444);
  static const info       = Color(0xFF3B82F6);

  // Certification badge
  static const certified  = Color(0xFF22C55E);
  static const pending    = Color(0xFFF59E0B);
  static const rejected   = Color(0xFFEF4444);
}

class YonwaSpacing {
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 16.0;
  static const double lg   = 24.0;
  static const double xl   = 32.0;
  static const double xxl  = 48.0;
  static const double xxxl = 64.0;
}

class YonwaRadius {
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 24.0;
  static const double full = 999.0;
}

// ─────────────────────────────────────────────
//  TEXT STYLES
// ─────────────────────────────────────────────

class YonwaTextStyles {
  static const String fontFamily = 'Poppins';

  static const display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static const button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
}

// ─────────────────────────────────────────────
//  LIGHT THEME
// ─────────────────────────────────────────────

ThemeData yonwaLightTheme() {
  const seed = YonwaColors.primary500;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: YonwaTextStyles.fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      primary: YonwaColors.primary500,
      onPrimary: Colors.white,
      secondary: YonwaColors.secondary,
      surface: YonwaColors.neutral0,
      background: YonwaColors.background,
      error: YonwaColors.error,
    ),
    scaffoldBackgroundColor: YonwaColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: YonwaColors.neutral800,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: YonwaTextStyles.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: YonwaColors.neutral800,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: YonwaColors.primary500,
        foregroundColor: Colors.white,
        textStyle: YonwaTextStyles.button,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YonwaRadius.lg),
        ),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: YonwaColors.primary500,
        textStyle: YonwaTextStyles.button,
        side: const BorderSide(color: YonwaColors.primary500, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YonwaRadius.lg),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: YonwaColors.primary500,
        textStyle: YonwaTextStyles.button,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: YonwaColors.neutral100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(YonwaRadius.md),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(YonwaRadius.md),
        borderSide: const BorderSide(color: YonwaColors.neutral200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(YonwaRadius.md),
        borderSide: const BorderSide(color: YonwaColors.primary500, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(YonwaRadius.md),
        borderSide: const BorderSide(color: YonwaColors.error),
      ),
      hintStyle: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral400),
    ),
    cardTheme: CardThemeData(
      color: YonwaColors.neutral0,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(YonwaRadius.lg),
        side: const BorderSide(color: YonwaColors.neutral200, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: YonwaColors.neutral100,
      selectedColor: YonwaColors.primary100,
      labelStyle: YonwaTextStyles.caption,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(YonwaRadius.full),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: YonwaColors.neutral0,
      selectedItemColor: YonwaColors.primary500,
      unselectedItemColor: YonwaColors.neutral400,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(
        fontFamily: YonwaTextStyles.fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: YonwaTextStyles.fontFamily,
        fontSize: 11,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: YonwaColors.neutral200,
      thickness: 0.5,
    ),
    textTheme: const TextTheme(
      displayLarge: YonwaTextStyles.display,
      headlineLarge: YonwaTextStyles.h1,
      headlineMedium: YonwaTextStyles.h2,
      headlineSmall: YonwaTextStyles.h3,
      bodyLarge: YonwaTextStyles.bodyLarge,
      bodyMedium: YonwaTextStyles.body,
      bodySmall: YonwaTextStyles.caption,
      labelLarge: YonwaTextStyles.button,
      labelMedium: YonwaTextStyles.label,
    ),
  );
}

// ─────────────────────────────────────────────
//  DARK THEME
// ─────────────────────────────────────────────

ThemeData yonwaDarkTheme() {
  const seed = YonwaColors.primary500;

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: YonwaTextStyles.fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      primary: YonwaColors.primary400,
      onPrimary: YonwaColors.neutral900,
      secondary: YonwaColors.secondary,
      surface: YonwaColors.neutral800,
      background: YonwaColors.neutral900,
      error: YonwaColors.error,
    ),
    scaffoldBackgroundColor: YonwaColors.neutral900,
    appBarTheme: const AppBarTheme(
      backgroundColor: YonwaColors.neutral800,
      foregroundColor: YonwaColors.neutral0,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: YonwaTextStyles.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: YonwaColors.neutral0,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: YonwaColors.primary500,
        foregroundColor: Colors.white,
        textStyle: YonwaTextStyles.button,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YonwaRadius.lg),
        ),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: YonwaColors.primary400,
        textStyle: YonwaTextStyles.button,
        side: const BorderSide(color: YonwaColors.primary400, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YonwaRadius.lg),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: YonwaColors.primary400,
        textStyle: YonwaTextStyles.button,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: YonwaColors.neutral700,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(YonwaRadius.md),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(YonwaRadius.md),
        borderSide: const BorderSide(color: YonwaColors.neutral600),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(YonwaRadius.md),
        borderSide: const BorderSide(color: YonwaColors.primary400, width: 2),
      ),
      hintStyle: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
    ),
    cardTheme: CardThemeData(
      color: YonwaColors.neutral800,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(YonwaRadius.lg),
        side: const BorderSide(color: YonwaColors.neutral700, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: YonwaColors.neutral800,
      selectedItemColor: YonwaColors.primary400,
      unselectedItemColor: YonwaColors.neutral500,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    dividerTheme: const DividerThemeData(
      color: YonwaColors.neutral700,
      thickness: 0.5,
    ),
    textTheme: const TextTheme(
      displayLarge: YonwaTextStyles.display,
      headlineLarge: YonwaTextStyles.h1,
      headlineMedium: YonwaTextStyles.h2,
      headlineSmall: YonwaTextStyles.h3,
      bodyLarge: YonwaTextStyles.bodyLarge,
      bodyMedium: YonwaTextStyles.body,
      bodySmall: YonwaTextStyles.caption,
      labelLarge: YonwaTextStyles.button,
      labelMedium: YonwaTextStyles.label,
    ),
  );
}


