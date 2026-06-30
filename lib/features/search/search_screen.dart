import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../mock/mock_data.dart';
import '../../theme/yonwa_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isSearching = false;

  // Suggestions populaires
  final List<String> _popularSearches = [
    'Guide Ganvié',
    'Poterie Abomey',
    'Tissage indigo',
    'Visite Ouidah',
    'Sculpture bois',
    'Bijoux traditionnels',
    'Circuit palais royaux',
    'Cuisine locale',
  ];

  // Catégories de recherche
  final List<Map<String, dynamic>> _categories = [
    {'icon': HugeIcons.strokeRoundedUser, 'label': 'Artisans', 'count': 45},
    {'icon': HugeIcons.strokeRoundedCompass, 'label': 'Guides', 'count': 23},
    {'icon': HugeIcons.strokeRoundedShoppingCart01, 'label': 'Produits', 'count': 128},
    {'icon': HugeIcons.strokeRoundedTouchInteraction01, 'label': 'Services', 'count': 34},
    {'icon': HugeIcons.strokeRoundedRoute01, 'label': 'Expériences', 'count': 56},
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // Recherche dans les acteurs
    final actorResults = MockData.actors.where((actor) {
      return actor['nom'].toString().toLowerCase().contains(query) ||
          actor['ville'].toString().toLowerCase().contains(query) ||
          actor['bio'].toString().toLowerCase().contains(query);
    }).toList();

    // Recherche dans les produits
    final productResults = MockData.products.where((product) {
      return product['title'].toString().toLowerCase().contains(query) ||
          product['category'].toString().toLowerCase().contains(query);
    }).toList();

    setState(() {
      _results = [
        ...actorResults.map((e) => {...e, 'type': 'profile'}),
        ...productResults.map((e) => {...e, 'type': 'product'}),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec bouton retour et recherche
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                  ),
                  const SizedBox(width: 8),
                  
                  // Barre de recherche
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Rechercher...',
                                hintStyle: GoogleFonts.inter(
                                  color: YonwaColors.neutral400,
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                              ),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: YonwaColors.neutral900,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                _searchController.clear();
                              },
                              icon: const Icon(Icons.close_rounded),
                              iconSize: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenu
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isSearching) {
      return _buildResults();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Catégories
          Text(
            'Catégories',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: YonwaColors.neutral900,
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: YonwaColors.neutral200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: YonwaColors.primary50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: HugeIcon(
                        icon: category['icon'],
                        color: YonwaColors.primary500,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            category['label'],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: YonwaColors.neutral900,
                            ),
                          ),
                          Text(
                            '${category['count']} résultats',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: YonwaColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Recherches populaires
          Text(
            'Recherches populaires',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: YonwaColors.neutral900,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches.map((search) {
              return ActionChip(
                label: Text(
                  search,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: YonwaColors.neutral700,
                  ),
                ),
                onPressed: () {
                  _searchController.text = search;
                },
                backgroundColor: Colors.white,
                side: BorderSide(color: YonwaColors.neutral200),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedSearchList01,
                color: YonwaColors.neutral400,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun résultat trouvé',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: YonwaColors.neutral700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Essayez avec d\'autres mots-clés',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: YonwaColors.neutral500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        
        if (result['type'] == 'profile') {
          return _ProfileResultTile(
            name: result['nom'],
            role: result['roleDisplay'] ?? result['role'],
            location: result['ville'],
            imageUrl: result['photoUrl'],
            rating: result['rating'],
            onTap: () => Navigator.pushNamed(context, '/profile/${result['id']}'),
          );
        } else {
          return _ProductResultTile(
            title: result['title'],
            price: result['price'],
            imageUrl: result['image'],
            category: result['category'],
          );
        }
      },
    );
  }
}

class _ProfileResultTile extends StatelessWidget {
  final String name;
  final String role;
  final String location;
  final String? imageUrl;
  final String rating;
  final VoidCallback onTap;

  const _ProfileResultTile({
    required this.name,
    required this.role,
    required this.location,
    this.imageUrl,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: YonwaColors.neutral200),
        ),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                imageUrl ?? 'https://i.pravatar.cc/300?u=$name',
              ),
              backgroundColor: YonwaColors.neutral200,
            ),
            const SizedBox(width: 12),
            
            // Infos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: YonwaColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$role • $location',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: YonwaColors.neutral600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Rating
            Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedStar,
                  color: Color(0xFFC9A84C),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  rating,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: YonwaColors.neutral800,
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

class _ProductResultTile extends StatelessWidget {
  final String title;
  final String price;
  final String? imageUrl;
  final String category;

  const _ProductResultTile({
    required this.title,
    required this.price,
    this.imageUrl,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: YonwaColors.neutral200),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: YonwaColors.neutral200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl ?? 'https://via.placeholder.com/60',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image,
                  color: YonwaColors.neutral400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: YonwaColors.neutral900,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: YonwaColors.primary50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: YonwaColors.primary500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
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
    );
  }
}