import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class HistoryScreen extends StatelessWidget {
  final Function(String) navigate;
  const HistoryScreen({super.key, required this.navigate});

  Color _statusColor(String s) {
    switch (s) {
      case 'upcoming': return AppColors.green;
      case 'completed': return AppColors.textMuted;
      case 'cancelled': return AppColors.primary;
      default: return AppColors.textMuted;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'upcoming': return 'À venir';
      case 'completed': return 'Terminé';
      case 'cancelled': return 'Annulé';
      default: return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 14),
            decoration: const BoxDecoration(color: AppColors.card, border: Border(bottom: BorderSide(color: AppColors.border))),
            child: const Text('Mes réservations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark)),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
              itemCount: MockData.history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (_, i) {
                final h = MockData.history[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.06), blurRadius: 10)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: SizedBox(width: 80, height: 80, child: NetworkImg(url: h.image)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text(h.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.3))),
                                    AppBadge(label: _statusLabel(h.status), color: _statusColor(h.status)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(h.date, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                Text('Guide: ${h.guide}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                const SizedBox(height: 4),
                                Text('${(h.price / 1000).toStringAsFixed(0)} 000 FCFA', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (h.status == 'completed') ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => navigate('reviews'),
                            icon: const Icon(Icons.star_outline, size: 15),
                            label: const Text('Laisser un avis'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.secondary,
                              side: const BorderSide(color: AppColors.secondary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                      if (h.status == 'upcoming') ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(foregroundColor: AppColors.textMuted, side: const BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 10)),
                                child: const Text('Modifier'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => navigate('chat'),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 10)),
                                child: const Text('Contacter'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
