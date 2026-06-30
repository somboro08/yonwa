import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:math';
import '../../theme/yonwa_theme.dart';
import '../../theme/theme_provider.dart';
import '../../models/models.dart';
import '../../widgets/listing_card.dart';
import '../../widgets/horizontal_product_scroll.dart';
import '../../services/auth_service.dart';
import 'notification_screen.dart';
import 'explorer_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/user_profile_tab.dart';
import '../listing/all_listings_screen.dart';
import '../chat/messages_inbox_screen.dart';
import '../immersive_profile_screen.dart';
import '../ai_assistant_screen.dart';
import '../profile/detailed_profile_screen.dart';
import 'search_screen.dart';
import '../../providers/user_provider.dart';
import '../commerce/my_orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final _searchController = TextEditingController();

  // Variables de filtrage
  UserRole? _selectedProfileType;
  String? _selectedActivity;
  String? _selectedServiceType;

  // Carousel controller
  final PageController _carouselController = PageController();
  int _currentCarouselIndex = 0;
  Timer? _carouselTimer;

  // Carousel images
  final List<Map<String, String>> _carouselImages = [
    {
      'image': 'assets/images/hero1.jpg',
      'title': 'Découvrez Ganvié',
      'subtitle': "La Venise d'Afrique",
    },
    {
      'image': 'assets/images/hero2.jpg',
      'title': 'Artisanat Béninois',
      'subtitle': 'Savoir-faire ancestral',
    },
    {
      'image': 'assets/images/hero3.jpg',
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
      'subtitle': 'Patrimoine de l\'humanité',
    },
    {
      'image': 'assets/images/hero8.jpeg',
      'title': 'Festivals du Bénin',
      'subtitle': 'Couleurs et traditions',
    },
    {
      'image': 'assets/images/hero10.jpeg',
      'title': 'Nature Béninoise',
      'subtitle': 'Paysages à couper le souffle',
    },
  ];

  // Liste globale de profils professionnels simulés
  final List<Map<String, dynamic>> _actors = [
    {
      'nom': 'Amina Cissé',
      'role': UserRole.artisan,
      'ville': 'Bohicon',
      'photoUrl': 'assets/images/hero22.jpeg',
      'coverImage': 'assets/images/hero11.jpeg',
      'rating': '4.9',
      'bio':
          'Artisane spécialisée dans le tissage traditionnel d\'indigo. J\'utilise des pigments organiques du Bénin.',
      'savoirFaire': ['Textile', 'Artisanat traditionnel'],
      'servicesProduits': ['Produits physiques', 'Ateliers'],
      'subscribers': 245,
      'sales': 38,
      'articles': 64,
      'servicesCount': 2,
      'isVerified': true,
      'telephone': '+229 97 12 34 88',
    },
    {
      'nom': 'Sika Adjovi',
      'role': UserRole.artisan,
      'ville': 'Abomey',
      'photoUrl': 'assets/images/hero25.jpeg',
      'coverImage': 'assets/images/hero12.jpeg',
      'rating': '4.7',
      'bio':
          'Créatrice de jarres en terre cuite d\'Abomey. Mes oeuvres perpétuent la mémoire royale béninoise.',
      'savoirFaire': ['Poterie', 'Artisanat traditionnel'],
      'servicesProduits': ['Produits physiques'],
      'subscribers': 180,
      'sales': 24,
      'articles': 32,
      'servicesCount': 0,
      'isVerified': true,
      'telephone': '+229 96 15 24 33',
    },
    {
      'nom': 'Koffi Djibo',
      'role': UserRole.artisanConcepteur,
      'ville': 'Ouidah',
      'photoUrl': 'assets/images/hero26.jpeg',
      'coverImage': 'assets/images/hero29.jpeg',
      'rating': '4.8',
      'bio':
          'Concepteur-artisan spécialisé dans la sculpture contemporaine sur bois de teck et d\'ébène.',
      'savoirFaire': ['Sculpture', 'Bois', 'Artisanat traditionnel'],
      'servicesProduits': ['Produits physiques', 'Ateliers', 'Formations'],
      'subscribers': 350,
      'sales': 14,
      'articles': 18,
      'servicesCount': 8,
      'isVerified': true,
      'telephone': '+229 90 22 11 00',
    },
    {
      'nom': 'Fati Salifou',
      'role': UserRole.artisanConcepteur,
      'ville': 'Parakou',
      'photoUrl': 'assets/images/hero27.jpeg',
      'coverImage': 'assets/images/hero28.jpeg',
      'rating': '4.9',
      'bio':
          'Créatrice conceptrice de bijoux de luxe en bronze et pierres semi-précieuses du Bénin.',
      'savoirFaire': ['Bijoux', 'Métal', 'Artisanat traditionnel'],
      'servicesProduits': ['Produits physiques', 'Services'],
      'subscribers': 420,
      'sales': 45,
      'articles': 55,
      'servicesCount': 10,
      'isVerified': true,
      'telephone': '+229 97 88 55 22',
    },
    {
      'nom': 'Binta Sow',
      'role': UserRole.artisanRevendeur,
      'ville': 'Porto-Novo',
      'photoUrl': 'assets/images/hero30.jpeg',
      'coverImage': 'assets/images/hero13.jpeg',
      'rating': '4.6',
      'bio':
          'Revendeuse de paniers tressés et batiks fabriqués à la main par des coopératives de femmes au Bénin.',
      'savoirFaire': ['Artisanat traditionnel', 'Textile'],
      'servicesProduits': ['Produits physiques'],
      'subscribers': 120,
      'sales': 78,
      'articles': 120,
      'servicesCount': 0,
      'isVerified': false,
      'telephone': '+229 01 95 66 77 88',
    },
    {
      'nom': 'Yao Mensah',
      'role': UserRole.artisanRevendeur,
      'ville': 'Cotonou',
      'photoUrl': 'assets/images/hero31.jpeg',
      'coverImage': 'assets/images/hero14.jpeg',
      'rating': '4.5',
      'bio':
          'Collectionneur et revendeur de batiks authentiques et de sculptures traditionnelles.',
      'savoirFaire': ['Textile', 'Sculpture', 'Artisanat traditionnel'],
      'servicesProduits': ['Produits physiques', 'Ateliers'],
      'subscribers': 90,
      'sales': 34,
      'articles': 48,
      'servicesCount': 1,
      'isVerified': true,
      'telephone': '+229 97 11 22 33',
    },
    {
      'nom': 'Koffi Mensah',
      'role': UserRole.guideTouristique,
      'ville': 'Ganvié',
      'photoUrl': 'assets/images/hero32.jpeg',
      'coverImage': 'assets/images/hero15.jpeg',
      'rating': '4.9',
      'bio':
          'Guide touristique officiel à Ganvié. Découvrez l\'histoire lacustre et les traditions Tofinu.',
      'savoirFaire': ['Expériences culturelles', 'Cuisine locale'],
      'servicesProduits': ['Expériences touristiques', 'Services', 'Ateliers'],
      'subscribers': 580,
      'sales': 0,
      'articles': 0,
      'servicesCount': 42,
      'isVerified': true,
      'telephone': '+229 97 12 34 56',
    },
    {
      'nom': 'Lionel Gbèdo',
      'role': UserRole.guideTouristique,
      'ville': 'Ouidah',
      'photoUrl': 'assets/images/hero33.jpeg',
      'coverImage': 'assets/images/hero16.jpeg',
      'rating': '4.8',
      'bio':
          'Spécialiste de l\'histoire de Ouidah, du culte vaudou et de la route des esclaves. Visites guidées personnalisées.',
      'savoirFaire': ['Expériences culturelles', 'Autres'],
      'servicesProduits': ['Expériences touristiques', 'Services'],
      'subscribers': 310,
      'sales': 0,
      'articles': 0,
      'servicesCount': 28,
      'isVerified': true,
      'telephone': '+229 96 44 22 99',
    },
    {
      'nom': 'Gnonnan Pierre',
      'role': UserRole.revendeur,
      'ville': 'Cotonou',
      'photoUrl': 'assets/images/hero34.jpeg',
      'coverImage': 'assets/images/hero17.jpeg',
      'rating': '4.7',
      'bio':
          'Galeriste à Cotonou. Revendeur agréé d\'oeuvres d\'art contemporaines et traditionnelles béninoises.',
      'savoirFaire': ['Peinture', 'Sculpture', 'Autres'],
      'servicesProduits': ['Produits physiques', 'Services'],
      'subscribers': 95,
      'sales': 150,
      'articles': 210,
      'servicesCount': 0,
      'isVerified': true,
      'telephone': '+229 97 55 44 33',
    },
    {
      'nom': 'Chantal Agbado',
      'role': UserRole.revendeur,
      'ville': 'Grand-Popo',
      'photoUrl': 'assets/images/hero35.jpeg',
      'coverImage': 'assets/images/hero18.jpg',
      'rating': '4.4',
      'bio':
          'Boutique d\'objets de décoration, souvenirs et produits du terroir à Grand-Popo.',
      'savoirFaire': ['Artisanat traditionnel', 'Cuisine locale'],
      'servicesProduits': ['Produits physiques'],
      'subscribers': 60,
      'sales': 95,
      'articles': 140,
      'servicesCount': 0,
      'isVerified': false,
      'telephone': '+229 95 11 00 22',
    },
  ];

  // Données du Fil d'actualité enrichi
  final List<Map<String, dynamic>> _feedPosts = [
    {
      'type': 'Aventure',
      'image':
          'https://www.gouv.bj/upload/images/banners/546730049088001761344719.png',
      'title': 'Ganvié au coucher du soleil',
      'desc':
          'Une vue imprenable sur la cité lacustre avec nos voyageurs ce soir. Magique !',
      'author': 'Koffi Mensah',
      'location': 'Ganvié',
      'views': '2.4k',
      'likes': 245,
      'comments': 34,
      'avatar':
          'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?q=80&w=150',
    },
    {
      'type': 'Publication',
      'image':
          'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?q=80&w=800',
      'title': 'Nouveaux tissages indigo disponibles',
      'desc':
          'Fraîchement arrivés de notre coopérative à Bohicon, découvrez ces motifs géométriques traditionnels.',
      'author': 'Binta Sow',
      'location': 'Bohicon',
      'views': '1.8k',
      'likes': 182,
      'comments': 12,
      'avatar':
          'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?q=80&w=150',
    },
    {
      'type': 'Article',
      'image':
          'https://images.unsplash.com/photo-1590674899484-d56419821d99?q=80&w=800',
      'title': 'L\'histoire de Ouidah et sa Route des Esclaves',
      'desc':
          'Plongez dans les récits historiques de Ouidah, un haut lieu de culture, de mémoire et de vaudou.',
      'author': 'Lionel Gbèdo',
      'location': 'Ouidah',
      'views': '3.2k',
      'likes': 412,
      'comments': 56,
      'avatar':
          'https://images.unsplash.com/photo-1489980508314-941910ded1f4?q=80&w=150',
    },
    {
      'type': 'Actualité',
      'image':
          'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?q=80&w=800',
      'title': 'Ouverture du Musée d\'Art Contemporain',
      'desc':
          'Les nouveaux pavillons exposant des oeuvres d\'artistes béninois contemporains ouvrent officiellement à Cotonou.',
      'author': 'Rédaction Yonwa',
      'location': 'Cotonou',
      'views': '5.0k',
      'likes': 890,
      'comments': 124,
      'avatar': 'https://i.pravatar.cc/150?u=yonwa',
    },
    {
      'type': 'Expérience partagée',
      'image':
          'https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?q=80&w=800',
      'title': 'Mon atelier poterie avec Sika Adjovi',
      'desc':
          'Quel bonheur d\'apprendre à façonner l\'argile d\'Abomey sous l\'oeil bienveillant de Sika !',
      'author': 'Sophie M. (Voyageuse)',
      'location': 'Abomey',
      'views': '980',
      'likes': 98,
      'comments': 15,
      'avatar': 'https://i.pravatar.cc/100?u=sophie',
    },
  ];

  late AnimationController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _startCarouselTimer();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_carouselController.hasClients) {
        final nextPage = (_currentCarouselIndex + 1) % _carouselImages.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _toggleDrawer() {
    if (_drawerController.isDismissed) {
      _drawerController.forward();
    } else {
      _drawerController.reverse();
    }
  }

  void _openSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  @override
  void dispose() {
    _drawerController.dispose();
    _carouselTimer?.cancel();
    _carouselController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Returns the appropriate ImageProvider based on path type (asset or network).
  ImageProvider<Object> _imageProvider(String path) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    return isNetwork ? NetworkImage(path) : AssetImage(path) as ImageProvider<Object>;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authService = AuthService();
    final isMock = authService.isMockMode;

    const profileWidget = UserProfileTab();

    final size = MediaQuery.of(context).size;
    final drawerWidth = size.width * 0.72;

    return AnimatedBuilder(
      animation: _drawerController,
      builder: (context, child) {
        final val = _drawerController.value;
        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF1E1E2C)
              : const Color(0xFF2A2A3E),
          body: Stack(
            children: [
              // Drawer content at the back
              if (val > 0)
                Positioned.fill(
                  child: _buildDrawerContent(context, isDark, drawerWidth),
                ),

              // 3D Cube transformed home screen
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..translate(val * drawerWidth)
                  ..rotateY(-val * (pi / 2.5)), // cube rotation
                child: GestureDetector(
                  onTap: val > 0 ? _toggleDrawer : null,
                  child: AbsorbPointer(
                    absorbing: val > 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(val * 16),
                      child: Scaffold(
                        backgroundColor: isDark
                            ? YonwaColors.neutral900
                            : YonwaColors.background,
                        body: IndexedStack(
                          index: _selectedIndex,
                          children: [
                            _buildHomeBody(isDark),
                            const ExplorerScreen(),
                            const AIAssistantScreen(),
                            const MessagesInboxScreen(),
                            profileWidget,
                          ],
                        ),
                        bottomNavigationBar: _YonwaBottomNav(
                          selectedIndex: _selectedIndex,
                          onTap: (i) => setState(() => _selectedIndex = i),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerContent(BuildContext context, bool isDark, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 28,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [YonwaColors.primary500, YonwaColors.secondary],
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=marc',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Marc Gbènan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Voyageur Passionné',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Drawer Items List
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Tableau de bord Pro',
                    onTap: () {
                      _toggleDrawer();
                      // Switch to Pro or Open dashboard
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.calendar_month_rounded,
                    label: 'Mes Réservations',
                    onTap: () {
                      _toggleDrawer();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyOrdersScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.favorite_rounded,
                    label: 'Mes Favoris',
                    onTap: () {
                      _toggleDrawer();
                      setState(() => _selectedIndex = 1); // Switch to Explorer
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.verified_user_rounded,
                    label: 'Vérification d\'identité',
                    onTap: () {
                      _toggleDrawer();
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Colors.white24, height: 1),
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_rounded,
                    label: 'Paramètres',
                    onTap: () {
                      _toggleDrawer();
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline_rounded,
                    label: 'Support & Assistance',
                    onTap: () {
                      _toggleDrawer();
                    },
                  ),
                ],
              ),
            ),

            // Logout
            _buildDrawerItem(
              icon: Icons.logout_rounded,
              label: 'Déconnexion',
              color: Colors.redAccent,
              onTap: () {
                _toggleDrawer();
                Navigator.of(context).pushReplacementNamed('/auth');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color.withOpacity(0.85), size: 20),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13.5,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: color.withOpacity(0.3),
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildHomeBody(bool isDark) {
    return Stack(
      children: [
        // Dynamic background with blurred header image + blue filter
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: Container(
              key: ValueKey(_currentCarouselIndex),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    _carouselImages[_currentCarouselIndex]['image']!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        // Theme overlay tint
        Positioned.fill(
          child: Container(
            color: isDark
                ? YonwaColors.neutral900.withOpacity(0.42)
                : YonwaColors.neutral500.withOpacity(0.18),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              color: isDark
                  ? Colors.black.withOpacity(0.65)
                  : Colors.white.withOpacity(0.55),
            ),
          ),
        ),

        // Scrollable content
        CustomScrollView(
          slivers: [
            // Header with Carousel
            SliverToBoxAdapter(child: _buildCarouselHeader(isDark)),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  YonwaSpacing.md,
                  YonwaSpacing.sm,
                  YonwaSpacing.md,
                  YonwaSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Catégories
                    _buildCategories(isDark),
                    const SizedBox(height: YonwaSpacing.md),

                    // Section scrollable horizontale
                    HorizontalProductScroll(
                      title: 'Artisans et Expériences',
                      items: _actors.map((actor) => {
                        'title': actor['nom'],
                        'price': actor['role'] == UserRole.guideTouristique ? 'Voir expérience' : 'Voir produits',
                        'image': actor['photoUrl'],
                        'onTap': () => _openActorProfile(actor),
                      }).toList(),
                    ),
                    const SizedBox(height: YonwaSpacing.md),

                    // Sections de profils par catégorie
                    _buildProfileSections(isDark),
                    const SizedBox(height: YonwaSpacing.xs),

                    // Title for feed
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fil d\'actualité',
                          style: YonwaTextStyles.h2.copyWith(
                            color: isDark
                                ? YonwaColors.neutral0
                                : YonwaColors.primary700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? YonwaColors.neutral800.withOpacity(0.8)
                                : Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(YonwaRadius.md),
                            boxShadow: [
                              BoxShadow(
                                color: YonwaColors.primary500.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: YonwaColors.primary500,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: YonwaSpacing.md),
                  ],
                ),
              ),
            ),

            // Social Feed
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: YonwaSpacing.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _buildFeedItem(_feedPosts[i], isDark),
                  childCount: _feedPosts.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: YonwaSpacing.xxl)),
          ],
        ),
      ],
    );
  }

  Widget _buildCarouselHeader(bool isDark) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Carousel
        SizedBox(
          height: size.height * 0.35,
          width: double.infinity,
          child: PageView.builder(
            controller: _carouselController,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
            itemCount: _carouselImages.length,
            itemBuilder: (context, index) {
              final image = _carouselImages[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(image['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient Overlay (Blue Tint)
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.withOpacity(0.4),
                          Colors.blue.withOpacity(0.2),
                          isDark
                              ? YonwaColors.neutral900.withOpacity(0.8)
                              : YonwaColors.background.withOpacity(0.9),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        // Header Content
        Positioned.fill(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(YonwaSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Bar
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/icons/yome.png',
                          width: 36,
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Yonwa',
                        style: YonwaTextStyles.h2.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _buildIconButton(Icons.notifications_none_rounded, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      }),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _toggleDrawer,
                        child: const _BurgerMenu(),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Carousel Title & Subtitle
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      key: ValueKey(_currentCarouselIndex),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _carouselImages[_currentCarouselIndex]['title']!,
                          style: YonwaTextStyles.display.copyWith(
                            color: Colors.white,
                            fontSize: 32,
                            height: 1.1,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        Text(
                          _carouselImages[_currentCarouselIndex]['subtitle']!,
                          style: YonwaTextStyles.bodyLarge.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: YonwaSpacing.md),

                  // Carousel Indicators
                  Row(
                    children: List.generate(
                      _carouselImages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        width: _currentCarouselIndex == index ? 24 : 8,
                        height: 4,
                        decoration: BoxDecoration(
                          color: _currentCarouselIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: YonwaSpacing.md),

                  // Search Bar - Modern Design
                  GestureDetector(
                    onTap: _openSearchPage,
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? YonwaColors.neutral800 : Colors.white,
                        borderRadius: BorderRadius.circular(YonwaRadius.xl),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: isDark ? YonwaColors.neutral700 : Colors.white,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  YonwaColors.primary500,
                                  YonwaColors.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(
                                YonwaRadius.md,
                              ),
                            ),
                            child: const Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: IgnorePointer(
                              child: TextField(
                                controller: _searchController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Une destination, un artisan...',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintStyle: YonwaTextStyles.body.copyWith(
                                    color: isDark
                                        ? YonwaColors.neutral400
                                        : YonwaColors.neutral400,
                                  ),
                                  filled: false,
                                ),
                                style: YonwaTextStyles.body.copyWith(
                                  color: isDark
                                      ? YonwaColors.neutral0
                                      : YonwaColors.neutral800,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? YonwaColors.neutral700
                                  : YonwaColors.neutral100,
                              borderRadius: BorderRadius.circular(
                                YonwaRadius.md,
                              ),
                            ),
                            child: Icon(
                              Icons.mic_none_rounded,
                              color: isDark
                                  ? YonwaColors.neutral400
                                  : YonwaColors.neutral500,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildQuickActions(bool isDark) {
    final actions = [
      {
        'icon': Icons.explore_rounded,
        'label': 'Explorer',
        'color': YonwaColors.primary500,
      },
      {
        'icon': Icons.room_service_rounded,
        'label': 'Services',
        'color': YonwaColors.secondary,
      },
      {
        'icon': Icons.local_offer_rounded,
        'label': 'Offres',
        'color': YonwaColors.accent,
      },
      {
        'icon': Icons.stars_rounded,
        'label': 'Favoris',
        'color': YonwaColors.error,
      },
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral300,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explorer',
            style: YonwaTextStyles.h3.copyWith(
              color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: YonwaSpacing.md),
          Row(
            children: actions.map((action) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? YonwaColors.neutral800 : Colors.white,
                      borderRadius: BorderRadius.circular(YonwaRadius.md),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (action['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            action['icon'] as IconData,
                            color: action['color'] as Color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          action['label'] as String,
                          style: YonwaTextStyles.caption.copyWith(
                            color: isDark
                                ? YonwaColors.neutral300
                                : YonwaColors.neutral600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(bool isDark) {
    final categories = [
      {'role': null, 'label': 'Tous', 'icon': Icons.grid_view_rounded},
      {
        'role': UserRole.artisan,
        'label': 'Artisans',
        'icon': Icons.brush_rounded,
      },
      {
        'role': UserRole.artisanConcepteur,
        'label': 'Concepteurs',
        'icon': Icons.palette_rounded,
      },
      {
        'role': UserRole.artisanRevendeur,
        'label': 'Artisans Rev.',
        'icon': Icons.storefront_rounded,
      },
      {
        'role': UserRole.guideTouristique,
        'label': 'Guides',
        'icon': Icons.explore_rounded,
      },
      {
        'role': UserRole.revendeur,
        'label': 'Revendeurs',
        'icon': Icons.local_mall_rounded,
      },
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral300,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Catégories',
            style: YonwaTextStyles.h3.copyWith(
              color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final role = cat['role'] as UserRole?;
                final label = cat['label'] as String;
                final icon = cat['icon'] as IconData;
                final isSelected = _selectedProfileType == role;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedProfileType = role;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [
                                YonwaColors.primary500,
                                YonwaColors.secondary,
                              ],
                            )
                          : null,
                      color: isSelected
                          ? null
                          : (isDark ? YonwaColors.neutral800 : Colors.white),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                  ? YonwaColors.neutral700
                                  : YonwaColors.neutral200),
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: YonwaColors.primary500.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: isSelected
                              ? Colors.white
                              : YonwaColors.primary500,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? Colors.white70
                                      : YonwaColors.neutral800),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
          _buildFilterDropdowns(isDark),
        ],
      ),
    );
  }

  Widget _buildFilterDropdowns(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildFilterChip(
            label: _selectedProfileType == null
                ? 'Type de profil'
                : _selectedProfileType!.displayName,
            isActive: _selectedProfileType != null,
            onTap: () {
              final options = [
                'Tous',
                'Artisan',
                'Artisan concepteur',
                'Artisan revendeur',
                'Guide touristique',
                'Revendeur',
              ];
              _openFilterBottomSheet(
                title: 'Type de profil',
                options: options,
                currentValue: _selectedProfileType?.displayName,
                onSelected: (val) {
                  setState(() {
                    if (val == null) {
                      _selectedProfileType = null;
                    } else {
                      _selectedProfileType = UserRole.values.firstWhere(
                        (e) => e.displayName == val,
                        orElse: () => UserRole.voyageur,
                      );
                    }
                  });
                },
              );
            },
            isDark: isDark,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: _selectedActivity == null
                ? 'Savoir-faire'
                : _selectedActivity!,
            isActive: _selectedActivity != null,
            onTap: () {
              final options = [
                'Tous',
                'Sculpture',
                'Textile',
                'Peinture',
                'Poterie',
                'Bijoux',
                'Bois',
                'Artisanat traditionnel',
                'Cuisine locale',
                'Expériences culturelles',
                'Autres',
              ];
              _openFilterBottomSheet(
                title: 'Savoir-faire / Activité',
                options: options,
                currentValue: _selectedActivity,
                onSelected: (val) {
                  setState(() {
                    _selectedActivity = val;
                  });
                },
              );
            },
            isDark: isDark,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: _selectedServiceType == null
                ? 'Services/Produits'
                : _selectedServiceType!,
            isActive: _selectedServiceType != null,
            onTap: () {
              final options = [
                'Tous',
                'Produits physiques',
                'Services',
                'Expériences touristiques',
                'Ateliers',
                'Formations',
              ];
              _openFilterBottomSheet(
                title: 'Services / Produits',
                options: options,
                currentValue: _selectedServiceType,
                onSelected: (val) {
                  setState(() {
                    _selectedServiceType = val;
                  });
                },
              );
            },
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? YonwaColors.primary500.withOpacity(0.12)
              : (isDark ? YonwaColors.neutral800 : Colors.white),
          borderRadius: BorderRadius.circular(YonwaRadius.full),
          border: Border.all(
            color: isActive
                ? YonwaColors.primary500
                : (isDark ? YonwaColors.neutral700 : YonwaColors.neutral200),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive
                    ? YonwaColors.primary500
                    : (isDark ? Colors.white70 : YonwaColors.neutral800),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isActive
                  ? YonwaColors.primary500
                  : (isDark ? Colors.white30 : Colors.black38),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterBottomSheet({
    required String title,
    required List<String> options,
    required String? currentValue,
    required ValueChanged<String?> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? YonwaColors.neutral800
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Text(
                  title,
                  style: YonwaTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : YonwaColors.neutral900,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, idx) {
                    final option = options[idx];
                    final isSelected =
                        (currentValue == null && option == 'Tous') ||
                        (currentValue == option);
                    return ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? YonwaColors.primary500
                              : (isDark
                                    ? Colors.white70
                                    : YonwaColors.neutral800),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: YonwaColors.primary500,
                            )
                          : null,
                      onTap: () {
                        if (option == 'Tous') {
                          onSelected(null);
                        } else {
                          onSelected(option);
                        }
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileSections(bool isDark) {
    final filtered = _filteredActors();

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 56,
                color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral300,
              ),
              const SizedBox(height: 12),
              Text(
                'Aucun professionnel ne correspond aux filtres.',
                style: YonwaTextStyles.body.copyWith(
                  color: isDark
                      ? YonwaColors.neutral400
                      : YonwaColors.neutral500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedProfileType = null;
                    _selectedActivity = null;
                    _selectedServiceType = null;
                    _searchController.clear();
                  });
                },
                child: const Text('Réinitialiser les filtres'),
              ),
            ],
          ),
        ),
      );
    }

    final categories = [
      {
        'roles': [UserRole.artisan, UserRole.artisanConcepteur],
        'title': 'Nos Artisans',
      },
      {
        'roles': [UserRole.artisanRevendeur],
        'title': 'Nos Artisans Revendeurs',
      },
      {
        'roles': [UserRole.guideTouristique],
        'title': 'Nos Guides Touristiques',
      },
      {
        'roles': [UserRole.revendeur],
        'title': 'Nos Revendeurs',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.map((cat) {
        final roles = cat['roles'] as List<UserRole>;
        final title = cat['title'] as String;
        final actorsInCat = filtered
            .where((a) => roles.contains(a['role'] as UserRole))
            .toList();

        if (actorsInCat.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: YonwaColors.primary500,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: YonwaTextStyles.h3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : YonwaColors.neutral800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 255,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: actorsInCat.length,
                itemBuilder: (context, index) {
                  final actor = actorsInCat[index];
                  final actorRole = actor['role'] as UserRole;
                  final actorWithDetails = {
                    ...actor,
                    'products': _getProductsForDemo(actorRole, actor['nom']),
                    'catalog': _getCatalogForDemo(actorRole, actor['nom']),
                    'services': _getServicesForDemo(actorRole, actor['nom']),
                    'experiences': _getExperiencesForDemo(
                      actorRole,
                      actor['nom'],
                    ),
                    'publications': _getPublicationsForDemo(
                      actorRole,
                      actor['nom'],
                    ),
                    'reviews': _getReviewsForDemo(actorRole, actor['nom']),
                  };
                  return _buildActorCard(actorWithDetails, isDark);
                },
              ),
            ),
            const SizedBox(height: YonwaSpacing.xl),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildActorCard(Map<String, dynamic> actor, bool isDark) {
    return GestureDetector(
      onTap: () => _openActorProfile(actor),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark
                ? YonwaColors.neutral700
                : YonwaColors.neutral200.withOpacity(0.5),
            width: 0.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 110,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 75,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _imageProvider(actor['coverImage'] ?? 'assets/images/hero1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isDark ? YonwaColors.neutral800 : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: _imageProvider(actor['photoUrl'] ?? 'assets/images/hero22.jpeg'),
                        backgroundColor: YonwaColors.neutral200,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(YonwaRadius.sm),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: YonwaColors.warning,
                            size: 12,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${actor['rating']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    actor['nom'],
                    style: YonwaTextStyles.label.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : YonwaColors.neutral900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 11,
                        color: isDark
                            ? YonwaColors.neutral400
                            : YonwaColors.neutral500,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        actor['ville'],
                        style: YonwaTextStyles.caption.copyWith(
                          fontSize: 10.5,
                          color: isDark
                              ? YonwaColors.neutral400
                              : YonwaColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    actor['bio'],
                    style: YonwaTextStyles.caption.copyWith(
                      fontSize: 11,
                      color: isDark
                          ? YonwaColors.neutral400
                          : YonwaColors.neutral600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {
                    _openActorProfile(actor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: YonwaColors.primary500.withOpacity(0.12),
                    foregroundColor: YonwaColors.primary500,
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Voir Profil',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openActorProfile(Map<String, dynamic> actor) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => DetailedProfileScreen(actor: actor)),
    );
  }

  List<Map<String, dynamic>> _filteredActors() {
    final search = _searchController.text.trim().toLowerCase();

    return _actors.where((actor) {
      if (search.isNotEmpty) {
        final name = (actor['nom'] as String).toLowerCase();
        final bio = (actor['bio'] as String).toLowerCase();
        final location = (actor['ville'] as String).toLowerCase();
        if (!name.contains(search) &&
            !bio.contains(search) &&
            !location.contains(search)) {
          return false;
        }
      }
      if (_selectedProfileType != null) {
        final role = actor['role'] as UserRole;
        final isMergedArtisan =
            _selectedProfileType == UserRole.artisan &&
            (role == UserRole.artisan || role == UserRole.artisanConcepteur);
        if (!isMergedArtisan && role != _selectedProfileType) {
          return false;
        }
      }
      if (_selectedActivity != null) {
        final list = actor['savoirFaire'] as List<String>;
        if (!list.contains(_selectedActivity)) {
          return false;
        }
      }
      if (_selectedServiceType != null) {
        final list = actor['servicesProduits'] as List<String>;
        if (!list.contains(_selectedServiceType)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> _getProductsForDemo(UserRole role, String name) {
    if (role == UserRole.artisan) {
      return [
        {
          'title': 'Jarre d\'Abomey en argile',
          'price': '8 500 FCFA',
          'image':
              'https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?q=80&w=300',
        },
        {
          'title': 'Canari traditionnel décoré',
          'price': '6 000 FCFA',
          'image':
              'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?q=80&w=300',
        },
        {
          'title': 'Vase en céramique ocre',
          'price': '12 000 FCFA',
          'image':
              'https://images.unsplash.com/photo-1580481072645-022f9a6dbf27?q=80&w=300',
        },
      ];
    } else if (role == UserRole.artisanConcepteur) {
      return [
        {
          'title': 'Fauteuil Royal réinventé',
          'price': '185 000 FCFA',
          'image':
              'https://images.unsplash.com/photo-1592078615290-033ee584e267?q=80&w=300',
        },
        {
          'title': 'Masque mural contemporain',
          'price': '45 000 FCFA',
          'image':
              'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?q=80&w=300',
        },
      ];
    } else if (role == UserRole.artisanRevendeur ||
        role == UserRole.revendeur) {
      return [
        {
          'title': 'Pagne tissé indigo (2 yards)',
          'price': '15 000 FCFA',
          'image':
              'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?q=80&w=300',
        },
        {
          'title': 'Écharpe en coton bio teint',
          'price': '7 500 FCFA',
          'image':
              'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?q=80&w=300',
        },
        {
          'title': 'Sac en raphia coloré',
          'price': '5 500 FCFA',
          'image':
              'https://images.unsplash.com/photo-1524498250077-3a9f0c572269?q=80&w=300',
        },
      ];
    }
    return [];
  }

  List<Map<String, dynamic>> _getCatalogForDemo(UserRole role, String name) {
    if (role == UserRole.artisan) {
      return [
        {
          'name': 'Art de la table',
          'count': '12 objets',
          'image':
              'https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?q=80&w=200',
        },
        {
          'name': 'Jarres & Grandes pièces',
          'count': '5 pièces',
          'image':
              'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?q=80&w=200',
        },
      ];
    } else if (role == UserRole.artisanConcepteur) {
      return [
        {
          'name': 'Collection Vodoun Chic',
          'count': '8 créations',
          'image':
              'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?q=80&w=200',
        },
        {
          'name': 'Mobilier & Teck',
          'count': '4 modèles',
          'image':
              'https://images.unsplash.com/photo-1592078615290-033ee584e267?q=80&w=200',
        },
      ];
    } else if (role == UserRole.artisanRevendeur ||
        role == UserRole.revendeur) {
      return [
        {
          'name': 'Tissages & Pagnes',
          'count': '24 articles',
          'image':
              'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?q=80&w=200',
        },
        {
          'name': 'Accessoires de mode',
          'count': '15 articles',
          'image':
              'https://images.unsplash.com/photo-1524498250077-3a9f0c572269?q=80&w=200',
        },
      ];
    }
    return [];
  }

  List<Map<String, dynamic>> _getServicesForDemo(UserRole role, String name) {
    if (role == UserRole.guideTouristique) {
      return [
        {
          'title': 'Accompagnement personnalisé à la journée',
          'duration': '8 heures',
          'price': '15 000 FCFA',
          'icon': Icons.directions_run_rounded,
        },
        {
          'title': 'Service de chauffeur & traducteur',
          'duration': 'Selon besoin',
          'price': 'Sur devis',
          'icon': Icons.directions_car_rounded,
        },
      ];
    } else if (role == UserRole.artisanConcepteur) {
      return [
        {
          'title': 'Atelier de design collaboratif',
          'duration': '3 heures',
          'price': '30 000 FCFA',
          'icon': Icons.palette_rounded,
        },
        {
          'title': 'Conception de mobilier sur mesure',
          'duration': 'Projet complet',
          'price': 'Sur devis',
          'icon': Icons.architecture_rounded,
        },
      ];
    }
    return [];
  }

  List<Map<String, dynamic>> _getExperiencesForDemo(
    UserRole role,
    String name,
  ) {
    if (role == UserRole.guideTouristique) {
      return [
        {
          'title': 'Visite privée de la cité lacustre de Ganvié',
          'price': '25 000 FCFA / pers',
          'rating': '4.9 (42 avis)',
          'image':
              'https://www.gouv.bj/upload/images/banners/546730049088001761344719.png',
        },
        {
          'title': 'Pèlerinage historique sur la Route des Esclaves',
          'price': '15 000 FCFA / pers',
          'rating': '4.8 (38 avis)',
          'image':
              'https://images.unsplash.com/photo-1590674899484-d56419821d99?q=80&w=300',
        },
      ];
    }
    return [];
  }

  List<Map<String, dynamic>> _getPublicationsForDemo(
    UserRole role,
    String name,
  ) {
    return [
      {
        'title': 'Nouvelle création disponible au showroom ✨',
        'time': 'Il y a 2 heures',
        'image':
            'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?q=80&w=400',
        'likes': 42,
      },
      {
        'title': 'Partage du savoir-faire avec la nouvelle génération.',
        'time': 'Il y a 1 jour',
        'image':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400',
        'likes': 78,
      },
    ];
  }

  List<Map<String, dynamic>> _getReviewsForDemo(UserRole role, String name) {
    return [
      {
        'user': 'Sophie M.',
        'rating': 5,
        'comment':
            'Une expérience extraordinaire ! Service très professionnel et qualité impeccable. Je recommande vivement.',
        'date': '22 Juin 2026',
        'avatar': 'https://i.pravatar.cc/100?u=sophie',
      },
      {
        'user': 'Jean-Luc K.',
        'rating': 4,
        'comment':
            'Très satisfait de l\'accueil et du produit acheté. Très authentique.',
        'date': '15 Juin 2026',
        'avatar': 'https://i.pravatar.cc/100?u=jeanluc',
      },
    ];
  }

  Widget _buildFeedItem(Map<String, dynamic> post, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: YonwaSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(YonwaRadius.xl),
        boxShadow: [
          BoxShadow(
            color: (isDark ? YonwaColors.neutral700 : YonwaColors.primary700)
                .withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Padding(
            padding: const EdgeInsets.all(YonwaSpacing.md),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    post['avatar'] ??
                        'https://i.pravatar.cc/150?u=${post['author']}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['author'],
                        style: YonwaTextStyles.label.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? YonwaColors.neutral0
                              : YonwaColors.neutral800,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 12,
                            color: YonwaColors.primary500,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            post['location'],
                            style: YonwaTextStyles.caption.copyWith(
                              color: YonwaColors.primary500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildPostTypeBadge(post['type'] ?? 'Publication'),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? YonwaColors.neutral700
                        : YonwaColors.neutral100,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_vert_rounded,
                    color: YonwaColors.neutral400,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          // Post Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.zero,
              bottom: Radius.zero,
            ),
            child: Image.network(
              post['image'],
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(YonwaSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'],
                  style: YonwaTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? YonwaColors.neutral0
                        : YonwaColors.primary700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post['desc'],
                  style: YonwaTextStyles.body.copyWith(
                    color: isDark
                        ? YonwaColors.neutral300
                        : YonwaColors.neutral600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildFeedAction(
                      Icons.favorite_rounded,
                      post['likes'].toString(),
                      YonwaColors.error,
                      isDark,
                    ),
                    const SizedBox(width: 20),
                    _buildFeedAction(
                      Icons.chat_bubble_rounded,
                      post['comments'].toString(),
                      YonwaColors.primary500,
                      isDark,
                    ),
                    const Spacer(),
                    _buildFeedAction(
                      Icons.share_rounded,
                      '',
                      isDark ? YonwaColors.neutral400 : YonwaColors.neutral700,
                      isDark,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTypeBadge(String type) {
    Color color;
    switch (type) {
      case 'Aventure':
        color = YonwaColors.accent;
        break;
      case 'Publication':
        color = YonwaColors.secondary;
        break;
      case 'Article':
        color = YonwaColors.info;
        break;
      case 'Actualité':
        color = YonwaColors.primary500;
        break;
      case 'Expérience partagée':
        color = YonwaColors.success;
        break;
      default:
        color = YonwaColors.neutral500;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(YonwaRadius.sm),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildFeedAction(
    IconData icon,
    String count,
    Color color,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color.withOpacity(0.8)),
        if (count.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(
            count,
            style: YonwaTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral700,
            ),
          ),
        ],
      ],
    );
  }
}

class _BurgerMenu extends StatelessWidget {
  const _BurgerMenu();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 18,
            height: 2.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 12,
            height: 2.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 24,
            height: 2.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _YonwaBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  const _YonwaBottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(YonwaRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: YonwaColors.primary500,
        unselectedItemColor: isDark
            ? YonwaColors.neutral400
            : YonwaColors.neutral400,
        selectedLabelStyle: YonwaTextStyles.caption.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: YonwaTextStyles.caption,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Explorer',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3D1A08),
                    YonwaColors.primary500,
                    YonwaColors.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            label: 'IA',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_rounded),
            label: 'Messages',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Text(
        title,
        style: YonwaTextStyles.h2.copyWith(
          color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
        ),
      ),
    );
  }
}

// ✅ Widget placeholder pour le mode test
class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Profil',
              style: YonwaTextStyles.h3.copyWith(
                color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: YonwaColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(YonwaRadius.full),
              ),
              child: Text(
                'Test',
                style: YonwaTextStyles.caption.copyWith(
                  color: YonwaColors.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: YonwaColors.primary100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                size: 80,
                color: YonwaColors.primary500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Mode Test',
              style: YonwaTextStyles.h2.copyWith(
                color: isDark ? YonwaColors.neutral0 : YonwaColors.neutral800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connectez-vous pour accéder à votre profil',
              style: YonwaTextStyles.body.copyWith(
                color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/auth', (route) => false);
              },
              icon: const Icon(Icons.login_rounded),
              label: const Text('Se connecter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: YonwaColors.primary500,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(YonwaRadius.lg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
