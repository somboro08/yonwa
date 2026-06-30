import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../theme/yonwa_theme.dart';

/// Onglet "Rendez-vous" — pour les guides touristiques.
/// Affiche les demandes de réservation avec confirmation/rejet.
class AppointmentsSection extends ConsumerWidget {
  const AppointmentsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(userProviderRef).appointments;

    if (appointments.isEmpty) {
      return const _EmptyState(
        icon: HugeIcons.strokeRoundedCalendar01,
        message: 'Aucun rendez-vous programmé pour le moment.',
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final apt = appointments[index];
        final status = apt['status'] ?? 'pending';
        final isPending = status == 'pending';
        final isConfirmed = status == 'confirmed';

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: YonwaColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: YonwaColors.neutral200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        apt['clientName'] ?? 'Client',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: YonwaColors.neutral900,
                        ),
                      ),
                    ),
                    _StatusBadge(status: status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedCalendar03,
                      color: YonwaColors.neutral500,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      apt['date'] ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: YonwaColors.neutral700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedClock01,
                      color: YonwaColors.neutral500,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      apt['time'] ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: YonwaColors.neutral700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedLocation01,
                      color: YonwaColors.neutral500,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        apt['location'] ?? '',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: YonwaColors.neutral600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (apt['experience'] != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: YonwaColors.primary50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      apt['experience']!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: YonwaColors.primary500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                if (isPending) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _rejectAppointment(context, ref, index),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: YonwaColors.error,
                            side: const BorderSide(color: YonwaColors.error),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Refuser'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _confirmAppointment(context, ref, index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: YonwaColors.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Confirmer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmAppointment(BuildContext context, WidgetRef ref, int index) {
    // TODO: Implement confirmation logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Rendez-vous confirmé'),
        backgroundColor: YonwaColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YonwaRadius.md),
        ),
      ),
    );
  }

  void _rejectAppointment(BuildContext context, WidgetRef ref, int index) {
    // TODO: Implement rejection logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Rendez-vous refusé'),
        backgroundColor: YonwaColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(YonwaRadius.md),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'confirmed':
        color = YonwaColors.success;
        label = 'Confirmé';
        break;
      case 'cancelled':
        color = YonwaColors.error;
        label = 'Annulé';
        break;
      case 'completed':
        color = YonwaColors.primary500;
        label = 'Terminé';
        break;
      default:
        color = YonwaColors.warning;
        label = 'En attente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
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