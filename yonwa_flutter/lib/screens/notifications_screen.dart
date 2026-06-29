import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class NotificationsScreen extends StatelessWidget {
  final VoidCallback onBack;
  const NotificationsScreen({super.key, required this.onBack});

  IconData _icon(String type) {
    switch (type) {
      case 'booking': return Icons.check_circle_outline;
      case 'message': return Icons.chat_bubble_outline;
      case 'review': return Icons.star_outline;
      case 'promo': return Icons.bolt;
      default: return Icons.notifications_outlined;
    }
  }

  Color _color(String type) {
    switch (type) {
      case 'booking': return AppColors.green;
      case 'message': return AppColors.primary;
      case 'review': return AppColors.secondary;
      case 'promo': return AppColors.purple;
      default: return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifs = MockData.notifications;
    final today = notifs.where((n) => !n.read).toList();
    final week = notifs.where((n) => n.read).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 14),
            decoration: const BoxDecoration(color: AppColors.card, border: Border(bottom: BorderSide(color: AppColors.border))),
            child: Row(
              children: [
                GestureDetector(onTap: onBack, child: const Icon(Icons.chevron_left, size: 26, color: AppColors.textDark)),
                const SizedBox(width: 12),
                const Expanded(child: Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark))),
                TextButton(onPressed: () {}, child: const Text("Tout lire", style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600))),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (today.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
                    child: Text("AUJOURD'HUI", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1)),
                  ),
                  ...today.map((n) => _NotifTile(n: n, iconData: _icon(n.type), color: _color(n.type))),
                ],
                if (week.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
                    child: Text("CETTE SEMAINE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1)),
                  ),
                  ...week.map((n) => _NotifTile(n: n, iconData: _icon(n.type), color: _color(n.type))),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final dynamic n;
  final IconData iconData;
  final Color color;

  const _NotifTile({required this.n, required this.iconData, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: n.read ? Colors.transparent : const Color(0xFFFFF8F4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(iconData, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(n.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark))),
                      if (!n.read) Container(width: 8, height: 8, margin: const EdgeInsets.only(left: 4, top: 4), decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(n.body, style: const TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4)),
                  const SizedBox(height: 4),
                  Text(n.time, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
