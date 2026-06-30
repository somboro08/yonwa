import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../models/models.dart';
import '../../shared/providers/user_provider.dart';
import '../../shared/widgets/floating_navbar.dart';
import '../../core/responsive/breakpoints.dart';
import '../../theme/yonwa_theme.dart';
import 'role_profile_config.dart';
import 'widgets/profile_header.dart';
import 'widgets/quick_actions_bar.dart';
import 'sections/about_section.dart';
import 'sections/catalog_section.dart';
import 'sections/experiences_section.dart';
import 'sections/products_section.dart';
import 'sections/publications_section.dart';
import 'sections/reviews_section.dart';
import 'sections/services_section.dart';
import 'sections/appointments_section.dart';
import 'sections/adventure_history_section.dart';

/// Profil "self" adaptatif : un seul écran, configuré par le rôle de l'utilisateur.
class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  UserRole? _configuredForRole;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  /// (Re)crée le TabController quand le rôle change (le nombre d'onglets varie).
  void _syncTabController(UserRole role, int tabCount) {
    if (_configuredForRole != role || _tabController == null) {
      _tabController?.dispose();
      _tabController = TabController(length: tabCount, vsync: this);
      _configuredForRole = role;
    }
  }

  void _openRoleSwitcher() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _RoleSwitcherSheet(
        currentRole: ref.read(userProviderRef).role,
        onSelect: (role) async {
          Navigator.pop(context);
          await ref.read(userProviderRef).updateRole(role);
        },
      ),
    );
  }

  void _onQuickAction(QuickActionType type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Action "${type.name}" — bientôt disponible.')),
    );
  }

  /// Construit le widget de section correspondant à un onglet.
  Widget _buildSection(ProfileTab tab) {
    switch (tab) {
      case ProfileTab.products:
        return const ProductsSection();
      case ProfileTab.catalog:
        return const CatalogSection();
      case ProfileTab.services:
        return const ServicesSection();
      case ProfileTab.experiences:
        return const ExperiencesSection();
      case ProfileTab.appointments:
        return const AppointmentsSection();
      case ProfileTab.adventureHistory:
        return const AdventureHistorySection();
      case ProfileTab.publications:
        return const PublicationsSection();
      case ProfileTab.reviews:
        return const ReviewsSection();
      case ProfileTab.about:
        return const AboutSection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProviderRef);
    final config = RoleProfileConfig.forRole(user.role);
    _syncTabController(user.role, config.tabs.length);

    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: SafeArea(
        top: false,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Navbar flottante (mobile)
              if (context.isMobile)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 10,
                      bottom: 8,
                    ),
                    child: FloatingNavbar(
                      onMenuPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),

              // Header fixe (cover + avatar + KPI) + actions rapides + TabBar.
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ProfileHeader(onRoleTap: _openRoleSwitcher),
                    const SizedBox(height: 16),
                    QuickActionsBar(
                      actions: config.quickActions,
                      onAction: _onQuickAction,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // TabBar collante.
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  controller: _tabController!,
                  tabs: config.tabs,
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: config.tabs.map(_buildSection).toList(),
          ),
        ),
      ),
    );
  }
}

/// TabBar collante intégrée à un NestedScrollView.
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController controller;
  final List<ProfileTab> tabs;
  static const double _height = 48;

  _StickyTabBarDelegate({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: YonwaColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: const Color(0xFFC9A84C),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: const Color(0xFF0D0D0D),
        unselectedLabelColor: const Color(0xFF6B6B7A),
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        dividerColor: Colors.transparent,
        tabs: tabs
            .map((t) => Tab(text: RoleProfileConfig.tabLabel(t)))
            .toList(),
      ),
    );
  }

  @override
  double get maxExtent => _height;

  @override
  double get minExtent => _height;

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) =>
      controller != oldDelegate.controller || tabs != oldDelegate.tabs;
}

/// Bottom sheet de permutation de rôle (utile pour tester l'adaptation).
class _RoleSwitcherSheet extends StatelessWidget {
  final UserRole currentRole;
  final ValueChanged<UserRole> onSelect;
  const _RoleSwitcherSheet({required this.currentRole, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEF2),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
                  Text(
                    'Changer de profil',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: YonwaColors.neutral900,
                    ),
                  ),
          const SizedBox(height: 4),
                  Text(
                    'L\'expérience s\'adapte au rôle choisi.',
                    style: GoogleFonts.inter(fontSize: 13, color: YonwaColors.neutral500),
                  ),
          const SizedBox(height: 16),
          ...UserRole.values.map((role) {
            final isSelected = role == currentRole;
            final color = RoleProfileConfig.roleColor(role);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.08) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? color.withOpacity(0.4) : YonwaColors.neutral200,
                    ),
                  ),
              child: ListTile(
                onTap: () => onSelect(role),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUserCircle,
                    color: color,
                    size: 20,
                  ),
                ),
                title: Text(
                  role.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: YonwaColors.neutral900,
                  ),
                ),
                subtitle: Text(
                  RoleProfileConfig.roleTagline(role),
                  style: GoogleFonts.inter(fontSize: 11, color: YonwaColors.neutral500),
                ),
                trailing: isSelected
                    ? HugeIcon(
                        icon: HugeIcons.strokeRoundedTickDouble02,
                        color: color,
                        size: 20,
                      )
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }
}
