import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class ArtisansListScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) navigate;
  const ArtisansListScreen({super.key, required this.onBack, required this.navigate});

  @override
  State<ArtisansListScreen> createState() => _ArtisansListScreenState();
}

class _ArtisansListScreenState extends State<ArtisansListScreen> {
  String _filter = 'Tous';
  final _filters = ['Tous', 'Bronzier', 'Tisserand', 'Potier', 'Sculpteur'];

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
              children: [
                Row(
                  children: [
                    GestureDetector(onTap: widget.onBack, child: const Icon(Icons.chevron_left, size: 26, color: AppColors.textDark)),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Artisans', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark))),
                    GestureDetector(
                      onTap: () => widget.navigate('map'),
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final active = _filter == _filters[i];
                      return GestureDetector(
                        onTap: () => setState(() => _filter = _filters[i]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: active ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(_filters[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: active ? Colors.white : AppColors.textMuted)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${MockData.artisans.length} artisans trouvés', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: MockData.artisans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) {
                final a = MockData.artisans[i];
                return GestureDetector(
                  onTap: () => widget.navigate('artisanProfile'),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.07), blurRadius: 12)],
                    ),
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(width: 95, height: 95, child: NetworkImg(url: a.image)),
                            ),
                            if (a.certified)
                              Positioned(
                                bottom: 6, left: 6,
                                child: Container(
                                  width: 22, height: 22,
                                  decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle, border: Border.all(color: AppColors.card, width: 1.5)),
                                  child: const Icon(Icons.military_tech, size: 12, color: AppColors.textDark),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                              Text(a.specialty, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 3),
                              Row(children: [
                                const Icon(Icons.location_on_outlined, size: 11, color: AppColors.textMuted),
                                const SizedBox(width: 2),
                                Text(a.location, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ]),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  StarRating(value: a.rating, count: a.reviews, size: 11),
                                  Text('dès ${(a.price / 1000).toStringAsFixed(0)}k FCFA', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Wrap(spacing: 6, children: a.tags.take(2).map((t) => AppBadge(label: t, color: AppColors.textMuted)).toList()),
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
