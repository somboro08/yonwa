import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class HomeScreen extends StatelessWidget {
  final Function(String) navigate;
  const HomeScreen({super.key, required this.navigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: _buildCategories()),
          SliverToBoxAdapter(child: _buildExperiences()),
          SliverToBoxAdapter(child: _buildArtisans()),
          SliverToBoxAdapter(child: _buildGuides()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
      color: AppColors.card,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Bonjour, Adama 👋', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              const SizedBox(height: 2),
              const Text('Que découvrez-vous\naujourd\'hui ?', style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.w800, height: 1.2)),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => navigate('notifications'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      const Center(child: Icon(Icons.notifications_outlined, color: AppColors.textDark, size: 20)),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => navigate('favorites'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Icon(Icons.favorite_border, color: AppColors.textDark, size: 20)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => navigate('search'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: AppColors.textMuted, size: 18),
            SizedBox(width: 10),
            Text('Artisan, guide, expérience…', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          SectionTitle(title: 'Catégories', actionLabel: 'Voir tout', onAction: () => navigate('categories')),
          const SizedBox(height: 14),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final cat = MockData.categories[i];
                return GestureDetector(
                  onTap: () => navigate('artisansList'),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: AppColors.surface,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: NetworkImg(url: cat.image),
                      ),
                      const SizedBox(height: 6),
                      Text(cat.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperiences() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        children: [
          SectionTitle(title: 'Expériences', actionLabel: 'Voir tout', onAction: () => navigate('search')),
          const SizedBox(height: 14),
          SizedBox(
            height: 240,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.experiences.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final exp = MockData.experiences[i];
                return GestureDetector(
                  onTap: () => navigate('experienceProfile'),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(height: 130, width: double.infinity, child: NetworkImg(url: exp.image)),
                            if (exp.badge != null)
                              Positioned(
                                top: 10,
                                left: 10,
                                child: AppBadge(label: exp.badge!, color: AppColors.secondary),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(exp.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark, height: 1.3)),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  StarRating(value: exp.rating, count: exp.reviews, size: 11),
                                  Text('${(exp.price / 1000).toStringAsFixed(0)}k FCFA', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                ],
                              ),
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

  Widget _buildArtisans() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        children: [
          SectionTitle(title: 'Artisans à découvrir', actionLabel: 'Voir tout', onAction: () => navigate('artisansList')),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.artisans.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final a = MockData.artisans[i];
                return GestureDetector(
                  onTap: () => navigate('artisanProfile'),
                  child: Container(
                    width: 140,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.06), blurRadius: 10)],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(height: 95, width: double.infinity, child: NetworkImg(url: a.image)),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [AppColors.textDark.withOpacity(0.6), Colors.transparent]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                              Text(a.specialty, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                              const SizedBox(height: 4),
                              StarRating(value: a.rating, size: 10),
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

  Widget _buildGuides() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Column(
        children: [
          SectionTitle(title: 'Guides certifiés', actionLabel: 'Voir tout', onAction: () => navigate('search')),
          const SizedBox(height: 14),
          SizedBox(
            height: 155,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.guides.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final g = MockData.guides[i];
                return GestureDetector(
                  onTap: () => navigate('guideProfile'),
                  child: Container(
                    width: 145,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.06), blurRadius: 10)],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 90, width: double.infinity, child: NetworkImg(url: g.image)),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(g.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                              Text(g.specialty, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                              const SizedBox(height: 4),
                              StarRating(value: g.rating, size: 10),
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
