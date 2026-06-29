import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

ThemeData getYonwaTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: YonwaColors.background,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: YonwaColors.accentDeep,
      onPrimary: YonwaColors.surface,
      secondary: YonwaColors.accentGold,
      onSecondary: YonwaColors.textPrimary,
      error: YonwaColors.error,
      onError: YonwaColors.surface,
      surface: YonwaColors.surface,
      onSurface: YonwaColors.textPrimary,
    ),
    textTheme: TextTheme(
      displayLarge: YonwaTypography.display,
      headlineMedium: YonwaTypography.heading,
      bodyLarge: YonwaTypography.body,
      bodyMedium: YonwaTypography.bodySecondary,
      labelSmall: YonwaTypography.caption,
    ),
  );
}
