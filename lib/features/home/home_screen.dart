import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../mock/mock_data.dart';
import '../../models/models.dart';
import '../../shared/providers/auth_provider.dart';
import '../../theme/yonwa_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        // Header principal de l'accueil
        const SliverToBoxAdapter(child: HomeHeader()),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        // Carousel 30% hauteur
        const SliverToBoxAdapter(child: HeroCarousel()),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Bouton recherche
        const SliverToBoxAdapter(child: SearchButton()),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Sections de profils par catégorie
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ProfileSection(title: 'Artisans', role: 'artisan'),
              SizedBox(height: 24),
              ProfileSection(title: 'Concepteurs', role: 'concepteur'),
              SizedBox(height: 24),
              ProfileSection(title: 'Guides', role: 'guide'),
              SizedBox(height: 24),
            ],
          ),
        ),

        // Section Produits & Services
        const SliverToBoxAdapter(child: ProductsServicesSection()),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

// ── CAROUSEL 30% HAUTEUR ────────────────────────────────────────────────────
class HeroCarousel extends StatefulWidget {
  const HeroCarousel({super.key});

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/hero1.jpg',
      'title': 'Découvrez Ganvié',
      'subtitle': 'La Venise d\'Afrique',
    },
    {
      'image': 'assets/images/hero2.jpg',
      'title': 'Artisanat Béninois',
      'subtitle': 'Savoir-faire ancestral',
    },
    {
      'image': 'assets/images/hero3.jpeg',
      'title': 'Cuisine Traditionnelle',
      'subtitle': 'Saveurs du Bénin',
    },
    {
      'image': 'assets/images/hero4.jpeg',
      'title': 'Plages de Ouidah',
      'subtitle': 'Paradis tropical',
    },
    {
      'image': 'assets/images/hero6.jpeg',
      'title': 'Palais Royaux d\'Abomey',
      'subtitle': 'Patrimoine UNESCO',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _slides.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        setState(() => _currentPage = nextPage);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.30;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Image.asset(
                slide['image']!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: YonwaColors.primary500,
                  child: Center(
                    child: Text(
                      slide['title']!,
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Indicateurs
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── HEADER PRINCIPAL DE L'ACCUEIL ────────────────────────────────────────
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateProvider);
    final photoUrl =
      currentUser?.userMetadata?['avatar_url'] as String? ??
      currentUser?.userMetadata?['photo_url'] as String?;
    final title = currentUser?.email != null
        ? 'Bonjour, ${currentUser!.email}'
        : 'Bonjour, invité';
    final subtitle = currentUser != null
        ? 'Découvrez les trésors du Bénin'
        : 'Connectez-vous pour sauvegarder vos favoris et réservations';

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: YonwaColors.neutral200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: YonwaColors.primary50,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
              child: photoUrl == null
                  ? const Icon(Icons.person, color: YonwaColors.primary500)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: YonwaColors.neutral900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: YonwaColors.neutral500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => context.push('/notifications'),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedNotification01,
                    color: YonwaColors.neutral700,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 2),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => context.push('/messages'),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedMessage01,
                    color: YonwaColors.primary500,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── BOUTON RECHERCHE ─────────────────────────────────────────────────────────
class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: InkWell(
        onTap: () => context.push('/search'),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: YonwaColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: YonwaColors.neutral200),
          ),
          child: Row(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedSearchList01,
                color: YonwaColors.neutral500,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Rechercher artisan, guide, expérience...',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: YonwaColors.neutral400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── SECTION PROFILS HORIZONTALE ─────────────────────────────────────────────
class ProfileSection extends StatelessWidget {
  final String title;
  final String role;

  const ProfileSection({super.key, required this.title, required this.role});

  @override
  Widget build(BuildContext context) {
    final profiles = _getProfilesByRole(role);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title (${profiles.length})',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: YonwaColors.neutral900,
                ),
              ),
              TextButton.icon(
                onPressed: () => context.push('/profiles/$role'),
                icon: const Icon(
                  Icons.add,
                  size: 18,
                  color: YonwaColors.primary500,
                ),
                label: Text(
                  'Voir tout',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: YonwaColors.primary500,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 30),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Scroll horizontal
        SizedBox(
          height: 200, // Hauteur fixe pour les cartes profils
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return Container(
                width: 140, // Largeur fixe pour les cartes profils
                margin: EdgeInsets.only(
                  right: index < profiles.length - 1 ? 10 : 0,
                ),
                child: ProfileCard(
                  imageUrl: profile['photoUrl'],
                  coverUrl: profile['coverImage'],
                  name: profile['nom'],
                  role: profile['roleDisplay'],
                  rating: profile['rating'],
                  location: profile['ville'],
                  onTap: () => context.push('/profile/${profile['id']}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getProfilesByRole(String role) {
    final actors = MockData.actors;

    switch (role) {
      case 'artisan':
        return actors.where((actor) {
          return actor['role'] == UserRole.artisan ||
              actor['role'] == UserRole.artisanRevendeur;
        }).toList();
      case 'concepteur':
        return actors
            .where((actor) => actor['role'] == UserRole.artisanConcepteur)
            .toList();
      case 'guide':
        return actors
            .where((actor) => actor['role'] == UserRole.guideTouristique)
            .toList();
      default:
        return actors;
    }
  }
}

// ── CARD PROFIL CORRIGÉE ────────────────────────────────────────────────────
class ProfileCard extends StatelessWidget {
  final String? imageUrl;
  final String? coverUrl;
  final String name;
  final String role;
  final String rating;
  final String location;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    this.imageUrl,
    this.coverUrl,
    required this.name,
    required this.role,
    required this.rating,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: YonwaColors.neutral200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image de couverture
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.asset(
                  coverUrl ?? 'assets/images/hero1.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: YonwaColors.neutral200,
                    child: const Icon(
                      Icons.image,
                      color: YonwaColors.neutral400,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),

            // Image de profil + infos
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar
                    Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            imageUrl ?? 'assets/images/hero1.jpg',
                          ),
                          backgroundColor: YonwaColors.neutral200,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Nom
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: YonwaColors.neutral900,
                      ),
                    ),

                    // Rôle
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: YonwaColors.neutral600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Rating + Location
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedStar,
                          color: YonwaColors.secondary,
                          size: 10,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: YonwaColors.neutral800,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 8,
                              color: YonwaColors.neutral500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── SECTION PRODUITS & SERVICES ──────────────────────────────────────────────
class ProductsServicesSection extends ConsumerWidget {
  const ProductsServicesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre + Onglets filtre
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Produits & Services',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: YonwaColors.neutral900,
                ),
              ),
              const SizedBox(height: 8),

              // Onglets filtre
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: 'Tout', isSelected: true, onTap: () {}),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Produits',
                      isSelected: false,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Services',
                      isSelected: false,
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Expériences',
                      isSelected: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Liste horizontale - même hauteur que les profils
        SizedBox(
          height: 200, // Même hauteur que les cartes profils
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: 10,
            itemBuilder: (context, index) {
              // Produits fictifs
              final List<Map<String, String>> mockProducts = [
                {
                  'title': 'Poterie artisanale',
                  'price': '15 000 FCFA',
                  'category': 'Artisanat',
                },
                {
                  'title': 'Visite guidée Ganvié',
                  'price': '25 000 FCFA',
                  'category': 'Tourisme',
                },
                {
                  'title': 'Tissu Wax premium',
                  'price': '35 000 FCFA',
                  'category': 'Textile',
                },
                {
                  'title': 'Cours de cuisine',
                  'price': '20 000 FCFA',
                  'category': 'Cuisine',
                },
                {
                  'title': 'Statue en bronze',
                  'price': '50 000 FCFA',
                  'category': 'Art',
                },
                {
                  'title': 'Excursion Abomey',
                  'price': '30 000 FCFA',
                  'category': 'Tourisme',
                },
                {
                  'title': 'Pagne traditionnel',
                  'price': '12 000 FCFA',
                  'category': 'Textile',
                },
                {
                  'title': 'Atelier tissage',
                  'price': '18 000 FCFA',
                  'category': 'Artisanat',
                },
                {
                  'title': 'Découverte Ouidah',
                  'price': '22 000 FCFA',
                  'category': 'Tourisme',
                },
                {
                  'title': 'Bijoux en perles',
                  'price': '8 000 FCFA',
                  'category': 'Artisanat',
                },
              ];

              final product = mockProducts[index % mockProducts.length];
              return Container(
                width: 140, // Même largeur que les cartes profils
                margin: EdgeInsets.only(right: index < 9 ? 10 : 0),
                child: GestureDetector(
                  onTap: () => context.push('/product/${index + 1}'),
                  child: ProductCard(
                    imageUrl: 'assets/images/hero1.jpg',
                    title: product['title']!,
                    price: product['price']!,
                    category: product['category']!,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? YonwaColors.primary500 : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? YonwaColors.primary500 : YonwaColors.neutral200,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : YonwaColors.neutral700,
          ),
        ),
      ),
    );
  }
}

// ── CARD PRODUIT CORRIGÉE ────────────────────────────────────────────────────
class ProductCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String price;
  final String category;

  const ProductCard({
    super.key,
    this.imageUrl,
    required this.title,
    required this.price,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: YonwaColors.neutral200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image - même proportion que les profils
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                imageUrl ?? 'assets/images/hero1.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: YonwaColors.neutral200,
                  child: const Icon(
                    Icons.image,
                    color: YonwaColors.neutral400,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          // Infos - même proportion que les profils
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Catégorie
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: YonwaColors.primary50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: YonwaColors.primary500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Titre
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: YonwaColors.neutral900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Prix
                  Text(
                    price,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: YonwaColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
