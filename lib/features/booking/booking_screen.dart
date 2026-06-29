import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/responsive/breakpoints.dart';
import '../../shared/widgets/floating_navbar.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  static void _dummyCallback() {}

  @override
  Widget build(BuildContext context) {
    final mockBookings = [
      {
        'title': 'Atelier Tissage Indigo',
        'host': 'Amina Cissé',
        'date': '12 Juil 2026',
        'time': '10:00 - 13:00',
        'location': 'Bohicon, Bénin',
        'status': 'Confirmé',
        'price': '15 000 FCFA',
        'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      },
      {
        'title': 'Visite guidée lacustre',
        'host': 'Koffi Mensah',
        'date': '18 Juil 2026',
        'time': '09:00 - 12:00',
        'location': 'Ganvié, Bénin',
        'status': 'En attente',
        'price': '10 000 FCFA',
        'image': 'https://images.unsplash.com/photo-1501854140801-50d01698950b',
      }
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          // Navbar floating (mobile only)
          if (context.isMobile)
            const SliverToBoxAdapter(child: FloatingNavbar(onMenuPressed: _dummyCallback)),

          // Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mes Réservations',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D0D0D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Retrouvez et gérez vos ateliers et circuits programmés.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF6B6B7A),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Booking List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final booking = mockBookings[index];
                  final isConfirmed = booking['status'] == 'Confirmé';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFEEEEF2), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Row(
                        children: [
                          // Small left image side
                          Image.network(
                            booking['image']!,
                            width: 100,
                            height: 140,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 100,
                              height: 140,
                              color: const Color(0xFFF2F2F4),
                              child: const Icon(Icons.broken_image, color: Color(0xFFB0B0BE)),
                            ),
                          ),
                          // Content details
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          booking['title']!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0D0D0D),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isConfirmed 
                                              ? const Color(0xFF38A169).withOpacity(0.08)
                                              : const Color(0xFFC9A84C).withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Text(
                                          booking['status']!,
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: isConfirmed 
                                                ? const Color(0xFF38A169)
                                                : const Color(0xFFC9A84C),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Hôte : ${booking['host']}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF6B6B7A),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // Date & Time Row
                                  Row(
                                    children: [
                                      const HugeIcon(
                                        icon: HugeIcons.strokeRoundedCalendar03,
                                        color: Color(0xFF6B6B7A),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        booking['date']!,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: const Color(0xFF0D0D0D),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const HugeIcon(
                                        icon: HugeIcons.strokeRoundedClock01,
                                        color: Color(0xFF6B6B7A),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        booking['time']!,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: const Color(0xFF0D0D0D),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Location & Price
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const HugeIcon(
                                            icon: HugeIcons.strokeRoundedCompass,
                                            color: Color(0xFF6B6B7A),
                                            size: 14,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            booking['location']!,
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: const Color(0xFF6B6B7A),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        booking['price']!,
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1A1A2E),
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
                childCount: mockBookings.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
