import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../models/models.dart';
import '../../mock/mock_data.dart';
import '../../theme/yonwa_theme.dart';

class ProfileCategoryScreen extends StatelessWidget {
  final String category;

  const ProfileCategoryScreen({super.key, required this.category});

  String get title {
    switch (category) {
      case 'artisan':
        return 'Artisans';
      case 'concepteur':
        return 'Concepteurs';
      case 'guide':
        return 'Guides';
      default:
        return 'Profils';
    }
  }

  UserRole? get role {
    switch (category) {
      case 'artisan':
        return UserRole.artisan;
      case 'concepteur':
        return UserRole.artisanConcepteur;
      case 'guide':
        return UserRole.guideTouristique;
      default:
        return null;
    }
  }

  List<Map<String, dynamic>> get profiles {
    if (role == null) {
      return MockData.actors;
    }

    return MockData.actors
        .where((actor) => actor['role'] == role)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YonwaColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          '$title (${profiles.length})',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: YonwaColors.neutral900,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: YonwaColors.neutral900,
          ),
        ),
      ),
      body: profiles.isEmpty
          ? Center(
              child: Text(
                'Aucun profil trouvé pour cette catégorie.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: YonwaColors.neutral500,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: profiles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final profile = profiles[index];
                final actorIndex = MockData.actors.indexOf(profile);
                final roleLabel = (profile['role'] as UserRole).displayName;
                return GestureDetector(
                  onTap: () => context.push('/profile/$actorIndex'),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: YonwaColors.neutral200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(18),
                            ),
                            child: Image.asset(
                              profile['coverImage'] as String,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: YonwaColors.neutral200,
                                child: const Icon(
                                  Icons.image,
                                  color: YonwaColors.neutral400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile['nom'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: YonwaColors.neutral900,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  roleLabel,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: YonwaColors.primary500,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  profile['ville'] as String,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: YonwaColors.neutral600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const HugeIcon(
                                      icon: HugeIcons.strokeRoundedStar,
                                      color: YonwaColors.secondary,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      profile['rating'] as String,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: YonwaColors.neutral900,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
