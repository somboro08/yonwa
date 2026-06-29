# YONWA — Application Flutter

Application mobile de tourisme culturel au Bénin.

## Lancer le projet

```bash
flutter pub get
flutter run
```

## Structure du projet

```
lib/
├── main.dart                  # Point d'entrée + navigateur d'écrans
├── theme/
│   └── app_theme.dart         # Couleurs, typographie, thème global
├── models/
│   └── models.dart            # Classes de données (Artisan, Guide, etc.)
├── data/
│   └── mock_data.dart         # Données de démonstration
├── widgets/
│   └── shared_widgets.dart    # Composants réutilisables
└── screens/
    ├── splash_screen.dart
    ├── onboarding_screen.dart
    ├── login_screen.dart
    ├── home_screen.dart
    ├── search_screen.dart
    ├── categories_screen.dart
    ├── map_screen.dart
    ├── artisans_list_screen.dart
    ├── artisan_profile_screen.dart
    ├── guide_profile_screen.dart
    ├── experience_profile_screen.dart
    ├── booking_screen.dart
    ├── payment_screen.dart
    ├── confirmation_screen.dart
    ├── messaging_screen.dart
    ├── chat_screen.dart
    ├── notifications_screen.dart
    ├── favorites_screen.dart
    ├── history_screen.dart
    ├── reviews_screen.dart
    ├── user_profile_screen.dart
    └── settings_screen.dart
```

## Palette de couleurs

| Rôle | Couleur |
|------|---------|
| Primary | `#C4622D` (orange brûlé) |
| Secondary | `#D4A853` (or) |
| Background | `#FAF6F0` (crème) |
| Texte foncé | `#2C1A0E` (brun) |
| Texte muted | `#8B6E55` |

## Dépendances principales

- `cached_network_image` — chargement d'images réseau avec cache
- `google_fonts` — polices DM Sans & Playfair Display
- `smooth_page_indicator` — indicateur de pages (onboarding)
- `provider` — gestion d'état (prêt à utiliser)
