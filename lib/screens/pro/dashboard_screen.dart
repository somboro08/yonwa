import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';

class ProfessionalDashboardScreen extends StatelessWidget {
  const ProfessionalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Professionnel')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(YonwaSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vos statistiques', style: YonwaTextStyles.h2),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard('Vues', '124'),
                const SizedBox(width: 16),
                _buildStatCard('Réservations', '12'),
              ],
            ),
            const SizedBox(height: 24),
            Text('Réservations récentes', style: YonwaTextStyles.h2),
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
          color: YonwaColors.neutral100,
          borderRadius: BorderRadius.circular(YonwaRadius.md),
        ),
        child: Column(
          children: [
            Text(value, style: YonwaTextStyles.h1.copyWith(color: YonwaColors.primary500)),
            Text(label, style: YonwaTextStyles.label),
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
        decoration: BoxDecoration(color: YonwaColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(YonwaRadius.sm)),
        child: Text('Confirmé', style: YonwaTextStyles.caption.copyWith(color: YonwaColors.success)),
      ),
    );
  }
}



