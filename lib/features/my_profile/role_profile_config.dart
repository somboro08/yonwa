// ─────────────────────────────────────────────────────────────────────────
//  CONFIGURATION ADAPTATIVE DU PROFIL PAR RÔLE
//  Pattern strategy : un seul écran, des configurations.
//  Évite les switch-case éparpillés dans la UI.
// ─────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../models/models.dart';

/// Un KPI affiché dans le header du profil.
class ProfileKpi {
  final String label;
  final String statsKey; // clé dans UserProvider.stats
  final List<List<dynamic>> icon;

  const ProfileKpi({
    required this.label,
    required this.statsKey,
    required this.icon,
  });
}

/// Type d'action rapide possible dans le profil.
enum QuickActionType {
  addProduct,
  publish,
  addCreation,
  addWorkshop,
  manageStock,
  addExperience,
  manageAvailability,
  explore,
  book,
}

/// Une action rapide proposée selon le rôle.
class ProfileQuickAction {
  final String label;
  final List<List<dynamic>> icon;
  final QuickActionType type;

  const ProfileQuickAction({
    required this.label,
    required this.icon,
    required this.type,
  });
}

/// Identifiant d'un onglet de profil (les libellés localisés viennent de la config).
enum ProfileTab {
  products,
  catalog,
  services,
  experiences,
  appointments,
  adventureHistory,
  publications,
  reviews,
  about,
}

class RoleProfileConfig {
  final UserRole role;
  final List<ProfileTab> tabs;
  final List<ProfileKpi> kpis;
  final List<ProfileQuickAction> quickActions;

  const RoleProfileConfig({
    required this.role,
    required this.tabs,
    required this.kpis,
    required this.quickActions,
  });

  /// Libellé localisé d'un onglet.
  static String tabLabel(ProfileTab tab) {
    switch (tab) {
      case ProfileTab.products:
        return 'Produits';
      case ProfileTab.catalog:
        return 'Catalogue';
      case ProfileTab.services:
        return 'Services';
      case ProfileTab.experiences:
        return 'Expériences';
      case ProfileTab.appointments:
        return 'Rendez-vous';
      case ProfileTab.adventureHistory:
        return 'Historique';
      case ProfileTab.publications:
        return 'Publications';
      case ProfileTab.reviews:
        return 'Avis';
      case ProfileTab.about:
        return 'À propos';
    }
  }

  /// Récupère la configuration pour un rôle donné.
  static RoleProfileConfig forRole(UserRole role) {
    switch (role) {
      case UserRole.voyageur:
        return const RoleProfileConfig(
          role: UserRole.voyageur,
          tabs: [
            ProfileTab.experiences,
            ProfileTab.publications,
            ProfileTab.reviews,
            ProfileTab.about,
          ],
          kpis: [
            ProfileKpi(
              label: 'Abonnés',
              statsKey: 'abonnés',
              icon: HugeIcons.strokeRoundedUserGroup,
            ),
            ProfileKpi(
              label: 'Favoris',
              statsKey: 'favoris',
              icon: HugeIcons.strokeRoundedFavourite,
            ),
          ],
          quickActions: [
            ProfileQuickAction(
              label: 'Explorer',
              icon: HugeIcons.strokeRoundedCompass,
              type: QuickActionType.explore,
            ),
            ProfileQuickAction(
              label: 'Réserver',
              icon: HugeIcons.strokeRoundedCalendar03,
              type: QuickActionType.book,
            ),
          ],
        );

      case UserRole.artisan:
        return const RoleProfileConfig(
          role: UserRole.artisan,
          tabs: [
            ProfileTab.products,
            ProfileTab.catalog,
            ProfileTab.publications,
            ProfileTab.reviews,
            ProfileTab.about,
          ],
          kpis: [
            ProfileKpi(
              label: 'Abonnés',
              statsKey: 'abonnés',
              icon: HugeIcons.strokeRoundedUserGroup,
            ),
            ProfileKpi(
              label: 'Ventes',
              statsKey: 'ventes',
              icon: HugeIcons.strokeRoundedCoins01,
            ),
            ProfileKpi(
              label: 'Articles',
              statsKey: 'articlesVendus',
              icon: HugeIcons.strokeRoundedPackage,
            ),
          ],
          quickActions: [
            ProfileQuickAction(
              label: 'Ajouter produit',
              icon: HugeIcons.strokeRoundedAdd01,
              type: QuickActionType.addProduct,
            ),
            ProfileQuickAction(
              label: 'Publier',
              icon: HugeIcons.strokeRoundedSent,
              type: QuickActionType.publish,
            ),
          ],
        );

      case UserRole.artisanConcepteur:
        return const RoleProfileConfig(
          role: UserRole.artisanConcepteur,
          tabs: [
            ProfileTab.catalog,
            ProfileTab.products,
            ProfileTab.services,
            ProfileTab.publications,
            ProfileTab.reviews,
            ProfileTab.about,
          ],
          kpis: [
            ProfileKpi(
              label: 'Abonnés',
              statsKey: 'abonnés',
              icon: HugeIcons.strokeRoundedUserGroup,
            ),
            ProfileKpi(
              label: 'Ventes',
              statsKey: 'ventes',
              icon: HugeIcons.strokeRoundedCoins01,
            ),
            ProfileKpi(
              label: 'Services',
              statsKey: 'servicesRéalisés',
              icon: HugeIcons.strokeRoundedTouchInteraction01,
            ),
          ],
          quickActions: [
            ProfileQuickAction(
              label: 'Nouvelle création',
              icon: HugeIcons.strokeRoundedAdd01,
              type: QuickActionType.addCreation,
            ),
            ProfileQuickAction(
              label: 'Créer atelier',
              icon: HugeIcons.strokeRoundedTouchInteraction01,
              type: QuickActionType.addWorkshop,
            ),
          ],
        );

      case UserRole.artisanRevendeur:
        return const RoleProfileConfig(
          role: UserRole.artisanRevendeur,
          tabs: [
            ProfileTab.products,
            ProfileTab.catalog,
            ProfileTab.reviews,
            ProfileTab.about,
          ],
          kpis: [
            ProfileKpi(
              label: 'Abonnés',
              statsKey: 'abonnés',
              icon: HugeIcons.strokeRoundedUserGroup,
            ),
            ProfileKpi(
              label: 'Ventes',
              statsKey: 'ventes',
              icon: HugeIcons.strokeRoundedCoins01,
            ),
            ProfileKpi(
              label: 'Articles',
              statsKey: 'articlesVendus',
              icon: HugeIcons.strokeRoundedPackage,
            ),
          ],
          quickActions: [
            ProfileQuickAction(
              label: 'Ajouter produit',
              icon: HugeIcons.strokeRoundedAdd01,
              type: QuickActionType.addProduct,
            ),
            ProfileQuickAction(
              label: 'Stock',
              icon: HugeIcons.strokeRoundedPackageDelivered,
              type: QuickActionType.manageStock,
            ),
          ],
        );

      case UserRole.guideTouristique:
        return const RoleProfileConfig(
          role: UserRole.guideTouristique,
          tabs: [
            ProfileTab.experiences,
            ProfileTab.services,
            ProfileTab.appointments,
            ProfileTab.adventureHistory,
            ProfileTab.publications,
            ProfileTab.reviews,
            ProfileTab.about,
          ],
          kpis: [
            ProfileKpi(
              label: 'Abonnés',
              statsKey: 'abonnés',
              icon: HugeIcons.strokeRoundedUserGroup,
            ),
            ProfileKpi(
              label: 'Services',
              statsKey: 'servicesRéalisés',
              icon: HugeIcons.strokeRoundedTouchInteraction01,
            ),
          ],
          quickActions: [
            ProfileQuickAction(
              label: 'Nouvelle expérience',
              icon: HugeIcons.strokeRoundedAdd01,
              type: QuickActionType.addExperience,
            ),
            ProfileQuickAction(
              label: 'Disponibilités',
              icon: HugeIcons.strokeRoundedCalendar03,
              type: QuickActionType.manageAvailability,
            ),
          ],
        );

      case UserRole.revendeur:
        return const RoleProfileConfig(
          role: UserRole.revendeur,
          tabs: [
            ProfileTab.products,
            ProfileTab.catalog,
            ProfileTab.reviews,
            ProfileTab.about,
          ],
          kpis: [
            ProfileKpi(
              label: 'Abonnés',
              statsKey: 'abonnés',
              icon: HugeIcons.strokeRoundedUserGroup,
            ),
            ProfileKpi(
              label: 'Ventes',
              statsKey: 'ventes',
              icon: HugeIcons.strokeRoundedCoins01,
            ),
            ProfileKpi(
              label: 'Articles',
              statsKey: 'articlesVendus',
              icon: HugeIcons.strokeRoundedPackage,
            ),
          ],
          quickActions: [
            ProfileQuickAction(
              label: 'Ajouter article',
              icon: HugeIcons.strokeRoundedAdd01,
              type: QuickActionType.addProduct,
            ),
            ProfileQuickAction(
              label: 'Stock',
              icon: HugeIcons.strokeRoundedPackageDelivered,
              type: QuickActionType.manageStock,
            ),
          ],
        );
    }
  }

  /// Couleur d'accent associée à un rôle (pour badges).
  static Color roleColor(UserRole role) {
    switch (role) {
      case UserRole.voyageur:
        return const Color(0xFF2B6CB0); // bleu voyage
      case UserRole.artisan:
      case UserRole.artisanConcepteur:
        return const Color(0xFFC05621); // terre cuite
      case UserRole.artisanRevendeur:
      case UserRole.revendeur:
        return const Color(0xFF2F855A); // vert commerce
      case UserRole.guideTouristique:
        return const Color(0xFF6B46C1); // violet aventure
    }
  }

  /// Courte phrase de positionnement affichée sous le nom.
  static String roleTagline(UserRole role) {
    switch (role) {
      case UserRole.voyageur:
        return 'Voyageur & découvreur de culture';
      case UserRole.artisan:
        return 'Artisan & créateur de savoir-faire';
      case UserRole.artisanConcepteur:
        return 'Designer-artisan · pièces d\'exception';
      case UserRole.artisanRevendeur:
        return 'Coopérative d\'artisanat solidaire';
      case UserRole.guideTouristique:
        return 'Guide touristique certifié';
      case UserRole.revendeur:
        return 'Boutique de souvenirs & terroir';
    }
  }
}
