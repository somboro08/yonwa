import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class GuideProfileScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) navigate;
  const GuideProfileScreen({super.key, required this.onBack, required this.navigate});

  @override
  State<GuideProfileScreen> createState() => _GuideProfileScreenState();
}

class _GuideProfileScreenState extends State<GuideProfileScreen> {
  bool _saved = false;
  final guide = MockData.guides[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Hero
                Stack(
                  children: [
                    SizedBox(height: 260, width: double.infinity, child: NetworkImg(url: guide.image)),
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.textDark.withOpacity(0.1), AppColors.textDark.withOpacity(0.5)],
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 16,
                      child: GestureDetector(
                        onTap: widget.onBack,
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                          child: const Icon(Icons.chevron_left, color: AppColors.textDark),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => setState(() => _saved = !_saved),
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                          child: Icon(_saved ? Icons.favorite : Icons.favorite_border,
                            color: _saved ? AppColors.primary : AppColors.textDark, size: 18),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16, left: 20, right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (guide.certified) const AppBadge(label: 'Guide Certifié', color: AppColors.secondary),
                          const SizedBox(height: 8),
                          Text(guide.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                          Text(guide.specialty, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats
                      Row(
                        children: [
                          Expanded(child: _InfoChip(icon: Icons.star_rounded, color: AppColors.secondary, label: '${guide.rating} (${guide.reviews})')),
                          const SizedBox(width: 10),
                          Expanded(child: _InfoChip(icon: Icons.location_on_outlined, color: AppColors.primary, label: guide.location)),
                          const SizedBox(width: 10),
                          Expanded(child: _InfoChip(icon: Icons.monetization_on_outlined, color: AppColors.green, label: '${(guide.price / 1000).toStringAsFixed(0)}k FCFA')),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Languages
                      const Text('Langues', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, children: guide.languages.map((l) => AppBadge(label: l, color: AppColors.blue)).toList()),
                      const SizedBox(height: 20),

                      // Bio
                      const Text('À propos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      Text(guide.bio, style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.6)),
                      const SizedBox(height: 20),

                      // Tours
                      const Text('Circuits proposés', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      ...guide.tours.map((t) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.05), blurRadius: 8)],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.explore_outlined, color: AppColors.primary, size: 18),
                            const SizedBox(width: 12),
                            Expanded(child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark))),
                            const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
                          ],
                        ),
                      )),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // CTA
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              color: AppColors.card,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => widget.navigate('chat'),
                      icon: const Icon(Icons.chat_bubble_outline, size: 16),
                      label: const Text('Message'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textDark,
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => widget.navigate('booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const StadiumBorder(),
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      child: const Text('Réserver ce guide'),
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _InfoChip({required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 5),
          Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.textDark, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
