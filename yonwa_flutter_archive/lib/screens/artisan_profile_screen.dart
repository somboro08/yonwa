import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../data/mock_data.dart';

class ArtisanProfileScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) navigate;
  const ArtisanProfileScreen({super.key, required this.onBack, required this.navigate});

  @override
  State<ArtisanProfileScreen> createState() => _ArtisanProfileScreenState();
}

class _ArtisanProfileScreenState extends State<ArtisanProfileScreen> {
  bool _saved = false;
  String _tab = 'about';
  final artisan = MockData.artisans[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHero(),
                _buildInfo(),
                _buildStats(),
                _buildTabs(),
                _buildTabContent(),
                const SizedBox(height: 120),
              ],
            ),
          ),
          _buildBottomCTA(),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Stack(
      children: [
        SizedBox(height: 280, width: double.infinity, child: NetworkImg(url: artisan.image)),
        Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.textDark.withOpacity(0.1), AppColors.textDark.withOpacity(0.4)],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: GestureDetector(
            onTap: widget.onBack,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
              child: const Icon(Icons.chevron_left, color: AppColors.textDark),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 16,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _saved = !_saved),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                  child: Icon(
                    _saved ? Icons.favorite : Icons.favorite_border,
                    color: _saved ? AppColors.primary : AppColors.textDark,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                child: const Icon(Icons.share_outlined, color: AppColors.textDark, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Transform.translate(
            offset: const Offset(0, -20),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.card, width: 3),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8)],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: NetworkImg(url: artisan.avatar),
                ),
                if (artisan.certified)
                  Positioned(
                    bottom: -3,
                    right: -3,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.card, width: 2),
                      ),
                      child: const Icon(Icons.military_tech, size: 10, color: AppColors.textDark),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(artisan.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                Text(artisan.specialty, style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Text(artisan.location, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Row(
        children: [
          _StatBox(label: '${artisan.rating}', sub: '${artisan.reviews} avis', icon: Icons.star_rounded, iconColor: AppColors.secondary),
          const SizedBox(width: 10),
          const _StatBox(label: '12', sub: 'ans d\'exp.', icon: Icons.workspace_premium_outlined, iconColor: AppColors.primary),
          const SizedBox(width: 10),
          const _StatBox(label: '3', sub: 'continents', icon: Icons.public, iconColor: AppColors.blue),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = [['about', 'À propos'], ['work', 'Créations'], ['reviews', 'Avis']];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: tabs.map((t) {
            final active = _tab == t[0];
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _tab = t[0]),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: active ? AppColors.card : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    t[1],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? AppColors.primary : AppColors.textMuted),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: _tab == 'about'
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(artisan.bio, style: const TextStyle(fontSize: 14, color: AppColors.textDark, height: 1.6)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 6, children: artisan.tags.map((t) => AppBadge(label: t)).toList()),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CONTACT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.phone, size: 15),
                            label: const Text('Appeler'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.textDark,
                              foregroundColor: const Color(0xFFFAF6F0),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => widget.navigate('chat'),
                            icon: const Icon(Icons.chat_bubble_outline, size: 15),
                            label: const Text('Message'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              foregroundColor: AppColors.textDark,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ])
          : _tab == 'work'
              ? GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: artisan.products.map((url) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: NetworkImg(url: url),
                  )).toList(),
                )
              : _buildReviews(),
    );
  }

  Widget _buildReviews() {
    return Column(
      children: List.generate(3, (i) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                  child: const Icon(Icons.person, color: AppColors.textMuted, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Voyageur YONWA', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    const StarRating(value: 5.0, size: 11),
                  ],
                )),
                const Text('14 juin', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Expérience incroyable ! Kokou est un vrai artiste passionné. La pièce réalisée dépasse mes attentes.', style: TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.5)),
          ],
        ),
      )),
    );
  }

  Widget _buildBottomCTA() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [BoxShadow(color: AppColors.textDark.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('À partir de', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                Text('${(artisan.price / 1000).toStringAsFixed(0)} 000 FCFA', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary)),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => widget.navigate('booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                child: const Text('Réserver'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, sub;
  final IconData icon;
  final Color iconColor;

  const _StatBox({required this.label, required this.sub, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDark)),
            Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
