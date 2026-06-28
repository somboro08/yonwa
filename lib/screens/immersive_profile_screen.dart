import 'package:flutter/material.dart';
import '../theme/yonwa_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImmersiveProfileScreen extends StatelessWidget {
  const ImmersiveProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YonwaColors.background,
      body: CustomScrollView(
        slivers: [
          // Media Player Section (50-60% height placeholder)
          _buildMediaSliver(context),
          
          // Information Panel
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(YonwaSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: YonwaSpacing.md),
                  _buildAuthorSection(),
                  const SizedBox(height: YonwaSpacing.lg),
                  _buildQuickActions(),
                  const SizedBox(height: YonwaSpacing.xl),
                  _buildPresentationCard(),
                  const SizedBox(height: YonwaSpacing.xl),
                  _buildAssociatedContent(),
                  const SizedBox(height: YonwaSpacing.xl),
                  _buildCommentsSection(),
                  const SizedBox(height: YonwaSpacing.xl),
                  _buildAISuggestions(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaSliver(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            height: size.height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1590674899484-d56419821d99'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Icon(Icons.play_circle_fill_rounded, size: 80, color: Colors.white.withOpacity(0.8)),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.4),
              child: const BackButton(color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              children: [
                _buildMediaControl(Icons.fullscreen),
                const SizedBox(width: 10),
                _buildMediaControl(Icons.settings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaControl(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Découverte des villages lacustres de Ganvié',
          style: YonwaTextStyles.h2.copyWith(color: YonwaColors.primary700, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '12 450 vues • il y a 2 jours',
          style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500),
        ),
      ],
    );
  }

  Widget _buildAuthorSection() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=koffi'),
        ),
        const SizedBox(width: YonwaSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Koffi Guide', style: YonwaTextStyles.label.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  const Icon(Icons.verified, size: 14, color: YonwaColors.info),
                ],
              ),
              Text('2.5k abonnés', style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500)),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: YonwaColors.primary500,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(YonwaRadius.full)),
          ),
          child: const Text('Suivre'),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildActionButton(Icons.thumb_up_off_alt, '245'),
          _buildActionButton(Icons.bookmark_border_rounded, 'Sauvegarder'),
          _buildActionButton(Icons.share_outlined, 'Partager'),
          _buildActionButton(Icons.calendar_today_rounded, 'Réserver', isPrimary: true),
          _buildActionButton(Icons.chat_bubble_outline_rounded, 'Contacter'),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {bool isPrimary = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18, color: isPrimary ? Colors.white : YonwaColors.neutral700),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? YonwaColors.primary500 : YonwaColors.neutral100,
          foregroundColor: isPrimary ? Colors.white : YonwaColors.neutral700,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(YonwaRadius.full)),
        ),
      ),
    );
  }

  Widget _buildPresentationCard() {
    return Container(
      padding: const EdgeInsets.all(YonwaSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(YonwaRadius.lg),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('À propos de l\'expérience', style: YonwaTextStyles.h3.copyWith(color: YonwaColors.primary600)),
          const SizedBox(height: YonwaSpacing.sm),
          const Text(
            'Plongez au cœur de Ganvié, la Venise de l\'Afrique. Une expérience immersive unique avec Koffi, guide local expert depuis 10 ans. Vous découvrirez les traditions ancestrales, la pêche locale et l\'architecture sur pilotis.',
            style: YonwaTextStyles.body,
          ),
          const Divider(height: 32),
          _buildInfoRow(Icons.location_on_rounded, '📍 Ganvié, Lac Nokoué'),
          _buildInfoRow(Icons.payments_rounded, '💰 25 000 FCFA / personne'),
          _buildInfoRow(Icons.event_available_rounded, '📅 Disponible tous les jours'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: YonwaColors.primary500),
          const SizedBox(width: 8),
          Text(text, style: YonwaTextStyles.label),
        ],
      ),
    );
  }

  Widget _buildAssociatedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Autres expériences proposées', style: YonwaTextStyles.h3),
        const SizedBox(height: YonwaSpacing.md),
        _buildAssociatedCard('Fabrication traditionnelle du tissu indigo', 'Artisan Amina', '8.2k vues • 15 min'),
        _buildAssociatedCard('Initiation à l\'apiculture béninoise', 'Guide Moussa', '3.1k vues • 45 min'),
      ],
    );
  }

  Widget _buildAssociatedCard(String title, String author, String stats) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 140,
              height: 90,
              color: YonwaColors.neutral200,
              child: const Icon(Icons.image, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: YonwaTextStyles.label.copyWith(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(author, style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500)),
                Text(stats, style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Commentaires', style: YonwaTextStyles.h3),
            const SizedBox(width: 8),
            Text('34', style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500)),
          ],
        ),
        const SizedBox(height: YonwaSpacing.md),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 18)),
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: YonwaColors.neutral100, borderRadius: BorderRadius.circular(YonwaRadius.md)),
            child: Text('Ajouter un commentaire...', style: YonwaTextStyles.caption),
          ),
        ),
      ],
    );
  }

  Widget _buildAISuggestions() {
    return Container(
      padding: const EdgeInsets.all(YonwaSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [YonwaColors.accent.withOpacity(0.1), YonwaColors.primary500.withOpacity(0.1)]),
        borderRadius: BorderRadius.circular(YonwaRadius.lg),
        border: Border.all(color: YonwaColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_rounded, color: YonwaColors.accent),
              const SizedBox(width: 8),
              Text('Vous pourriez également aimer', style: YonwaTextStyles.label.copyWith(fontWeight: FontWeight.bold, color: YonwaColors.accent)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Basé sur votre intérêt pour la culture lacustre, nous vous suggérons la visite du marché flottant de Ganvié.', style: YonwaTextStyles.caption),
        ],
      ),
    );
  }
}


