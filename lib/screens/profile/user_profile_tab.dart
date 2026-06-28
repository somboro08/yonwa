import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/yonwa_theme.dart';
import '../../models/models.dart';
import '../../providers/user_provider.dart';
import '../../widgets/yonwa_badge.dart';
import '../booking/my_bookings_screen.dart';
import 'favorites_screen.dart';
import 'identity_verification_screen.dart';
import 'settings_screen.dart';
import 'support_screen.dart';

class UserProfileTab extends StatefulWidget {
  const UserProfileTab({super.key});

  @override
  State<UserProfileTab> createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<UserProfileTab> with TickerProviderStateMixin {
  TabController? _tabController;
  UserRole? _currentRole;
  List<String> _tabs = [];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProvider = context.watch<UserProvider>();
    final role = userProvider.role;

    // Réinitialiser le TabController si le rôle change
    if (_currentRole != role) {
      _currentRole = role;
      _initTabs(role);
    }

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : const Color(0xFFF5F6FA),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Top Cover Photo & Settings Button
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.primary500,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Cover photo
                    Image.asset(
                      userProvider.coverImage,
                      fit: BoxFit.cover,
                    ),
                    // Tint overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.1),
                            isDark ? YonwaColors.neutral900 : const Color(0xFFF5F6FA),
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: const Text(
                'Mon Profil',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              actions: [
                _buildHeaderIcon(Icons.edit_rounded, () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Édition du profil en cours d\'implémentation...')),
                  );
                }),
                const SizedBox(width: 8),
                _buildHeaderIcon(Icons.settings_rounded, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                }),
                const SizedBox(width: 16),
              ],
            ),

            // Profile Header Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Transform.translate(
                  offset: const Offset(0, -40),
                  child: Column(
                    children: [
                      // Avatar row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark ? YonwaColors.neutral900 : const Color(0xFFF5F6FA),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 46,
                              backgroundImage: NetworkImage(userProvider.photoUrl),
                              backgroundColor: YonwaColors.neutral200,
                            ),
                          ),
                          const Spacer(),
                          // Verification & Role Tag
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const CertificationBadge(status: CertificationStatus.certified),
                                const SizedBox(height: 4),
                                Text(
                                  role.displayName,
                                  style: YonwaTextStyles.caption.copyWith(
                                    color: YonwaColors.primary500,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Name and Email
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProvider.fullName,
                              style: YonwaTextStyles.h2.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : YonwaColors.neutral900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              userProvider.email,
                              style: YonwaTextStyles.caption.copyWith(
                                color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Bio Description
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userProvider.bio,
                          style: YonwaTextStyles.body.copyWith(
                            color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Stats Row
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
                            _buildStatItem('${userProvider.stats['abonnés']}', 'Abonnés', isDark),
                            _buildVerticalDivider(isDark),
                            _buildStatItem('${userProvider.stats['ventes']}', 'Ventes', isDark),
                            _buildVerticalDivider(isDark),
                            _buildStatItem('${userProvider.stats['articlesVendus']}', 'Articles', isDark),
                            _buildVerticalDivider(isDark),
                            _buildStatItem('${userProvider.stats['servicesRéalisés']}', 'Services', isDark),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),

            // Pinned Tab Bar
            if (_tabController != null)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: YonwaColors.primary500,
                    unselectedLabelColor: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                    indicatorColor: YonwaColors.primary500,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 14),
                    unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.normal, fontSize: 14),
                    tabs: _tabs.map((tabName) => Tab(text: tabName)).toList(),
                  ),
                  isDark,
                ),
              ),
          ];
        },
        body: _tabController == null
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: _tabs.map((tabName) => _buildTabContent(tabName, userProvider, isDark)).toList(),
              ),
      ),
    );
  }

  void _initTabs(UserRole role) {
    _tabController?.dispose();
    switch (role) {
      case UserRole.guideTouristique:
        _tabs = ['Expériences', 'Services', 'Publications', 'Avis', 'À propos'];
        break;
      case UserRole.artisan:
        _tabs = ['Produits', 'Catalogue', 'Publications', 'Avis', 'À propos'];
        break;
      case UserRole.artisanConcepteur:
        _tabs = ['Catalogue', 'Produits', 'Services', 'Publications', 'Avis', 'À propos'];
        break;
      case UserRole.artisanRevendeur:
      case UserRole.revendeur:
        _tabs = ['Produits', 'Catalogue', 'Avis', 'À propos'];
        break;
      case UserRole.voyageur:
        _tabs = ['Publications', 'Expériences', 'Avis', 'À propos'];
        break;
    }
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
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

  Widget _buildTabContent(String tabName, UserProvider userProvider, bool isDark) {
    switch (tabName) {
      case 'Produits':
        final list = userProvider.products;
        if (list.isEmpty) return _buildEmptyState('Aucun produit mis en vente', isDark);
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemCount: list.length,
          itemBuilder: (context, index) => _buildProductCard(list[index], isDark),
        );
      case 'Catalogue':
        final list = userProvider.catalog;
        if (list.isEmpty) return _buildEmptyState('Aucun catalogue disponible', isDark);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) => _buildCatalogItem(list[index], isDark),
        );
      case 'Services':
        final list = userProvider.services;
        if (list.isEmpty) return _buildEmptyState('Aucun service proposé', isDark);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) => _buildServiceItem(list[index], isDark),
        );
      case 'Expériences':
        final list = userProvider.experiences;
        if (list.isEmpty) return _buildEmptyState('Aucune expérience enregistrée', isDark);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) => _buildExperienceItem(list[index], isDark),
        );
      case 'Publications':
        final list = userProvider.publications;
        if (list.isEmpty) return _buildEmptyState('Aucune publication', isDark);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) => _buildPublicationItem(list[index], isDark),
        );
      case 'Avis':
        final list = userProvider.reviews;
        if (list.isEmpty) return _buildEmptyState('Aucun avis client', isDark);
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, index) => _buildReviewItem(list[index], isDark),
        );
      case 'À propos':
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Presentation Card
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? YonwaColors.neutral800 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mon Récit / Présentation',
                      style: YonwaTextStyles.h3.copyWith(color: YonwaColors.primary500, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userProvider.bio,
                      style: YonwaTextStyles.body.copyWith(height: 1.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Action List - "Mon Espace"
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? YonwaColors.neutral800 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mon Espace Client / Pro',
                      style: YonwaTextStyles.label.copyWith(
                        color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildEspaceItem(Icons.calendar_month_rounded, 'Mes Réservations', YonwaColors.primary500, isDark, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MyBookingsScreen()));
                    }),
                    _buildEspaceItem(Icons.favorite_rounded, 'Mes Favoris', YonwaColors.error, isDark, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
                    }),
                    _buildEspaceItem(Icons.verified_user_rounded, 'Vérification d\'identité', YonwaColors.success, isDark, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const IdentityVerificationScreen()));
                    }),
                    _buildEspaceItem(Icons.help_outline_rounded, 'Aide & Support', YonwaColors.accent, isDark, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen()));
                    }),
                    const Divider(height: 24),
                    _buildEspaceItem(Icons.logout_rounded, 'Déconnexion', YonwaColors.error, isDark, () {
                      _showLogoutDialog(context, isDark);
                    }),
                  ],
                ),
              ),
            ],
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
          Icon(Icons.inbox_rounded, size: 40, color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral300),
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

  Widget _buildProductCard(Map<String, dynamic> product, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              product['image'],
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
                  product['title'],
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
                      product['price'],
                      style: YonwaTextStyles.caption.copyWith(color: YonwaColors.secondary, fontWeight: FontWeight.bold),
                    ),
                    const Icon(Icons.edit_note_rounded, size: 18, color: YonwaColors.primary500),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogItem(Map<String, dynamic> catalog, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Image.network(
            catalog['image'],
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  catalog['name'],
                  style: YonwaTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : YonwaColors.neutral800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  catalog['count'],
                  style: YonwaTextStyles.caption.copyWith(color: YonwaColors.primary500, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_rounded, color: YonwaColors.primary500, size: 16),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: YonwaColors.primary500.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(service['icon'] as IconData? ?? Icons.design_services_rounded, color: YonwaColors.primary500, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['title'],
                  style: YonwaTextStyles.label.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : YonwaColors.neutral800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Durée : ${service['duration']}',
                  style: YonwaTextStyles.caption.copyWith(color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500),
                ),
              ],
            ),
          ),
          Text(
            service['price'],
            style: YonwaTextStyles.caption.copyWith(color: YonwaColors.secondary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(Map<String, dynamic> experience, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            experience['image'],
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experience['title'],
                  style: YonwaTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : YonwaColors.neutral800,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      experience['price'],
                      style: YonwaTextStyles.caption.copyWith(color: YonwaColors.secondary, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      experience['rating'],
                      style: YonwaTextStyles.caption.copyWith(color: YonwaColors.success, fontWeight: FontWeight.bold),
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

  Widget _buildPublicationItem(Map<String, dynamic> pub, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? YonwaColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            pub['image'],
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pub['title'],
                  style: YonwaTextStyles.body,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded, color: YonwaColors.error, size: 16),
                    const SizedBox(width: 4),
                    Text('${pub['likes']}', style: YonwaTextStyles.caption),
                    const Spacer(),
                    Text(
                      pub['time'],
                      style: YonwaTextStyles.caption.copyWith(color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400),
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
        border: Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(review['avatar']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['user'],
                      style: YonwaTextStyles.label.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : YonwaColors.neutral800,
                      ),
                    ),
                    Text(
                      review['date'],
                      style: YonwaTextStyles.caption.copyWith(color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400),
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
                    color: index < review['rating'] ? YonwaColors.warning : YonwaColors.neutral300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'],
            style: YonwaTextStyles.body.copyWith(
              color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEspaceItem(IconData icon, String title, Color color, bool isDark, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: YonwaTextStyles.body.copyWith(
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : YonwaColors.neutral800,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: isDark ? YonwaColors.neutral600 : YonwaColors.neutral300,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? YonwaColors.neutral800 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Déconnexion',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annuler', style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
            },
            child: const Text('Déconnexion', style: TextStyle(color: YonwaColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final bool isDark;

  _SliverTabBarDelegate(this.tabBar, this.isDark);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? YonwaColors.neutral900 : const Color(0xFFF5F6FA),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) {
    return true; // Rebuild to handle tab updates
  }
}
