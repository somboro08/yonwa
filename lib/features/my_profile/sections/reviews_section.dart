import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../shared/providers/user_provider.dart';

/// Onglet "Avis" — retours clients reçus par l'utilisateur.
/// Alimenté par UserProvider.reviews (commun à tous les rôles).
class ReviewsSection extends ConsumerWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(userProviderRef).reviews;

    if (reviews.isEmpty) {
      return const _Empty(message: 'Aucun avis pour le moment.');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final r = reviews[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEEEF2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(r['avatar'] ?? ''),
                    backgroundColor: const Color(0xFFF2F2F4),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      r['user'] ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D0D0D),
                      ),
                    ),
                  ),
                  ...List.generate(
                    5,
                    (i) => HugeIcon(
                      icon: HugeIcons.strokeRoundedStar,
                      color: i < (r['rating'] as int? ?? 0)
                          ? const Color(0xFFC9A84C)
                          : const Color(0xFFEEEEF2),
                      size: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                r['comment'] ?? '',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF0D0D0D),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                r['date'] ?? '',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFFB0B0BE),
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
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B6B7A)),
        ),
      ),
    );
  }
}
