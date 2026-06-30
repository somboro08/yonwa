import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/responsive/breakpoints.dart';
import '../../mock/mock_data.dart';
import '../../shared/widgets/floating_navbar.dart';
import '../../theme/yonwa_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Carousel 30% hauteur
              const SliverToBoxAdapter(child: HeroCarousel()),
              
              // Header flottant sans background et hauteur réduite
              const SliverToBoxAdapter(child: FloatingHeader()),
              
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              
              // Bouton recherche
              const SliverToBoxAdapter(child: SearchButton()),
              
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              
              // Sections de profils par catégorie
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ProfileSection(
                      title: 'Artisans pour vous',
                      role: 'artisan',
                    ),
                    SizedBox(height: 24),
                    ProfileSection(
                      title: 'Guides touristiques',
                      role: 'guide',
                    ),
                    SizedBox(height: 24),
                    ProfileSection(
                      title: 'Revendeurs',
                      role: 'revendeur',
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
              
              // Section Produits & Services
              const SliverToBoxAdapter(child: ProductsServicesSection()),
              
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          
          // Navbar flottante avec fond blanc
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 16,
                right: 16,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu hamburger
                  IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedMenu01,
                      color: YonwaColors.neutral900,
                      size: 24,
                    ),
                  ),
                  
                  // Titre Yonwa
                  Text(
                    'Yonwa',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: YonwaColors.primary500,
                    ),
                  ),
                  
                  // Bouton S'inscrire
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: YonwaColors.primary500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'S\'inscrire',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
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
                        : Colors.white.withOpacity(0.5),
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

// ── HEADER FLOTTANT SANS BACKGROUND ────────────────────────────────────────
class FloatingHeader extends StatelessWidget {
  const FloatingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      height: 40,
      child: Row(
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: YonwaColors.primary500, width: 2),
            ),
            child: const CircleAvatar(
              backgroundImage: NetworkImage('https://i0.wp.com/site-touristique-du-benin.com/wp-content/uploads/2023/08/AAA-1.jpg'),
            ),
          ),
          const SizedBox(width: 8),
          
          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bonjour, Gaspard',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Découvrez le Bénin',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          
          // Notification
          Stack(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedNotification01,
                color: Colors.white,
                size: 20,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
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

  const ProfileSection({
    super.key,
    required this.title,
    required this.role,
  });

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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: YonwaColors.neutral900,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Voir tout',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: YonwaColors.primary500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Scroll horizontal
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.32,
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
    // Créer des profils fictifs pour chaque catégorie
    final List<Map<String, dynamic>> mockProfiles = [];
    
    // Noms de base pour chaque catégorie
    final List<Map<String, String>> artisans = [
      {'nom': 'Koffi Mensah', 'ville': 'Cotonou', 'roleDisplay': 'Artisan Sculpteur'},
      {'nom': 'Awa Dossou', 'ville': 'Porto-Novo', 'roleDisplay': 'Artisan Tisserande'},
      {'nom': 'Souleymane Diallo', 'ville': 'Parakou', 'roleDisplay': 'Artisan Bijoutier'},
      {'nom': 'Fatou Traoré', 'ville': 'Abomey', 'roleDisplay': 'Artisan Potière'},
      {'nom': 'Ibrahim Kone', 'ville': 'Natitingou', 'roleDisplay': 'Artisan Forgeron'},
    ];
    
    final List<Map<String, String>> guides = [
      {'nom': 'Alain Kouassi', 'ville': 'Ganvié', 'roleDisplay': 'Guide Touristique'},
      {'nom': 'Sandra Fagbohun', 'ville': 'Ouidah', 'roleDisplay': 'Guide Culturel'},
      {'nom': 'Marc Zinsou', 'ville': 'Abomey', 'roleDisplay': 'Guide Historique'},
      {'nom': 'Léa Akindès', 'ville': 'Cotonou', 'roleDisplay': 'Guide Nature'},
      {'nom': 'David Tokpah', 'ville': 'Porto-Novo', 'roleDisplay': 'Guide Gastronomique'},
    ];
    
    final List<Map<String, String>> revendeurs = [
      {'nom': 'Jean-Marie Ahouanvoébla', 'ville': 'Cotonou', 'roleDisplay': 'Revendeur d\'Art'},
      {'nom': 'Rosalie Hountondji', 'ville': 'Porto-Novo', 'roleDisplay': 'Revendeuse de Tissus'},
      {'nom': 'Moussa Gassama', 'ville': 'Parakou', 'roleDisplay': 'Revendeur de Produits'},
      {'nom': 'Yolande Dossou', 'ville': 'Abomey', 'roleDisplay': 'Revendeuse d\'Objets'},
      {'nom': 'Rachid Adégbé', 'ville': 'Natitingou', 'roleDisplay': 'Revendeur d\'Artisanat'},
    ];

    final List<Map<String, dynamic>> selectedProfiles;
    
    switch (role) {
      case 'artisan':
        selectedProfiles = artisans.map((a) => {
          ...a,
          'id': 'artisan_${artisans.indexOf(a)}',
          'photoUrl': 'assets/images/hero1.jpg',
          'coverImage': 'assets/images/hero2.jpg',
          'rating': (3.5 + (artisans.indexOf(a) * 0.3)).toStringAsFixed(1),
          'role': 'artisan',
        }).toList();
        break;
      case 'guide':
        selectedProfiles = guides.map((a) => {
          ...a,
          'id': 'guide_${guides.indexOf(a)}',
          'photoUrl': 'assets/images/hero1.jpg',
          'coverImage': 'assets/images/hero2.jpg',
          'rating': (4.0 + (guides.indexOf(a) * 0.2)).toStringAsFixed(1),
          'role': 'guideTouristique',
        }).toList();
        break;
      case 'revendeur':
        selectedProfiles = revendeurs.map((a) => {
          ...a,
          'id': 'revendeur_${revendeurs.indexOf(a)}',
          'photoUrl': 'assets/images/hero1.jpg',
          'coverImage': 'assets/images/hero2.jpg',
          'rating': (3.8 + (revendeurs.indexOf(a) * 0.2)).toStringAsFixed(1),
          'role': 'revendeur',
        }).toList();
        break;
      default:
        return [];
    }
    
    return selectedProfiles;
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: YonwaColors.neutral200),
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
                    ),
                  ),
                ),
              ),
            ),
            
            // Image de profil + infos
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar
                    Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
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
                    const SizedBox(height: 4),
                    
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
                    const SizedBox(height: 1),
                    
                    // Rôle
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: YonwaColors.neutral600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    
                    // Rating + Location
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedStar,
                          color: Color(0xFFC9A84C),
                          size: 10,
                        ),
                        const SizedBox(width: 1),
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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: YonwaColors.neutral900,
                ),
              ),
              const SizedBox(height: 12),
              
              // Onglets filtre
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(label: 'Tout', isSelected: true, onTap: () {}),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Produits', isSelected: false, onTap: () {}),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Services', isSelected: false, onTap: () {}),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Expériences', isSelected: false, onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Liste horizontale
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: 10,
            itemBuilder: (context, index) {
              // Produits fictifs
              final List<Map<String, String>> mockProducts = [
                {'title': 'Poterie artisanale', 'price': '15 000 FCFA', 'category': 'Artisanat'},
                {'title': 'Visite guidée Ganvié', 'price': '25 000 FCFA', 'category': 'Tourisme'},
                {'title': 'Tissu Wax premium', 'price': '35 000 FCFA', 'category': 'Textile'},
                {'title': 'Cours de cuisine béninoise', 'price': '20 000 FCFA', 'category': 'Cuisine'},
                {'title': 'Statue en bronze', 'price': '50 000 FCFA', 'category': 'Art'},
                {'title': 'Excursion Abomey', 'price': '30 000 FCFA', 'category': 'Tourisme'},
                {'title': 'Pagne traditionnel', 'price': '12 000 FCFA', 'category': 'Textile'},
                {'title': 'Atelier tissage', 'price': '18 000 FCFA', 'category': 'Artisanat'},
                {'title': 'Découverte Ouidah', 'price': '22 000 FCFA', 'category': 'Tourisme'},
                {'title': 'Bijoux en perles', 'price': '8 000 FCFA', 'category': 'Artisanat'},
              ];
              
              final product = mockProducts[index % mockProducts.length];
              return Container(
                width: (MediaQuery.of(context).size.width - 72) / 3,
                margin: EdgeInsets.only(
                  right: index < 9 ? 12 : 0,
                ),
                child: ProductCard(
                  imageUrl: 'assets/images/hero1.jpg',
                  title: product['title']!,
                  price: product['price']!,
                  category: product['category']!,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : YonwaColors.neutral700,
          ),
        ),
      ),
    );
  }
}

// ── CARD PRODUIT ─────────────────────────────────────────────────────────────
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: YonwaColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                imageUrl ?? 'assets/images/hero.jpeg',
                fit: BoxFit.cover,
                width: 280,
                errorBuilder: (_, __, ___) => Container(
                  color: YonwaColors.neutral200,
                  child: const Icon(
                    Icons.image,
                    color: YonwaColors.neutral400,
                  ),
                ),
              ),
            ),
          ),
          
          // Infos
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Catégorie
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: YonwaColors.primary50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: YonwaColors.primary500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Titre
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: YonwaColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Prix
                  Text(
                    price,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
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