import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class SearchScreen extends StatefulWidget {
  final Function(String) navigate;
  const SearchScreen({super.key, required this.navigate});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query = '';
  String _filter = 'Tous';
  final _filters = ['Tous', 'Artisans', 'Guides', 'Expériences', 'Sites'];

  final _popularSearches = [
    'Palais Royal Abomey',
    'Poterie traditionnelle',
    'Cérémonie Vodoun',
    'Marché Dantokpa',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.background,
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                        child: TextField(
                          controller: _ctrl,
                          autofocus: true,
                          onChanged: (v) => setState(() => _query = v),
                          decoration: InputDecoration(
                            hintText: 'Artisan, guide, expérience...',
                            hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                            prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 18),
                            suffixIcon: _query.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, color: AppColors.textMuted, size: 16),
                                    onPressed: () { _ctrl.clear(); setState(() => _query = ''); },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 13),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => widget.navigate('map'),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.map_outlined, color: AppColors.primary, size: 20),
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
                          child: Text(
                            _filters[i],
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: active ? Colors.white : AppColors.textMuted),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                if (_query.isEmpty) ...[
                  const Text('Recherches populaires', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.8)),
                  const SizedBox(height: 8),
                  ..._popularSearches.map((s) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.search, color: AppColors.textMuted, size: 16),
                    ),
                    title: Text(s, style: const TextStyle(fontSize: 13, color: AppColors.textDark)),
                    trailing: const Icon(Icons.arrow_forward, size: 14, color: AppColors.textLight),
                    onTap: () { _ctrl.text = s; setState(() => _query = s); },
                  )),
                  const SizedBox(height: 16),
                ],
                const Text('À découvrir', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.8)),
                const SizedBox(height: 12),
                ...MockData.artisans.map((a) => _ResultCard(
                  type: 'Artisan',
                  name: a.name,
                  subtitle: '${a.specialty} · ${a.location}',
                  image: a.image,
                  rating: a.rating,
                  reviews: a.reviews,
                  price: a.price,
                  certified: a.certified,
                  onTap: () => widget.navigate('artisanProfile'),
                )),
                ...MockData.guides.map((g) => _ResultCard(
                  type: 'Guide',
                  name: g.name,
                  subtitle: '${g.specialty} · ${g.location}',
                  image: g.image,
                  rating: g.rating,
                  reviews: g.reviews,
                  price: g.price,
                  certified: g.certified,
                  onTap: () => widget.navigate('guideProfile'),
                  typeColor: AppColors.secondary,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String type, name, subtitle, image;
  final double rating;
  final int reviews, price;
  final bool certified;
  final VoidCallback onTap;
  final Color typeColor;

  const _ResultCard({
    required this.type,
    required this.name,
    required this.subtitle,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.certified,
    required this.onTap,
    this.typeColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.06), blurRadius: 8)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(width: 68, height: 68, child: NetworkImg(url: image)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppBadge(label: type, color: typeColor),
                      if (certified) ...[const SizedBox(width: 6), const AppBadge(label: 'Certifié', color: AppColors.green)],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                  Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StarRating(value: rating, count: reviews, size: 11),
                      Text('${(price / 1000).toStringAsFixed(0)}k FCFA', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
