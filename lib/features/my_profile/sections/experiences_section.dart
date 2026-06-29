import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../shared/providers/user_provider.dart';

/// Onglet "Expériences" — visites/prestations touristiques proposées.
/// Alimenté par UserProvider.experiences (guide & voyageur).
class ExperiencesSection extends ConsumerWidget {
  const ExperiencesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiences = ref.watch(userProviderRef).experiences;

    if (experiences.isEmpty) {
      return const _Empty(message: 'Aucune expérience à afficher.');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final e = experiences[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEEEEF2)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                e['image'] ?? '',
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: const Color(0xFFF2F2F4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e['title'] ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D0D0D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedStar,
                          color: Color(0xFFC9A84C),
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            e['rating'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF6B6B7A),
                            ),
                          ),
                        ),
                        Text(
                          e['price'] ?? '',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                      ],
                    ),
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

class _Empty extends StatelessWidget {
  final String message;
  const _Empty({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedRoute01,
              color: Color(0xFFB0B0BE),
              size: 44,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B6B7A)),
            ),
          ],
        ),
      ),
    );
  }
}
