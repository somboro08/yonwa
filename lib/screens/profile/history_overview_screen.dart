import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';
import 'history_detail_screen.dart';

class HistoryOverviewScreen extends StatelessWidget {
  const HistoryOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final adventures = [
      {
        'title': 'Aventure à Ganvié au coucher du soleil',
        'location': 'Ganvié',
        'coverImage':
            'assets/images/hero1.jpg',
        'summary': 'Une sortie en pirogue et la visite des ateliers lacustres.',
      },
      {
        'title': 'Route des Esclaves et mémoire d’Ouidah',
        'location': 'Ouidah',
        'coverImage':
            'assets/images/hero4.jpg',
        'summary':
            'Un parcours culturel et historique avec d’anciens voyageurs.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des aventures'),
        backgroundColor: YonwaColors.primary500,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: adventures.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final adventure = adventures[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HistoryDetailScreen(adventure: adventure),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? YonwaColors.neutral800 : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark
                      ? YonwaColors.neutral700
                      : YonwaColors.neutral200,
                  width: 0.8,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    adventure['coverImage']!,
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
                          adventure['title']!,
                          style: YonwaTextStyles.label.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          adventure['summary']!,
                          style: YonwaTextStyles.caption,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          adventure['location']!,
                          style: YonwaTextStyles.caption.copyWith(
                            color: YonwaColors.primary500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
