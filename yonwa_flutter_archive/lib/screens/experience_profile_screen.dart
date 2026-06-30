import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class ExperienceProfileScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) navigate;
  const ExperienceProfileScreen({super.key, required this.onBack, required this.navigate});

  @override
  State<ExperienceProfileScreen> createState() => _ExperienceProfileScreenState();
}

class _ExperienceProfileScreenState extends State<ExperienceProfileScreen> {
  bool _saved = false;
  final exp = MockData.experiences[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(height: 280, width: double.infinity, child: NetworkImg(url: exp.image)),
                    Container(height: 280, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, AppColors.textDark.withOpacity(0.6)]))),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 16,
                      child: GestureDetector(
                        onTap: widget.onBack,
                        child: Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle), child: const Icon(Icons.chevron_left, color: AppColors.textDark)),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => setState(() => _saved = !_saved),
                        child: Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                          child: Icon(_saved ? Icons.favorite : Icons.favorite_border, color: _saved ? AppColors.primary : AppColors.textDark, size: 18)),
                      ),
                    ),
                    if (exp.badge != null)
                      Positioned(top: 16, left: 16, child: AppBadge(label: exp.badge!, color: AppColors.secondary)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBadge(label: exp.category, color: AppColors.primary),
                      const SizedBox(height: 8),
                      Text(exp.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark, height: 1.2)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          StarRating(value: exp.rating, count: exp.reviews),
                          const Spacer(),
                          const Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(exp.duration, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          const SizedBox(width: 12),
                          const Icon(Icons.people_outline, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(exp.groupSize, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.person_outline, color: AppColors.textMuted, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Guide', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                              Text(exp.guide, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                      const SizedBox(height: 8),
                      Text(exp.description, style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.6)),
                      const SizedBox(height: 20),
                      _IncludeSection(title: 'Inclus', items: exp.includes, isIncluded: true),
                      const SizedBox(height: 12),
                      _IncludeSection(title: 'Non inclus', items: exp.excludes, isIncluded: false),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
              color: AppColors.card,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Par personne', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                      Text('${(exp.price / 1000).toStringAsFixed(0)} 000 FCFA', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => widget.navigate('booking'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: const StadiumBorder(), textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      child: const Text('Réserver'),
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

class _IncludeSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool isIncluded;

  const _IncludeSection({required this.title, required this.items, required this.isIncluded});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Icon(isIncluded ? Icons.check_circle : Icons.cancel_outlined, size: 15, color: isIncluded ? AppColors.green : AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(item, style: const TextStyle(fontSize: 12, color: AppColors.textDark))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
