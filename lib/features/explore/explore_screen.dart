import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import '../../core/responsive/breakpoints.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/floating_navbar.dart';
import '../../shared/widgets/responsive_card_grid.dart';
import '../../shared/widgets/yonwa_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  static void _dummyCallback() {}

  @override
  Widget build(BuildContext context) {
    // We will show a curated list of local creators and products
    final actors = MockData.actors;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
                      color: const Color(0xFF0D0D0D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explorez la diversité des artisans, guides et revendeurs locaux du Bénin.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6B6B7A),
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
                      color: isSelected ? const Color(0xFF1A1A2E) : Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : const Color(0xFFEEEEF2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.white : const Color(0xFF6B6B7A),
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
