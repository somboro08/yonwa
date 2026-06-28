import 'package:flutter/material.dart';
import '../../theme/yonwa_theme.dart';

class HistoryDetailScreen extends StatelessWidget {
  final Map<String, String> adventure;

  const HistoryDetailScreen({super.key, required this.adventure});

  static const _people = [
    {
      'name': 'Sophie M.',
      'image': 'assets/images/hero20.jpeg',
      'desc': 'Voyageuse accompagnee pendant la visite lacustre.',
    },
    {
      'name': 'Jean-Luc K.',
      'image': 'assets/images/hero21.jpeg',
      'desc': 'Passionne d histoire locale et de photographie.',
    },
    {
      'name': 'Awa T.',
      'image': 'assets/images/hero22.jpeg',
      'desc': 'A decouvert les ateliers artisanaux du parcours.',
    },
  ];

  static const _media = [
    'assets/images/hero1.jpg',
    'assets/images/hero2.jpg',
    'assets/images/hero3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : YonwaColors.neutral50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: YonwaColors.primary500,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(adventure['location'] ?? 'Aventure'),
              background: Image.asset(
                adventure['coverImage'] ?? _media.first,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(adventure['title'] ?? '', style: YonwaTextStyles.h1),
                  const SizedBox(height: 8),
                  Text(
                    adventure['summary'] ?? '',
                    style: YonwaTextStyles.body.copyWith(color: YonwaColors.neutral500),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Touristes guides'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _people.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final person = _people[index];
                        return _PersonCard(person: person);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Images de l aventure'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 128,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _media.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _showGallery(context, index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              _media[index],
                              width: 180,
                              height: 128,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Narration'),
                  const SizedBox(height: 12),
                  Text(
                    'Le depart s est fait au petit matin, avec une lumiere douce sur les pirogues. '
                    'Le groupe a traverse les lieux importants, rencontre des habitants, puis termine '
                    'par un moment de partage autour des savoir-faire locaux.',
                    style: YonwaTextStyles.body,
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(_media[1], height: 190, width: double.infinity, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle('Videos reel'),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _openReels(context),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(image: AssetImage(_media[2]), fit: BoxFit.cover, opacity: 0.55),
                      ),
                      child: const Center(
                        child: Icon(Icons.play_circle_fill_rounded, size: 64, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: YonwaTextStyles.h3.copyWith(fontWeight: FontWeight.bold));
  }

  void _showGallery(BuildContext context, int initialIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (_) => PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: _media.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Center(child: Image.asset(_media[index], fit: BoxFit.contain)),
              Positioned(
                right: 16,
                top: 48,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download_rounded, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openReels(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const _AdventureReelsScreen()),
    );
  }
}

class _PersonCard extends StatelessWidget {
  final Map<String, String> person;

  const _PersonCard({required this.person});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      child: Column(
        children: [
          CircleAvatar(radius: 38, backgroundImage: AssetImage(person['image']!)),
          const SizedBox(height: 8),
          Text(person['name']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: YonwaTextStyles.label),
          Text(
            person['desc']!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: YonwaTextStyles.caption.copyWith(color: YonwaColors.neutral500),
          ),
        ],
      ),
    );
  }
}

class _AdventureReelsScreen extends StatelessWidget {
  const _AdventureReelsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(color: Colors.black),
              Center(
                child: Icon(
                  Icons.play_circle_outline_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 86,
                ),
              ),
              Positioned(
                left: 16,
                right: 72,
                bottom: 40,
                child: Text(
                  'Video ${index + 1} de l aventure',
                  style: YonwaTextStyles.h2.copyWith(color: Colors.white),
                ),
              ),
              Positioned(
                top: 40,
                right: 12,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
