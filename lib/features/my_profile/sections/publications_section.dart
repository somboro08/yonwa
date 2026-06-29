import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../shared/providers/user_provider.dart';

/// Onglet "Publications" — fil d'actualité social de l'utilisateur.
/// Alimenté par UserProvider.publications (commun à tous les rôles).
class PublicationsSection extends ConsumerWidget {
  const PublicationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publications = ref.watch(userProviderRef).publications;

    if (publications.isEmpty) {
      return const _Empty(message: 'Aucune publication.');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: publications.length,
      itemBuilder: (context, index) {
        final p = publications[index];
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
                p['image'] ?? '',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: const Color(0xFFF2F2F4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['title'] ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0D0D0D),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          p['time'] ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF6B6B7A),
                          ),
                        ),
                        const Spacer(),
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedFavourite,
                          color: Color(0xFFE53E3E),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${p['likes']}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF6B6B7A),
                            fontWeight: FontWeight.w600,
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
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF6B6B7A)),
        ),
      ),
    );
  }
}
