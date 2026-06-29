import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';
import '../../core/responsive/breakpoints.dart';
import '../../mock/mock_data.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/widgets/floating_navbar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String id;
  const ProfileScreen({super.key, required this.id});

  static void _dummyCallback() {}

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _showPrivateContact = false;

  void _onContactTap() {
    requireAuth(context, ref, () {
      setState(() {
        _showPrivateContact = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Accès autorisé : Informations de contact déverrouillées !'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Safely parse index
    final index = int.tryParse(widget.id) ?? 0;
    final actors = MockData.actors;
    final actor = (index >= 0 && index < actors.length) ? actors[index] : actors[0];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          // Navbar floating (mobile only)
          if (context.isMobile)
            const SliverToBoxAdapter(child: FloatingNavbar(onMenuPressed: ProfileScreen._dummyCallback)),

          // Cover Image & Avatar Header
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Cover
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    image: actor['coverImage'] != null
                        ? DecorationImage(
                            image: actor['coverImage'].toString().startsWith('http')
                                ? NetworkImage(actor['coverImage'].toString())
                                : AssetImage(actor['coverImage'].toString()) as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
                // Back Button (if mobile)
                if (Navigator.canPop(context))
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0D0D0D)),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                // Avatar (centered overlap)
                Positioned(
                  bottom: -50,
                  left: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        actor['photoUrl'] ?? 'https://i.pravatar.cc/300?u=actor',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 60),
          ),

          // Main Profile details
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        actor['nom'] ?? 'Nom inconnu',
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D0D0D),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (actor['isVerified'] == true)
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedTickDouble02,
                          color: Color(0xFF38A169),
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    actor['ville'] ?? 'Bénin',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6B6B7A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Bio
                  Text(
                    actor['bio'] ?? 'Aucune biographie fournie.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF0D0D0D),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Savoir-faire tags
                  Text(
                    'Savoir-faire',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D0D0D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ((actor['savoirFaire'] as List<dynamic>?) ?? ['Artisanat'])
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F4),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                tag.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFF6B6B7A),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 32),

                  // Call to action sensitive button
                  if (!_showPrivateContact)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A2E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedLockKey,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          'Déverrouiller le contact',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        onPressed: _onContactTap,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38A169).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF38A169).withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const HugeIcon(
                                icon: HugeIcons.strokeRoundedCall,
                                color: Color(0xFF38A169),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                actor['telephone'] ?? '+229 97 00 00 00',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF38A169),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ce numéro est réservé aux clients Yonwa certifiés.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF6B6B7A),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
