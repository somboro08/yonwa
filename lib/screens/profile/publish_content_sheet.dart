import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/yonwa_theme.dart';
import 'history_overview_screen.dart';
import 'publish_experience_screen.dart';
import 'publish_product_screen.dart';
import 'publish_publication_screen.dart';
import 'publish_service_screen.dart';
import 'write_adventure_screen.dart';

class PublishContentSheet extends StatelessWidget {
  final UserRole? role;

  const PublishContentSheet({super.key, this.role});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canSell = role == null ||
        role == UserRole.artisan ||
        role == UserRole.artisanConcepteur ||
        role == UserRole.artisanRevendeur ||
        role == UserRole.revendeur;
    final canGuide = role == null || role == UserRole.guideTouristique;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Publier un contenu',
              style: YonwaTextStyles.h3.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : YonwaColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            if (canSell) ...[
              _buildOption(
                context,
                icon: Icons.shopping_bag_rounded,
                label: 'Produit',
                description: 'Ajouter un article a vendre dans votre profil.',
                page: const PublishProductScreen(),
              ),
              _buildOption(
                context,
                icon: Icons.collections_bookmark_rounded,
                label: 'Catalogue',
                description: 'Organiser vos produits ou offres par collection.',
                page: const PublishCatalogScreen(),
              ),
            ],
            _buildOption(
              context,
              icon: Icons.room_service_rounded,
              label: 'Service',
              description: 'Ajouter une prestation a reserver.',
              page: const PublishServiceScreen(),
            ),
            if (canGuide)
              _buildOption(
                context,
                icon: Icons.travel_explore_rounded,
                label: 'Experience',
                description: 'Publier une visite ou une aventure touristique.',
                page: const PublishExperienceScreen(),
              ),
            _buildOption(
              context,
              icon: Icons.newspaper_rounded,
              label: 'Publication',
              description: 'Partager une actualite, un produit ou une annonce.',
              page: const PublishPublicationScreen(),
            ),
            if (canGuide) ...[
              _buildOption(
                context,
                icon: Icons.history_rounded,
                label: 'Historique',
                description: 'Voir les aventures deja racontees.',
                page: const HistoryOverviewScreen(),
              ),
              _buildOption(
                context,
                icon: Icons.edit_note_rounded,
                label: 'Ecrire une aventure',
                description: 'Raconter une aventure avec images, videos et touristes.',
                page: const WriteAdventureScreen(),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200,
                  foregroundColor: isDark ? Colors.white70 : YonwaColors.neutral800,
                ),
                child: const Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String description,
    required Widget page,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: YonwaColors.neutral200, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: YonwaColors.primary500.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: YonwaColors.primary500),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: YonwaTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: YonwaTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: YonwaColors.neutral400),
          ],
        ),
      ),
    );
  }
}
