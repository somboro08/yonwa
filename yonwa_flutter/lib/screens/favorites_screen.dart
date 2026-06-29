import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class FavoritesScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) navigate;
  const FavoritesScreen({super.key, required this.onBack, required this.navigate});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _tab = 'artisans';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 14),
            color: AppColors.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Favoris', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [['artisans', 'Artisans'], ['experiences', 'Expériences'], ['guides', 'Guides']].map((t) {
                      final active = _tab == t[0];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tab = t[0]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            decoration: BoxDecoration(
                              color: active ? AppColors.card : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(t[1], textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? AppColors.primary : AppColors.textMuted)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _tab == 'artisans' ? MockData.artisans.length : _tab == 'guides' ? MockData.guides.length : MockData.experiences.length,
              itemBuilder: (_, i) {
                String image, name, sub;
                double rating;
                if (_tab == 'artisans') {
                  final a = MockData.artisans[i];
                  image = a.image; name = a.name; sub = a.specialty; rating = a.rating;
                } else if (_tab == 'guides') {
                  final g = MockData.guides[i];
                  image = g.image; name = g.name; sub = g.specialty; rating = g.rating;
                } else {
                  final e = MockData.experiences[i];
                  image = e.image; name = e.title; sub = e.category; rating = e.rating;
                }

                return GestureDetector(
                  onTap: () => widget.navigate(_tab == 'artisans' ? 'artisanProfile' : _tab == 'guides' ? 'guideProfile' : 'experienceProfile'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.07), blurRadius: 10)],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              NetworkImg(url: image),
                              Positioned(
                                top: 8, right: 8,
                                child: Container(
                                  width: 28, height: 28,
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                                  child: const Icon(Icons.favorite, size: 14, color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                              Text(sub, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                              const SizedBox(height: 4),
                              StarRating(value: rating, size: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
