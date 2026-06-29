import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/profile_avatar.dart';

class NavItem {
  final List<List<dynamic>> icon;
  final String label;
  final String route;
  const NavItem({required this.icon, required this.label, required this.route});
}

final List<NavItem> _navItems = [
  const NavItem(
    icon: HugeIcons.strokeRoundedCompass,
    label: 'Explorer',
    route: '/home',
  ),
  const NavItem(
    icon: HugeIcons.strokeRoundedUser,
    label: 'Profils',
    route: '/explore',
  ),
  const NavItem(
    icon: HugeIcons.strokeRoundedRoute01,
    label: 'Expériences',
    route: '/booking',
  ),
  const NavItem(
    icon: HugeIcons.strokeRoundedPackage,
    label: 'Produits',
    route: '/explore',
  ),
  const NavItem(
    icon: HugeIcons.strokeRoundedCalendar01,
    label: 'Réservations',
    route: '/booking',
  ),
  const NavItem(
    icon: HugeIcons.strokeRoundedUserCircle,
    label: 'Mon Profil',
    route: '/me',
  ),
];

class WebSidebar extends StatelessWidget {
  final String currentRoute;
  const WebSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: double.infinity,
      color: const Color(0xFFFFFFFF),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Text(
            'Yonwa',
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0D0D0D),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 40),
          // Nav items
          ..._navItems.map((item) {
            final isSelected = currentRoute == item.route;
            return _SidebarNavItem(
              icon: item.icon,
              label: item.label,
              route: item.route,
              isSelected: isSelected,
            );
          }),
          const Spacer(),
          // Avatar cliquable → profil self
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEEEEF2)),
            ),
            child: const ProfileAvatar(showLabel: true),
          ),
          const SizedBox(height: 8),
          _SidebarNavItem(
            icon: HugeIcons.strokeRoundedSettings02,
            label: 'Paramètres',
            route: '/settings',
            isSelected: currentRoute == '/settings',
          ),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String route;
  final bool isSelected;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          context.go(route);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFC9A84C).withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              HugeIcon(
                icon: icon,
                color: isSelected ? const Color(0xFFC9A84C) : const Color(0xFF6B6B7A),
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFFC9A84C) : const Color(0xFF6B6B7A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Sidebar compacte (tablet — icônes seulement)
class WebSidebarCompact extends StatelessWidget {
  final String currentRoute;
  const WebSidebarCompact({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: double.infinity,
      color: const Color(0xFFFFFFFF),
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          // Logo réduit (initiale)
          Text('Y', style: GoogleFonts.poppins(
            fontSize: 22, fontWeight: FontWeight.w800,
            color: const Color(0xFFC9A84C),
          )),
          const SizedBox(height: 40),
          ..._navItems.map((item) {
            final isSelected = currentRoute == item.route;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: IconButton(
                icon: HugeIcon(
                  icon: item.icon,
                  color: isSelected ? const Color(0xFFC9A84C) : const Color(0xFF6B6B7A),
                  size: 24,
                ),
                onPressed: () {
                  context.go(item.route);
                },
              ),
            );
          }),
          const Spacer(),
          // Avatar cliquable → profil self
          const ProfileAvatar(compact: true),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSettings02,
                color: currentRoute == '/settings' ? const Color(0xFFC9A84C) : const Color(0xFF6B6B7A),
                size: 24,
              ),
              onPressed: () {
                context.go('/settings');
              },
            ),
          ),
        ],
      ),
    );
  }
}
