import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/responsive/breakpoints.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/floating_navbar.dart';
import '../../shared/widgets/responsive_card_grid.dart';
import '../../shared/widgets/yonwa_card.dart';
import '../../theme/yonwa_theme.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static void _dummyCallback() {}

  @override
  Widget build(BuildContext context) {
    // We will show a curated list of local creators and products
    final actors = MockData.actors;

    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: CustomScrollView(
        slivers: [
          // Navbar floating (mobile only)
          if (context.isMobile)
            const SliverToBoxAdapter(child: FloatingNavbar(onMenuPressed: _dummyCallback)),

          // Title & Description
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profils & Métiers',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: YonwaColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explorez la diversité des artisans, guides et revendeurs locaux du Bénin.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: YonwaColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Categories chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                itemCount: MockData.searchCategories.length,
                itemBuilder: (context, index) {
                  final cat = MockData.searchCategories[index];
                  final isSelected = index == 0;
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? YonwaColors.primary500 : YonwaColors.surface,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : YonwaColors.neutral200,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: GoogleFonts.inter(
                            color: isSelected ? Colors.white : YonwaColors.neutral500,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                },
              ),
            ),
          ),

          // Responsive grid of profiles
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: ResponsiveCardGrid(
                items: actors,
                cardBuilder: (item, index) {
                  final actor = item as Map<String, dynamic>;
                  return YonwaCard(
                    imageUrl: actor['photoUrl'] ?? 'https://i.pravatar.cc/300?u=actor',
                    title: actor['nom'] ?? 'Nom inconnu',
                    subtitle: actor['bio'] ?? 'Description indisponible',
                    tag: actor['ville'] ?? 'Bénin',
                    onTap: () => context.push('/profile/$index'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
