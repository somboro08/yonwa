import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';
import '../../models/models.dart';
import '../../widgets/listing_card.dart';

class AllListingsScreen extends StatelessWidget {
  final String title;
  final List<Listing> listings;

  const AllListingsScreen({
    super.key, 
    required this.title, 
    required this.listings,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      appBar: AppBar(
        title: Text(title, style: YonwaTextStyles.h3),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: listings.isEmpty
          ? _buildEmptyState(isDark)
          : ListView.separated(
              padding: const EdgeInsets.all(YonwaSpacing.md),
              itemCount: listings.length,
              separatorBuilder: (context, index) => const SizedBox(height: YonwaSpacing.md),
              itemBuilder: (context, index) {
                return ListingCard(listing: listings[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
          ),
          const SizedBox(height: YonwaSpacing.lg),
          Text(
            'Aucun logement trouvé',
            style: YonwaTextStyles.h2.copyWith(
              color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral700,
            ),
          ),
          const SizedBox(height: YonwaSpacing.sm),
          Text(
            'Réessayez avec d\'autres critères ou une autre ville.',
            style: YonwaTextStyles.body.copyWith(
              color: YonwaColors.neutral500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


