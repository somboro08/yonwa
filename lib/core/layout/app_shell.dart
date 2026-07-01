import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../responsive/responsive_layout.dart';
import '../../shared/widgets/profile_avatar.dart';
import 'web_sidebar.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;

    return ResponsiveLayout(
      mobile: _MobileShell(currentRoute: location, child: child),
      tablet: _TabletShell(currentRoute: location, child: child),
      desktop: _DesktopShell(currentRoute: location, child: child),
    );
  }
}

// ── DESKTOP ──────────────────────────────────────────────────
class _DesktopShell extends StatelessWidget {
  final Widget child;
  final String currentRoute;
  const _DesktopShell({required this.child, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Row(
        children: [
          // Sidebar gauche fixe
          WebSidebar(currentRoute: currentRoute),
          // Séparateur très léger
          Container(width: 1, color: const Color(0xFFEEEEF2)),
          // Zone centrale scrollable
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── TABLET ───────────────────────────────────────────────────
class _TabletShell extends StatelessWidget {
  final Widget child;
  final String currentRoute;
  const _TabletShell({required this.child, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Row(
        children: [
          // Sidebar compacte (icônes seulement)
          WebSidebarCompact(currentRoute: currentRoute),
          Container(width: 1, color: const Color(0xFFEEEEF2)),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── MOBILE ───────────────────────────────────────────────────
class _MobileShell extends StatelessWidget {
  final Widget child;
  final String currentRoute;
  const _MobileShell({required this.child, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Avatar cliquable → profil self
            const _DrawerHeaderWithAvatar(),
            ListTile(
              leading: const HugeIcon(icon: HugeIcons.strokeRoundedCompass, color: Color(0xFF6B6B7A), size: 22),
              title: const Text('Explorer'),
              onTap: () { context.go('/home'); Navigator.pop(context); },
            ),
            ListTile(
              leading: const HugeIcon(icon: HugeIcons.strokeRoundedUser, color: Color(0xFF6B6B7A), size: 22),
              title: const Text('Profils'),
              onTap: () { context.go('/explore'); Navigator.pop(context); },
            ),
            ListTile(
              leading: const HugeIcon(icon: HugeIcons.strokeRoundedCalendar01, color: Color(0xFF6B6B7A), size: 22),
              title: const Text('Réservations'),
              onTap: () { context.go('/booking'); Navigator.pop(context); },
            ),
            const Divider(),
            ListTile(
              leading: const HugeIcon(icon: HugeIcons.strokeRoundedUserCircle, color: Color(0xFFC9A84C), size: 22),
              title: const Text('Mon Profil'),
              onTap: () { context.go('/me'); Navigator.pop(context); },
            ),
          ],
        ),
      ),
      body: SafeArea(child: child),
      bottomNavigationBar: _MobileNavbar(currentRoute: currentRoute),
    );
  }
}

class _MobileNavbar extends StatelessWidget {
  final String currentRoute;
  const _MobileNavbar({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEF2), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MobileNavbarItem(
            icon: HugeIcons.strokeRoundedCompass,
            label: 'Explorer',
            route: '/home',
            isSelected: currentRoute == '/home',
          ),
          _MobileNavbarItem(
            icon: HugeIcons.strokeRoundedUser,
            label: 'Profils',
            route: '/explore',
            isSelected: currentRoute == '/explore',
          ),
          _MobileNavbarItem(
            icon: HugeIcons.strokeRoundedCalendar01,
            label: 'Réservations',
            route: '/booking',
            isSelected: currentRoute == '/booking',
          ),
          _MobileNavbarItem(
            icon: HugeIcons.strokeRoundedUserCircle,
            label: 'Profil',
            route: '/me',
            isSelected: currentRoute == '/me',
          ),
        ],
      ),
    );
  }
}

class _MobileNavbarItem extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String label;
  final String route;
  final bool isSelected;

  const _MobileNavbarItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: icon,
            color: isSelected ? const Color(0xFFC9A84C) : const Color(0xFF6B6B7A),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? const Color(0xFFC9A84C) : const Color(0xFF6B6B7A),
            ),
          ),
        ],
      ),
    );
  }
}

/// En-tête du drawer mobile : bandeau or + avatar cliquable.
class _DrawerHeaderWithAvatar extends StatelessWidget {
  const _DrawerHeaderWithAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2E),
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 16),
      child: ProfileAvatar(showLabel: true, radius: 22),
    );
  }
}
