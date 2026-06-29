import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class CategoriesScreen extends StatelessWidget {
  final VoidCallback onBack;
  final Function(String) navigate;
  const CategoriesScreen({super.key, required this.onBack, required this.navigate});

  IconData _icon(String name) {
    switch (name) {
      case 'palette': return Icons.palette_outlined;
      case 'restaurant': return Icons.restaurant_outlined;
      case 'account_balance': return Icons.account_balance_outlined;
      case 'forest': return Icons.forest_outlined;
      case 'music_note': return Icons.music_note_outlined;
      case 'content_cut': return Icons.content_cut_outlined;
      default: return Icons.category_outlined;
    }
  }

  Color _hexColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: 'Catégories', onBack: onBack),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: MockData.categories.length,
        itemBuilder: (_, i) {
          final cat = MockData.categories[i];
          final color = _hexColor(cat.color);
          return GestureDetector(
            onTap: () => navigate('artisansList'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImg(url: cat.image),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [color.withOpacity(0.55), AppColors.textDark.withOpacity(0.6)],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                          child: Icon(_icon(cat.iconName), color: Colors.white, size: 20),
                        ),
                        const Spacer(),
                        Text(cat.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                        Text('${cat.count} créateurs', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
