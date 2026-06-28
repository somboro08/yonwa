import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      appBar: AppBar(
        title: const Text('Mes Favoris', style: YonwaTextStyles.h3),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 64,
              color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
            ),
            const SizedBox(height: YonwaSpacing.md),
            Text(
              'Aucun favori pour le moment',
              style: YonwaTextStyles.h3.copyWith(color: YonwaColors.neutral500),
            ),
            const SizedBox(height: YonwaSpacing.sm),
            Text(
              'Ajoutez des logements à vos favoris pour les retrouver ici.',
              style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


