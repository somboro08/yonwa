import 'package:flutter/material.dart';
import '../../theme/tourism_theme.dart';

class ProfessionalDashboardScreen extends StatelessWidget {
  const ProfessionalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Professionnel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TourismSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vos statistiques', style: TourismTextStyles.h2),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard('Vues', '124'),
                const SizedBox(width: 16),
                _buildStatCard('Réservations', '12'),
              ],
            ),
            const SizedBox(height: 24),
            Text('Réservations récentes', style: TourismTextStyles.h2),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, i) => _buildBookingItem(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TourismColors.neutral100,
          borderRadius: BorderRadius.circular(TourismRadius.md),
        ),
        child: Column(
          children: [
            Text(value, style: TourismTextStyles.h1.copyWith(color: TourismColors.primary500)),
            Text(label, style: TourismTextStyles.label),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingItem() {
    return ListTile(
      title: const Text('Séjour de Jean K.'),
      subtitle: const Text('15 - 17 Juin'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: TourismColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(TourismRadius.sm)),
        child: Text('Confirmé', style: TourismTextStyles.caption.copyWith(color: TourismColors.success)),
      ),
    );
  }
}


