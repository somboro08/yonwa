import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../theme/yonwa_theme.dart';

/// Onglet "Historique d'aventures" — pour les guides touristiques.
/// Affiche les anciennes visites avec détails, photos et récits.
class AdventureHistorySection extends ConsumerWidget {
  const AdventureHistorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adventures = ref.watch(userProviderRef).adventureHistory;

    if (adventures.isEmpty) {
      return const _EmptyState(
        icon: HugeIcons.strokeRoundedRoute01,
        message: 'Aucune aventure réalisée pour le moment.',
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: adventures.length,
      itemBuilder: (context, index) {
        final adv = adventures[index];
        final rating = adv['rating'] ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: YonwaColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: YonwaColors.neutral200),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image principale
              if (adv['image'] != null)
                Image.network(
                  adv['image']!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: YonwaColors.neutral200,
                    child: const Center(
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedImage01,
                        color: YonwaColors.neutral400,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre et date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            adv['title'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: YonwaColors.neutral900,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: YonwaColors.primary50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            adv['date'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: YonwaColors.primary500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Lieu et participants
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedLocation01,
                          color: YonwaColors.neutral500,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            adv['location'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: YonwaColors.neutral600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedUserGroup,
                          color: YonwaColors.neutral500,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          adv['participants'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: YonwaColors.neutral600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Récit
                    if (adv['narrative'] != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: YonwaColors.neutral50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: YonwaColors.neutral200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const HugeIcon(
                                  icon: HugeIcons.strokeRoundedBookmark01,
                                  color: YonwaColors.secondary,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Récit de l\'aventure',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: YonwaColors.neutral700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              adv['narrative']!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: YonwaColors.neutral700,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Galerie de photos (si disponible)
                    if (adv['gallery'] != null && (adv['gallery'] as List).isNotEmpty) ...[
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: (adv['gallery'] as List).length,
                          itemBuilder: (context, i) {
                            final photo = (adv['gallery'] as List)[i];
                            return Container(
                              margin: EdgeInsets.only(right: i < (adv['gallery'] as List).length - 1 ? 8 : 0),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: YonwaColors.neutral200),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  photo,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: YonwaColors.neutral200,
                                    child: const Icon(
                                      Icons.image,
                                      color: YonwaColors.neutral400,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Note et avis clients
                    if (rating > 0) ...[
                      Row(
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedStar,
                            color: Color(0xFFC9A84C),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$rating / 5',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: YonwaColors.neutral800,
                            ),
                          ),
                          if (adv['clientFeedback'] != null) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '"${adv['clientFeedback']}"',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: YonwaColors.neutral600,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: icon,
              color: YonwaColors.neutral400,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: YonwaColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}