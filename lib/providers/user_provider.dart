import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class UserProvider extends ChangeNotifier {
  static const String _roleKey = 'yonwa_user_role';
  static const String _interestKey = 'yonwa_user_interest';
  static const String _regionsKey = 'yonwa_user_regions';
  static const String _detailsKey = 'yonwa_user_details';

  // Profil principal simulé
  String _nom = 'Gbènan';
  String _prenom = 'Marc';
  String _email = 'marc.gbenan@email.com';
  String _telephone = '+229 97 12 34 56';
  UserRole _role = UserRole.voyageur;
  String _photoUrl = 'https://i.pravatar.cc/300?u=marc';
  String _coverImage = 'assets/images/hero3.png';
  List<String> _coverImages = ['assets/images/hero3.png'];
  String? _customBio;
  String _interest = '';
  List<String> _regions = [];
  List<String> _profileDetails = [];

  UserProvider() {
    _loadUserRole();
  }

  // Getters
  String get nom => _nom;
  String get prenom => _prenom;
  String get fullName => '$_prenom $_nom';
  String get email => _email;
  String get telephone => _telephone;
  UserRole get role => _role;
  String get photoUrl => _photoUrl;
  String get coverImage => _coverImage;
  List<String> get coverImages => List.unmodifiable(_coverImages);
  String get interest => _interest;
  List<String> get regions => List.unmodifiable(_regions);
  List<String> get profileDetails => List.unmodifiable(_profileDetails);

  // Charger le rôle persisté
  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRole = prefs.getString(_roleKey);
    if (savedRole != null) {
      _role = UserRole.values.firstWhere(
        (e) => e.name == savedRole,
        orElse: () => UserRole.voyageur,
      );
      notifyListeners();
    }
    _interest = prefs.getString(_interestKey) ?? '';
    _regions = prefs.getStringList(_regionsKey) ?? [];
    _profileDetails = prefs.getStringList(_detailsKey) ?? [];
  }

  // Modifier le rôle de l'utilisateur
  Future<void> updateRole(UserRole newRole) async {
    _role = newRole;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, newRole.name);
    notifyListeners();
  }

  Future<void> completeOnboardingProfile({
    required UserRole role,
    required String interest,
    required List<String> regions,
    required List<String> details,
  }) async {
    _role = role;
    _interest = interest;
    _regions = List<String>.from(regions);
    _profileDetails = List<String>.from(details);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role.name);
    await prefs.setString(_interestKey, interest);
    await prefs.setStringList(_regionsKey, _regions);
    await prefs.setStringList(_detailsKey, _profileDetails);
    notifyListeners();
  }

  // Mettre à jour les informations du profil
  void updateProfile({required String nom, required String prenom, required String telephone}) {
    _nom = nom;
    _prenom = prenom;
    _telephone = telephone;
    notifyListeners();
  }

  Future<void> updateEditableProfile({
    required String nom,
    required String prenom,
    required String email,
    required String telephone,
    required UserRole role,
    required String bio,
    required List<String> coverImages,
  }) async {
    _nom = nom;
    _prenom = prenom;
    _email = email;
    _telephone = telephone;
    _role = role;
    _customBio = bio;
    _coverImages = coverImages.where((url) => url.trim().isNotEmpty).toList();
    if (_coverImages.isNotEmpty) {
      _coverImage = _coverImages.first;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role.name);
    notifyListeners();
  }

  // Obtenir les statistiques dynamiques selon le rôle actif
  Map<String, int> get stats {
    switch (_role) {
      case UserRole.voyageur:
        return {
          'abonnés': 142,
          'ventes': 0,
          'articlesVendus': 0,
          'servicesRéalisés': 0,
        };
      case UserRole.artisan:
        return {
          'abonnés': 248,
          'ventes': 32,
          'articlesVendus': 48,
          'servicesRéalisés': 0,
        };
      case UserRole.artisanConcepteur:
        return {
          'abonnés': 350,
          'ventes': 14,
          'articlesVendus': 18,
          'servicesRéalisés': 8,
        };
      case UserRole.artisanRevendeur:
        return {
          'abonnés': 120,
          'ventes': 78,
          'articlesVendus': 120,
          'servicesRéalisés': 0,
        };
      case UserRole.guideTouristique:
        return {
          'abonnés': 580,
          'ventes': 0,
          'articlesVendus': 0,
          'servicesRéalisés': 42,
        };
      case UserRole.revendeur:
        return {
          'abonnés': 95,
          'ventes': 150,
          'articlesVendus': 210,
          'servicesRéalisés': 0,
        };
    }
  }

  // Obtenir la description dynamique selon le rôle actif
  String get bio {
    if (_customBio != null && _customBio!.trim().isNotEmpty) {
      return _customBio!;
    }
    switch (_role) {
      case UserRole.voyageur:
        return 'Voyageur passionné de découvertes culturelles et d\'artisanat traditionnel. Toujours ravi de parcourir le Bénin !';
      case UserRole.artisan:
        return 'Artisan potier de père en fils basé à Abomey. Je façonne l\'argile béninoise pour créer des objets uniques, décoratifs et utilitaires.';
      case UserRole.artisanConcepteur:
        return 'Designer-artisan installé à Cotonou. Je fusionne le patrimoine traditionnel béninois avec le design contemporain pour des pièces d\'exception.';
      case UserRole.artisanRevendeur:
        return 'Boutique d\'artisanat solidaire. Nous collaborons directement avec 15 artisanes de Bohicon pour revendre leurs tissages d\'indigo authentiques.';
      case UserRole.guideTouristique:
        return 'Guide certifié par le ministère du Tourisme. 10 ans d\'expérience dans le Sud et le Centre du Bénin. Passionné d\'histoire et de traditions locales.';
      case UserRole.revendeur:
        return 'Votre boutique de souvenirs de voyage à Dantokpa, Cotonou. Sélection d\'épices locales, de batiks et d\'objets d\'art traditionnels.';
    }
  }

  // --- CONTENUS DYNAMIQUES DE DÉMO POUR LES ONGLETS ---

  // --- ETAT DYNAMIQUE ---
  final List<Map<String, dynamic>> _myProducts = [];
  final List<Map<String, dynamic>> _myServices = [];
  final List<Map<String, dynamic>> _myExperiences = [];
  final List<Map<String, dynamic>> _myPublications = [];

  // Getters dynamiques enrichis
  List<Map<String, dynamic>> get products => [..._myProducts, ..._getMockProducts()];
  List<Map<String, dynamic>> get services => [..._myServices, ..._getMockServices()];
  List<Map<String, dynamic>> get experiences => [..._myExperiences, ..._getMockExperiences()];
  List<Map<String, dynamic>> get publications => [..._myPublications, ..._getMockPublications()];

  // Méthodes d'ajout
  void addProduct(Map<String, dynamic> product) {
    _myProducts.add(product);
    notifyListeners();
  }

  void addService(Map<String, dynamic> service) {
    _myServices.add(service);
    notifyListeners();
  }

  void addExperience(Map<String, dynamic> exp) {
    _myExperiences.add(exp);
    notifyListeners();
  }

  void addPublication(Map<String, dynamic> pub) {
    _myPublications.add(pub);
    notifyListeners();
  }

  // Helper pour renommer les getters de mock existants
  List<Map<String, dynamic>> _getMockProducts() {
    switch (_role) {
      case UserRole.artisan:
        return [
          {'title': 'Jarre d\'Abomey en argile', 'price': '8 500 FCFA', 'image': 'https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?q=80&w=300'},
          {'title': 'Canari traditionnel décoré', 'price': '6 000 FCFA', 'image': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?q=80&w=300'},
          {'title': 'Vase en céramique ocre', 'price': '12 000 FCFA', 'image': 'https://images.unsplash.com/photo-1580481072645-022f9a6dbf27?q=80&w=300'},
        ];
      case UserRole.artisanConcepteur:
        return [
          {'title': 'Fauteuil Royal réinventé', 'price': '185 000 FCFA', 'image': 'https://images.unsplash.com/photo-1592078615290-033ee584e267?q=80&w=300'},
          {'title': 'Masque mural contemporain', 'price': '45 000 FCFA', 'image': 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?q=80&w=300'},
        ];
      case UserRole.artisanRevendeur:
        return [
          {'title': 'Pagne tissé indigo (2 yards)', 'price': '15 000 FCFA', 'image': 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?q=80&w=300'},
          {'title': 'Écharpe en coton bio teint', 'price': '7 500 FCFA', 'image': 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?q=80&w=300'},
        ];
      case UserRole.revendeur:
        return [
          {'title': 'Statuette vaudou en laiton', 'price': '18 000 FCFA', 'image': 'https://images.unsplash.com/photo-1606744824163-985d376605aa?q=80&w=300'},
          {'title': 'Sac en raphia coloré', 'price': '5 500 FCFA', 'image': 'https://images.unsplash.com/photo-1524498250077-3a9f0c572269?q=80&w=300'},
          {'title': 'Coffret d\'épices du Bénin', 'price': '4 000 FCFA', 'image': 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=300'},
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _getMockServices() {
    switch (_role) {
      case UserRole.guideTouristique:
        return [
          {'title': 'Accompagnement personnalisé à la journée', 'duration': '8 heures', 'price': '15 000 FCFA', 'icon': Icons.directions_run_rounded},
          {'title': 'Service de chauffeur & traducteur', 'duration': 'Selon besoin', 'price': 'Sur devis', 'icon': Icons.directions_car_rounded},
        ];
      case UserRole.artisanConcepteur:
        return [
          {'title': 'Atelier de design collaboratif', 'duration': '3 heures', 'price': '30 000 FCFA', 'icon': Icons.palette_rounded},
          {'title': 'Conception de mobilier sur mesure', 'duration': 'Projet complet', 'price': 'Sur devis', 'icon': Icons.architecture_rounded},
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _getMockExperiences() {
    switch (_role) {
      case UserRole.guideTouristique:
        return [
          {'title': 'Visite privée de la cité lacustre de Ganvié', 'price': '25 000 FCFA / pers', 'rating': '4.9 (42 avis)', 'image': 'https://www.gouv.bj/upload/images/banners/546730049088001761344719.png'},
          {'title': 'Pèlerinage historique sur la Route des Esclaves', 'price': '15 000 FCFA / pers', 'rating': '4.8 (38 avis)', 'image': 'https://images.unsplash.com/photo-1590674899484-d56419821d99?q=80&w=300'},
        ];
      case UserRole.voyageur:
        return [
          {'title': 'Ganvié au coucher du soleil', 'price': '25 000 FCFA', 'rating': 'Réservez à nouveau', 'image': 'https://www.gouv.bj/upload/images/banners/546730049088001761344719.png'},
        ];
      default:
        return [];
    }
  }

  List<Map<String, dynamic>> _getMockPublications() {
    return [
      {
        'title': 'Nouvelle création disponible au showroom ✨',
        'time': 'Il y a 2 heures',
        'image': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?q=80&w=400',
        'likes': 42,
      },
      {
        'title': 'Partage du savoir-faire avec la nouvelle génération.',
        'time': 'Il y a 1 jour',
        'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400',
        'likes': 78,
      },
    ];
  }

  // --- FIN ETAT DYNAMIQUE ---

  // Produits
  List<Map<String, dynamic>> get products {
    switch (_role) {
      case UserRole.artisan:
        return [
          {'title': 'Jarre d\'Abomey en argile', 'price': '8 500 FCFA', 'image': 'https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?q=80&w=300'},
          {'title': 'Canari traditionnel décoré', 'price': '6 000 FCFA', 'image': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?q=80&w=300'},
          {'title': 'Vase en céramique ocre', 'price': '12 000 FCFA', 'image': 'https://images.unsplash.com/photo-1580481072645-022f9a6dbf27?q=80&w=300'},
        ];
      case UserRole.artisanConcepteur:
        return [
          {'title': 'Fauteuil Royal réinventé', 'price': '185 000 FCFA', 'image': 'https://images.unsplash.com/photo-1592078615290-033ee584e267?q=80&w=300'},
          {'title': 'Masque mural contemporain', 'price': '45 000 FCFA', 'image': 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?q=80&w=300'},
        ];
      case UserRole.artisanRevendeur:
        return [
          {'title': 'Pagne tissé indigo (2 yards)', 'price': '15 000 FCFA', 'image': 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?q=80&w=300'},
          {'title': 'Écharpe en coton bio teint', 'price': '7 500 FCFA', 'image': 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?q=80&w=300'},
        ];
      case UserRole.revendeur:
        return [
          {'title': 'Statuette vaudou en laiton', 'price': '18 000 FCFA', 'image': 'https://images.unsplash.com/photo-1606744824163-985d376605aa?q=80&w=300'},
          {'title': 'Sac en raphia coloré', 'price': '5 500 FCFA', 'image': 'https://images.unsplash.com/photo-1524498250077-3a9f0c572269?q=80&w=300'},
          {'title': 'Coffret d\'épices du Bénin', 'price': '4 000 FCFA', 'image': 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?q=80&w=300'},
        ];
      default:
        return [];
    }
  }

  // Catalogue
  List<Map<String, dynamic>> get catalog {
    switch (_role) {
      case UserRole.artisan:
        return [
          {'name': 'Art de la table', 'count': '12 objets', 'image': 'https://images.unsplash.com/photo-1612196808214-b8e1d6145a8c?q=80&w=200'},
          {'name': 'Jarres & Grandes pièces', 'count': '5 pièces', 'image': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?q=80&w=200'},
        ];
      case UserRole.artisanConcepteur:
        return [
          {'name': 'Collection Vodoun Chic', 'count': '8 créations', 'image': 'https://images.unsplash.com/photo-1578301978693-85fa9c0320b9?q=80&w=200'},
          {'name': 'Mobilier & Teck', 'count': '4 modèles', 'image': 'https://images.unsplash.com/photo-1592078615290-033ee584e267?q=80&w=200'},
        ];
      case UserRole.artisanRevendeur:
      case UserRole.revendeur:
        return [
          {'name': 'Tissages & Pagnes', 'count': '24 articles', 'image': 'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?q=80&w=200'},
          {'name': 'Accessoires de mode', 'count': '15 articles', 'image': 'https://images.unsplash.com/photo-1524498250077-3a9f0c572269?q=80&w=200'},
        ];
      default:
        return [];
    }
  }

  // Services
  List<Map<String, dynamic>> get services {
    switch (_role) {
      case UserRole.guideTouristique:
        return [
          {'title': 'Accompagnement personnalisé à la journée', 'duration': '8 heures', 'price': '15 000 FCFA', 'icon': Icons.directions_run_rounded},
          {'title': 'Service de chauffeur & traducteur', 'duration': 'Selon besoin', 'price': 'Sur devis', 'icon': Icons.directions_car_rounded},
        ];
      case UserRole.artisanConcepteur:
        return [
          {'title': 'Atelier de design collaboratif', 'duration': '3 heures', 'price': '30 000 FCFA', 'icon': Icons.palette_rounded},
          {'title': 'Conception de mobilier sur mesure', 'duration': 'Projet complet', 'price': 'Sur devis', 'icon': Icons.architecture_rounded},
        ];
      default:
        return [];
    }
  }

  // Expériences
  List<Map<String, dynamic>> get experiences {
    switch (_role) {
      case UserRole.guideTouristique:
        return [
          {'title': 'Visite privée de la cité lacustre de Ganvié', 'price': '25 000 FCFA / pers', 'rating': '4.9 (42 avis)', 'image': 'https://www.gouv.bj/upload/images/banners/546730049088001761344719.png'},
          {'title': 'Pèlerinage historique sur la Route des Esclaves', 'price': '15 000 FCFA / pers', 'rating': '4.8 (38 avis)', 'image': 'https://images.unsplash.com/photo-1590674899484-d56419821d99?q=80&w=300'},
        ];
      case UserRole.voyageur:
        return [
          {'title': 'Ganvié au coucher du soleil', 'price': '25 000 FCFA', 'rating': 'Réservez à nouveau', 'image': 'https://www.gouv.bj/upload/images/banners/546730049088001761344719.png'},
        ];
      default:
        return [];
    }
  }

  // Publications
  List<Map<String, dynamic>> get publications {
    return [
      {
        'title': 'Nouvelle création disponible au showroom ✨',
        'time': 'Il y a 2 heures',
        'image': 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?q=80&w=400',
        'likes': 42,
      },
      {
        'title': 'Partage du savoir-faire avec la nouvelle génération.',
        'time': 'Il y a 1 jour',
        'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=400',
        'likes': 78,
      },
    ];
  }

  // Avis
  List<Map<String, dynamic>> get reviews {
    return [
      {
        'user': 'Sophie M.',
        'rating': 5,
        'comment': 'Une expérience extraordinaire ! Service très professionnel et qualité impeccable. Je recommande vivement.',
        'date': '22 Juin 2026',
        'avatar': 'https://i.pravatar.cc/100?u=sophie',
      },
      {
        'user': 'Jean-Luc K.',
        'rating': 4,
        'comment': 'Très satisfait de l\'accueil et du produit acheté. Très authentique.',
        'date': '15 Juin 2026',
        'avatar': 'https://i.pravatar.cc/100?u=jeanluc',
      },
    ];
  }
}
