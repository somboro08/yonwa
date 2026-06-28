import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/yonwa_theme.dart';

// ─── Data ────────────────────────────────────

class _Profile {
  final String id, name, specialty, city, image, bio, tag;
  final double rating;
  final int reviews;
  final int price;
  final List<String> skills;
  _Profile({required this.id, required this.name, required this.specialty, required this.city, required this.image, required this.bio, required this.tag, required this.rating, required this.reviews, required this.price, required this.skills});
}

final _allProfiles = [
  _Profile(id:'1', name:'Koffi Mensah', specialty:'Guide lacustre', city:'Ganvié', image:'assets/images/hero1.png', bio:'Guide expérimenté sur le lac Nokoué depuis 12 ans. Je vous ferai découvrir la cité lacustre de Ganvié et ses secrets cachés.', tag:'Guide', rating:4.9, reviews:84, price:15000, skills:['Pirogue', 'Bilingue FR/EN', 'Photographie', 'Histoire']),
  _Profile(id:'2', name:'Amina Cissé', specialty:'Tisserande traditionnelle', city:'Bohicon', image:'assets/images/hero2.png', bio:'Artisane passionnée spécialisée dans le tissage du pagne traditionnel. Chaque création est unique et porte l\'âme du Bénin.', tag:'Artisane', rating:4.8, reviews:61, price:8000, skills:['Tissage', 'Teinture indigo', 'Formation', 'Vente']),
  _Profile(id:'3', name:'Lionel Gbèdo', specialty:'Guide historique', city:'Ouidah', image:'assets/images/hero12.jpg', bio:'Passionné par l\'histoire du Bénin, je vous guiderai sur la Route des Esclaves et les monuments de Ouidah.', tag:'Guide', rating:4.7, reviews:47, price:12000, skills:['Histoire', 'Vaudou', 'Francophone', 'Mémoire']),
  _Profile(id:'4', name:'Moussa Aké', specialty:'Guide safari', city:'Natitingou', image:'assets/images/hero10.jpg', bio:'Spécialiste du Parc National du W et de la faune béninoise. Aventures inoubliables garanties !', tag:'Guide', rating:4.6, reviews:39, price:20000, skills:['Safari', 'Faune', '4x4', 'Camping']),
  _Profile(id:'5', name:'Sika Adjovi', specialty:'Potière', city:'Abomey', image:'assets/images/hero6.png', bio:'Héritière d\'une longue tradition de poterie royale d\'Abomey. Créatrice de pièces uniques inspirées des bas-reliefs des Palais Royaux.', tag:'Artisane', rating:4.9, reviews:52, price:5000, skills:['Poterie', 'Art royal', 'Cuisson', 'Sculpture']),
  _Profile(id:'6', name:'Binta Sow', specialty:'Guide culinaire', city:'Cotonou', image:'assets/images/hero3.png', bio:'Chef et guide culinaire, je vous invite à découvrir les saveurs authentiques de la cuisine béninoise à travers marchés et restaurants.', tag:'Guide', rating:4.8, reviews:73, price:10000, skills:['Cuisine', 'Marché', 'Recettes', 'Dégustation']),
];

// ─── Vertical Carousel Images ────────────────

final _heroImages = [
  'assets/images/hero1.png','assets/images/hero5.png','assets/images/hero7.png',
  'assets/images/hero10.jpg','assets/images/hero15.jpg','assets/images/hero18.jpg',
];

final _heroTitles = ['Ganvié', 'Abomey', 'Lac Nokoué', 'Parc du W', 'Festivals', 'Couchers de soleil'];

// ─── Explorer Screen ─────────────────────────

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});
  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  final _pageCtrl = PageController();
  int _carouselIdx = 0;
  Timer? _timer;
  String _selectedCat = 'Tout';
  final _cats = ['Tout', 'Guides', 'Artisans', 'Destinations', 'Événements'];
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageCtrl.hasClients) {
        final next = (_carouselIdx + 1) % _heroImages.length;
        _pageCtrl.animateToPage(next, duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() { _timer?.cancel(); _pageCtrl.dispose(); _search.dispose(); super.dispose(); }

  List<_Profile> get _filtered {
    var list = _allProfiles;
    if (_selectedCat == 'Guides') list = list.where((p) => p.tag == 'Guide').toList();
    if (_selectedCat == 'Artisans') list = list.where((p) => p.tag == 'Artisane').toList();
    if (_search.text.isNotEmpty) list = list.where((p) => p.name.toLowerCase().contains(_search.text.toLowerCase()) || p.city.toLowerCase().contains(_search.text.toLowerCase())).toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? YonwaColors.neutral900 : const Color(0xFFF8F4EF),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildVerticalCarousel(isDark)),
          SliverToBoxAdapter(child: _buildSearchBar(isDark)),
          SliverToBoxAdapter(child: _buildCategories(isDark)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.64),
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ProfileCard(profile: _filtered[i], isDark: isDark, onTap: () => _showDetail(context, _filtered[i], isDark)),
                childCount: _filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalCarousel(bool isDark) {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageCtrl,
            scrollDirection: Axis.vertical,
            onPageChanged: (i) => setState(() => _carouselIdx = i),
            itemCount: _heroImages.length,
            itemBuilder: (_, i) => Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(_heroImages[i], fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: YonwaColors.primary300)),
                Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.6)]))),
              ],
            ),
          ),
          // Title
          Positioned(bottom: 50, left: 20,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Column(key: ValueKey(_carouselIdx), crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Explorer', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w500)),
                Text(_heroTitles[_carouselIdx], style: const TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              ]),
            ),
          ),
          // Vertical dots
          Positioned(right: 16, top: 0, bottom: 0,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_heroImages.length, (i) =>
              AnimatedContainer(duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(vertical: 3),
                width: 4, height: _carouselIdx == i ? 20 : 6,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: _carouselIdx == i ? Colors.white : Colors.white38)),
            )),
          ),
          // Safe area top header
          Positioned(top: 0, left: 0, right: 0,
            child: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(children: [
                const Text('Explorer', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const Spacer(),
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20)),
              ]),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(children: [
          const Icon(Icons.search_rounded, size: 20, color: YonwaColors.primary500),
          const SizedBox(width: 8),
          Expanded(child: TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: isDark ? Colors.white : YonwaColors.neutral800),
            decoration: InputDecoration(
              hintText: 'Chercher un guide, artisan, ville...',
              hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: isDark ? YonwaColors.neutral500 : YonwaColors.neutral400),
              border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero,
            ),
          )),
        ]),
      ),
    );
  }

  Widget _buildCategories(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 6),
      child: SizedBox(height: 36, child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _cats.length,
        itemBuilder: (_, i) {
          final sel = _cats[i] == _selectedCat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCat = _cats[i]),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: sel ? const LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary]) : null,
                color: sel ? null : (isDark ? YonwaColors.neutral800 : Colors.white),
                borderRadius: BorderRadius.circular(18),
                border: sel ? null : Border.all(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral200),
              ),
              child: Text(_cats[i], style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : (isDark ? YonwaColors.neutral300 : YonwaColors.neutral600))),
            ),
          );
        },
      )),
    );
  }

  void _showDetail(BuildContext context, _Profile p, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileBottomSheet(profile: p, isDark: isDark),
    );
  }
}

// ─── Profile Card ────────────────────────────

class _ProfileCard extends StatelessWidget {
  final _Profile profile;
  final bool isDark;
  final VoidCallback onTap;
  const _ProfileCard({required this.profile, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral800 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            Image.asset(profile.image, height: 150, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(height: 150, color: YonwaColors.primary200)),
            Positioned(top: 10, left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(profile.tag, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            Positioned(top: 10, right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                child: const Icon(Icons.favorite_border_rounded, size: 16, color: YonwaColors.primary500),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(profile.name, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : YonwaColors.neutral900), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(profile.specialty, style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: isDark ? YonwaColors.neutral400 : YonwaColors.neutral500), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.location_on_rounded, size: 12, color: YonwaColors.primary500),
                const SizedBox(width: 2),
                Expanded(child: Text(profile.city, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: YonwaColors.primary500))),
                const Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                const SizedBox(width: 2),
                Text('${profile.rating}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
              ]),
              const SizedBox(height: 6),
              Text('À partir de ${profile.price} FCFA', style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: YonwaColors.primary500)),
            ]),
          ),
        ]),
      ),
    );
  }
}

// ─── Bottom Sheet ────────────────────────────

class _ProfileBottomSheet extends StatelessWidget {
  final _Profile profile;
  final bool isDark;
  const _ProfileBottomSheet({required this.profile, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: isDark ? YonwaColors.neutral900 : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(controller: ctrl, children: [
          // Handle
          Center(child: Container(margin: const EdgeInsets.only(top: 10, bottom: 6), width: 40, height: 4, decoration: BoxDecoration(color: isDark ? YonwaColors.neutral700 : YonwaColors.neutral300, borderRadius: BorderRadius.circular(2)))),
          // Hero image
          Stack(children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: Image.asset(profile.image, height: 240, width: double.infinity, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(height: 240, color: YonwaColors.primary200)),
            ),
            Container(height: 240, decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.5)]),
            )),
            Positioned(bottom: 16, left: 20,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [YonwaColors.primary500, YonwaColors.secondary]), borderRadius: BorderRadius.circular(14)),
                    child: Text(profile.tag, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))),
                  const SizedBox(width: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: YonwaColors.success, borderRadius: BorderRadius.circular(14)),
                    child: Row(children: const [Icon(Icons.verified_rounded, size: 12, color: Colors.white), SizedBox(width: 4), Text('Certifié', style: TextStyle(fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))])),
                ]),
                const SizedBox(height: 6),
                Text(profile.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('${profile.specialty} • ${profile.city}', style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.white70)),
              ]),
            ),
          ]),
          // Stats row
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              _Stat(label: 'Note', value: '${profile.rating}', icon: Icons.star_rounded, color: const Color(0xFFF59E0B)),
              _Stat(label: 'Avis', value: '${profile.reviews}', icon: Icons.chat_bubble_rounded, color: YonwaColors.primary500),
              _Stat(label: 'Tarif', value: '${profile.price}F', icon: Icons.payments_rounded, color: YonwaColors.accent),
            ]),
          ),
          // Bio
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('À propos', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : YonwaColors.neutral900)),
              const SizedBox(height: 8),
              Text(profile.bio, style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: isDark ? YonwaColors.neutral300 : YonwaColors.neutral600, height: 1.6)),
            ]),
          ),
          // Skills
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Compétences', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : YonwaColors.neutral900)),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8, children: profile.skills.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: YonwaColors.primary500.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: YonwaColors.primary500.withOpacity(0.3))),
                child: Text(s, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: YonwaColors.primary500, fontWeight: FontWeight.w500)),
              )).toList()),
            ]),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.chat_rounded, size: 18),
                label: const Text('Contacter', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.calendar_today_rounded, size: 18),
                label: const Text('Réserver', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold)),
              )),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _Stat({required this.label, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20)),
      const SizedBox(height: 6),
      Text(value, style: TextStyle(fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.bold, color: color)),
      Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: YonwaColors.neutral400)),
    ]));
  }
}
