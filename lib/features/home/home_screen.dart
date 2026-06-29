import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/responsive/breakpoints.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/floating_navbar.dart';
import '../../shared/widgets/responsive_card_grid.dart';
import '../../shared/widgets/yonwa_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actors = MockData.actors;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      // Drawer is defined here in the main Scaffold for easy access
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFC9A84C)),
              child: Text('Menu', style: GoogleFonts.poppins(color: Colors.white, fontSize: 24)),
            ),
            ListTile(title: const Text('Explorer'), onTap: () => context.go('/home')),
            ListTile(title: const Text('Profils'), onTap: () => context.go('/explore')),
            ListTile(title: const Text('Réservations'), onTap: () => context.go('/booking')),
          ],
        ),
      ),
      body: Builder(
        builder: (context) => Stack(
          children: [
            CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: HeroHeader()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                const SliverToBoxAdapter(child: SearchBarWidget()),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 32),
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
            if (context.isMobile)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 0,
                right: 0,
                child: FloatingNavbar(
                  onMenuPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── HERO HEADER WITH VERTICAL AUTO-SCROLLING SLIDESHOW ────────────────────
class HeroHeader extends StatefulWidget {
  const HeroHeader({super.key});

  @override
  State<HeroHeader> createState() => _HeroHeaderState();
}

class _HeroHeaderState extends State<HeroHeader> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _imagePaths = [
    'assets/images/hero30.jpeg',
    'assets/images/hero31.jpeg',
    'assets/images/hero32.jpeg',
    'assets/images/hero33.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    final nextPage = (_currentPage + 1) % _imagePaths.length;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
    setState(() => _currentPage = nextPage);
    Future.delayed(const Duration(seconds: 3), _autoScroll);
  }

  @override
  Widget build(BuildContext context) {
    // 25% of screen height
    final height = MediaQuery.of(context).size.height * 0.25;

    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _imagePaths.length,
        itemBuilder: (context, index) {
          return Image.asset(
            _imagePaths[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

// ── SEARCH BAR PERCHÉE ────────────────────────────────────────────────────
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: const Color(0xFFEEEEF2), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedSearchList01,
              color: Color(0xFF6B6B7A),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher un artisan, un guide...',
                  hintStyle: GoogleFonts.inter(
                    color: const Color(0xFFB0B0BE),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 1,
              height: 20,
              color: const Color(0xFFEEEEF2),
            ),
            const SizedBox(width: 8),
            const HugeIcon(
              icon: HugeIcons.strokeRoundedSlidersHorizontal,
              color: Color(0xFF6B6B7A),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
