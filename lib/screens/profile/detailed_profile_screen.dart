import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/yonwa_theme.dart';
import '../../models/models.dart';
import '../../widgets/product_detail_bottom_sheet.dart';
import '../../widgets/yonwa_badge.dart';
import '../../providers/commerce_provider.dart';
import '../commerce/checkout_screen.dart';
import 'history_overview_screen.dart';
import 'publish_content_sheet.dart';

class DetailedProfileScreen extends StatefulWidget {
  final Map<String, dynamic> actor;

  const DetailedProfileScreen({super.key, required this.actor});

  @override
  State<DetailedProfileScreen> createState() => _DetailedProfileScreenState();
}

class _DetailedProfileScreenState extends State<DetailedProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _tabs;
  bool _isFollowing = false;
  late PageController _coverPageController;
  int _currentCoverIndex = 0;

  @override
  void initState() {
    super.initState();
    _initTabs();
    _coverPageController = PageController();
  }

  void _initTabs() {
    final role = widget.actor['role'] as UserRole;
    switch (role) {
      case UserRole.guideTouristique:
        _tabs = ['Expériences', 'Services', 'Publications', 'Avis', 'À propos'];
        break;
      case UserRole.artisan:
        _tabs = ['Produits', 'Catalogue', 'Publications', 'Avis', 'À propos'];
        break;
      case UserRole.artisanConcepteur:
        _tabs = [
          'Catalogue',
          'Produits',
          'Services',
          'Publications',
          'Avis',
          'À propos',
        ];
        break;
      case UserRole.artisanRevendeur:
      case UserRole.revendeur:
        _tabs = ['Produits', 'Catalogue', 'Avis', 'À propos'];
        break;
      case UserRole.voyageur:
        _tabs = ['Publications', 'Expériences', 'Avis', 'À propos'];
        break;
    }
    if (role == UserRole.guideTouristique && !_tabs.contains('Historique')) {
      _tabs.insert(3, 'Historique');
    }
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _coverPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final role = widget.actor['role'] as UserRole;

    return Scaffold(
      backgroundColor: isDark
          ? YonwaColors.neutral900
          : const Color(0xFFF5F6FA),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Sliver App Bar with Cover Photo and Avatar
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              backgroundColor: isDark
                  ? YonwaColors.neutral900
                  : YonwaColors.primary500,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildCoverSlideshow(),
                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.1),
                            isDark
                                ? YonwaColors.neutral900
                                : const Color(0xFFF5F6FA),
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Card Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Transform.translate(
                  offset: const Offset(0, -60),
                  child: Column(
                    children: [
                      // Avatar overlapping
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? YonwaColors.neutral900
                                  : const Color(0xFFF5F6FA),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _imageProvider(
                                widget.actor['photoUrl'] ??
                                    'assets/images/hero20.jpeg',
                              ),
                              backgroundColor: YonwaColors.neutral200,
                            ),
                          ),
                          const Spacer(),
                          // Verification Badge
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: widget.actor['isVerified'] == true
                                ? const CertificationBadge(
                                    status: CertificationStatus.certified,
                                  )
                                : const YonwaBadge(
                                    label: 'Professionnel',
                                    color: YonwaColors.secondary,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Name & Job
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.actor['nom'] ?? '',
                                  style: YonwaTextStyles.h1.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : YonwaColors.neutral900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      role.displayName,
                                      style: YonwaTextStyles.body.copyWith(
                                        color: YonwaColors.primary500,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '•',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white30
                                            : Colors.black26,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.location_on_rounded,
                                      size: 14,
                                      color: isDark
                                          ? YonwaColors.neutral400
                                          : YonwaColors.neutral500,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.actor['ville'] ?? 'Bénin',
                                      style: YonwaTextStyles.caption.copyWith(
                                        color: isDark
                                            ? YonwaColors.neutral400
                                            : YonwaColors.neutral600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Rating Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: YonwaColors.warning.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: YonwaColors.warning.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: YonwaColors.warning,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.actor['rating'] ?? 4.8}',
                                  style: YonwaTextStyles.caption.copyWith(
                                    color: isDark
                                        ? Colors.white
                                        : YonwaColors.neutral800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Description
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.actor['bio'] ?? '',
                          style: YonwaTextStyles.body.copyWith(
                            color: isDark
                                ? YonwaColors.neutral300
                                : YonwaColors.neutral600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Statistics Row
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isDark ? YonwaColors.neutral800 : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                              '${widget.actor['subscribers'] ?? 120}',
                              'Abonnés',
                              isDark,
                            ),
                            _buildVerticalDivider(isDark),
                            _buildStatItem(
                              '${widget.actor['sales'] ?? 15}',
                              'Ventes',
                              isDark,
                            ),
                            _buildVerticalDivider(isDark),
                            _buildStatItem(
                              '${widget.actor['articles'] ?? 24}',
                              'Articles',
                              isDark,
                            ),
                            _buildVerticalDivider(isDark),
                            _buildStatItem(
                              '${widget.actor['servicesCount'] ?? 5}',
                              'Services',
                              isDark,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Action buttons: Follow, Message, Book
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _isFollowing = !_isFollowing;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _isFollowing
                                          ? 'Vous suivez maintenant ${widget.actor['nom']}'
                                          : 'Vous ne suivez plus ${widget.actor['nom']}',
                                    ),
                                    backgroundColor: YonwaColors.primary500,
                                  ),
                                );
                              },
                              icon: Icon(
                                _isFollowing
                                    ? Icons.check
                                    : Icons.person_add_rounded,
                              ),
                              label: Text(_isFollowing ? 'Abonné' : 'Suivre'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFollowing
                                    ? (isDark
                                          ? YonwaColors.neutral700
                                          : YonwaColors.neutral200)
                                    : YonwaColors.primary500,
                                foregroundColor: _isFollowing
                                    ? (isDark
                                          ? Colors.white70
                                          : YonwaColors.neutral800)
                                    : Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? YonwaColors.neutral800
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark
                                    ? YonwaColors.neutral700
                                    : YonwaColors.neutral300,
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: YonwaColors.primary500,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Ouverture de la messagerie...',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? YonwaColors.neutral800
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark
                                    ? YonwaColors.neutral700
                                    : YonwaColors.neutral300,
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.share_outlined,
                                color: YonwaColors.primary500,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Lien de profil copié !'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tab Bar Pinned Section
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: YonwaColors.primary500,
                  unselectedLabelColor: isDark
                      ? YonwaColors.neutral400
                      : YonwaColors.neutral500,
                  indicatorColor: YonwaColors.primary500,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  tabs: _tabs.map((tabName) => Tab(text: tabName)).toList(),
                ),
                isDark,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _tabs
              .map((tabName) => _buildTabContent(tabName, isDark))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openPublishSheet,
        backgroundColor: YonwaColors.primary500,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Publier'),
      ),
    );
  }

  void _openPublishSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) =>
          PublishContentSheet(role: widget.actor['role'] as UserRole),
    );
  }

  Widget _buildStatItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: YonwaTextStyles.h3.copyWith(
            color: isDark ? Colors.white : YonwaColors.neutral900,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: YonwaTextStyles.caption.copyWith(
            color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(
      width: 1,
      height: 30,
      color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
    );
  }

  Widget _buildTabContent(String tabName, bool isDark) {
    final role = widget.actor['role'] as UserRole;
    final productsList =
        widget.actor['products'] as List<Map<String, dynamic>>? ?? [];
    final catalogList =
        widget.actor['catalog'] as List<Map<String, dynamic>>? ?? [];
    final servicesList =
        widget.actor['services'] as List<Map<String, dynamic>>? ?? [];
    final experiencesList =
        widget.actor['experiences'] as List<Map<String, dynamic>>? ?? [];
    final publicationsList =
        widget.actor['publications'] as List<Map<String, dynamic>>? ?? [];
    final reviewsList =
        widget.actor['reviews'] as List<Map<String, dynamic>>? ?? [];

    switch (tabName) {
      case 'Produits':
        if (productsList.isEmpty)
          return _buildEmptyState('Aucun produit disponible', isDark);
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: productsList.length,
          itemBuilder: (context, index) {
            final prod = productsList[index];
            return _buildProductCard(prod, isDark);
          },
        );
      case 'Catalogue':
        if (catalogList.isEmpty)
          return _buildEmptyState('Aucun catalogue disponible', isDark);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: catalogList.length,
          itemBuilder: (context, index) {
            final cat = catalogList[index];
            return _buildCatalogItem(cat, isDark);
          },
        );
      case 'Services':
        if (servicesList.isEmpty)
          return _buildEmptyState('Aucun service disponible', isDark);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: servicesList.length,
          itemBuilder: (context, index) {
            final serv = servicesList[index];
            return _buildServiceItem(serv, isDark);
          },
        );
      case 'Expériences':
        if (experiencesList.isEmpty)
          return _buildEmptyState('Aucune expérience disponible', isDark);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: experiencesList.length,
          itemBuilder: (context, index) {
            final exp = experiencesList[index];
            return _buildExperienceItem(exp, isDark);
          },
        );
      case 'Publications':
        if (publicationsList.isEmpty)
          return _buildEmptyState('Aucune publication', isDark);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: publicationsList.length,
          itemBuilder: (context, index) {
            final pub = publicationsList[index];
            return _buildPublicationItem(pub, isDark);
          },
        );
      case 'Historique':
        return const HistoryOverviewScreen();
      case 'Avis':
        if (reviewsList.isEmpty)
          return _buildEmptyState('Aucun avis pour le moment', isDark);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reviewsList.length,
          itemBuilder: (context, index) {
            final rev = reviewsList[index];
            return _buildReviewItem(rev, isDark);
          },
        );
      case 'À propos':
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? YonwaColors.neutral800 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Présentation',
                  style: YonwaTextStyles.h3.copyWith(
                    color: YonwaColors.primary500,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.actor['bio'] ?? '',
                  style: YonwaTextStyles.body.copyWith(height: 1.6),
                ),
                const Divider(height: 32),
                Text(
                  'Informations clés',
                  style: YonwaTextStyles.h3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildAboutRow(
                  Icons.location_on_rounded,
                  'Localisation : ${widget.actor['ville'] ?? "Bénin"}',
                  isDark,
                ),
                _buildAboutRow(
                  Icons.badge_rounded,
                  'Rôle : ${role.displayName}',
                  isDark,
                ),
                _buildAboutRow(
                  Icons.phone_rounded,
                  'Téléphone : ${widget.actor['telephone'] ?? "+229 97 00 00 00"}',
                  isDark,
                ),
                _buildAboutRow(
                  Icons.verified_rounded,
                  'Identité : Vérifiée sur Yonwa',
                  isDark,
                ),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _buildEmptyState(String text, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 48,
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral300,
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: YonwaTextStyles.body.copyWith(
              color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400,
            ),
          ),
        ],
      ),
    );
  }

  // Cards & Layout Components for Tabs
  Widget _buildProductCard(Map<String, dynamic> product, bool isDark) {
    final item = _commerceItemFromMap(product, CommerceItemType.product);
    return InkWell(
      onTap: () => _showCommerceItemSheet(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
            width: 0.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _assetOrNetworkImage(
                product['image'] ?? 'assets/images/hero2.jpg',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'] ?? '',
                    style: YonwaTextStyles.label.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : YonwaColors.neutral800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product['price'] ?? '',
                        style: YonwaTextStyles.caption.copyWith(
                          color: YonwaColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: YonwaColors.primary500,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
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

  Widget _buildCatalogItem(Map<String, dynamic> catalog, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          _assetOrNetworkImage(
            catalog['image'] ?? 'assets/images/hero3.jpg',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catalog['name'] ?? '',
                  style: YonwaTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : YonwaColors.neutral800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  catalog['count'] ?? '',
                  style: YonwaTextStyles.caption.copyWith(
                    color: YonwaColors.primary500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: YonwaColors.primary500,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service, bool isDark) {
    final item = _commerceItemFromMap(
      service,
      CommerceItemType.artisticExperience,
    );
    return InkWell(
      onTap: () => _showCommerceItemSheet(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: YonwaColors.primary500.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                service['icon'] as IconData? ?? Icons.design_services_rounded,
                color: YonwaColors.primary500,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['title'] ?? '',
                    style: YonwaTextStyles.label.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : YonwaColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Durée : ${service['duration']}',
                    style: YonwaTextStyles.caption.copyWith(
                      color: isDark
                          ? YonwaColors.neutral400
                          : YonwaColors.neutral500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  service['price'] ?? '',
                  style: YonwaTextStyles.caption.copyWith(
                    color: YonwaColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 16,
                  color: YonwaColors.primary500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceItem(Map<String, dynamic> experience, bool isDark) {
    final item = _commerceItemFromMap(
      experience,
      CommerceItemType.touristExperience,
    );
    return InkWell(
      onTap: () => _showCommerceItemSheet(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
            width: 0.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _assetOrNetworkImage(
              experience['image'] ?? 'assets/images/hero4.jpg',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience['title'] ?? '',
                    style: YonwaTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : YonwaColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        experience['price'] ?? '',
                        style: YonwaTextStyles.caption.copyWith(
                          color: YonwaColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: YonwaColors.warning,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            experience['rating'] ?? '',
                            style: YonwaTextStyles.caption.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildCoverSlideshow() {
    final coverImages = _coverImages();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _coverPageController,
          onPageChanged: (index) => setState(() => _currentCoverIndex = index),
          itemCount: coverImages.length,
          itemBuilder: (context, index) {
            return _assetOrNetworkImage(coverImages[index], fit: BoxFit.cover);
          },
        ),
        // Indicator for multiple cover images
        if (coverImages.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _coverPageController,
                count: coverImages.length,
                effect: ScrollingDotsEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  activeDotColor: isDark
                      ? Colors.white
                      : YonwaColors.primary500,
                  dotColor: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<String> _coverImages() {
    final raw = widget.actor['coverImages'];
    if (raw is List && raw.isNotEmpty) {
      return raw.cast<String>();
    }
    final cover = widget.actor['coverImage'] as String?;
    return [
      cover ?? 'assets/images/hero1.jpg',
      'assets/images/hero2.jpg',
      'assets/images/hero3.jpg',
    ];
  }

  CommerceItem _commerceItemFromMap(
    Map<String, dynamic> source,
    CommerceItemType type,
  ) {
    final title = (source['title'] ?? source['name'] ?? 'Element Yonwa')
        .toString();
    return CommerceItem(
      id: '${widget.actor['nom']}_$title'.replaceAll(' ', '_'),
      title: title,
      price: (source['price'] ?? 'Sur devis').toString(),
      image:
          (source['image'] ??
                  widget.actor['coverImage'] ??
                  'assets/images/hero1.jpg')
              .toString(),
      seller: (widget.actor['nom'] ?? 'Professionnel Yonwa').toString(),
      description:
          (source['description'] ??
                  widget.actor['bio'] ??
                  'Detail, disponibilite et conditions seront confirmes par le professionnel.')
              .toString(),
      type: type,
    );
  }

  void _showCommerceItemSheet(CommerceItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => ProductDetailBottomSheet(item: item),
    );
  }

  Widget _assetOrNetworkImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    if (isNetwork) {
      return Image.network(path, width: width, height: height, fit: fit);
    }
    return Image.asset(path, width: width, height: height, fit: fit);
  }

  ImageProvider<Object> _imageProvider(String path) {
    final isNetwork = path.startsWith('http://') || path.startsWith('https://');
    return isNetwork ? NetworkImage(path) : AssetImage(path);
  }

  Widget _buildPublicationItem(Map<String, dynamic> pub, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          width: 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pub['image'] != null)
            _assetOrNetworkImage(
              pub['image'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pub['title'] ?? '',
                  style: YonwaTextStyles.body.copyWith(
                    color: isDark ? Colors.white : YonwaColors.neutral800,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: YonwaColors.error.withOpacity(0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${pub['likes'] ?? 0}',
                      style: YonwaTextStyles.caption,
                    ),
                    const Spacer(),
                    Text(
                      pub['time'] ?? '',
                      style: YonwaTextStyles.caption.copyWith(
                        color: isDark
                            ? YonwaColors.neutral500
                            : YonwaColors.neutral400,
                      ),
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

  Widget _buildReviewItem(Map<String, dynamic> review, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: _imageProvider(
                  review['avatar'] ?? 'assets/images/hero21.jpeg',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['user'] ?? '',
                      style: YonwaTextStyles.label.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : YonwaColors.neutral800,
                      ),
                    ),
                    Text(
                      review['date'] ?? '',
                      style: YonwaTextStyles.caption.copyWith(
                        color: isDark
                            ? YonwaColors.neutral500
                            : YonwaColors.neutral400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: index < (review['rating'] ?? 5)
                        ? YonwaColors.warning
                        : YonwaColors.neutral300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'] ?? '',
            style: YonwaTextStyles.body.copyWith(
              color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: YonwaColors.primary500, size: 18),
          const SizedBox(width: 12),
          Text(
            text,
            style: YonwaTextStyles.body.copyWith(
              color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral800,
            ),
          ),
        ],
      ),
    );
  }
}

// Persist Header TabBar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  _SliverAppBarDelegate(this.tabBar, this.isDark);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: isDark ? YonwaColors.neutral900 : const Color(0xFFF5F6FA),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
